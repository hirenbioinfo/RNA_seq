source("/Users/hirenghosh/Project/RNAseq/volcano_plot/code/volcation_plot_scripit.R")

# Set the paths for the input data file and the output plot file
input_file <- "/Users/hirenghosh/Project/RNAseq/volcano_plot/data/severevshealthy_degresults.csv"
output_file <- "/Users/hirenghosh/Project/RNAseq/volcano_plot/plot/myvolcanoplot3.pdf"

# Call the function to generate the volcano plot
generate_volcano_plot(input_file, output_file)