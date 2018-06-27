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
