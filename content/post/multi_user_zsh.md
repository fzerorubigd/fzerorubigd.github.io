+++
date = "2015-01-16T14:36:50+03:30"
draft = false
title = "چند کاربر با یک zsh"
slug = "multi_user_zsh"
+++

قاعدتا نباید پیش بیاد، ولی پیش میاد که نیاز پیدا کنیم که چند نفر بخوان از یک اکانت استفاده کنند خصوصا برای SSH کردن به یک سرور. 
مثلا ما یک برنامه داریم که تحت یک کاربر خاص اجرا شده و همه ما نیاز داریم که با همون کاربر وارد سرور بشیم یا حتی اگه با کاربر خودمون هم باشه در نهایت برای تغییرات، مجبوریم به همون کاربر سوییچ کنیم. 
این کار شاید خوب نباشه، ولی الان بحث من نیست. لطفا نیاید بگید ای داد ای بیداد این مشکل امنیتی داره و فیلان. 

مشکل اینه که با این سیستم، همه مجبور به استفاده از یک سری تنظیمات مشترک میشیم. بیشتر از همه این مشکل خودشو تو تنظیمات شل نشون میده. حقیقت اینه که شل اون کاربر به خصوص ثابته،‌ مثلا برای ما zsh. 

من یه اسکریپت کوچیک نوشتم که بتونیم هم یه کانفیگ مجزا برای zsh داشته باشیم و هم اینکه بتونیم history رو برای هر کاربر جدا کنیم.

این اون اسکریپته : 

<script src="https://gist.github.com/fzerorubigd/a781e6425b810cbbe336.js"></script>
<noscript>
```
#!/bin/env zsh
# to setup :
# mkdir $ROOT/yourname
# $EDITOR $ROOT/yourname/zshrc

ROOT=~/.profiles

if [ -z $PROFILE_DIR ];then
    pushd $ROOT >/dev/null
    FILES=($ROOT/*/)
    FILES+=("Exit")

    select f in ${FILES[*]}
    do
        if [[ "$f" == 'Exit' ]];then
            return
        fi

        if [ -f "$f/zshrc" ];then
            PROFILE_DIR="$f"
            break
        fi
    done

    export PROFILE_DIR
    popd >/dev/null
fi
PROFILE_HISTORY="${PROFILE_DIR}zsh_history"
export HISTFILE=$PROFILE_HISTORY
source $PROFILE_DIR/zshrc

```
</noscript>


برای اینکه کار کنه، پوشه `~/.profiles` رو بسازید، بعد به ازای هر کاربر یه پوشه توی این بسازید
مثلا برای من میشه `~/.profiles/f0rud/` 
بعدش فایل `zshrc` رو برای خودتون بسازید و توی این فولدر بذارید دقت کنید که دیگه دات نداره اسمش.


تا اینجا همه چی اوکیه. ولی باحال تر میشه اگه کسی بخواد با ssh کردن، اتوماتیک خودش سوییچ بشه به کانفیگ مورد نظرش. 
برای اینکار باید به ssh بگیم که به env های کاربر توی فایل  ‍‍‍‍
`~/.ssh/authorized_keys` احترام بذاره. 

برای این کار بادی این آپشن  ‍`PermitUserEnvironment`
رو روشن کنید. البته یه ریسک هم داره : 

```Specifies whether ~/.ssh/environment and environment= options in
     ~/.ssh/authorized_keys are processed by sshd.  The default is
     "no".  Enabling environment processing may enable users to bypass
     access restrictions in some configurations using mechanisms such
     as LD_PRELOAD.```
     
بعدش کافیه تو فایل `~/.ssh/authorized_keys` که کلیدهای ssh خودتون رو اضافه میکنید،‌برای کاربر خودتون 
قبل از کلید خودتون اینو بنویسید : 
‍‍‍```
PROFILE_DIR=~/.profiles/f0rud/ ssh-rsa AAAAB3NzaC1yc2...
```
اون اسلش آخر هم لازمه. 
اینجوری دیگه زمان لاگین از طریق SSH پروفایل درست انتخاب میشه و دیگه نیازی به انتخاب اولیه نیست. 

