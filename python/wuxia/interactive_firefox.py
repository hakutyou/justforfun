import time
import hashlib
from urllib.parse import quote, unquote
import urllib.request
import selenium.webdriver.firefox.options
import selenium.webdriver.support.wait
import selenium.common
import PyQt5.QtCore

import api


def _get_cookies(name):
        failed = (0, 0)

        options = selenium.webdriver.firefox.options.Options()
        options.add_argument('-headless')
        driver = selenium.webdriver.Firefox(executable_path='geckodriver',
                                            firefox_options=options)
        # https://github.com/mozilla/geckodriver/releases
        selenium.webdriver.support.wait.WebDriverWait(driver, timeout=10)
        driver.get('http://wuxia.qq.com/comm-htdocs/pay/new_index.htm?t=wuxia')
        driver.switch_to.frame('__LoginIframe__')
        try:
                login = driver.find_element_by_xpath(
                        '//div[@id="qlogin_list"]/a[@class="face"]/span[@type="4"]')
        except selenium.common.exceptions.NoSuchElementException:
                print('未登录')
                return failed
        openid = login.get_attribute('uin')
        login.click()
        # driver.find_element_by_id('img_out_2295122015').click()
        time.sleep(1)  # wait 1 seconds, if cannot get cookie, try bigger number
        cookie = driver.get_cookie(name)['value']
        driver.quit()
        if cookie is None:
                return failed
        return openid, cookie


class Interactive(PyQt5.QtCore.QObject):
        def __init__(self, parent=None):
                super(Interactive, self).__init__(parent)
                self.baseurl = self.refresh()

        @staticmethod
        def refresh():
                wuxia_id = '1450003565'
                ask = {}
                ask['openid'], skey = _get_cookies('skey')
                ask['session_id'] = 'uin'
                ask['session_type'] = 'skey'
                if ask['openid'] == 0:
                        return None
                ask['openkey'] = quote(skey)
                ask['sck'] = hashlib.md5((wuxia_id + skey).encode(
                        'utf-8')).hexdigest().upper()
                url = api.baseurl_role_search
                for i in ['openid', 'openkey', 'session_id', 'session_type', 'sck']:
                        url += '&' + i + '=' + ask[i]
                return url

        @PyQt5.QtCore.pyqtSlot(str, str, result=list)
        def get_role(self, provide_uin, zone):
                def _unquote(x):
                        return {'role_name': unquote(x['role_name']),
                                'role_id': x['role_id']}
                if self.baseurl is None:
                        return [{'role_name': '获取sck失败'}]
                zoneid = api.zone_to_id(zone)
                url = self.baseurl
                url += '&provide_uin=' + provide_uin
                url += '&zoneid=' + zoneid
                content = urllib.request.urlopen(url)
                content = eval(content.read())

                if content['ret'] != 0:
                        try:
                                return [{'role_name': content['msg']}]
                        except KeyError:
                                return [{'role_name': '读取失败'}]
                return list(map(_unquote, content['role_list']))

        @PyQt5.QtCore.pyqtSlot(str)
        def output(self, string):
                print(string)
