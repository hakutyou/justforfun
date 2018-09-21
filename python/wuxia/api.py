import urllib.request

url_zone_search = url = 'http://game.gtimg.cn/comm-htdocs/js/game_area/utf8verson' \
                        '/wuxia_server_select_utf8.js'

baseurl_role_search = 'http://api.unipay.qq.com/v1/r/1450003565/get_role_list?pf' \
                      '=pay_center-__mds_webpay_iframe.hy-website'


def zone_to_id(zone):
        content = urllib.request.urlopen(url_zone_search)
        content = content.read().decode('utf-8')[55:-2]
        content = content.replace('t:', '"t":').replace('v:', '"v":').replace(
                'display:', '"display":').replace('status:', '"status":').replace(
                'opt_data_array:', '"opt_data_array":')
        gzone = eval(content)
        for lzone in gzone:
                for i in lzone['opt_data_array']:
                        if i['t'] == zone:
                                return i['v']
        return '6101'  # 欢乐英雄
