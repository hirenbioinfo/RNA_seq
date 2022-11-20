library(org.Hs.eg.db)
infile = read.csv("data/gene_lists.csv")
data = infile[,"ENSEMBL"]

# You can see that the subset data is listed as a integer, we now need to convert
# this to a vector to pass it into the annotation mapping

data = as.vector(data)

# Using the org.Hs.eg.db we set up mapping info - if you look at the documentation you
# can also obtain other keytypes

annots <- select(org.Hs.eg.db, keys=data, 
                 columns="SYMBOL", keytype="ENSEMBL")

result <- merge(infile, annots, by.x="ENSEMBL", by.y="ENSEMBL")

print(head(result))

#Annotables
library(annotables)
library(tidyverse)
infile = read.csv("data/gene_lists.csv")

infile %>% 
  dplyr::arrange(padj) %>% 
  head(20) %>% 
  dplyr::inner_join(grch38, by = c("ENSEMBL" = "ensgene"))