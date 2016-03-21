errMsg = {
    1 : 'Succeed',
    2 : 'Need POST',
    3 : 'Need GET'
}

def error(code):
    return errMsg(code)