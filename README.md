# hax-woiden-vc-renew-monitor

监控系统基于Python3

##食用方法：

* 填写`config.ini`配置文件
* 将需要启用的消息媒介值改为`1`
* **注意：当使用tgbot的时候一定要设置`chat_ids`,填自己的`tgid` 可以填多个`tgid` 用逗号隔开**

  ```ini
  [options]
  #需要使用的提醒方式将0改为1
  tgbot = 0
  email = 0

  ```


* 按文件提示填写消息媒介资料

  ```ini
  [email_info]
  #发件方邮箱
  sender_email = 
  #密码或者key
  sender_password = 
  #收件人信息,多个请用英文逗号隔开
  receiver_email = 
  #smtp服务器,默认是QQ邮箱,如用其他邮箱请自行修改
  smtp_server = 
  #邮件标题(修改即生效)
  subject = VPS即将到期通知
  [tgbot_info]
  #telegram 机器人的key
  tgbot_token = 
  #指定推送的TGchatid,如有多个ID用英文逗号(,)隔开,选择tgbot则此项必填
  chat_ids = 
  ```
* 配置网页端口信息
  默认端口8080，访问 `ip:8080` 修改该项后使用 `ip:端口` 访问

  ```
  [prot]
  #网页运行端口
  port = 8080
  ```
* 安装支持包

  ```bash
  #进入到项目目录下执行
  pip3 install -r requirements.txt
  ```
* 启动监控

  ```bash
  #直接启动
  python3 main.py
  #后台运行,记录日志(日志记录在当前目录的bot.log中)
  nohup python3 -u main.py > monitor.log 2>&1 &
  ```

```

```
