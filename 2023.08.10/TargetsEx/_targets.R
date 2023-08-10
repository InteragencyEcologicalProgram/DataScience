# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
# library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(
  packages = c("tidyr", "dplyr", "ggplot2") # packages that your targets need to run
  # format = "qs", # Optionally set the default storage format. qs is fast.
  #
  # For distributed computing in tar_make(), supply a {crew} controller
  # as discussed at https://books.ropensci.org/targets/crew.html.
  # Choose a controller that suits your needs. For example, the following
  # sets a controller with 2 workers which will run as local R processes:
  #
  #   controller = crew::crew_controller_local(workers = 2)
  #
  # Alternatively, if you want workers to run on a high-performance computing
  # cluster, select a controller from the {crew.cluster} package. The following
  # example is a controller for Sun Grid Engine (SGE).
  # 
  #   controller = crew.cluster::crew_controller_sge(
  #     workers = 50,
  #     # Many clusters install R as an environment module, and you can load it
  #     # with the script_lines argument. To select a specific verison of R,
  #     # you may need to include a version string, e.g. "module load R/4.3.0".
  #     # Check with your system administrator if you are unsure.
  #     script_lines = "module load R"
  #   )
  #
  # Set other options as needed.
)

# tar_make_clustermq() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
options(clustermq.scheduler = "multiprocess")

# tar_make_future() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:
list(
  # all of these calculations and plots are simple; goal is to illustrate one potential way 
  # to set up a pipeline with source data broken into the 8 example files
  
  # track files
  tar_target(inflow_a_bas, 
             file.path("data", "Inflow_RiverA_Baseline.csv"), 
             format = "file"),
  tar_target(outflow_a_bas, 
             file.path("data", "Outflow_RiverA_Baseline.csv"), 
             format = "file"),
  tar_target(inflow_b_bas, 
             file.path("data", "Inflow_RiverB_Baseline.csv"), 
             format = "file"),
  tar_target(outflow_b_bas, 
             file.path("data", "Outflow_RiverB_Baseline.csv"), 
             format = "file"),
  tar_target(inflow_a_pro, 
             file.path("data", "Inflow_RiverA_Proposed.csv"), 
             format = "file"),
  tar_target(outflow_a_pro, 
             file.path("data", "Outflow_RiverA_Proposed.csv"), 
             format = "file"),
  tar_target(inflow_b_pro, 
             file.path("data", "Inflow_RiverB_Proposed.csv"), 
             format = "file"),
  tar_target(outflow_b_pro, 
             file.path("data", "Outflow_RiverB_Proposed.csv"), 
             format = "file"),

  # compile files into lists
  tar_target(inflow_files_bas, list("A" = inflow_a_bas,
                                    "B" = inflow_b_bas)),
  tar_target(inflow_files_pro, list("A" = inflow_a_pro,
                                    "B" = inflow_b_pro)),
  tar_target(outflow_files_bas, list("A" = outflow_a_bas,
                                     "B" = outflow_b_bas)),
  tar_target(outflow_files_pro, list("A" = outflow_a_pro,
                                     "B" = outflow_b_pro)),
  
  # read and prep data
  tar_target(inflow_bas, prep_data(inflow_files_bas)),
  tar_target(inflow_pro, prep_data(inflow_files_pro)),
  tar_target(outflow_bas, prep_data(outflow_files_bas)),
  tar_target(outflow_pro, prep_data(outflow_files_pro)),
  
  # aggregate from monthly to annual
  tar_target(inflow_agg_bas, agg_data(inflow_bas)),
  tar_target(inflow_agg_pro, agg_data(inflow_pro)),
  tar_target(outflow_agg_bas, agg_data(outflow_bas)),
  tar_target(outflow_agg_pro, agg_data(outflow_pro)),
  
  # calculate monthly difference in inflow and outflow
  tar_target(diff_bas, calc_diff(inflow_bas, outflow_bas)),
  tar_target(diff_pro, calc_diff(inflow_pro, outflow_pro)),
  tar_target(diff_agg_bas, agg_data(diff_bas)),
  tar_target(diff_agg_pro, agg_data(diff_pro)),
  
  # create plots
  tar_target(diff_agg_bas_plot, plot_data(diff_agg_bas)),
  tar_target(diff_agg_pro_plot, plot_data(diff_agg_pro)),
  
  # save plots to file
  tar_target(diff_agg_bas_plot_file, 
             ggsave(file.path("figures", "Diff_Agg_Baseline.png"), diff_agg_bas_plot,
                    width = 6, height = 3.5), 
             format = "file"),
  tar_target(diff_agg_pro_plot_file, 
             ggsave(file.path("figures", "Diff_Agg_Proposed.png"), diff_agg_pro_plot,
                    width = 6, height = 3.5), 
             format = "file")
)
