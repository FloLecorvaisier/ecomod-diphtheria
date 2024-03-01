## This script MUST be run before any other, as it initializes multiple
## variables and load the packages needed for the different other scripts to
## run.

## To run if the files model.o and model.so are missing to compile the C
## script containing the model.
system('R CMD SHLIB files/model.c')

## Loading the libraries used by the different scripts.
library(deSolve)
library(doParallel)
library(egg)
library(ggplot2)
library(ggpubr)
library(ggtext)
library(metR)

## Base parameters values for the different parameters of the model:
## - Given values:
param = list(b     = 1 / 3,
             d     = 1 / (83 * 365),
             R0    = 2.6,
             p1    = 0.96,
             p2    = 0.6,
             gamma = 1 / 18.5, 
             eta   = 1 / (42 * 365),
             r1    = 0.6,
             r2    = 0.42,
             f     = 1 / (10 * 365))
## - Calculated values (from given values):
param$beta1  = param$R0 * (param$gamma + param$d)
param$beta1p = (1 - param$r1) * param$beta1
param$beta2  = (1 - param$r2) * param$beta1
param$omega  = param$f * param$p2

## Giving all the possible alternative values for the parameters.
list_values <- list()
list_values$eta <- 1 / (c(30, 42, 54) * 365)
list_values$f <- 1 / (c(5, 10, 20, 30) * 365)
list_values$R0 <- seq(1.8, 3.4, .4)
list_values$r1 <- c(.5, .6, .7)
list_values$r2 <- c(.34, .38, .42)
list_values$prop <- seq(.25, 1, .25)
list_values$gamma <- 1 / c(11.5, 15, 18.5)

## Initial values for the different compartments of the model. In their
## formulations, they may not look like what is explained in the main text that
## initial conditions correspond to the CEE of the DFE, but near equilibrium 
## these initial conditions match what we would obtain with the CEE and DFE
## initial conditions.
## Corresponding to the CEE:
init <- c(S  = 10096.33,
          I1 = 1,
          I2 = 1,
          V  = 0,
          R  = 0)
## Not used.
init_noI1 <- c(S = 10097.33,
               I1 = 0,
               I2 = 1,
               V = 0,
               R = 0) 
## Corresponds to the DFE.
init_noI2 <- c(S  = 10097.33,
               I1 = 1,
               I2 = 0,
               V  = 0,
               R  = 0)

## Number of cores to be used in the parallel simulations. Defaults to
## available number of cores minus one, but can be changed to any value.
n_cores <- detectCores() - 1

## We specify the duration (in days) of the simulations and the proportion of
## the values we want to exclude from the calculation of the prevalence at
## equilibrium (e.g., if `len_sim` is 1e6 and `last` is 0.9, then the
## equilibrium will be calculated using the values from t = 9e5 to 1e6).
len_sim = 1e6
last = .9
