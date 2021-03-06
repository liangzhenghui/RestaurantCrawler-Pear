# coding=utf-8
import json

from flask import jsonify, Blueprint, request, Response

from pear.models.user_log import UserLogDao
from pear.web.controllers.ele_crawler_controller import get_ele_msg_code, login_ele_by_mobile, get_ele_captchas, \
    get_ele_city_list, search_ele_address, get_ele_restaurants
from pear.web.utils.authorize import authorize
from pear.web.utils.set_cookie import set_cookie
from pear.utils.config import ELE_LOGIN_MAX_AGE

config_ele_crawler_router = Blueprint('config_ele_crawler', __name__, url_prefix='/config_ele_crawler')

# ------------------登录饿了么-----------------

"""
登录饿了么流程:
 输入手机号 -> 获取验证码图片 -> 输入验证码图片上字符 -> 获取登录短信验证码 -> 输入短信验证码，登录饿了么-> 获取登录成功的token存储到cookie
"""


# 获取图片验证码
@config_ele_crawler_router.route('/pic_code', methods=['GET'])
@authorize
def get_pic_code():
    mobile = request.args.get('mobile')
    success, ele_image_base64, ele_image_token = get_ele_captchas(mobile)
    return jsonify(success=success, ele_image_base64=ele_image_base64, ele_image_token=ele_image_token)


# 获取短信验证码
@config_ele_crawler_router.route('/sms_code', methods=['GET'])
@authorize
def get_sms_code():
    mobile = request.args.get('mobile')
    pic_code = request.args.get('pic_code', '')
    image_token = request.args.get('pic_token', '')
    success, ele_sms_token, msg = get_ele_msg_code(mobile, pic_code, image_token)
    return jsonify(success=success, ele_sms_token=ele_sms_token, message=msg)


# 通过短信验证码登录
@config_ele_crawler_router.route('/login_ele', methods=['GET'])
@authorize
def login_ele():
    u_id = request.cookies.get('u_id')
    UserLogDao.create(u_id, u'登录饿了么')
    mobile = request.args.get('mobile')
    sms_code = request.args.get('sms_code', '')
    sms_token = request.args.get('sms_token', '')
    success, cookies, content = login_ele_by_mobile(mobile, sms_code, sms_token)
    data = json.dumps({
        'success': True
    })
    if success:
        resp = Response(data, mimetype='application/json')
        for i, v in cookies.iteritems():
            set_cookie(resp, i, v)
        set_cookie(resp, 'ele_login_account', str(mobile), max_age=ELE_LOGIN_MAX_AGE)
        return resp
    return jsonify(success=False, message=content)


# --------------------------------------------

@config_ele_crawler_router.route('/cities')
def fetch_ele_cites():
    cities = get_ele_city_list()
    if cities:
        return jsonify(cities)
    else:
        return jsonify([])


@config_ele_crawler_router.route('/search_address')
@authorize
def ele_address():
    keyword = request.args.get('key')
    lat = request.args.get('lat', 0)
    lng = request.args.get('lng', 0)
    data = search_ele_address(keyword, lat, lng)
    if data:
        return jsonify(data)
    else:
        return jsonify([])


@config_ele_crawler_router.route('/get_restaurants', methods=['POST'])
@authorize
def ele_restaurants():
    cookies = request.cookies
    payload = request.json
    offset = payload.get('offset', 0)
    limit = payload.get('limit', 24)
    data = get_ele_restaurants(payload.get('geohash'), payload.get('latitude'), payload.get('longitude'), offset=offset,
                               limit=limit, cookies=cookies)
    return jsonify(data)
