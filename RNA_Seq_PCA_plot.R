##### setup ####

# load packages
library(tidyverse)
################################################################################
# read the data
trans_cts <- read_csv("./data/counts_transformed.csv")
sample_info <- read_csv("./data/sample_info.csv")
################################################################################
# Create a matrix from our table of counts
pca_matrix <- trans_cts %>% 
  # make the "gene" column become the rownames of the table
  column_to_rownames("gene") %>% 
  # coerce to a matrix
  as.matrix() %>% 
  # transpose the matrix so that rows = samples and columns = variables
  t()
################################################################################
# Perform the PCA
################################################################################
sample_pca <- prcomp(pca_matrix)

# Convert matrix to tibble
#as_tibble(pca_matrix)
# Convert matrix to tibble - add colnames to a new column called "gene"
as_tibble(pca_matrix, rownames = "sample")
pc_eigenvalues <- sample_pca$sdev^2

# create a "tibble" manually with 
# a variable indicating the PC number
# and a variable with the variances
pc_eigenvalues <- tibble(PC = factor(1:length(pc_eigenvalues)), 
                         variance = pc_eigenvalues) %>% 
  # add a new column with the percent variance
  mutate(pct = variance/sum(variance)*100) %>% 
  # add another column with the cumulative variance explained
  mutate(pct_cum = cumsum(pct))

# print the result
pc_eigenvalues



pc_eigenvalues %>% 
  ggplot(aes(x = PC)) +
  geom_col(aes(y = pct)) +
  geom_line(aes(y = pct_cum, group = 1)) + 
  geom_point(aes(y = pct_cum)) +
  labs(x = "Principal component", y = "Fraction variance explained")

# The PC scores are stored in the "x" value of the prcomp object
pc_scores <- sample_pca$x



pc_scores <- pc_scores %>% 
  # convert to a tibble retaining the sample names as a new column
  as_tibble(rownames = "sample")

# print the result
pc_scores


pc_scores %>% 
  # create the plot
  ggplot(aes(x = PC1, y = PC2)) +
  geom_point()

################################################################################
# pca plot
################################################################################

# Existing code
pca_plot <- sample_pca$x %>% # extract the loadings from prcomp
  as_tibble(rownames = "sample") %>%  # convert to a tibble retaining the sample names as a new column
  full_join(sample_info, by = "sample") %>%  # join with "sample_info" table 
  ggplot(aes(x = PC1, y = PC2, colour = factor(minute), shape = strain)) +
  geom_point(size = 3)  # create the plot with larger points

# Existing code
pca_plot +
  stat_ellipse(aes(x=PC1,y=PC2,fill=factor(strain)),
               geom="polygon",alpha=0.2) +
  guides(color=guide_legend("strain"),fill=guide_legend("strain"))

################################################################################
# Display a summary of the number of samples in each cluster
print(table(sample_info$strain))

################################################################################

# Load necessary library
library(plotly)

# Assuming pca_data is the data frame you have generated from PCA analysis and merging it with sample_info
pca_data <- sample_pca$x %>% 
  as_tibble(rownames = "sample") %>% 
  full_join(sample_info, by = "sample") 

# Create the PCA plot using ggplot2
pca_plot <- pca_data %>%
  ggplot(aes(x = PC1, y = PC2, colour = factor(minute), shape = strain)) +
  geom_point() +
  stat_ellipse(aes(x=PC1,y=PC2,fill=factor(strain)),geom="polygon",alpha=0.2) +
  guides(color=guide_legend("strain"),fill=guide_legend("strain")) +
  geom_point(size = 3)  # create the plot with larger points


# Convert the ggplot object to a plotly object
interactive_plot <- ggplotly(pca_plot)

# Print the interactive plot
print(interactive_plot)
################################################################################



