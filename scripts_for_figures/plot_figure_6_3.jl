using RCall, JLD

R"
library(gridExtra)
library(cowplot)
library(tidyverse)
library(latex2exp)
library(viridis)
"


DF = load("/Users/dariabystrova/Documents/GitHub/approximatingBNPpriors/saves_for_figures/figure_6_3.jld")
EV__NGGM = DF["NGGM"]




DF_NGGM = DataFrame(Exp = first.(EV__NGGM),Var =last.(EV__NGGM), beta = first.(grid_vec), sigma = last.(grid_vec))
DF_NGGM.std = sqrt.(DF_NGGM.Var)
DF_NGGM.beta_log = log.(DF_NGGM.beta)
DF_NGGM


R"
range01 <- function(x){(x-min(x))/(max(x)-min(x))}"
R"
df_r= $DF_NGGM
df_r$beta_scaled= range01(df_r$beta_log)
df_r$color = rgb(df_r$beta_scaled, df_r$sigma,0.5,1)
df_r$color_sigma = rgb(0, df_r$sigma,0.5,1)
df_r$color_beta = rgb(df_r$beta_scaled, 0,0.5,1)
"
R"
p <- df_r %>% ggplot(aes(x=Exp, y = std, group=sigma))  + geom_line( alpha = 0.8,linetype = 'longdash') + geom_point(aes(colour=color), size=4)
p_nggm <- p  + geom_line(data =df_r, aes(x=Exp, y = std, group=beta), alpha = 0.9,linetype = 'dotted') +
         xlim(0, 100)+ ylim(0,15)+labs(y='Std', x='Expectation')+scale_colour_identity()+theme_classic()+ theme(plot.title = element_text(hjust = 0.5,size = 15), axis.text.x = element_text(size=15), axis.text.y = element_text(size=15),legend.position='none')
 "



R"p_nggm
pdf('/Users/dariabystrova/Documents/GitHub/approximatingBNPpriors/figures/figure_6_3.pdf', width= 4, height = 4)
plot(p_nggm)
dev.off()"
