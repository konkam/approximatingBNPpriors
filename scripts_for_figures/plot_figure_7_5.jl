using RCall

R"
library(gridExtra)
library(cowplot)
library(tidyverse)
library(latex2exp)
library(viridis)
"


DF = load("/Users/dariabystrova/Documents/GitHub/approximatingBNPpriors/saves_for_figures/figure_7_5.jld")
grid_vec = DF["grid_vec"]

R"
range01 <- function(x){(x-min(x))/(max(x)-min(x))}
betas = exp(log($(first.(grid_vec))))
sigmas = $(last.(grid_vec))

to_plot = expand_grid(betas, sigmas) %>%
  mutate(col = rgb(red = range01(log(betas)), green = sigmas, blue = 0.5, alpha = 1))

pt = to_plot %>%
  ggplot(aes(x = betas, y = sigmas)) +
  geom_point(aes(colour = col),size=4) + scale_x_log10() + annotation_logticks(base = 10)+ scale_color_identity()
 pt = pt +  geom_line(data =to_plot, aes(x=betas, y = sigmas, group=betas),linetype = 'longdash', alpha = 0.5,size=0.3)+
   geom_line(data =to_plot, aes(x=betas, y = sigmas, group=sigmas),linetype = 'dotted', alpha = 0.5,size=0.3)+ theme_classic()+
   theme(plot.title = element_text(hjust = 0.5,size = 15), axis.text = element_text(size=15), axis.title=element_text(size=15),legend.position='none')+
   ylab(TeX(sprintf('$\\sigma$')))+ xlab(TeX(sprintf('$\\tau$')))"


R"
pdf('/Users/dariabystrova/Documents/GitHub/approximatingBNPpriors/figures/figure_7_5.pdf')
plot(pt)
dev.off()"
