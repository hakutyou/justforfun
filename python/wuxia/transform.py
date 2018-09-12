import urllib.parse
import hashlib

def to_md5(text, upper=True, coding='utf-8'):
    result = hashlib.md5(text.encode(coding)).hexdigest()
    if upper:
        result = result.upper()
    return result

def to_url(text):
    return urllib.parse.quote(text)

def from_url(text):
    return urllib.parse.unquote(text)
