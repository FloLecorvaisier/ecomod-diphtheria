## This script runs the numerical simulations of the model with different
## values of p1 (and p2), r1 and r2, to see how moving these parameters changes
## the R0 of the toxigenic strain.

data_R0 <- data.frame(p1 = rep(seq(0, 1, 0.01), times = 101),
                      r1 = rep(seq(0, 1, 0.01), each = 101),
                      r2 = rep(c(.34, .42, .50), each = 101 ** 2))

registerDoParallel(cl <- makeCluster(n_cores))
clusterEvalQ(cl, dyn.load("files/model.so"))
foreach(i = 1:nrow(data_R0), .combine = "rbind", .packages = "deSolve") %dopar% {
  param2 <- param
  param2$p1 <- param2$p2 <- data_R0$p1[i]
  param2$r1 <- data_R0$r1[i]
  param2$r2 <- data_R0$r2[i]
  param2$omega <- param2$p2 * param2$f
  param2$beta1p <- (1 - param2$r1) * param2$beta1
  param2$beta2 <- (1 - param2$r2) * param2$beta1
  
  ## Values of R0 at the disease-free equilibrium are easy to obtain if we
  ## know the values of the different parameters.
  s_dfe <- ((1 - param2$p1) * param2$d + param2$eta) /
    (param2$omega + param2$eta + param2$d)
  v_dfe <- (param2$p1 * param2$d + param2$omega) /
    (param2$omega + param2$eta + param2$d)
  RDFE <- (param2$beta1 * s_dfe + param2$beta1p * v_dfe) / (param2$gamma + param2$d)
  
  ## For the values at the Cd2 equilibrium, the value of R0 cannot be found
  ## analytically so we use numerical simulations instead to obtain `s_2` and
  ## `v_2`, from which we calculate the value of R0.
  out <- ode(y = init_noI1, parms = unlist(param2), times = seq(0, len_sim, 1), 
             dllname = "model", func = "derivs", initfunc = "initmod")
  s_2 = mean(out[(last * len_sim):len_sim, "S"]) / (param2$b / param2$d)
  v_2 = mean(out[(last * len_sim):len_sim, "V"]) / (param2$b / param2$d)
  RCEE <- param2$R0 * s_2 + (param2$beta1p * v_2) / (param2$gamma + param2$d)
  
  c(RDFE, RCEE)
} -> results
stopCluster(cl)

data_R0$RDFE <- results[, 1]
data_R0$RCEE <- results[, 2]

write.table(data_R0, file = "data/data-R0",
            quote = F, sep = "\t", row.names = F)
