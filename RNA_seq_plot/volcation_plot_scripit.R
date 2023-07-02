######################################
# Volcano Plot Script
# Author: Hiren Ghosh
# Affiliation: Uniklinik Freiburg
######################################
generate_volcano_plot <- function(data_file, output_file) {
  # Loading relevant libraries
  library(tidyverse)
  library(RColorBrewer)
  library(ggrepel)
  
  # Read data from the specified file
  df <- read.csv(data_file, row.names = 1)
  
  # Create the basic volcano plot
  volcano_plot <- ggplot(data = df, aes(x = log2fc, y = -log10(pval))) +
    geom_point()
  
  # Add threshold lines
  volcano_plot <- volcano_plot +
    geom_vline(xintercept = c(-0.6, 0.6), col = "red", linetype = 'dashed') +
    geom_hline(yintercept = -log10(0.05), col = "green", linetype = 'dashed')
  
  # Apply the Biostatsquid theme
  volcano_plot <- volcano_plot +
    theme_classic(base_size = 20) +
    theme(
      axis.title.y = element_text(face = "bold", margin = margin(0,20,0,0), size = rel(1.1), color = 'black'),
      axis.title.x = element_text(hjust = 0.5, face = "bold", margin = margin(20,0,0,0), size = rel(1.1), color = 'black'),
      plot.title = element_text(hjust = 0.5)
    )
  
  # Add a column to specify up-regulated/down-regulated genes
  df$diffexpressed <- "NO"
  df$diffexpressed[df$log2fc > 0.6 & df$pval < 0.05] <- "UP"
  df$diffexpressed[df$log2fc < -0.6 & df$pval < 0.05] <- "DOWN"
  
  # Create a new column "delabel" to de, that will contain the name of the top 30 differentially expressed genes (NA in case they are not)
  df$delabel <- ifelse(df$gene_symbol %in% head(df[order(df$padj), "gene_symbol"], 30), df$gene_symbol, NA)
  
  # Create the volcano plot with colored points and labels
  volcano_plot <- ggplot(data = df, aes(x = log2fc, y = -log10(pval), col = diffexpressed, label = delabel)) +
    geom_vline(xintercept = c(-0.6, 0.6), col = "gray", linetype = 'dashed') +
    geom_hline(yintercept = -log10(0.05), col = "gray", linetype = 'dashed') +
    geom_point(size = 2) +
    scale_color_manual(values = c("#00AFBB", "grey", "#bb0c00"),
                       labels = c("Downregulated", "Not significant", "Upregulated")) +
    coord_cartesian(ylim = c(0, 250), xlim = c(-10, 10)) +
    labs(color = 'Severe', x = expression("log"[2]*"FC"), y = expression("-log"[10]*"p-value")) +
    scale_x_continuous(breaks = seq(-10, 10, 2)) +
    ggtitle('Thf-like cells in severe COVID vs healthy patients') +
    geom_text_repel(max.overlaps = Inf)
  
  # Save the plot as a PDF file
  ggsave(output_file, plot = volcano_plot, width = 8, height = 12)
}


################################################################################
# use 
# open a new r script and copy the line bellow and change the file path and plot name as necessary
#source("volcation_plot_scripit.R")
# Set the paths for the input data file and the output plot file
#input_file <- "/Users/hirenghosh/Project/RNAseq/volcano_plot/severevshealthy_degresults.csv"
#output_file <- "/Users/hirenghosh/Project/RNAseq/volcano_plot/myvolcanoplot2.pdf"
# Call the function to generate the volcano plot
#generate_volcano_plot(input_file, output_file)