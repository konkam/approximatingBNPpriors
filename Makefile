############ Comments

# Using a makefile is a way to record how to make all figures in a single script, this is one way of making Supplemental Information for a paper.
# The advantage of a makefile is that with the make utility, whenever a change is made to the SI, only the part of the computations relevant to the change are run. In other words, the dependence structure of the files is recorded in the makefile, so it is possible to identify what scripts or file can be affected by a change to another file. This also allows performing independent computations in parallel.

# To use, run in a terminal:

# make Figures

# Parallel computations using 8 cores can be made by:

# make -j8 Figures


#-------------------

# Scripts to make the figures are in the folder scripts_for_figure/
# If a figure takes a long time to draw, it is more convenient to save the results than to recompute everything each time the figure needs change.
# Saved results are in the folder saves_for_figure/

# A script to make figure "figname" is named figname_fig.jl
# A script to compute the results beforehand is named figname_precomp.jl
# A saved result for a figure is a file named figname.jld, created using the Julia package JLD

#-------------------

# To get reproducible julia figures, we use the following command:
# julia --project=. myscript.jl 
# The above command makes sure that julia runs using all the packages that are specified in the Manifest.toml file, ensuring reproducibility.
# For more info, see https://julialang.github.io/Pkg.jl/v1/environments/#Using-someone-else's-project-1

############# Figures

## accuracy_PknCnkVnk_1000_5000bits
saves_for_figures/accuracy_PknCnkVnk.jld: scripts_for_figures/accuracy_PknCnkVnk_precomp.jl
	julia --project=. scripts_for_figures/accuracy_PknCnkVnk_precomp.jl

figures/accuracy_PknCnkVnk_1000_5000bits.pdf: saves_for_figures/accuracy_PknCnkVnk.jld scripts_for_figures/accuracy_PknCnkVnk_fig.jl
	julia --project=. scripts_for_figures/accuracy_PknCnkVnk_fig.jl


## accuracy_Cnk_sigma
saves_for_figures/accuracy_Cnk_sigma.jld: scripts_for_figures/accuracy_Cnk_sigma_precomp.jl
	julia --project=. scripts_for_figures/accuracy_Cnk_sigma_precomp.jl

figures/accuracy_Cnk_sigma.pdf: saves_for_figures/accuracy_Cnk_sigma.jld scripts_for_figures/accuracy_Cnk_sigma_fig.jl
	julia --project=. scripts_for_figures/accuracy_Cnk_sigma_fig.jl

## Vnk_instability
figures/Vnk_instability.pdf: scripts_for_figures/Vnk_instability.jl
	julia --project=. scripts_for_figures/Vnk_instability.jl

Figures: figures/accuracy_PknCnkVnk_1000_5000bits.pdf figures/accuracy_Cnk_sigma.pdf figures/Vnk_instability.pdf