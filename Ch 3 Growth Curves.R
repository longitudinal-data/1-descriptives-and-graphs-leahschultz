## Assignment #2
## Chapter 3: Growth Curves

library(lme4)
library(sjPlot)
library(ggplot2)
library(broom)
library(merTools)

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

model3 <- lmer(cbmom ~ grade + (1 | FAMID), data = purpose_long)
summary(model3)

## Fixed effect estimate for intercept decreased from 1.60 to 1.32.
## 

## 4. Run an additional model with a random slope.
## How does this change compare to the previous model?
## Should you keep the random slope or not?

model4 <- lmer(cbmom ~ grade + (1 + grade | FAMID), data = purpose_long)
summary(model4)

## 5. Interpret the correlation between the slope and the intercept.
### Correlation between slope and intercept = -.89. 

## 6. Create a density plot of the random effects from your final model.

random_params <- tidy(model4, effect = "ran_modes")

raneff_plot <- ggplot(random_params, aes(x = estimate, color = term)) +
  geom_density()

## 7. Create a caterpillar plot of the random effects.
## Is there any person that seems odd in terms of a large standard errors around
## intercept and slope estimates?

re.sim <- REsim(model4)
plotREsim(re.sim)

## 8. Create a plot of the trajectory, along with a spaghetti plot of each
## person’s individual slope. Set the alpha level (transparency) on the
## individual slopes to make them easier to see.

predict <- predictInterval(merMod = model4, newdata = purpose_long_elem,
                           level = 0.9, n.sims = 100, 
                           stat = "median", include.resid.var = TRUE)
growth_df <- cbind(purpose_long_elem, predict$fit)

growth_plot <- ggplot(purpose_long_elem, aes(x = grade, y = predict$fit)) +
  geom_line(aes(group = FAMID), alpha = .2) +
  stat_smooth(method = lm)
growth_plot


