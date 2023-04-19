<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>hax&woiden&vc续期监控</title>
    <link rel="stylesheet" type="text/css" href="css/home.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>
    <div class="box">
        <h1>小鸡监控系统</h1>
        <span class="add_span"><a>添加监控</a></span>
        <div class="content"></div>
    </div>

    <div class="overlay"></div>
    <!-- 隐藏的添加窗口 -->
    <div class="add_window">
        <h2>添加一个监控</h2>
        <form id="add">
            <ul>
                <li>
                    <label for="ops">选择小鸡站：</label>
                    <select id="ops" name="ops">
                        <option value="hax">Hax</option>
                        <option value="woiden">Woiden</option>
                        <option value="vc">Vc</option>
                    </select>
                </li>
                <li>
                    <label for="cookie">网页Cookie：</label>
                    <input type="text" id="cookie" name="cookie" required>
                </li>
                <li>
                    <label for="name">设置备注名：</label>
                    <input type="text" id="name" name="name" required>
                </li>
                <li>
                    <button type="submit">提交</button>
                    <button type="button" id="close_add">取消</button>
                </li>
            </ul>
        </form>
    </div>
    <div class="modify_window">
    </div>
</body>
<script>
    var addSpan = document.querySelector(".add_span a");
    var addWindow = document.querySelector(".add_window");
    var overlay = document.querySelector(".overlay");
    var sub = document.getElementById('add');
    var close = document.getElementById('close_add');
    var modify_window = document.querySelector('.modify_window')

    addSpan.addEventListener("click", function () {
        addWindow.style.display = "flex";
        overlay.style.display = 'block';
    })

    overlay.addEventListener("click", function () {
        addWindow.style.display = 'None';
        overlay.style.display = 'none';
    })

    close.addEventListener('click', function () {
        addWindow.style.display = 'None';
        overlay.style.display = 'none';
    })

    sub.addEventListener('submit', function (e) {
        e.preventDefault();
        const ops = document.getElementById("ops").value;
        const cookie = document.getElementById("cookie").value;
        const form = document.getElementById('add')
        const xhr = new XMLHttpRequest();
        xhr.onload = function () {
            if (this.status == 200) {
                // const resp = xhr.responseText;
                selectAll()
            } else {
                console.log('添加失败');
            }
        }
        xhr.open('POST', '/add', true);
        const formData = new FormData(form);
        xhr.send(formData);
        addWindow.style.display = 'None';
        overlay.style.display = 'none';
    })
    $(document).ready(function () {
        selectAll()
    })
    function selectAll() {
        var xhr = new XMLHttpRequest();
        let count = 0;
        xhr.open('GET', '/select', true);
        xhr.onload = function () {
            if (this.status == 200) {
                const resp = JSON.parse(xhr.responseText);
                if (resp.msg == null) {
                    var $h2null = $("<h2>").text("未添加监控");
                    $(document).ready(function () {
                        $(".content").append($h2null);
                    })
                } else {
                    $('.content').off('click', '[id^="delBtn"]');
                    $('.content').off('click', '[id^="modifyBtn"]');
                    addblock(resp);
                }
            } else {
                console.log('请求失败');
            }
        }
        xhr.send();
    }
    function addblock(resp) {
        $('.content').empty();
        const content = $('.content');
        const blocks = []; // 存放要添加的元素的数组
        const template = (item) => {
            const pstTime = new Date(item[4] + ' 00:00:00 PST');
            pstTime.setHours(pstTime.getHours() + 23);
            pstTime.setMinutes(pstTime.getMinutes() + 59);
            pstTime.setSeconds(pstTime.getSeconds() + 59); // 在PST时间上加上23小时59分59秒
            // 获取当前时区偏移量
            const timeZoneOffset = new Date().getTimezoneOffset() * 60 * 1000;
            // 计算UTC时间戳
            const utcTimestamp = pstTime.getTime() - timeZoneOffset;
            // 创建UTC时间对象
            const utcTime = new Date(utcTimestamp);
            var utcStr
            // 转换成UTC+8时间字符串
            if (utcTime == 'Invalid Date') {
                utcStr = 'null';
            } else {
                utcStr = utcTime.toISOString().replace('Z', ' UTC+8').replace('T', ' ').substring(0, 19)+' UTC+8';
            }
            return `
                <div id='vpsHeader'>
                <span id='opsVal'>${item[2]}</span>
                <span id='name'><span style='color: ${ckDate(utcStr)[1]}; font-size: 15px; width: 55px'>${ckDate(utcStr)[0]}</span>:${item[1]}</span>
                <button id='delBtn${item[0]}' value = '${item[0]}' style='color: red'>删除</button>
                <button id='modifyBtn${item[0]}' value = '${item[0]}' style='color: green'>修改</button>
                </div>
                <div id='vpsInfo'>
                <span>Cookie状态：</span> <h5 style='color: ${ckState(item[7])[1]}'>${ckState(item[7])[0]}</h5>
                <span>过期时间：</span> <h5 style="color: #ed9e37; font-size: 14px">${utcStr}</h5>
                <span>最近查询时间：</span> <h5>${item[6]}</h5>
                <span>位置：</span> <h5>${item[2]}:${item[5]}</h5>
                <span>Creation Date：</span> <h5 class="ip_address">${item[3]}</h5>
                </div>
            `;
        };
        delContentChild(); // 删除之前的所有子元素
        resp.msg.forEach((item) => {
            const block = document.createElement('div');
            block.className = 'vps';
            block.innerHTML = template(item);
            blocks.push(block); // 添加到数组中
        });
        content.append(...blocks); // 一次性添加到 content 中
        // 给所有删除按钮都添加点击事件的监听函数
        $('.content').on('click', '[id^="delBtn"]', function () {
            const btnValue = this.getAttribute('value'); // 获取当前按钮的 value
            const name = $(this).siblings('#name').html()// 获取当前条目的名称
            const currentBtn = this; // 保存当前按钮的引用
            const confirmed = confirm(`确定要删除 ${name} 的监控吗？`);
            if (confirmed) {
                $.ajax({
                    type: "POST",
                    url: '/del',
                    data: {
                        id: btnValue
                    },
                    success: function (resp) {
                        $(currentBtn).parent().parent().remove();
                    },
                    error: function (xhr, status, error) {
                        console.error(xhr);
                        console.error(status);
                        console.error(error);
                    }
                })
            } else {
                console.log('取消');
            }
        });

        // 给所有修改按钮都添加点击事件的监听函数
        $('.content').on('click', '[id^="modifyBtn"]', function () {
            const btnValue = this.getAttribute('value'); // 获取当前按钮的 value
            const pwd = prompt('请输入验证密码：');
            if (pwd != null) {
                $.ajax({
                    type: "POST",
                    url: '/checkPwd',
                    data: {
                        pwd: pwd
                    },
                    success: function (resp) {
                        console.log(resp);
                        if (resp['msg'] == 'success') {
                            $.ajax({
                                type: 'POST',
                                url: '/sel_id',
                                data: {
                                    id: btnValue
                                },
                                success: function (resp) {
                                    modify_window.style.display = "flex";
                                    overlay.style.display = 'block';
                                    const ops = resp['msg'][0][2]
                                    const formHTML = `
                                        <h2>修改监控信息</h2>
                                        <form id="modifyWindow">
                                            <ul>
                                                <li>
                                                    <input type="text" id="id" name="id" value='${resp['msg'][0][0]}' style="display: none" readonly required>
                                                    <label for="ops">选择小鸡站：</label>
                                                    <select id="ops" name="ops">
                                                        <option value="hax" ${ops === 'hax' ? 'selected' : ''}>Hax</option>
                                                        <option value="woiden" ${ops === 'woiden' ? 'selected' : ''}>Woiden</option>
                                                        <option value="vc" ${ops === 'vc' ? 'selected' : ''}>Vc</option>
                                                    </select>
                                                </li>
                                                <li>
                                                    <label for="cookie">网页Cookie：</label>
                                                    <input type="text" id="cookie" name="cookie" value='${resp['msg'][0][3]}' required>
                                                </li>
                                                <li>
                                                    <label for="name">设置备注名：</label>
                                                    <input type="text" id="name" name="name" value='${resp['msg'][0][1]}' required>
                                                </li>
                                                <li>
                                                    <button type="submit" id="modify_commit">提交</button>
                                                    <button type="button" id="cancel">取消</button>
                                                </li>
                                            </ul>
                                        </form>
                                    `;
                                    modify_window.innerHTML = formHTML;
                                    $('#modify_commit').on('click', function (event) {
                                        event.preventDefault()
                                        const formData = $('#modifyWindow').serialize(); // 获取表单数据
                                        $.ajax({
                                            type: "POST",
                                            url: '/modify',
                                            data: formData,
                                            success: function (resp) {
                                                if (resp.msg === '修改成功') {
                                                    // 修改成功后，隐藏 modify_window 和 overlay
                                                    modify_window.style.display = 'none';
                                                    overlay.style.display = 'none';
                                                    selectAll()
                                                } else {
                                                    console.log(resp);
                                                }
                                            },
                                            error: function (xhr, status, error) {
                                                console.error(xhr);
                                                console.error(status);
                                                console.error(error);
                                            }
                                        })
                                    })
                                    $('#cancel').on('click', function (event) {
                                        modify_window.style.display = 'none';
                                        overlay.style.display = 'none';
                                    })
                                    overlay.addEventListener("click", function () {
                                        modify_window.style.display = 'none';
                                        overlay.style.display = 'none';
                                    })
                                }
                            })
                        } else {
                            alert('密码验证失败')
                        }
                    }, error: function (xhr, status, error) {
                        console.error(xhr);
                        console.error(status);
                        console.error(error);
                    }
                })
            }
        });
    }
    function ckState(state) {
        var monitor_stat = '异常';
        var monitor_stat_color = 'red';
        if (state == 1) {
            monitor_stat = '正常';
            monitor_stat_color = 'green';
        }
        return ([monitor_stat, monitor_stat_color])
    }
    function ckDate(state){
        dt = ((new Date(state) - new Date().getTime()) / 1000).toFixed(2);
        dt = dt/3600/24;
        if ( dt > 3 ) {
            return(['正常','green'])
        }else if( 0 < dt && dt <= 3 ) {
            return(['待续期','yellow'])
        }else if (dt > 10 || dt < 0) {
            return(['已过期', 'red'])
        }else{
            return(['无状态', 'red'])
        }
    }
    function delContentChild() {
        const content = $(".content"); // 获取指定的 div 元素
        while (content.firstChild) { // 循环删除所有子元素
            content.removeChild(content.firstChild);
        }
    }
    setInterval(selectAll, 20000)
</script>

</html>