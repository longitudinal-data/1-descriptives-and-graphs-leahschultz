## Assignment #1
## Chapter 2: LDA Basics
library(dplyr)
library(tidyr)
library(ggplot2)
purpose <- read.csv("~/Dropbox/Lab & Research/OYSUP Project/oysup_self.csv")

## 1. Move your data into a long format and a wide format.
##    Did you have any specific challenges that you encountered? If so, discuss them.

purpose_long <- purpose %>%
  gather(-c(FAMID, SEX2, MEDUC2, MPEDUC2), key = "grade", value = "value") %>%
  separate(grade, into = c("variable", "grade"), sep = "_", convert = T) %>%
  spread(variable, value)
purpose_long

purpose_wide <- purpose_long %>%
  gather(-c(FAMID, SEX2, MEDUC2, MPEDUC2, grade), key = "variable", value = "value") %>%
  unite(VarG, variable, grade)  %>%
  spread(key = VarG, value = value) %>%
  select_if(~sum(!is.na(.)) > 0)
purpose_wide

### Challenges: First I forgot to exclude the ID variable and stable demographics, so it tried to make
### it into a value. I had a lot of variables that had repeated measures, so I had to think about
### how to split them after I gathered everything. Also, my variables were not consistently named
### because I was mixing naming conventions (my preferred conventions, and then the ones that OPP used).
### I went in and cleaned up my file a lot more so that I could use the separate function easily in the next step.

### One thing that was difficult was that I ended up with some NA columns -- drop and fill didn't
### seem to help, so I had to find a solution for how to drop the NA columns from the key-pair
### combinations that didn't exist (for example, purpose wasn't assessed at grade 1).

## 2. Create a wave variable and date variable (if applicable).

### Already created grade variable, which is equivalent to wave, for my purposes.

## 3. What is your sample size for each wave of assessment?

purpose_long %>% 
  group_by(grade) %>%
  filter(!is.na(cbmom)) %>%
  count()

### Grade 1: 220
### Grade 2: 408
### Grade 3: 606
### Grade 4: 806
### Grade 5: 994

## 4. Take the date variable and convert it to a different date format such
##    as time in study or age (if appropriate). What scale is most suitable for
##    your analyses? (weeks/months/years?)

### Not applicable for my analyses.

## 5. Graph your data using the different time metrics, fitting individual curves
##    for each person.

## Needed to drop variables at age 21:
purpose_long_elem <- purpose_long %>% 
  filter(grade != 21)

## Plotting individual curves for conflict with mother over time:
gg2 <- ggplot(purpose_long_elem, aes(x = grade, y = cbmom, group = FAMID)) +
  geom_line() + geom_point()
gg2

gg3 <- gg2 + aes(colour = factor(FAMID)) + guides(colour=FALSE) 
gg3

### Since these are sums, not AS interesting at the moment.

## Subset of 10 curves
set.seed(11)
ex.random <- purpose_long_elem %>% 
  select(FAMID) %>% 
  distinct %>% 
  sample_n(10) 

example <-
  left_join(ex.random, purpose_long_elem) 

gg4 <- ggplot(example, aes(x = grade, y = cbmom, group = FAMID)) + 
  geom_point() + stat_smooth(method="lm") + facet_wrap(~FAMID)
gg4

## 6. Create an overall average trend of your data (split up into groups if appropriate).
##    Attempt to color your individual data points and/or shade different lines
##    (highlight some participants, highlight the average trend line but not the individual
##    level lines).

gg5 <- ggplot(purpose_long_elem, aes(x = jitter(grade), y = cbmom)) +
  geom_point() + stat_smooth() 
gg5

## 7. Look at the correlations of your DV across time.

conflict_mom <- purpose_wide %>%
  select(cbmom_1:cbmom_5)
cor(conflict_mom, use = "complete.obs")

