dd1 = read.csv('quest_109_basics.csv',header = T)
dd2 = read.csv('quest_109_ph_extra.csv',header = T)

shortlisted_base = read.csv('quest109results.csv',header=T)
shortlisted = unique(shortlisted_base$photo_id)

dd1=dd1[duplicated(dd1)==F,]
dd2=dd2[duplicated(dd2)==F,]

dd = merge(dd1,dd2,by = 'user_id',all.x = T,all.y = F)
dd$y = rep('no',nrow(dd))
dd$y[dd$photo_id%in%shortlisted] = 'yes'
dd$y = as.factor(dd$y)

#####################
ddd1 = read.csv('quest_103_basics.csv',header = T)
ddd2 = read.csv('quest_103_ph_extra.csv',header = T)

shortlisted_base = read.csv('quest103results.csv',header=T)
shortlisted = unique(shortlisted_base$photo_id)

ddd1=ddd1[duplicated(ddd1)==F,]
ddd2=ddd2[duplicated(ddd2)==F,]

ddd = merge(ddd1,ddd2,by = 'user_id',all.x = T,all.y = F)
ddd$y = rep('no',nrow(ddd))
ddd$y[ddd$photo_id%in%shortlisted] = 'yes'
ddd$y = as.factor(ddd$y)


#####################
d = rbind(dd,ddd)

d$relevancy = 'irrelevant'
d$relevancy[d$relevant_tags > 0|d$relevant_description=='yes'] = 'relevant'
d$relevancy[d$relevancy!='relevant'&d$category!='uncategorized'&d$category!='others'] = 'possibly relevant'

d$relevancy = as.factor(d$relevancy)
######################

# d_no_records = d[d$photograph_prime+d$photograph_core+d$photograph_editors+d$photograph_presubmitted==0,]
# d_with_records = d[(d$photograph_prime+d$photograph_core+d$photograph_editors+d$photograph_presubmitted>0),]
# d_prime = d_with_records[d_with_records$comments >= 10|d_with_records$photograph_editors>0|d_with_records$editors_opinion!='unknown'|d_with_records$photograph_prime>0,]
# d_core = d_with_records[d_with_records$photo_id%in%unique(d_prime$photo_id)==F,]
# 
# length(d_prime$photo_id)/nrow(d)
# length(d_prime$photo_id[d_prime$y=='yes'])/length(d$photo_id[d$y=='yes'])


#####################
library(rpart)

t = d[,-c(1,3,4,5)]

set.seed(9999)
set_split = rbinom(nrow(t),1,0)
t_train = t[set_split==0,];t_test = t[set_split==1,]

weight_vector = rep(ceiling(length(t_train$photo_id[t_train$y=='yes'])/length(t_train$photo_id[t_train$y=='no'])),nrow(t_train))
weight_vector[t_train$y=='yes'] = floor(length(t_train$photo_id[t_train$y=='no'])/length(t_train$photo_id[t_train$y=='yes']))*2

fit = rpart(y ~ .,weights=weight_vector, data=t_train[,-1], method = 'class')

tt=predict(fit,t_test[,-c(1,18)],type = 'prob')

sensitivity = length(t_test$y[tt[,2]>0.5 & t_test$y=='yes'])/length(t_test$y[t_test$y=='yes'])
specificity = length(t_test$y[tt[,2]<=0.5 & t_test$y=='no'])/length(t_test$y[t_test$y=='no'])
reduced_size = length(t_test$y[tt[,2]>0.5])/nrow(t_test)

#####################

fit1 = rpart(y ~ .,weights=weight_vector, data=t_train[,-1], method = 'class')

#####################
library(randomForest)

fit2 = randomForest(y ~ .,weights=weight_vector, data =t_train[,-1], ntree=3000)
summary(fit2)

tt2 = predict(fit2,t_test[,-c(1,18)],type = 'prob')

sensitivity = length(t_test$y[tt2[,2]>0.5 & t_test$y=='yes'])/length(t_test$y[t_test$y=='yes'])
specificity = length(t_test$y[tt2[,2]<=0.5 & t_test$y=='no'])/length(t_test$y[t_test$y=='no'])
reduced_size = length(t_test$y[tt2[,2]>0.5])/nrow(t_test)


#####################
quest123 = read.csv('quest123.csv',header = T)
quest123_extra = read.csv('quest_123_ph_extra.csv',header = T)
shortlisted = c(162982501,145566305,155097121,156772323,120681645 ,165369255 ,165372627 ,167050101 ,169205843 ,169455203 ,169516071 ,169677525 ,169683779 ,169684571 ,169725061 ,170182077 ,170371191 
                ,170669887,95212759,26722657,83220095,89312533,91921681,116178709,120936745,129453211,135400647,136735425,144293145,150479139,155307637,158009731,158610033,161637545,163710021,163985947
                ,165418519,165634403,168561627,169420567,169596681,169796505,169868839,169933469,170021323,170216805,170311827,170493337,170644513,170709313,170788033,171165815,171196921,171205671)
length(shortlisted)
q123_1 = quest123[duplicated(quest123)==F,]
q123_2 = quest123_extra[duplicated(quest123_extra)==F,]
q123 = merge(q123_1,q123_2,by = 'user_id',all.x = T,all.y = F)
q123$y = rep('no',nrow(q123))
q123$y[q123$photo_id%in%shortlisted] = 'yes'
q123$y = as.factor(q123$y)

q123$relevancy = 'irrelevant'
q123$relevancy[q123$relevant_tags > 0|q123$relevant_description=='yes'] = 'relevant'
q123$relevancy[q123$relevancy!='relevant'&q123$category!='uncategorized'&q123$category!='others'] = 'possibly relevant'

q123$relevancy = as.factor(q123$relevancy)

q123 = q123[,-c(1,3,4,5)]

t123 = predict(fit2,q123[,-c(1,18)],type = 'prob')
sensitivity = length(q123$y[t123[,2]>0.0425266667& q123$y=='yes'])/length(q123$y[q123$y=='yes']);sensitivity
specificity = length(q123$y[t123[,2]<=0.0425266667& q123$y=='no'])/length(q123$y[q123$y=='no']);specificity
reduced_size = length(q123$y[t123[,2]>0.0425266667])/nrow(q123);reduced_size
quantile(t123[,2],seq(0,1,0.02))
which(q123$photo_id[t123[,2]>0.0206666667] == 136735425)
which(q123$photo_id[t123[,2]>0.0206666667] == 150479139)

sensitivity = length(q123$y[t123[,2]>0.009333333& q123$y=='yes'])/52;sensitivity
specificity = length(q123$y[t123[,2]<=0.009333333 & q123$y=='no'])/length(q123$y[q123$y=='no']);specificity
reduced_size = length(q123$y[t123[,2]>0.009333333])/nrow(q123);reduced_size

which(q123$photo_id[t123[,2]>0.009333333] == 136735425)
which(q123$photo_id[t123[,2]>0.009333333] == 150479139)

q123$photo_id[t123[,2]>=0.003666667 & q123$y=='yes' & t123[,2] <= 0.0056]

quantile(t123[,2],0.5)
quantile(t123[,2],0.8)
quantile(t123[,2],0.71)
      
      
########################
dd3 = read.csv('quest_111_basics.csv',header = T)
shortlisted_base = read.csv('quest_111_results.csv',header=T)
shortlisted = unique(shortlisted_base$photo_id)
dd3_extra = read.csv('quest_111_ph_extra.csv',header = T)
d3 = merge(dd3,dd3_extra,by = 'user_id',all.x = T,all.y = F)

d3=d3[duplicated(d3)==F,]

d3$y = rep('no',nrow(d3))
d3$y[d3$photo_id%in%shortlisted] = 'yes'
d3$y = as.factor(d3$y)

d3$relevancy = 'irrelevant'
d3$relevancy[d3$relevant_tags > 0|d3$relevant_description=='yes'] = 'relevant'
d3$relevancy[d3$relevancy!='relevant'&d3$category!='uncategorized'&d3$category!='others'] = 'possibly relevant'

d3$relevancy = as.factor(d3$relevancy)



nrow(d3)
q111 = d3[,-c(1,3,4,5)]
t111 = predict(fit2,q111[,-c(1,18)],type = 'prob')
quantile(t111[,2],seq(0,1,0.05))
sensitivity = length(q111$y[t111[,2]>0.0173333333& q111$y=='yes'])/length(q111$y[q111$y=='yes']);sensitivity
specificity = length(q111$y[t111[,2]<=0.0173333333& q111$y=='no'])/length(q111$y[q111$y=='no']);specificity
reduced_size = length(q111$y[t111[,2]>0.0173333333])/nrow(q111);reduced_size

which(q111$photo_id[t111[,2]>0.0173333333] == 165502841)
which(q111$photo_id[t111[,2]>0.0173333333] == 165432703) 

q111$photo_id[t111[,2]>0.0036666667&q111$y=='yes']

####################
q119 = read.csv('quest_119_basics_repull.csv',header = T)
shortlisted_base = read.csv('quest119results.csv',header=T)
shortlisted = unique(shortlisted_base$photo_id)
q119_extra = read.csv('quest_119_ph_extra.csv',header = T)
q119 = merge(q119,q119_extra,by = 'user_id',all.x = T,all.y = F)
q119 = q119[duplicated(q119) == F,]

q119$y = rep('no',nrow(q119))
q119$y[q119$photo_id%in%shortlisted] = 'yes'
q119$y = as.factor(q119$y)

q119$relevancy = 'irrelevant'
q119$relevancy[q119$relevant_tags > 0|q119$relevant_description=='yes'] = 'relevant'
q119$relevancy[q119$relevancy!='relevant'&q119$category!='uncategorized'&q119$category!='others'] = 'possibly relevant'

q119$relevancy = as.factor(q119$relevancy)


d119 = q119[,-c(1,3,4,5)]
t119 = predict(fit2,d119[,-c(1,18)],'prob')
quantile(t119[,2],seq(0,1,0.01))

sensitivity = length(q119$y[t119[,2]>0.0275666667& q119$y=='yes'])/length(q119$y[q119$y=='yes']);sensitivity
specificity = length(q119$y[t119[,2]<=0.0275666667& q119$y=='no'])/length(q119$y[q119$y=='no']);specificity
reduced_size = length(q119$y[t119[,2]>0.0275666667])/nrow(q119);reduced_size

which(q119$photo_id[t119[,2]>0.0275666667] == 54359842)


op=paste('http://500px.com/photo/',q119$photo_id[t119[,2]<=0.0093333333&t119[,2]>0.0006666667&q119$y=='yes'],sep = '')
write(op,'shortlisted photos q119.csv')
