+++
categories = ["go" ,"general"]
date = "2016-04-14T17:00:34+04:30"
description = ""
keywords = ["go","webserver" ,"unprivilaged"]
title = "go web server on port 80"
slug="go-web-server"
+++

Golang یک کتابخانه عالی [http](https://golang.org/pkg/net/http/) داره که کلی قابلیت بهت میده. مثلا [http2](http://http2.golang.org/) و  قابلیت ساپورت رنج روی فایل برای دانلود که تقریبا به [سادگی آب خوردن](https://golang.org/pkg/net/http/#ServeContent) پیاده میشه. 
من معمولا یه وب سرور میذاشتم سر راهش. یعنی پروکسیش میکردم. مثلا [nginx](https://www.nginx.com/) و هنوزم خیلی وقتا اینکار رو میکنم. 
منتها یه وقتایی هست که کلا نمیخوای درگیر وب سرور خارجی بشی. دلیلش هر چی هست :)‌ و میخوای از سرور خود Golang استفاده کنی. این کاملا با اون چیزی که توی پایتون و روبی و PHP به عنوان وب سرور به خوردمون دادن متفاوته. این یک سرور آماده برای کاره نه یک وب سرور برای محیط دولوپمنت. 

خوب اوکی، وب سرور آماده کاره، کد من چی؟آیا عاقلانست کدم رو با دسترسی روت اجرا کنم؟ 
چرا با روت؟ چون میخوام رو پورت ۸۰ یا ۴۴۳ گوش وایسه وب سرورم، و طبق استاندارد، فقط برنامه های اجرا شده با دسترسی روت میتونن روی پورتهای پایینتر از ۱۰۲۴ گوش وایسن. 

خوب یه کم نا امید کنندست. من هرگز همچین کاری نمیکنم. میشه انداختش توی داکر و امنیتش رو تا حدی تضمین کرد . دست کم اینه که اگه تو کد من زدم `rm -rf` همه چی نمیترکه. 
ولی راه ساده ترش ایه که به این فایل به خصوص اجازه بدیم رو پورتهای کمتر از ۱۰۲۴ هم گوش وایسه : 

```
# setcap cap_net_bind_service=+ep /path/to/executable
```
طبیعیه که # به معنی اینه که این دستور با دسترسی روت اجرا میشه. بعد از این دستور این برنامه میتونه روی پورتهای پایینتر هم گوش وایسه.

 برای اینکه بفهمید چه اتفاقی میفته، اول `man setcap` رو ببینید و برای لیست `capabilities` هم طبیعتا `man capabilities` رو. 

-- همین. 
