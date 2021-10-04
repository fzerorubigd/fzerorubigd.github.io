+++
categories = ["go", "trick"]
date = "2016-05-01T08:01:37+04:30"
title = "تزریق! نسخه به باینری وقت کامپایل #Golang"
description="برای این قسمت تصمیم گرفتم اسم سرخ پوستی بذارم، یه چیزی تو مایه های لطفا بمیر پلن ناین لعنتی!"
keywords = ["go"]
+++
بدنیست همیشه یه اطلاعاتی از نسخه برنامه تو دل خودش باشه. مدتهاست که من از Make برای کامپایل برنامه استفاده میکنم، و قبلترها، قبل از اینکه کامپایل کنم برنامه رو، یک فایل میساختم (به صورت اتوماتیک) مثلا با این محتوا : 

```go
package main 
// this file is autogenerated
var (
	// Commit hash 
	hash  = "a5df371b88bc3f875f49a3b7e19b55c88cd31487"
	short = "a5df371"
	// commit date
	date  = "2016-04-30 11:21:46 +0430 +0430"
	// build date 
	build = "2016-04-30 11:21:46 +0430 +0430"
	// commit count
	count = "42"
)
```

بعد قبل هر کامپایل این فایل مجددا ساخته میشه و متغیرهاش آپدیت میشن. خوبه، ولی نه به اندازه کافی. این فایل باید ignore بشه تو ورژن کنترل، کسی از کامند مناسب استفاده نکنه ساخته نمیشه و الی آخر. این شد که افتادم دنبال راه حل بهتر. 

بعد از اینکه کامپایلر کارش تموم میشه، و فایل های میانی ساخته میشن، لینکر اونها رو به هم لینک میکنه و فایل نهایی ساخته میشن. تو این مرحله، تازه رفرنسها مشخص میشن، و ارتباطها پیدا میشن و در صورتی که ارتباطی پیدا نشه خطا گرفته میشه، البته برای گو، یه لول هم قبلتر اتفاق میفته، (بر خلاف سی) ولی خوب، کلا قضیه اینه که اگه بخوای یه متغییر رو عوض کنی، بعد از کامپایل میشه. 


برای اینکار گو سوییچ ‍`-X` رو معرفی کرده. خیلی ساده، `-ldflags "-X pkg.variable=value‍` اینجوری میتونم به لینکر بگم که متغییری به اسم `variable` توی پکیجی به اسم `pkg` باید مقدارش برابر باشه با `value` . با این روش فقط میشه متغییر های رشته ای (string) رو وارد برنامه کرد و تایپ نمیشناسه. 

مثلا این برنامه رو در نظر بگیرید : 
```go 
package main

import (
	"fmt"
)

var variable string

func main() {
	fmt.Println(variable)
}
```
کامپایلش کنید طبیعیه که خروجی یه خط خالیه. ولی حالا اینجوری کامپایلش کنید : 
```
go build -ldflags "-X main.variable=value"
```

و دیگه خروجی خالی نیست. اگه از [gb](https://getgb.io/) استفاده میکنید (من استفاده میکنم :) ) اونهم این فلگ رو میشناسه. مثلا من این خطوط رو اول Makefile گذاشتم : 

```
export LONGHASH=$(shell git log -n1 --pretty="format:%H" | cat)
export SHORTHASH=$(shell git log -n1 --pretty="format:%h"| cat)
export COMMITDATE=$(shell git log -n1 --pretty="format:%cd"| sed -e "s/ /-/g")
export COMMITCOUNT=$(shell git rev-list HEAD --count| cat)
export BUILDDATE=$(shell date| sed -e "s/ /-/g")
export FLAGS="-X shared/config.hash=$(LONGHASH) -X shared/config.short=$(SHORTHASH) -X shared/config.date=$(COMMITDATE) -X shared/config.count=$(COMMITCOUNT) -X shared/config.build=$(BUILDDATE)"
export LDARG=-ldflags $(FLAGS)
```

و هر وقت تو Makefile بخوام چیزی رو کامپایل کنم اینجوری میشه : 

```
$(BIN)/gb build $(LDARG)
```
تو پکیج `shared/config` هم چنین چیزی دارم : 

```
// The following variables are injected at compile time, do not edit
var (
	hash  string
	short string
	date  string
	build string
	count string
)

func init() {
	Config.Count, _ = strconv.ParseInt(count, 10, 64)
	Config.Date, _ = time.Parse("Mon-Jan-02-15:04:05-2006--0700", date)
	Config.Hash = hash
	Config.Short = short
	Config.BuildDate, _ = time.Parse("Mon-Jan-02-15:04:05-MST-2006", build)

}

```


-- متوجه شدید این حضرات مکافات، تو کامپایلر go به جای دو تا دش از یه دش استفاده میکنن؟ این یکی از مشکلاتیه که من باهاشون دارم! لامصبا رفتن استاندارد مزخرف [plan9](https://en.wikipedia.org/wiki/Plan_9_from_Bell_Labs) رو اینجا استفاده کردن به جای [getopt](https://en.wikipedia.org/wiki/Getopt) :/ 


