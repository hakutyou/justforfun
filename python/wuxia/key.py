import selenium.webdriver

__all__ = [
    'get_cookies',
    'cookies_element',
]

def get_cookies():
    options = selenium.webdriver.firefox.options.Options()
    options.add_argument('-headless')
    driver = selenium.webdriver.Firefox(executable_path='geckodriver',
                                        firefox_options=options)
    # https://github.com/mozilla/geckodriver/releases
    wait = selenium.webdriver.support.wait.WebDriverWait(driver, timeout=10)
    driver.get('http://wuxia.qq.com/comm-htdocs/pay/new_index.htm?t=wuxia')
    driver.switch_to_frame('__LoginIframe__')
    try:
        login = driver.find_element_by_xpath('//div[@id="qlogin_list"]/a[@class="face"]/span[@type="4"]')
    except selenium.common.exceptions.NoSuchElementException:
        print('未登录')
        return 0, 0
    openid = login.get_attribute('uin')
    login.click()
    # driver.find_element_by_id('img_out_2295122015').click()
    cookies = driver.get_cookies()
    driver.quit()
    return openid, cookies

def cookies_element(name, cookies):
    for cookie in cookies:
        if cookie['name'] == name:
            return cookie['value']
