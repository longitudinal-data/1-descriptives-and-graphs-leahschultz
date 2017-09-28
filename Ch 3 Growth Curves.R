## Assignment #2
## Chapter 3: Growth Curves

library(lme4)
library(sjPlot)
library(ggplot2)
library(broom)

## 1. Run linear models on all of your subjects (a basic regression).
## What is the average intercept, the average slope?

model1 <- lm(cbmom ~ grade, data = purpose_long)
summary(model1)

## Average intercept = 1.28
## Average slope = .08

## 2. Now run a mlm/lmer model with only a random intercept.

model2 <- lmer(cbmom ~ 1 + (1 | FAMID), data = purpose_long)
summary(model2)

## What is the ICC?

# ICC = % between- vs. within-person variance
# variance by ID / variance by ID + residual variance

.64 / (.64 + 1.30) = .33

## What does residual variance look like compared to linear model?
## Create a graph to show this effect.

model1.aug <- augment(model1)
model2.aug <- augment(model2)
mod1_resid <- abs(model1.aug$.resid)
mod2_resid <- abs(model2.aug$.resid)
mean_mod1 <- mean(mod1_resid)
mean_mod2 <- mean(mod2_resid)
resid_df <- data.frame("Type" = c("Linear", "Mixed"), 
                       "Mean" = c(mean_mod1, mean_mod2))

resid_plot <- ggplot(resid_df, aes(x = Type, y = Mean)) +
  geom_col()

## Absolute value of the average residual variance is lower in the mixed model, since we're
## accounting for individual-level, random effects.


## 3. Introduce a fixed slope term. What is the difference in terms of the fixed
## effects estimates between this estimate and the previous? Of the residual standard
## error? Create a graph to show both fixed effects estimates and the CIs around them.

## 4. Run an additional model with a random slope.
## How does this change compare to the previous model?
## Should you keep the random slope or not?

## 5. Interpret the correlation between the slope and the intercept.

## 6. Create a density plot of the random effects from your final model.

## 7. Create a caterpillar plot of the random effects.
## Is there any person that seems odd in terms of a large standard errors around intercept and slope estimates?

##8. Create a plot of the trajectory, along with a spaghetti plot of each person’s individual slope. Set the alpha level (transparency) on the individual slopes to make them easier to see.

##9. Create a plot of the trajectory, along with a spaghetti plot of each person’s individual slope. Set the alpha level (transperancy) on the individual slopes to make them easier to see.