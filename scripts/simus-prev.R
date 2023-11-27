## Running the simulations with all the tested vallues of the parameters.
## The summarized output of the simulations for each value of the parameters
## is saved in a different file with a name written like "prev-[name of the
## parameter]-[value tested]".

registerDoParallel(cl <- makeCluster(n_cores))
clusterEvalQ(cl, dyn.load("files/model.so"))
for (param_name in names(list_values)) {
  for (param_value in unlist(list_values[param_name])) {
    foreach(p1 = seq(0, 1, .01), .combine = "rbind", .packages = "deSolve") %dopar% {
      param2 <- param
      param2$p1 <- p1
      if (param_name != "prop") param2[param_name] <- param_value
      if (param_name != "prop") param2$p2 <- p1 else param2$p2 <- p1 * param_value
      param2$omega <- param2$f * param2$p2
      param2$beta1 <- param2$R0 * (param2$gamma + param2$d)
      param2$beta1p <- (1 - param2$r1) * param2$beta1
      param2$beta2 <- (1 - param2$r2) * param2$beta1
        out <- ode(y = init, parms = unlist(param2), times = seq(0, len_sim, 1),
                   dllname = "model", func = "derivs", initfunc = "initmod")
      out_noI2 <- ode(y = init_noI2, parms = unlist(param2), times = seq(0, len_sim, 1), 
                      dllname = "model", func = "derivs", initfunc = "initmod")
      prev_abs = mean(out[(last * len_sim):len_sim, "I1"])
      prev_abs_noI2 = mean(out_noI2[(last * len_sim):len_sim, "I1"])
      prev_rel = mean(out[(last * len_sim):len_sim, "I1"] / (out[(last * len_sim):len_sim, "I1"] + out[(last * len_sim):len_sim, "I2"]))
      data.frame(prev_abs,
                 prev_abs_noI2,
                 prev_rel, 
                 p1)
    } -> outputs
    write.table(outputs, file = paste("data/outputs-prev/prev", param_name, param_value, sep = "-"), 
                quote = F, sep = "\t", row.names = F)
  }
}
stopCluster(cl)
