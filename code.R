data(mtcars)
summary(mtcars)
?mtcars
mtcars$am <- factor(mtcars$am)
mtcars$vs <- factor(mtcars$vs)
plot(mtcars$qsec, mtcars$mpg)
fitlm <- lm(mpg~., data=mtcars)
coef(fitlm)
confint(fitlm2)
n <- which(abs(hatvalues(fitlm) - summary(hatvalues(fitlm))[6]) < .01)
fitlm2 <- lm(mpg ~., data=mtcars[-n,])
fitglm <- glm(mpg~., data=mtcars, family = gaussian)
plot(predict(fitglm), resid(fitglm))
par(mfrow= c(2,2))
for (i in 2:dim(mtcars)[2]){
        plot(mtcars[,i], mtcars$mpg, xlab=names(mtcars)[i],
             ylab ="MPG")
}
hist(mtcars$mpg)
plot(fitlm)
summary(hatvalues(fitlm))

l <- list()
for (i in 2:dim(mtcars)[2]){
        formula <- paste("mpg", "~","+am+", paste(sapply(2:i, function(j) names(mtcars)[j]), collapse = "+"))       
        l[i] <- lm(formula, data = mtcars)
}
anova(sapply(1:length(l), function(i) l[[i]]))
anova(l[1], l[2])

library(caret)
corMatrix <- cor(mtcars[,- c(1,8,9)])
library(car)
vif(fitlm2)
highlyCorrelated <- findCorrelation(corMatrix, cutoff = .8)
newdata <- mtcars[, -(highlyCorrelated+1)]
fitlm <- lm(paste("mpg~",paste(sapply(3:ncol(mtcars), function(j) names(mtcars)[j]), collapse = "+")), data=mtcars)
fitlm2 <- lm(mpg ~., data=newdata)
coef(fitlm2)
confint(fitlm2, level = .8)


lm <- train(mpg ~ . , method="lm",  data=newdata)
lm
coef(lm$finalModel)
confint(lm$finalModel)

t.test(mtcars$mpg[mtcars$am == 0], mtcars$mpg[mtcars$am == 1], paired = F)
