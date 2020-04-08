library(dplyr)
getwe()
getwd()
setwd("C:/Users/chae/Desktop/dataset/covid-19")
install.packages("readxl")
library("readxl")
china_death = read.csv("china_deathrate.csv", header=T)
china_infected = read.csv("china_infected.csv", header=T)
korea_exposure = read.csv("korea_exposure.csv", header=T)
wuhan_pop = read.csv("wuhan_pop.csv",header=T)
wuhan_pop_rate = prop.table(wuhan_pop$population)
wuhan_pop_rate = prop.table(wuhan_pop$population) * 100
wuhan_pop_rate
wuhan_popularation = data.frame(age = wuhan_pop$age, percentage = wuhan_pop_rate)
wuhan_popularation

china_infected_list = merge(china_infected, wuhan_popularation, by='age')
colnames(china_infected_list) = c("age", "china_infected", "wuhan_pop")
china_infected_list
infected_ratio = china_infected_list$china_infected/china_infected_list$wuhan_pop
infected_ratio = prop.table(infected_ratio)
infected_ratio = infected_ratio*100
infected_ratio
china_infected_list = mutate(china_infected_list, infected_per_age = infected_ratio)
china_infected_list
colnames(china_infected_list) = c("age", "china_infected", "huabei_pop", 
                                  "infected_ratio")
china_infected_list #중국감염통계
korea_infected = read.csv("korea_infected.csv", header=T)
korea_infected_ratio = transmute(korea_infected, korea_infected_per_age = population/sum(population))
korea_infected_ratio = korea_infected_ratio * 100
korea_infected_ratio
infected_ratio = cbind(china_infected_list, korea_infected_ratio)
infected_ratio

install.packages("ggplot2")
library(ggplot2)
ggplot(infected_ratio, aes(x=age, y=china_infected, group=1)) +
  geom_line() + 
  ggtitle("연령대별 중국/한국 확진자 비율")

install.packages("reshape")
library(reshape)
infected_ratio = melt(infected_ratio, id.vars = 'age')
infected_ratio
colnames(infected_ratio) = c("age", "type", 'ratio')
infected_ratio

ggplot(data=infected_ratio, aes(x=age, y=ratio, colour=type, group=type)) +
  geom_line() +
  geom_point(size=3) +
  ggtitle("연령대별 한국/중국 확진자 비율")

ggplot(data=korea_exposure, aes(x="", y=percentage, fill=exposure)) + 
  geom_bar(stat='identity', width=1) + 
  coord_polar(theta='y') +
  ggtitle("한국 확진자 감염 경로")
