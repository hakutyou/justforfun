import urllib

__all__ = ['zone_to_id']

def zone_to_id(zone):
    url  = 'http://game.gtimg.cn/comm-htdocs/js/game_area/utf8verson/wuxia_server_select_utf8.js'
    content = urllib.request.urlopen(url)
    content = content.read().decode('utf-8')[55:-2]
    content = content.replace('t:', '"t":').replace('v:', '"v":') \
              .replace('display:', '"display":').replace('status:', '"status":') \
              .replace('opt_data_array:', '"opt_data_array":')
    gzone = eval(content)
    for lzone in gzone:
        for i in lzone['opt_data_array']:
            if i['t'] == zone:
                return i['v']
    return '6101' # hlyx
