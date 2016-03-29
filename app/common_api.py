errMsg = {
    1 : 'Succeed',
    2 : 'Need POST',
    3 : 'Need GET',
    4 : 'Run matlab error',
    5 : 'File is too big!'
}

def error(code):
    return {"code":code,"errMsg":errMsg[code]}