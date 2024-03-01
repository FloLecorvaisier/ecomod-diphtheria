## This script is used to create the second and third figures of the article.
## Note that the "Ubuntu" font must be installed on the device, else the
## default 

## The code below creates a global file with the results of all the simulations
## run with the `simus-prev.R` script to help create the figures.
lf <- list.files("data/outputs-prev", pattern = "prev")
cat(paste("prev_abs", "prev_abs_noI2", "prev_rel", "p1", "param", "value\n", sep = "\t"), file = "data/data-prev")
for (param_name in names(list_values)) {
  lf_param <- lf[grep(param_name, lf)]
  for (file in lf_param) {
    df <- read.table(paste0("data/outputs-prev/", file), header = T)
    value <- as.numeric(gsub(paste0("prev-", param_name, "-(.*)"), "\\1", file))
    df$param <- param_name
    if (param_name %in% c("f", "eta")) df$value = 1 / (value * 365) else df$value = value
    write.table(df, file = "data/data-prev", append = T, quote = F, sep = "\t", row.names = F, col.names = F)
  }
}

## We import the data and create some variables used for the figures.
data_prev <- read.table("data/data-prev", header = T)
pop_size <- param$b / param$d
labels <- c("Imm. duration (y)", "Time between<br>boosters (y)", "Basic rep.<br>number", 
            "Transmission<br>red. of *Cd<sub>1</sub>*", "Transmission<br>red. of *Cd<sub>2</sub>*", "Prop. of adults<br>taking boosters")

## We create the figure with the absolute prevalences.
list_plots_abs_prev <- list()
for (i in 1:length(names(list_values))) {
  param_name <- names(list_values)[i]
  data_prev2 <- data_prev[data_prev$param == param_name, ]
  data_prev2 <- data.frame(p1 = rep(data_prev2$p1, 2), 
                           prev = c(data_prev2$prev_abs, data_prev2$prev_abs_noI2),
                           val = rep(data_prev2$value, 2), 
                           type = rep(c("I2", "noI2"), each = nrow(data_prev2)))
  ggplot(data_prev2) +
    geom_line(aes(x = p1, y = prev * pop_size / 1e4, 
                  color = as.factor(val),
                  linetype = type,
                  group = interaction(type, val))) +
    labs(x = ifelse(i %in% 1:4, "", "Vaccine coverage"),
         y = ifelse(i %in% c(2, 4, 6), "\n", "Cases per 10,000\nindividuals"),
         color = labels[i]) +
    scale_color_manual(values = grey.colors(n = length(unique(data_prev2$val)),
                                            start = 0.2, end = 0.8, gamma = 1, rev = T)) +
    guides(linetype = "none") + 
    theme_minimal(base_family = "Ubuntu", base_size = 8) +
    theme(legend.title = element_markdown()) -> list_plots_abs_prev[[i]]
}
fig_2_abs_prev <- egg::ggarrange(plots = list_plots_abs_prev,
                                 labels = LETTERS[1:6], 
                                 label.args = list(gp = grid::gpar(fontfamily = "Ubuntu", size = 8, font = 2)))
ggsave("figures/fig-2-abs-prev.png", plot = fig_2_abs_prev, device = png, width = 14, height = 12, units = "cm", dpi = 600)

## We create the figure with the relative prevalences.
list_plots_rel_prev <- list()
for (i in 1:length(names(list_values))) {
  param_name <- names(list_values)[i]
  data_prev3 <- data_prev[data_prev$param == param_name, ]
  data_prev3 <- data.frame(p1 = data_prev3$p1,
                           prev = data_prev3$prev_rel,
                           val = data_prev3$value)
  ggplot(data_prev3) +
    geom_line(aes(x = p1, y = prev, 
                  color = as.factor(val),
                  group = as.factor(val))) +
    labs(x = ifelse(i %in% 1:4, "", "Vaccine coverage"),
         y = ifelse(i %in% c(2, 4, 6), "\n", "Cases per 10,000\nindividuals"),
         color = labels[i]) +
    scale_color_manual(values = grey.colors(n = length(unique(data_prev3$val)),
                                            start = 0.2, end = 0.8, gamma = 1, rev = T)) +
    guides(linetype = "none") + 
    theme_minimal(base_family = "Ubuntu", base_size = 8) +
    theme(legend.title = element_markdown()) -> list_plots_rel_prev[[i]]
}
fig_3_rel_prev <- egg::ggarrange(plots = list_plots_rel_prev,
                                 labels = LETTERS[1:6], 
                                 label.args = list(gp = grid::gpar(fontfamily = "Ubuntu", size = 8, font = 2)))
ggsave("figures/fig-3-rel-prev.png", plot = fig_3_rel_prev, device = png, width = 14, height = 12, units = "cm", dpi = 600)
