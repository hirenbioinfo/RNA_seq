# Set a CRAN mirror
# Written by : Hiren Ghosh
options(repos = c(CRAN = "https://cran.r-project.org"))
# Install and load the required package
if (!requireNamespace("openxlsx", quietly = TRUE)) {
  install.packages("openxlsx")
}
library(openxlsx)

# Define a help function
# Define a help function
print_help <- function() {
  cat("\nDescription:\n")
  
  cat("  =========================================================================\n")
  cat("  This script extracts specific columns from an input Excel dataset using\n")
  cat("  command-line arguments for column list, input file, and output file, and\n")
  cat("  creates a final subset data file. Each column should be listed on a separate\n")  
  cat("  line within the column list file \n")
  cat("  =========================================================================\n\n")
  cat("Usage: Rscript extract_data.R -l <column_list_file> -i <input_excel_file> -o <output_file>\n")
  cat("\nOptions:\n")
  cat("  -l\tColumn list file\n")
  cat("  -i\tInput Excel file\n")
  cat("  -o\tOutput file for the final subset data\n\n")
}

# Get command-line arguments
args <- commandArgs(trailingOnly = TRUE)

# Check if help flag is provided
if ("--help" %in% args || "-h" %in% args) {
  print_help()
  quit(status = 0)
}

# Check if the correct number of arguments is provided
if (length(args) != 6 || !all(c("-l", "-i", "-o") %in% args)) {
  cat("Error: Invalid arguments. Use --help or -h for usage information.\n")
  quit(status = 1)
}

# Extract command-line arguments
column_list_index <- which(args == "-l") + 1
input_excel_index <- which(args == "-i") + 1
output_file_index <- which(args == "-o") + 1

column_list_file <- args[column_list_index]
excel_data_file <- args[input_excel_index]
output_file <- args[output_file_index]

# Read the column names from the file
column_list <- readLines(column_list_file)

# Read the Excel file
data <- read.xlsx(excel_data_file, sheet = 1)

# Extract the first two columns
first_two_columns <- data[, 1:2]

# Extract specific columns from the list
subset_columns <- data[, column_list]

# Combine the first two columns and the subset columns
final_subset_data <- cbind(first_two_columns, subset_columns)

# Write the final subset data to the output file
write.xlsx(final_subset_data, output_file)
##