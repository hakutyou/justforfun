import zone
import transform
import key
import urllib.request

__all__ = [
    'read_role',
]

baseurl = 'http://api.unipay.qq.com/v1/r/1450003565/get_role_list?pf=pay_center-__mds_webpay_iframe.hy-website'

def read_role(openid, openkey, sck, provide_uin, zoneid,
              session_id='uin', session_type='skey'):
    url = baseurl
    for i in ['openid', 'openkey', 'session_id', 'session_type', 'sck', 'provide_uin', 'zoneid']:
        url += '&' + i + '=' + eval(i)
    content = urllib.request.urlopen(url)
    content = eval(content.read())
    if (content['ret'] != 0):
        try:
            print(content['msg'])
        except KeyError:
            print('读取失败')
    else:
        for role in content['role_list']:
            print('%s: %s' % (role['role_id'], transform.from_url(role['role_name'])))

if __name__ == '__main__':
    qq = '1351637848'
    zoneid = zone.zone_to_id('月见草')

    openid, cookies = key.get_cookies()
    if openid != 0:
        wuxiaid = '1450003565'
        skey = key.cookies_element('skey', cookies)
        openkey = transform.to_url(skey)
        sck = transform.to_md5(wuxiaid + skey)
        read_role(openid, openkey, sck=sck, provide_uin=qq, zoneid=zoneid)
