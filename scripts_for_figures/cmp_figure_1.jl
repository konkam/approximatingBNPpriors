include("/Users/dariabystrova/Documents/GitHub/approximatingBNPpriors/scripts_for_figures/common_functions.jl")
include("/Users/dariabystrova/Documents/GitHub/approximatingBNPpriors/scripts_for_figures/FK_sampling_functions.jl")
include("/Users/dariabystrova/Documents/GitHub/approximatingBNPpriors/scripts_for_figures/SB_sampling_functions.jl")

using JLD, GibbsTypePriors, DataFramesMeta, RCall, Optim, OptimTestProblems, StatsBase


## functions to generate the plots

function approximation_prior_distribution(beta,sigma,N,Nt,sigma_arr)
    Pkn_numeric_ = GibbsTypePriors.Pkn_NGG.(1:N, N, beta, sigma)
    Pkn_order2_ = Pkn_NGG_pred_approx(N, beta, sigma)
    Pkn_NGGMult = Pkn_NGGM_precomp.(1:N,N,Nt,beta,sigma, [Pkn_numeric_])
    Pkn_FK_ =  Pkn_NGG_FK(N, beta, sigma, Nt; runs=2*10^2)
    #R"p_ngg_sb <- Prior_on_K_SB_NGG($beta, $sigma, $N,$(Nt), runs=2*10^2)"
    #Pkn_SB_raw  = rcopy(R"p_ngg_sb$pk")
    Pkn_SB_  = Pkn_NGG_SB_1(N,beta,sigma,Nt; runs=2*10^2)

    df= DataFrame(Pkn_numeric = Pkn_numeric_,
                  Pkn_order2 = Pkn_order2_,
                  Pkn_NGGM = Pkn_NGGMult,
                  Pkn_FK = Pkn_FK_,
                  Pkn_SB = Pkn_SB_)
       return df
end


###########

n=100
β= 1.0
ntr=250
sigma_vec= [0.25,0.75]
DF_all_100 = map(x ->approximation_prior_distribution(β,x,n,ntr,sigma_vec),sigma_vec)



n=100
β= 10.0
ntr=250
sigma_vec= [0.25,0.75]
DF_all_100_10 = map(x ->approximation_prior_distribution(β,x,n,ntr,sigma_vec),sigma_vec)

DF_100 = [DF_all_100,DF_all_100_10 ]


save("/Users/dariabystrova/Documents/GitHub/approximatingBNPpriors/saves_for_figures/figure_1.jld", "DF_100" ,DF_100)
