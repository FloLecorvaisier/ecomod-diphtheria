## The chaotic code below creates and saves the first figure of the article,
## the schematic diagram of the model. Note that the "Ubuntu" font must be
## installed on the device, else the default font will be used instead.

end = .1
v_adj = .3
h_adj = .2

ggplot() +
  annotate("rect",
           xmin = c(0, 0, 3, 3, 6), xmax = c(1, 1, 4, 4, 7), ymin = c(0, 3, 3, 0, 1.5), ymax = c(1, 4, 4, 1, 2.5),
           fill = "white", color = "black") +
  annotate("segment",
           x = c(-1, -1, .25, .5, 1, 1, 1, 1, 4, 4, .75, .75, 3.75, 3.75, 6.75),
           xend= c(0 - end, 0 - end, .25, .5, 3 - end, 3 - end, 3 - end, 3 - end, 6 - end, 6 - end, .75, .75, 3.75, 3.75, 6.75), 
           y = c(.5, 3.5, 3, 1, .3, .7, 3.7, 3.3, 3.5, 0.5, 3, 0, 3, 0, 1.5), 
           yend = c(.5, 3.5, 1 + end, 3 - end, .3, 3.3, 3.7, 0.7, 2.2, 1.8, 2.5, -0.5, 2.5, -0.5, 1),
           arrow = arrow(length = unit(.1, 'cm'), type = "closed")) +
  annotate("path", x = c(6.5, 6.5, 0.5, 0.5), y = c(2.5, 5, 5, 4 + end),
           arrow = arrow(length = unit(.1, 'cm'), type = "closed")) +
  annotate("text",
           x = c(.5, .5, 3.5, 3.5, 6.5),
           y = c(3.5, .5, 3.5, .5, 2),
           label = c("S", "V", "I[1]", "I[2]", "R"),
           parse = T, family = "Ubuntu", size = 8) +
  annotate("text",
           x = c(-.5, -.5, 
                 .25 - h_adj, .50 + h_adj, 3.5,
                 2, 2, 2.5, 2.5,
                 5, 5,
                 .75 + h_adj, .75 + h_adj, 3.75 + h_adj, 3.75 + h_adj, 6.75 + h_adj),
           y = c(3.5 + v_adj, 
                 0.5 + v_adj, 2, 2, 5 + v_adj,
                 3.7 + v_adj, 0.3 - v_adj, 2 + 1.1 * v_adj, 2 - 1.1 * v_adj,
                 2 + 4 * v_adj, 2 - 4 * v_adj,
                 2.75, -.25, -.25, 2.75, 1.25),
           label = c("italic((1-p[1])*b)", "italic(p[1]*b)", 
                     "italic(ω)", "italic(η)", "italic(η)",
                     "italic(β[1])", "italic(β[2])", "italic(β[1]^minute)", "italic(β[2])",
                     "italic(γ)", "italic(γ)",
                     rep("italic(d)", 5)),
           parse = T, family = "Ubuntu", size = 3) +
  theme_void() -> transfer_diagram

ggsave(filename = "figures/fig-1-model.png", plot = transfer_diagram, device = "png", width = 13, height = 7, units = "cm", dpi = 1200)
