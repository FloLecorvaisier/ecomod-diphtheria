## This script is used to create the fourth figure of the article, which
## represents the change in the reproduction number (R0) of the toxigenic
## strain when the vaccine coverage and the vaccine efficacy change. Note that,
## like for other figures, the Ubuntu font must be installed on the device.

## We first load the data produced by the `simus-R0.R` script.
data_R0 <- read.table("data/data-R0", header = T)

## We create the subfigure 4A, where the population is at the DFE.
ggplot(data_R0[data_R0$r2 == .42, ]) +
  geom_contour_fill(aes(x = r1, y = p1, z = RDFE)) +
  geom_contour(aes(x = r1, y = p1, z = RDFE,
                   linetype = factor(after_stat(level) == 1, 
                                     levels = c(F, T)),
                   color = factor(after_stat(level) == 1,
                                  levels = c(F, T))),
               show.legend = F) +
  scale_color_manual(values = c("transparent", "#FFFFFFFF")) +
  scale_fill_gradient(low = "#CCCCCC", high = "#333333",
                      limits = c(min(c(data_R0$RDFE[data_R0$r2 == .42], data_R0$RCEE[data_R0$r2 == .42])), 
                                 max(c(data_R0$RDFE[data_R0$r2 == .42], data_R0$RCEE[data_R0$r2 == .42])))) +
  scale_x_continuous(breaks = seq(.1, .9, .2)) +
  scale_y_continuous(breaks = seq(.1, .9, .2)) +
  coord_cartesian(expand = F) +
  labs(y = bquote("Vaccine coverage ("*p[1]==p[2]*")"),
       x = bquote("Vaccine efficacy ("*r[1]*")"),
       fill = "Reproduction\nnumber") +
  theme_bw() +
  theme(plot.background = element_blank(), legend.background = element_blank(),
        text = element_text(family = "Ubuntu", size = 6)) -> plot_RDFE

## We create the subfigure 4B, where the population is at the CEE (see the 
## article for the definitions of the terms).
ggplot(data_R0[data_R0$r2 == .42, ]) +
  geom_contour_fill(aes(x = r1, y = p1, z = RCEE)) +
  geom_contour(aes(x = r1, y = p1, z = RCEE,
                   linetype = factor(after_stat(level) == 1, 
                                     levels = c(F, T)),
                   color = factor(after_stat(level) == 1,
                                  levels = c(F, T))),
               show.legend = F) +
  scale_color_manual(values = c("transparent", "#FFFFFFFF")) +
  scale_fill_gradient(low = "#CCCCCC", high = "#333333",
                      limits = c(min(c(data_R0$RDFE[data_R0$r2 == .42], data_R0$RCEE[data_R0$r2 == .42])), 
                                 max(c(data_R0$RDFE[data_R0$r2 == .42], data_R0$RCEE[data_R0$r2 == .42])))) +
  scale_x_continuous(breaks = seq(.1, .9, .2)) +
  scale_y_continuous(breaks = seq(.1, .9, .2)) +
  coord_cartesian(expand = F) +
  labs(y = bquote("Vaccine coverage ("*p[1]==p[2]*")"),
       x = bquote("Vaccine efficacy ("*r[1]*")"),
       fill = "Reproduction\nnumber") +
  theme_bw() +
  theme(plot.background = element_blank(), legend.background = element_blank(),
        text = element_text(family = "Ubuntu", size = 6)) -> plot_RCEE

## We create in multiple steps subfigure 4C. The first step is to draw the 
## contours for r2 = 0.34 and r2 = 0.50 and extract the plot as a ggplot_built 
## object.
ggplot(data_R0[data_R0$r2 != .42, ]) +
  geom_contour(aes(x = r1, y = p1, z = RCEE, group = r2,
                   color = factor(after_stat(level) == 1, levels = c(F, T)))) +
  scale_color_manual(values = c("transparent", "#000000FF")) -> contours_r2
ggbuilt_r2 = ggplot_build(contours_r2)

## The second step is to get a new data frame with the positions of the 
## contours. It will be used to draw the ribbon as a polygon.
data_ribbon <- ggbuilt_r2$data[[1]]
data_ribbon <- data_ribbon[data_ribbon$colour != "transparent", ]
y = c(data_ribbon$y[data_ribbon$group == "1-005-001"], 
      rev(data_ribbon$y[data_ribbon$group == "2-005-001"]))
x = c(data_ribbon$x[data_ribbon$group == "1-005-001"], 
      rev(data_ribbon$x[data_ribbon$group == "2-005-001"]))

## Finally, the third step is to build the final plot using the data frame
## containing the values of R0 and the coordinates x and y obtained previously.
## I am far from sure that this method is the smartest or the simpliest but,
## eh, it works.
ggplot(data_R0[data_R0$r2 == .42, ]) +
  geom_contour(aes(x = r1, y = p1, z = RCEE,
                   color = factor(after_stat(level) == 1,
                                  levels = c(F, T))),
               linetype = "dashed",
               show.legend = F) +
  geom_contour(aes(x = r1, y = p1, z = RDFE,
                   color = factor(after_stat(level) == 1,
                                  levels = c(F, T))),
               show.legend = F) +
  annotate("polygon", x = x, y = y, fill = "#CCCCCCAA") +
  scale_x_continuous(limits = c(.4, 1)) +
  scale_color_manual(values = c("transparent", "#000000FF")) +
  labs(y = quote("Vaccine coverage ("*p[1]==p[2]*")"),
       x = quote("Vaccine efficacy ("*r[1]*")")) +
  theme_minimal() +
  theme(text = element_text(family = "Ubuntu", size = 6)) -> plot_r2

## Now that all three subfigures are created, it is possible to merge them
## into the final figure 4.
fig_4_efficacy <- ggarrange(ggarrange(plot_RDFE, plot_RCEE,
                                      common.legend = T, legend = "right",
                                      labels = LETTERS[1:2], font.label = list(family = "Ubuntu", size = 11)),
                            plot_r2, ncol = 1,
                            labels = c("", "C"),
                            font.label = list(family = "Ubuntu", size = 11))
ggsave("figures/fig-4-efficacy.png", fig_4_efficacy, device = png, width = 14, height = 11, units = "cm", dpi = 1200)
