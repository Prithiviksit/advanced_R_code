library(pryr)


# 6.2.1
j<-function(x){
    y<-2
    function()c(x,y)
}
k<-j(1)
k()
rm(j,k)
# When function k is created the variable y is preserved in the environment

# 6.2.2
l<-function(x)x+1
m<-function(){
    l<-function(x) x+2
    l(10)
}
m()
rm(l,m)

n<-function(x)x/2
o<-function(){
    n<-10
    n(n)
}
o()
rm(n,o)
# the variable n defined in the o function is not a function, so it is ignored;

# 6.2.3
j<-function(){
    if(!exists("a")){
        a<-1
    }else{
        a<-a+1
    }
    print(a)
}
j()
j()
rm(j)
# always return 1 since everytime the function is called, a new environment is created

j<-function(){
    if(!exists("a")){
        a<<-1
    }else{
        a<<-a+1
    }
    print(a)
}
j()
# return 1, 2, 3 instead;



# 6.2.4
f<-function()x
x<-15
f()
x<-20
f()
# R determined the value when the function is called, not created.


f<-function()x + 1
codetools::findGlobals(f)
# find global dependence

environment(f)<-emptyenv()
f()


# 6.2.5

c<-10
c(c=c)

f<-function(x){
    f<-function(x){
        f<-function(x){
            x^2
        }
        f(x)+1
    }
    f(x*2)
}
f(10) #21^2

# 6.3

`for`(i,1:2,print(i))

# 6.4

f<-function(abcdef,bcde1,bcde2){
    list(a=abcdef,b1=bcde1,b2=bcde2)
}
str(f(1,2,3))
str(f(2,3,a=1))


# 6.4.4 Lazy evaluation
f<-function(x)10
f(stop("This is an error!"))
f()
str(stop("This is an error"))
error<-stop("This is an error")
body(stop)
formals(stop)

f<-function(x){
    force(x)
    10
}
f(stop("This is an error!"))
f()
rm(list=ls())
add<-function(x){
    function(y)x+y
}
adders<-lapply(1:10,add)
adders[[1]](10)
adders[[10]](10)

add<-function(x){
    force(x)
    function(y)x+y
}
adders<-lapply(1:10,add)
adders[[1]](10)
adders[[10]](10)


f<-function(x=ls()){
    print(exists(x))
    a<-1
    x
}
f()
# ls() is called when the function exists(x) is called, but when x is called again, it preserves the 
# value of x, not call ls() again.

f<-function(x=ls()){
#    print(exists(x))
    a<-1
    x
}
f()

x<-NULL
if(!is.null(x)&&x>0){}
`&&`<-function(x,y){
    if(!x)return(FALSE)
    if(!y)return(FALSE)
    TRUE
}
a<-NULL
!is.null(a)&&a>0
a<-1
!is.null(a)&&a>0
a<-NULL
!is.null(a)||stop("a is null")

# 6.4.5

f<-function(...){
    names(list(...))
}
f(a=1,b=2)
# use list(...) to capture the ... arguments


# 6.4.6 EX
x<-sample(replace = TRUE,20,x=c(1:10,NA))
y<-runif(min=0,max=1,20)
cor(m="k",y=y,u="p",x=x) # m for methods, p for how to deal with missin values.


f1<-function(x={y<-1:2},y=0){x+y}
f1()
# intially, y is set to 0, but when x is called, y is set to c(1,2)

f2<-function(x=z){
    z<-100
    x
}
f2()


# 6.5.1 Infix
`%+%`<-function(a,b) paste(a,b,sep=" ")
"new" %+% "string"

`%||%` <-function(a,b)if(!is.null(a)) a else b
f<-function(x)NULL
f(3)%||%0

# 6.5.2 replacement functions
`seconds<-`<-function(x,value){
    x[2]<-value
    x
}
x<-1:10
address(x)
seconds(x)<-5L
x
address(x)

x<-1:10
address(x)
x[2]<-7L
address(x)


`modify<-` <-function(x,position,value){
    x[position]<-value
    x
}
modify(x,1)<-10
x
get("x")
modify(get("x"),1)<-10
# cannot assign value to get("x")

x<-c(a=1,b=2,c=3)
names(x)
names(x)[2]<-"two"
names(x)

`%|%`<-function(a,b) !((a&&b)||(!a&&!b))
TRUE %|% FALSE
FALSE %|% FALSE
TRUE %|% TRUE

`%cap%`<-function(a,b)intersect(a,b)
c(1,2,3,4,5) %cap% c(4,5,6,7,8)

`replaceRandom<-`<-function(x,value=rnorm(1)){
    x[sample(1:length(x),1)]<-value
    x
}
x<-1:10
replaceRandom(x)<-5
x
# the value cannot be missing ???


# 6.6 return
f<-function(x){
    x$a<-2
    x
}
x<-list(a=1)
f(x)
x


f1<-function(x)1
f2<-function(x) invisible(1)
f1()
f2()
f2()==1
(f2())
(a<-2)



# 6.6.1 on exit
in_dir<-function(dir,code){
    old<-setwd(dir)
    on.exit(setwd(old))
    force(code)
}
getwd()
in_dir("~",getwd())
old<-getwd()
str(setwd("~"))
# setwd returns the value of the current wd
setwd(old)
rm(list=ls())

# 6.6.2 ex
source
library(pryr)
detach("package::pryr",unload = TRUE)
unloadNamespace("pryr")
?options


graphics.device<-function(code){
    pdf()
    force(code)
    on.exit(dev.off())
}
graphics.device("a<-1")


capture.output2<-function(code){
    tmp<-tempfile()
    on.exit(file.remove(tmp),add = TRUE)
    
    sink(tmp)
    on.exit(sink(),add = TRUE)
    
    force(code)
    readLines(tmp)
}
capture.output2(x<-2+4)
