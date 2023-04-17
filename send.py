# -*- coding: utf-8 -*-
import configparser, requests, smtplib, datetime
from email.mime.text import MIMEText
from email.utils import formataddr
from sql import addSend, selectSend

def conf(s_name):
    config = configparser.ConfigParser()
    try:
        with open('config.ini', 'r', encoding='utf-8') as f:
            config.read_file(f)
        list = {}
        for k,v in config.items(s_name):
            list.update({k: v})
        return list
    except:
        return None
    
def sendMsg(m_id, msg):
    options = conf('options')
    if options == None:
        print('配置文件读取失败')
    else:
        if options['tgbot'] == '1' and options['email'] == '0':
            tg(m_id, msg)
        elif options['tgbot'] == '0' and options['email'] == '1':
            mail(m_id, msg)
        elif options['tgbot'] == '1' and options['email'] == '1':
            tg(m_id, msg)
            mail(m_id, msg)
        else:
            print('配置文件读取不正确')
    
def tg(m_id, msg):
    try:
        res = selectSend(m_id, 1)
        if len(res) == 0:
            item = conf('tgbot_info')
            bot_token = item['tgbot_token']
            chat_ids = item['chat_ids'].split(',')
            url = f'https://api.telegram.org/bot{bot_token}'
            try:
                for chat_id in list(set(chat_ids)):
                    data = {
                        'chat_id' : chat_id,
                        'text': msg
                    }
                    resp = requests.post(f"{url}/sendMessage", data=data)
                    addSend(m_id, msg, 1)
                    print(resp.json())

            except:
                print('TGbot接口请求失败,发送失败')
        else:
            if (datetime.datetime.now() - datetime.datetime.strptime(res[0][4], '%Y-%m-%d %H:%M:%S')) > datetime.timedelta(minutes=30):
                item = conf('tgbot_info')
                bot_token = item['tgbot_token']
                chat_ids = item['chat_ids'].split(',')
                url = f'https://api.telegram.org/bot{bot_token}'
                try:
                    for chat_id in list(set(chat_ids)):
                        data = {
                            'chat_id' : chat_id,
                            'text': msg
                        }
                        resp = requests.post(f"{url}/sendMessage", data=data)
                        addSend(m_id, msg, 1)
                        print(resp.json())

                except:
                    print('TGbot接口请求失败,发送失败')
            # else:
                # print('1分钟内已发送')
    except:
        pass
def mail(m_id, msg):
    try:
        res = selectSend(m_id, 2)
        if len(res) == 0:
            ei = conf('email_info')
            for r_email in ei['receiver_email'].split(','):
                message = MIMEText(msg, 'plain', 'utf-8')
                message['From'] = formataddr(('AUXBot', ei['sender_email']))
                message['To'] = formataddr(('告警用户',r_email))
                message['Subject'] = ei['subject']
                # try:
                #     message['Subject'] = msg.split('\n')[0]
                # except:
                #     message['Subject'] = msg
                try:
                    server = smtplib.SMTP_SSL(ei['smtp_server'], 465)
                    server.login(ei['sender_email'], ei['sender_password'])
                    server.sendmail(ei['sender_email'], r_email, message.as_string())
                    server.quit()
                    print('通知邮件发送成功')
                    addSend(m_id, msg, 2)
                except Exception as e:
                    print(f'通知邮件发送失败,错误信息{e}')
        else:
            if (datetime.datetime.now() - datetime.datetime.strptime(res[0][4], '%Y-%m-%d %H:%M:%S')) > datetime.timedelta(hours=8):
                ei = conf('email_info')
                for r_email in ei['receiver_email'].split(','):
                    message = MIMEText(msg, 'plain', 'utf-8')
                    message['From'] = formataddr(('AUXBot', ei['sender_email']))
                    message['To'] = formataddr(('告警用户',r_email))
                    message['Subject'] = ei['subject']
                    # try:
                    #     message['Subject'] = msg.split('\n')[0]
                    # except:
                    #     message['Subject'] = msg
                    try:
                        server = smtplib.SMTP_SSL(ei['smtp_server'], 465)
                        server.login(ei['sender_email'], ei['sender_password'])
                        server.sendmail(ei['sender_email'], r_email, message.as_string())
                        server.quit()
                        print('通知邮件发送成功')
                        addSend(m_id, msg, 2)
                    except Exception as e:
                        print(f'通知邮件发送失败,错误信息{e}')
    except:
        pass