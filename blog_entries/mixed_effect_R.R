# Purpose is to understand R/frequentist/lme4 mixed effects approach
# and contrast with Bayesian way

# pckgs <- c("lme4", "nlmeU", "plyr", "reshape", "RLRsim", "WWGbook", "ellipse")
# install.packages(pckgs)

# pckgs <- c("tidyverse", "ggVennDiagram")
# install.packages(pckgs)


# install.packages("nleqslv")
# install.packages("merTools")
# 
# install.packages("sf")


# library("devtools")
# # install_github("lme4/lme4",dependencies=TRUE)
# 
# library(installr)
# updateR()


# library(lme4)
# library(nlme)
# library(rethinking)
#library(tidyverse)
# #library(brms)


# Doing TJ Mahr's post --------


# Convert to tibble for better printing. Convert factors to strings
sleepstudy <- sleepstudy %>% 
  as_tibble() %>% 
  mutate(Subject = as.character(Subject))

# Add two fake participants
df_sleep <- bind_rows(
  sleepstudy,
  tibble(Reaction = c(286, 288), Days = 0:1, Subject = "374"),
  tibble(Reaction = 245, Days = 0, Subject = "373"))

df_sleep


# save sleep df
write.csv(df_sleep, '/Users/blacar/Documents/ds_projects/stats_rethinking/data/b_other/sleep_lme4mahr.csv')

# plot each individual ----
xlab <- "Days of sleep deprivation"
ylab <- "Average reaction time (ms)"

ggplot(df_sleep) + 
  aes(x = Days, y = Reaction) + 
  stat_smooth(method = "lm", se = FALSE) +
  # Put the points on top of lines
  geom_point() +
  facet_wrap("Subject") +
  labs(x = xlab, y = ylab) + 
  # We also need to help the x-axis, so it doesn't 
  # create gridlines/ticks on 2.5 days
  scale_x_continuous(breaks = 0:4 * 2)

# no pooling ----
df_no_pooling <- lmList(Reaction ~ Days | Subject, df_sleep) %>% 
  coef() %>% 
  # Subject IDs are stored as row-names. Make them an explicit column
  rownames_to_column("Subject") %>% 
  rename(Intercept = `(Intercept)`, Slope_Days = Days) %>% 
  add_column(Model = "No pooling") %>% 
  # Remove the participant who only had one data-point
  filter(Subject != "373")

head(df_no_pooling)

# complete pooling -------

# Fit a model on all the data pooled together
m_pooled <- lm(Reaction ~ Days, df_sleep) 

# Repeat the intercept and slope terms for each participant
df_pooled <- tibble(
  Model = "Complete pooling",
  Subject = unique(df_sleep$Subject),
  Intercept = coef(m_pooled)[1], 
  Slope_Days = coef(m_pooled)[2]
)

head(df_pooled)


# complete vs.no pooling------

# Join the raw data so we can use plot the points and the lines.
df_models <- bind_rows(df_pooled, df_no_pooling) %>% 
  left_join(df_sleep, by = "Subject")

p_model_comparison <- ggplot(df_models) + 
  aes(x = Days, y = Reaction) + 
  # Set the color mapping in this layer so the points don't get a color
  geom_abline(
    aes(intercept = Intercept, slope = Slope_Days, color = Model),
    size = .75
  ) + 
  geom_point() +
  facet_wrap("Subject") +
  labs(x = xlab, y = ylab) + 
  scale_x_continuous(breaks = 0:4 * 2) + 
  # Fix the color palette 
  scale_color_brewer(palette = "Dark2") + 
  theme(legend.position = "top", legend.justification = "left")

p_model_comparison

# mixed effects model ------
library(arm)

m <- lmer(Reaction ~ 1 + Days + (1 + Days | Subject), df_sleep)
arm::display(m)

# ----

# Make a dataframe with the fitted effects
df_partial_pooling <- coef(m)[["Subject"]] %>% 
  rownames_to_column("Subject") %>% 
  as_tibble() %>% 
  rename(Intercept = `(Intercept)`, Slope_Days = Days) %>% 
  add_column(Model = "Partial pooling")

head(df_partial_pooling)

# visualize with partial pooling ---
df_models <- bind_rows(df_pooled, df_no_pooling, df_partial_pooling) %>% 
  left_join(df_sleep, by = "Subject")

# Replace the data-set of the last plot
p_model_comparison %+% df_models


# focus on a few individuals
df_zoom <- df_models %>% 
  filter(Subject %in% c("335", "350", "373", "374"))

p_model_comparison %+% df_zoom



# Understanding brms vs rethinking package ------

# simplest varying intercepts model (tadpoles)

data(reedfrogs)
d <- reedfrogs
str(d)


# make the tank cluster variable
d$tank <- 1:nrow(d)

dat <- list(
  S = d$surv,
  N = d$density,
  tank = d$tank )
  
  
## R code 13.3
m13.2 <- ulam(
  alist(
    S ~ dbinom( N , p ) ,
    logit(p) <- a[tank] ,
    a[tank] ~ dnorm( a_bar , sigma ) ,
    a_bar ~ dnorm( 0 , 1.5 ) ,
    sigma ~ dexp( 1 )
  ), data=dat , chains=4 , log_lik=TRUE )


## R code 13.5
# extract Stan samples
post <- extract.samples(m13.2)

# compute mean intercept for each tank
# also transform to probability with logistic
d$propsurv.est <- logistic( apply( post$a , 2 , mean ) )

# display raw proportions surviving in each tank
plot( d$propsurv , ylim=c(0,1) , pch=16 , xaxt="n" ,
      xlab="tank" , ylab="proportion survival" , col=rangi2 )
axis( 1 , at=c(1,16,32,48) , labels=c(1,16,32,48) )

# overlay posterior means
points( d$propsurv.est )

# mark posterior mean probability across tanks
abline( h=mean(inv_logit(post$a_bar)) , lty=2 )

# draw vertical dividers between tank densities
abline( v=16.5 , lwd=0.5 )
abline( v=32.5 , lwd=0.5 )
text( 8 , 0 , "small tanks" )
text( 16+8 , 0 , "medium tanks" )
text( 32+8 , 0 , "large tanks" )


