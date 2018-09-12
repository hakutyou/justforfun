import selenium.webdriver
import requests

baseurl = 'http://apps.game.qq.com/daoju/v3/recommend/common?jsonp_name=recommend_friend'

def daoju_login():
    options = selenium.webdriver.firefox.options.Options()
    options.add_argument('-headless')
    driver = selenium.webdriver.Firefox(executable_path='geckodriver',
                                        firefox_options=options)
    # https://github.com/mozilla/geckodriver/releases
    wait = selenium.webdriver.support.wait.WebDriverWait(driver, timeout=10)
    driver.get('https://xui.ptlogin2.qq.com/cgi-bin/xlogin?s_url=http%3A%2F%2Fwww.daoju.qq.com')
    try:
        login = driver.find_element_by_xpath('//div[@id="qlogin_list"]/a[@class="face"]/span[@type="4"]')
    except selenium.common.exceptions.NoSuchElementException:
        print('未登录')
        return False
    login.click()
    cookies = driver.get_cookies()
    driver.quit()
    return cookies

def read_friend(cookie, role_id):
    def get_url(sRoleId):
        url = baseurl
        actid = '9150'
        sceneid = '18601'
        jsonp_name = 'recommend_friend'
        for i in ['actid', 'sceneid', 'jsonp_name', 'sRoleId']:
            url += '&' + i + '=' + eval(i)
        return url
    s = requests.session()
    c = requests.cookies.RequestsCookieJar()
    for item in cookies:
        c.set(item['name'], item['value'])
    s.cookies.update(c)
    return s.get(get_url(role_id)).text
    
if __name__ == '__main__':
    cookies = daoju_login()
    print(read_friend(cookies, '12700432424161990862')) # not worked
