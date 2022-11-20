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




###
# Install the package if you have not installed by running this command: 
BiocManager::install("EnsDb.Hsapiens.v79")

library(EnsDb.Hsapiens.v79)

# 1. Convert from ensembl.gene to gene.symbol
ensembl.genes <- c("ENSG00000150676", "ENSG00000099308", "ENSG00000142676", "ENSG00000180776", "ENSG00000108848", "ENSG00000277370", "ENSG00000103811", "ENSG00000101473")

geneIDs1 <- ensembldb::select(EnsDb.Hsapiens.v79, keys= ensembl.genes, keytype = "GENEID", columns = c("SYMBOL","GENEID"))

# 2. Convert from gene.symbol to ensembl.gene
geneSymbols <-  c('DDX26B','CCDC83',  'MAST3', 'RPL11', 'ZDHHC20',  'LUC7L3',  'SNORD49A',  'CTSH', 'ACOT8')

geneIDs2 <- ensembldb::select(EnsDb.Hsapiens.v79, keys= geneSymbols, keytype = "SYMBOL", columns = c("SYMBOL","GENEID"))