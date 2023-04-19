# -*- coding: utf-8 -*-
from bottle import route, run, template, debug, request, static_file
from add import *
import threading, time, sys, signal

should_stop_checking = False
def check_vps():
    global should_stop_checking
    while not should_stop_checking:
        CheckVPS()
        checkDateTime()
        time.sleep(10) # 每隔60秒执行一次
        
# 正常结束进程
def signal_handler(sig, frame):
    global should_stop_checking
    should_stop_checking = True
    print("程序已结束,等待进程关闭")
    sys.exit(0)
# 多线程
def thread_check(signal_handler):
    signal.signal(signal.SIGINT, signal_handler)
    t1 = threading.Thread(target=check_vps)
    t1.start()

thread_check(signal_handler)

debug(True)
@route('/')
def home():
    return template('tpl/home.tpl')

@route('/css/<fname>', method = 'GET')
def home(fname):
    return static_file(fname, root='tpl/css')

@route('/add', method = 'POST')
def add():
    name = request.forms.get('name')
    ops = request.forms.get('ops')
    cookie = request.forms.get('cookie')
    addVps({'name': name, 'ops': ops, 'cookie': cookie})
    return {'message':'添加成功'}
@route('/select')
def select():
    return selectAllInfo_Info()
@route('/del', method = 'POST')
def delete():
    id = request.forms.get('id')
    return deleteVPS(id)
@route('/modify', method = 'POST')
def delete():
    id = request.forms.get('id')
    name = request.forms.get('name')
    ops = request.forms.get('ops')
    cookie = request.forms.get('cookie')
    return updateVPS([id, name, ops, cookie])

@route('/checkPwd', method = 'POST')
def checkPwd():
    try:
        res = conf('password')
        Password = res['password']
        pwd = request.forms.get('pwd')
        if pwd == Password:
            return {'msg': 'success'}
        else:
            return {'msg': 'reject'}
    except:
        print(conf('password'))
        print(request.forms.get('pwd'))
        print('error')
@route('/sel_id', method = 'POST')
def sel_Id():
    id = request.forms.get('id')
    return selectVPSForId(id)
# run(host='localhost', port=8080, reloader=True, server='wsgiref')


cf = conf('prot')
# print(cf)
if cf == None:
        print('配置文件读取失败')
        sys.exit(0)
else:
    if cf['port'] != '':
            run(host='::', port=cf['port'], server='wsgiref')
    else:
        print('配置文件读取不正确')

# 后台运行
# nohup python3 -u main.py > monitor.log 2>&1 &
