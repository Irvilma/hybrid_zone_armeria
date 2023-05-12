#!/bin/sh
#SBATCH -p generic #trabajos en paralelo
#SBATCH -N 1 #numero de nodos
#SBATCH -n 8 #numero de cores(CPUs)
#SBATCH -e error_%A_%a.out
#SBATCH -o output_%A_%a.out

# step by step from: https://speciationgenomics.github.io/mapping_reference/

REF=/home/rjb/ivilla/HybriSeq/31.chloroplast2/reference/Assembly_denovo_chloro_156APT.fasta
/home/rjb/ivilla/software/bwa-0.7.12/bwa index $REF

# Next, we will declare an array to ensure that we have all our individuals

INDS=($(for i in /home/rjb/ivilla/HybriSeq/31.chloroplast2/data/*R1.fq.gz; do echo $(basename ${i%.R*}); done))


for IND in ${INDS[@]};
do
	# declare variables
	FORWARD=/home/rjb/ivilla/HybriSeq/31.chloroplast2/data/${IND}.R1.fq.gz
	REVERSE=/home/rjb/ivilla/HybriSeq/31.chloroplast2/data/${IND}.R2.fq.gz
	OUTPUT=/home/rjb/ivilla/HybriSeq/31.chloroplast2/align/${IND}_sort.bam

	
	# then align and sort
	#echo "Aligning $IND with bwa"
	#/home/rjb/ivilla/software/bwa-0.7.12/bwa mem -M $REF $FORWARD $REVERSE | /home/rjb/ivilla/software/samtools-1.2/samtools view -b | /home/rjb/ivilla/software/samtools-1.2/samtools sort -T ${IND} > $OUTPUT

# then align and sort
	echo "Aligning $IND with bwa"
	/home/rjb/ivilla/software/bwa-0.7.12/bwa mem -M $REF $FORWARD $REVERSE > ${IND}.sam
	/home/rjb/ivilla/software/samtools-1.2/samtools view -b ${IND}.sam > ${IND}.bam
	/home/rjb/ivilla/software/samtools-1.2/samtools sort ${IND}.bam ${IND}_sort
	mv ${IND}_sort $OUTPUT

done

# SNPCalling:
/home/rjb/ivilla/software/samtools-1.2/samtools faidx $REF
/home/rjb/ivilla/software/samtools-1.2/samtools mpileup  -f $REF ./align/*_sort.bam | java -jar /home/rjb/ivilla/software/VarScan.v2.3.9.jar  mpileup2snp  --min-var-freq 0.5 --min-avg-qual 30 --min-freq-for-hom 0.5 --output-vcf 1 --min-coverage 3 --strand-filter 1 > chloroplast_arm_hirta.vcf

# Demenou use mpileup -B:
# BAQ is the Phred-scaled probability of a read base being misaligned. It greatly helps to reduce false SNPs caused by misalignments. BAQ is calculated using the probabilistic realignment method described in the paper “Improving SNP discovery by base alignment quality”, Heng Li, Bioinformatics, 
# Volume 27, Issue 8 <https://doi.org/10.1093/bioinformatics/btr076>
# BAQ is turned on when a reference file is supplied using the -f option. To disable it, use the -B option. 

# Filtering:

#/home/rjb/ivilla/software/vcftools_0.1.13/bin/vcftools --vcf chloroplast_arm_demenou.vcf --hardy #para obtener la observed heterozygosity per site
/home/rjb/ivilla/software/vcftools_0.1.13/bin/vcftools --vcf chloroplast_arm_hirta.vcf --remove-indels --recode --recode-INFO-all --min-alleles 2 --max-alleles 2  --minDP 5 --minGQ 10 --max-missing 0.7 --out chloroplast_arm_hirta_filtered


### Run in terminal of MAC:
# Impute missing data:
#jjava -Xmx1820m -jar /Volumes/Backup\ Plus/2018-Proyecto_Armeria-GNF/31.chloroplast2/paper_impute_plastic_data/beagle.r1399.jar gt=chloroplast_arm_hirta_filtered.recode.vcf out=chloroplast_arm_hirta_filtered.recode_impute

# Convert vcf to fasta
# Run bgzip (NOT gzip) to compress your joint VCF file
#bgzip file.vcf

# tabix to index it
#tabix vcf file.vcf.gz

### Run in cluster Trueno: environmental secapr_env (python3.6 and all dependences installed)

#python3 ./vcf2msa.py -r Assembly_denovo_chloro_156APT_cut_nodes.fasta -v chloroplast_arm_demenou_filtered.recode_impute.vcf.gz
