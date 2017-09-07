## Assignment #1
## Chapter 2: LDA Basics
library(dplyr)
library(tidyr)
purpose <- read.csv("~/Dropbox/Lab & Research/OYSUP Project/oysup_self.csv")

## 1. Move your data into a long format and a wide format.
##    Did you have any specific challenges that you encountered? If so, discuss them.

purpose_long <- purpose %>%
  gather(-c(FAMID, SEX2, MEDUC2, MPEDUC2), key = "grade", value = "value")
purpose_long

purpose_wide <- purpose_long %>%
  spread(key = "grade", value = "value")
purpose_wide

### Challenges: First I forgot to exclude the ID variable and stable demographics, so it tried to make
### it into a value. I had a lot of variables that had repeated measures, so I had to think about
### how to split them after I gathered everything. Also, my variables were not consistently named
### because I was mixing naming conventions (my preferred conventions, and then the ones that OPP used).
### I went in and cleaned up my file a lot more so that I could use the separate function easily in the next step.

## 2. Create a wave variable and date variable (if applicable).

### Created grade variable
purpose_long_2 <- purpose_long %>% 
  separate(grade, into = c("variable", "grade"), sep = "_", convert = T) %>%
  spread(variable, value) 
purpose_long_2

## 3. What is your sample size for each wave of assessment?

### 

## 4. Take the date variable and convert it to a different date format such
##    as time in study or age (if appropriate). ## What scale is most suitable for
##    your analyses? (weeks/months/years?)

## 5. Graph your data using the different time metrics, fitting individual curves
##    for each person.

## 6. Create an overall average trend of your data (split up into groups if appropriate).
##    Attempt to color your individual data points and/or shade different lines
##    (highlight some particiapnts, highlight the average trend line but not the individual
##    level lines).

## 7. Look at the correlations of your DV across time