<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>hax&woiden&vc续期监控</title>
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
<style>
    * {
        margin: 0;
        padding: 0;
    }

    html,
    body {
        height: 100vh;
        width: 100vw;
    }

    /* 对于小于等于 768 像素的设备 */
    @media (max-width: 768px) {
        body {
            background-color: #fff;
            background-image: url('https://auxos.cn/template/stat/2.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: scroll;
        }

        /* 在这里定义样式 */
        .box {
            width: 100%;
            height: 100%;
            background-repeat: no-repeat !important;
            background-size: cover !important;
            position: absolute;
            display: None;
        }
        .overlay,.add_window, .modify_window{
            display: none;
        }
    }

    /* 对于大于 768 像素的设备 */
    @media (min-width: 769px) {
        body {
            background-color: #fff;
            background-image: url('https://auxos.cn/template/stat/1.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: scroll;
        }

        .box {
            width: 100%;
            height: 100%;
            position: absolute;
            text-align: center;
        }

        h1 {
            text-align: center;
            margin-top: 8%;
        }

        .add_span {
            display: block;
            margin-top: 2%;
            font-size: 14px;
            font-family: Cambria, Cochin, Georgia, Times, 'Times New Roman', serif;
        }

        .add_span a {
            cursor: pointer;
        }

        .content {
            max-width: 1175px;
            min-height: 200px;
            /* background-color: rgba(125, 125, 125, 0.4); */
            margin: auto;
            margin-top: 2%;
            border-radius: 20px;
            /* border: 1px dotted #4fbcde; */
            display: flex;
            justify-content: center;
            text-align: center;
            flex-wrap: wrap;
        }

        .content .child {
            /* 确保子元素不会超出 content 的高度 */
            overflow: hidden;
        }

        .overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(125, 125, 125, 0.5);
            /* 半透明黑色背景 */
            z-index: 1;
            /* 遮罩层置于最上层 */
            display: none;
            /* 初始状态下隐藏 */
        }

        .add_window {
            text-align: center;
            border-radius: 10px;
            width: 30%;
            height: 40%;
            background-color: #ffffff;
            display: None;
            position: fixed;
            top: 50%;
            left: 50%;
            z-index: 2;
            transform: translate(-50%, -50%);
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .modify_window {
            text-align: center;
            border-radius: 10px;
            width: 30%;
            height: 40%;
            background-color: #ffffff;
            display: None;
            position: fixed;
            top: 50%;
            left: 50%;
            z-index: 2;
            transform: translate(-50%, -50%);
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .add_window form,
        .modify_window form {
            margin: 20px;
        }

        .add_window ul,
        .modify_window ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .add_window li,
        .modify_window li {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
        }

        .add_window label,
        .modify_window label {
            width: 120px;
            text-align: right;
            margin-right: 10px;
            font-size: 16px;
        }

        .add_window input,
        .modify_window input[type=text],
        .add_window select,
        .modify_window select {
            flex: 1;
            height: 30px;
            border-radius: 5px;
            border: 1px solid #ccc;
            padding: 5px;
            font-size: 16px;
            color: #555;
        }

        .add_window button,
        .modify_window button {
            background-color: #4CAF50;
            border: none;
            color: white;
            padding: 10px 20px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin-right: 10px;
            border-radius: 5px;
            cursor: pointer;
        }

        .add_window button[type=submit],
        .modify_window button[type=submit] {
            background-color: #008CBA;
        }

        .add_window button[type=button].modify_window button[type=button] {
            background-color: #f44336;
        }

        .vps {
            width: 350px;
            height: 150px;
            /* background: linear-gradient(to bottom, #4fbcde, #ffcc02); */
            background-color: rgba(255, 255, 255, 0.4);
            /* border-radius: 30px; */
            margin: 5px;
            text-align: center;
            float: left;
            box-shadow: 8px 8px 10px rgba(0, 0, 0, 0.4);
            /* overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap; */
        }

        .vps span {
            width: 100%;
            height: 30px;
            float: left;
        }

        .vps #name {
            width: 210px;
            display: flex;
            justify-items: center;
            padding-left: 15px;
            color: #000000;
        }

        .vps #btn {
            width: 40px;
            text-align: center;
            float: right;
            background-color: rgb(255, 255, 255, 1);
            /* border: None; */
            margin-right: 20px;
            font-weight: 500;
            border: 1px;
            height: 20px;
            box-shadow: 5px 5px 7px rgba(0, 0, 0, 0.5);
            cursor: pointer;
            /* border-radius: 5px; */
        }

        .vps #vpsHeader {
            padding-top: 10px;
            /* border-top-left-radius: 30px;
            border-top-right-radius: 30px; */
            font-weight: 900;
            height: 30px;
            background-color: rgba(55, 253, 226, 0.2);
            border-bottom: 1px solid #555;
        }

        .vps #vpsInfo {
            height: 109px;
            width: 100%;
        }

        .vps #vpsInfo span {
            width: 120px;
            height: 21px;
            display: flex;
            justify-content: right;
            align-items: center;
            font-size: 12px;
            font-weight: 550;
            color: #555;

        }

        .vps #vpsInfo h5 {
            width: 200px;
            height: 21px;
            display: flex;
            justify-content: left;
            align-items: center;
            color: #555;
            /* padding-right: 20px; */
        }

        .vps #vpsHeader #cookieVal,
        .vps #vpsHeader #opsVal {
            display: none;
        }

        .vps .ip_address {
            width: 300px;
            height: 1.2em;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            /* display: inline-block;
            width: 100px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis; */
        }

        .vps .ip_address:hover {
            overflow: visible;
        }

        /* 在这里定义样式 */

    }
</style>
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
            const pstTime = new Date(item[5] + ' 00:00:00 PST');
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
            if (utcTime == 'Invalid Date'){
                utcStr = 'null';
            }else{
                utcStr = utcTime.toISOString().replace('Z', ' UTC+8').replace('T', ' ').substring(0, 19);
            }
            return `
                <div id='vpsHeader'>
                <span id='cookieVal'>${item[3]}</span>
                <span id='opsVal'>${item[2]}</span>
                <span id='name'>${item[1]}</span>
                <button id='delBtn${item[0]}' value = '${item[0]}' style='color: red'>删除</button>
                <button id='modifyBtn${item[0]}' value = '${item[0]}' style='color: green'>修改</button>
                </div>
                <div id='vpsInfo'>
                <span>Cookie状态：</span> <h5 style='color: ${ckState(item[11])[1]}'>${ckState(item[11])[0]}</h5>
                <span>过期时间：</span> <h5 style="color: #ed9e37; font-size: 14px">${utcStr} UTC+8</h5>
                <!-- <span>创建时间：</span> <h5>${item[4]} CST</h5> -->
                <span>最近查询时间：</span> <h5>${item[10]}</h5>
                <span>位置：</span> <h5>${item[2]}:${item[6]}</h5>
                <!-- <span>IP地址：</span> <h5 class="ip_address">${item[7]}</h5> -->
                <span>Creation Date：</span> <h5 class="ip_address">${item[4]}</h5>
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
            modify_window.style.display = "flex";
            overlay.style.display = 'block';
            const name = $(this).siblings('#name').html();
            const ops = $(this).siblings('#opsVal').html();
            const cookie = $(this).siblings('#cookieVal').html();
            const formHTML = `
        <h2>修改监控信息</h2>
        <form id="modifyWindow">
            <ul>
                <li>
                    <input type="text" id="id" name="id" value='${btnValue}' style="display: none" readonly required>
                    <label for="ops">选择小鸡站：</label>
                    <select id="ops" name="ops">
                        <option value="hax" ${ops === 'hax' ? 'selected' : ''}>Hax</option>
                        <option value="woiden" ${ops === 'woiden' ? 'selected' : ''}>Woiden</option>
                        <option value="vc" ${ops === 'vc' ? 'selected' : ''}>Vc</option>
                    </select>
                </li>
                <li>
                    <label for="cookie">网页Cookie：</label>
                    <input type="text" id="cookie" name="cookie" value='${cookie}' required>
                </li>
                <li>
                    <label for="name">设置备注名：</label>
                    <input type="text" id="name" name="name" value='${name}' required>
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
    function delContentChild() {
        const content = $(".content"); // 获取指定的 div 元素
        while (content.firstChild) { // 循环删除所有子元素
            content.removeChild(content.firstChild);
        }
    }
    setInterval(selectAll, 20000)
</script>

</html>