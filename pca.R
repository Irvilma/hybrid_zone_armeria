######PCA con adegenet#####

###cargar package adegenet
#install.packages("adegenet")
library(adegenet)
### instalar y cargar el paquete vcfR
#install.packages("vcfR")
library(vcfR)
###crear objeto genlight (igual que para DAPC)
#El objeto genlight se obtiene con vcfR (a partir de .vcf)


matriz<-read.vcfR("/Volumes/BackupPlus/CLUSTER/HybriSeq/14.ipyrad/c88d8m139sh60/c88d8m139sh60_outfiles/c88d8m139sh60.vcf")

#Convert .vcf file to a genlight object
matriz<-vcfR2genlight(matriz)
matriz
plot(matriz)


## perform PCA
#toRemove <- is.na(glMean(matriz, alleleAsUnit = FALSE)) # TRUE where NA
#which(toRemove) # position of entirely non-typed loci
#b <- matriz[, !toRemove]
#b # this should work
#plot(b)

##Remove loci with few information:
NAs<- glNA(matriz, alleleAsUnit = FALSE)
NAs
toRemove <- NAs > 120
c<- matriz[,!toRemove]
c
plot(c)

pca <- glPca(c, nf= 4286, parallel = FALSE, alleleAsUnit = FALSE, loadings = TRUE)
barplot(pca$eig, main="eigenvalues GBS-SNP", col=heat.colors(length(pca$eig)),
        xlab= "Principal components",ylab = "Percentage of variances",
        #names.arg = 1:27)
        #names.arg = c("PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","PC11","PC12","PC13","PC14","PC15",
        #              "PC16","PC17","PC18","PC19","PC20","PC21","PC22","PC23","PC24","PC25","PC26","PC27"),
        cex.axis = 0.8, cex.names = 0.8)

barplot(100*pca$eig/sum(pca$eig), col = heat.colors(50), main="PCA Eigenvalues")
title(ylab="Percent of variance\nexplained", line = 2)
title(xlab="Eigenvalues", line = 1)

#scores<- write.table(pca$scores,"G:/2018-Proyecto_Armeria-GNF/21.tortoise_strategy_Scott2019/2.c88d8m139sh60/2.pca/scores_c88d8m139sh60.txt")

#https://cran.r-project.org/web/packages/ggfortify/vignettes/plot_pca.html

#library(ggfortify)

#table <- read.table("G:/2018-Proyecto_Armeria-GNF/21.tortoise_strategy_Scott2019/2.c88d8m139sh60/2.pca/scores_c88d8m139sh60_edit.txt")
#table2 <- read.table("G:/2018-Proyecto_Armeria-GNF/21.tortoise_strategy_Scott2019/2.c88d8m139sh60/2.pca/scores_c88d8m139sh60_edit.txt")

#table$ind <- NULL
#table$pop <- NULL
#autoplot(prcomp(table))
#autoplot(prcomp(table), data = table2, colour = 'pop')

###################################################################
pop.data <- read.table("/Volumes/Backup Plus/2018-Proyecto_Armeria-GNF/21.tortoise_strategy_Scott2019/2.c88d8m139sh60/2.pca/pop_5groups", sep = "\t", header = F)
pop(c) <- pop.data$V2

pca.scores <- as.data.frame(pca$scores)
pca.scores$pop <- pop(c)

library(RColorBrewer)
cols <- brewer.pal(n = nPop(c), name = "Set2")


####### https://speciationgenomics.github.io/pca/ #####################
#Plotting the data
#Now that we have done our housekeeping, we have everything in place to actually 
#visualise the data properly. 
#First we will plot the eigenvalues. 
#It is quite straightforward to translate these into percentage variance explained 
#(although note, you could just plot these raw if you wished).
# first convert to percentage variance explained
pve <- data.frame(PC = 1:154, pve = pca$eig/sum(pca$eig)*100)
# make plot
a <- ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity")
a + ylab("Percentage variance explained") + theme_light()

# calculate the cumulative sum of the percentage variance explained
cumsum(pve$pve)

library(ggplot2)

set.seed(9)
p <- ggplot(pca.scores, aes(x=PC1, y=PC2, colour=pop)) 
p <- p + geom_point(size=2)
#p <- p + stat_ellipse(level = 0.95, size = 1)
p <- p + scale_color_manual(values = cols) 
p <- p + geom_hline(yintercept = 0) 
p <- p + geom_vline(xintercept = 0) 
p <- p + coord_equal()
#p <- p+ geom_text(label=rownames(pca.scores), nudge_x = 0.08, nudge_y = 0.08, check_overlap = T)
p <- p + theme_bw()
p <- p + xlab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) + ylab(paste0("PC2 (", signif(pve$pve[2], 3), "%)"))

p

set.seed(9)
p <- ggplot(pca.scores, aes(x=PC1, y=PC3, colour=pop)) 
p <- p + geom_point(size=2)
#p <- p + stat_ellipse(level = 0.95, size = 1)
p <- p + scale_color_manual(values = cols) 
p <- p + geom_hline(yintercept = 0) 
p <- p + geom_vline(xintercept = 0) 
p <- p + coord_equal()
#p <- p+ geom_text(label=rownames(pca.scores), nudge_x = 0.08, nudge_y = 0.08, check_overlap = T)
p <- p + theme_bw()
p <- p + xlab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) + ylab(paste0("PC3 (", signif(pve$pve[3], 3), "%)"))

p

