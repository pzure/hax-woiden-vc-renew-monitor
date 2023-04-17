# -*- coding: utf-8 -*-
import sqlite3, os, datetime

def connSqlite():
    conn = None
    if os.path.exists(''):
        conn = sqlite3.connect('monitor.db')
    else:
        conn = sqlite3.connect('monitor.db')
        c = conn.cursor()
        c.execute('''CREATE TABLE IF NOT EXISTS vps
                    (id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT,
                    ops TEXT,
                    cookie TEXT,
                    creation_date TEXT,
                    valid_until TEXT,
                    location TEXT,
                    ipv6 TEXT,
                    ram TEXT,
                    disk_total TEXT,
                    update_time TEXT,
                    state INTEGER DEFAULT 0)
                ''')

        c.execute('''CREATE TABLE IF NOT EXISTS send
                    (id INTEGER PRIMARY KEY AUTOINCREMENT,
                    monitor_id INTEGER,
                    content TEXT,
                    flag INTEGER,
                    date TEXT DEFAULT (datetime('now', 'localtime')))
                ''')
        conn.commit()
    return conn
def addSql(name, ops, cookie):
    conn = connSqlite()
    exec = conn.cursor()
    exec.execute("insert into vps(name, ops, cookie) values(?, ?, ?)",(name, ops, cookie))
    conn.commit()
    conn.close()
def selectSql():
    conn = connSqlite()
    exec = conn.cursor()
    exec.execute('select * from vps')
    res = exec.fetchall()
    conn.close()
    return res
def selectSql_VPS_ID(id):
    conn = connSqlite()
    exec = conn.cursor()
    exec.execute('select * from vps where id = ?',(id,))
    res = exec.fetchall()
    conn.close()
    return res
def updateInfoSql(creation_date,valid_until,location,ipv6,ram,disk_total,id):
    conn = connSqlite()
    exec = conn.cursor()
    exec.execute("update vps set creation_date=?, valid_until=?, location=?, ipv6=?, ram=?, disk_total=?, update_time=?, state=? where id=?",(
        creation_date,valid_until,location,ipv6,ram,disk_total, datetime.datetime.now(), 1, id
    ))
    conn.commit()
    conn.close()
def updateState(state, id):
    conn = connSqlite()
    exec = conn.cursor()
    exec.execute("update vps set state=? where id=?",(state, id))
    conn.commit()
    conn.close()
def updateVps(name, ops, cookie, id):
    conn = connSqlite()
    exec = conn.cursor()
    exec.execute("update vps set name=?, ops=?, cookie=? where id=?",(name, ops, cookie, id))
    conn.commit()
    conn.close()
def deleteVps(id):
    conn = connSqlite()
    exec = conn.cursor()
    exec.execute("delete from vps where id=?",(id,))
    conn.commit()
    conn.close()
def addSend(m_id, msg, flag):
    conn = connSqlite()
    exec = conn.cursor()
    exec.execute("insert into send(monitor_id, content, flag) values(?, ?, ?)",(m_id, msg, flag))
    conn.commit()
    conn.close()
def selectSend(m_id, flag):
    conn = connSqlite()
    exec = conn.cursor()
    exec.execute("select * from send where monitor_id = ? and flag = ? order by date DESC LIMIT 1",(m_id, flag))
    res = exec.fetchall()
    conn.close()
    return res