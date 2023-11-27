# Scripts associated with the article [*Using a dynamical model to study the impact of a toxoid vaccine on the evolution of a bacterium: The example of diphtheria*](<https://doi.org/10.1016/j.ecolmodel.2023.110569>)

Scripts presented in this repository are expected to work on R version 4.3.2. Versions of the R packages used to produce the results shown are presented at the end of the document.

The file `model.c` in the `files/` folder is the C script containing the model used in the article <sup>1</sup>. It can be compiled directly in R using the command `system(R CMD SHLIB files/model.c)`. This command will produce two files: `model.o` and `model.so`, which are already included in the `files/` folder.

The `init.R` script must be run before any other one. It loads the packages needed for other scripts to work and initiates some variables (e.g., parameters values used in the model).

The simulations are mainly run through the `simus-prev.R` script. It tests different values for six parameters of the model (+ the vaccine coverage) and checks what the prevalence of the toxigenic strain is at equilibrium. The script `simus-R0.R` runs more simulations, this time testing the impact of having different values of `r1` and `p1` / `p2` (see the related article for the definition of the parameters) on the transmission number $R_0$ of the toxigenic strains.

Once all simulations are done, the figures can be produced. The four figures of the article are produced with three scripts. The first one, `fig-1.R` draws the schematic diagram of the model, as odd as it is to draw it using R. The second one, `fig-2.3R`, creates the figures showing the absolute and relative prevalence of the toxigenic strain for different values of the parameters. The third one, `fig-4.R`, creates the figure showing how moving the vaccine coverage and efficacy can move the $R_0$ of the toxigenic strain, at the DFE or at the CEE <sup>2</sup>.

If someone wants to run all the scripts, it should not take "too much" time. With a good computer, all scripts should run in half a day at most <sup>3</sup>. What is particularly long is to run the simulations, and especially running the `sumus-R0.R` script.

Here are the details of the R install and packages loaded to run the different scripts (obtained using `sessionInfo()`):

```
R version 4.3.2 (2023-10-31)
Platform: x86_64-pc-linux-gnu (64-bit)
Running under: Ubuntu 20.04.6 LTS

Matrix products: default
BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.9.0 
LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.9.0

locale:
 [1] LC_CTYPE=fr_FR.UTF-8       LC_NUMERIC=C               LC_TIME=fr_FR.UTF-8        LC_COLLATE=fr_FR.UTF-8     LC_MONETARY=fr_FR.UTF-8   
 [6] LC_MESSAGES=fr_FR.UTF-8    LC_PAPER=fr_FR.UTF-8       LC_NAME=C                  LC_ADDRESS=C               LC_TELEPHONE=C            
[11] LC_MEASUREMENT=fr_FR.UTF-8 LC_IDENTIFICATION=C       

time zone: Europe/Paris
tzcode source: system (glibc)

attached base packages:
[1] parallel  stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] metR_0.14.1       ggtext_0.1.2      ggpubr_0.6.0      egg_0.4.5         ggplot2_3.4.4     gridExtra_2.3     doParallel_1.0.17 iterators_1.0.14 
 [9] foreach_1.5.2     deSolve_1.38     

loaded via a namespace (and not attached):
 [1] utf8_1.2.4        generics_0.1.3    tidyr_1.3.0       rstatix_0.7.2     xml2_1.3.5        magrittr_2.0.3    grid_4.3.2        fastmap_1.1.1    
 [9] backports_1.4.1   purrr_1.0.2       fansi_1.0.5       scales_1.2.1      textshaping_0.3.7 codetools_0.2-19  abind_1.4-5       cli_3.6.1        
[17] rlang_1.1.2       munsell_0.5.0     withr_2.5.2       cachem_1.0.8      tools_4.3.2       memoise_2.0.1     checkmate_2.3.0   ggsignif_0.6.4   
[25] dplyr_1.1.4       colorspace_2.1-0  broom_1.0.5       vctrs_0.6.4       R6_2.5.1          lifecycle_1.0.4   car_3.1-2         ragg_1.2.6       
[33] pkgconfig_2.0.3   pillar_1.9.0      gtable_0.3.4      glue_1.6.2        data.table_1.14.8 Rcpp_1.0.11       systemfonts_1.0.5 tibble_3.2.1     
[41] tidyselect_1.2.0  rstudioapi_0.15.0 farver_2.1.1      labeling_0.4.3    carData_3.0-5     compiler_4.3.2    gridtext_0.1.5
```

> <sup>1</sup> The model is written in a C script rather than a R script to increase speed, as numerical simulations returned by the `deSolve` package are obtained approximatively 60x faster if the model is encoded in a compiled langage than in R. To learn more on using the `deSolve` package with compiled langages, see [this vignette](https://cran.r-project.org/web/packages/deSolve/vignettes/compiledCode.pdf).

> <sup>2</sup> DFE: Disease-Free equilibrium; CEE: *Cd~2~*-Endemic Equilibrium. See the article for more details.

> <sup>3</sup> I run the scripts on a device with 16 GB of DDR4 RAM and an Intel Core i7-1165G7 processor (1.2-2.8 GHz).
