#!/bin/bash
#SBATCH -p generic #particion(cola)
#SBATCH -N 1 #numero de nodos
#SBATCH -n 8 #numero de cores(CPUs)
#SBATCH -e error_%A_%a.out
#SBATCH -o output_%A_%a.out

cd /home/rjb/ivilla/HybriSeq/19.bgc/2.genotyped_uncertainty_model

SCRATCHDIR=/scratch-global/ivilla/bgc
cp -p /home/rjb/ivilla/HybriSeq/19.bgc/2.genotyped_uncertainty_model/bgc_inputFiles/arm_bgc_p0in.txt $SCRATCHDIR
cp -p /home/rjb/ivilla/HybriSeq/19.bgc/2.genotyped_uncertainty_model/bgc_inputFiles/arm_bgc_p1in.txt $SCRATCHDIR
cp -p /home/rjb/ivilla/HybriSeq/19.bgc/2.genotyped_uncertainty_model/bgc_inputFiles/arm_bgc_admixedin.txt $SCRATCHDIR

#cp -p /home/rjb/ivilla/HybriSeq/19.bgc/2.genotyped_uncertainty_model/example_files/eatt_bgc_p0in.txt $SCRATCHDIR
#cp -p /home/rjb/ivilla/HybriSeq/19.bgc/2.genotyped_uncertainty_model/example_files/eatt_bgc_p1in.txt $SCRATCHDIR
#cp -p /home/rjb/ivilla/HybriSeq/19.bgc/2.genotyped_uncertainty_model/example_files/eatt_bgc_admixedin.txt $SCRATCHDIR

#cp -p /home/rjb/ivilla/HybriSeq/19.bgc/2.genotyped_uncertainty_model/example_bgc/Parental1.bgc_format.txt $SCRATCHDIR
#cp -p /home/rjb/ivilla/HybriSeq/19.bgc/2.genotyped_uncertainty_model/example_bgc/Parental2.bgc_format.txt $SCRATCHDIR
#cp -p /home/rjb/ivilla/HybriSeq/19.bgc/2.genotyped_uncertainty_model/example_bgc/admix.gen.bgc_format.txt $SCRATCHDIR

#cp -p /home/rjb/ivilla/bgcdist/bgc $SCRATCHDIR
#cp -p /home/rjb/ivilla/bgcdist/estpost $SCRATCHDIR


cd $SCRATCHDIR
#./bgc -a ptl0_in.txt -b ptl1_in.txt -h axd_in.txt -O 0 -x 50000 -n 30000 -p 1 -t 20 #parametros similares a Parchman etal 2013 (50 loci): The genomic consequences of adaptive divergence and reproductive isolation between species of manakins
#./bgc -a ptl0_in.txt -b ptl1_in.txt -h axd_in.txt -O 0 -x 1000000 -n 800000 -p 1 -t 50 #parametros tutorial CLineHelpR donde analizan 233 loci: despues del burnin, se queda con 200000samples, que reduce selecciona 1 cada 50 cadena. Tiempo consumido: 28 horas
#DOESN'T WORK!#./bgc -a arm_bgc_p0in.txt -b arm_bgc_p1in.txt -h arm_bgc_admixedin.txt -O 0 -x 10000000 -n 1000000 -p 1 -t 50 -q 1 -N 1 -E 0.003 # UNA MAGNITUD MÁS de iterations tutorial CLineHelpR donde analizan 233 loci: despues del burnin, se queda con 200000samples, que reduce selecciona 1 cada 50 cadena
#DOESN'T WORK!#./bgc -a arm_bgc_p0in.txt -b arm_bgc_p1in.txt -h arm_bgc_admixedin.txt -O 0 -x 1800000 -n 1000000 -t 50 -q 1 -N 1 -E 0.003 -p 1 #Parámetros tutorial. Posteriormente se hará un post burn-in de 200000 samples y un thin = 50 en R (ClineHelpR)
#DOESN'T WORK!!#./bgc -a arm_bgc_p0in.txt -b arm_bgc_p1in.txt -h arm_bgc_admixedin.txt -O 0 -x 1000000 -n 800000 -t 50 -q 1 -N 1 -E 0.003
#DOESN'T WORK!!#./bgc -a arm_bgc_p0in.txt -b arm_bgc_p1in.txt -h arm_bgc_admixedin.txt -O 0 -x 1000000 -n 800000 -q 1 -N 1 -E 0.003 
#DOESN'T WORK!!#./bgc -a arm_bgc_p0in.txt -b arm_bgc_p1in.txt -h arm_bgc_admixedin.txt -O 0 -x 100000 -n 80000 -t 50 -q 1 -N 1 -E 0.003
#./bgc -a arm_bgc_p0in.txt -b arm_bgc_p1in.txt -h arm_bgc_admixedin.txt -x 10000 -n 6000 -O 0 -N 1 -E 0.003 ###¡¡¡¡¡¡WORKS!!!!!!!
#./bgc -a arm_bgc_p0in.txt -b arm_bgc_p1in.txt -h arm_bgc_admixedin.txt -x 10000 -n 7000 -O 0 -N 1 -E 0.003 ###¡¡¡¡¡¡WORKS!!!!!!!
#DOESN'T WORK!!#./bgc -a arm_bgc_p0in.txt -b arm_bgc_p1in.txt -h arm_bgc_admixedin.txt -x 20000 -n 16000 -O 0 -N 1 -E 0.003
#DOESN'T WORK!!#./bgc -a arm_bgc_p0in.txt -b arm_bgc_p1in.txt -h arm_bgc_admixedin.txt -x 15000 -n 11000 -O 0 -N 1 -E 0.003
#./bgc -a arm_bgc_p0in.txt -b arm_bgc_p1in.txt -h arm_bgc_admixedin.txt -x 10000 -n 5000 -O 0 -N 1 -E 0.003
./bgc -a arm_bgc_p0in.txt -b arm_bgc_p1in.txt -h arm_bgc_admixedin.txt -O 0 -x 25000 -n 5000 -t 5 -p 1 -q 1 -N 1 -m 0 -d 1 -s 1 -I 1 -T 0 -E 0.003 # parameters frorm example_nature20



#run1 from the mcmcout.hdf5:

./estpost -i mcmcout.hdf5 -p LnL -o arm_bgc_stat_LnL_1 -s 2 -w 0
./estpost -i mcmcout.hdf5 -p alpha -o arm_bgc_stat_a0_1 -s 2 -w 0
./estpost -i mcmcout.hdf5 -p beta -o arm_bgc_stat_b0_1 -s 2 -w 0
./estpost -i mcmcout.hdf5 -p gamma-quantile -o arm_bgc_stat_qa_1 -s 0  -w 0
./estpost -i mcmcout.hdf5 -p zeta-quantile -o arm_bgc_stat_qb_1 -s 0  -w 0
./estpost -i mcmcout.hdf5 -p hi -o arm_bgc_stat_hi_1 -s 2  -w 0

#run2 from the same mcmcout.hdf5:

./estpost -i mcmcout.hdf5 -p LnL -o arm_bgc_stat_LnL_2 -s 2 -w 0
./estpost -i mcmcout.hdf5 -p alpha -o arm_bgc_stat_a0_2 -s 2 -w 0
./estpost -i mcmcout.hdf5 -p beta -o arm_bgc_stat_b0_2 -s 2 -w 0
./estpost -i mcmcout.hdf5 -p gamma-quantile -o arm_bgc_stat_qa_2 -s 0 -w 0
./estpost -i mcmcout.hdf5 -p zeta-quantile -o arm_bgc_stat_qb_2 -s 0 -w 0
./estpost -i mcmcout.hdf5 -p hi -o arm_bgc_stat_hi_2 -s 2  -w 0

#run3 from the same mcmcout.hdf5:

./estpost -i mcmcout.hdf5 -p LnL -o arm_bgc_stat_LnL_3 -s 2 -w 0
./estpost -i mcmcout.hdf5 -p alpha -o arm_bgc_stat_a0_3 -s 2 -w 0
./estpost -i mcmcout.hdf5 -p beta -o arm_bgc_stat_b0_3 -s 2 -w 0
./estpost -i mcmcout.hdf5 -p gamma-quantile -o arm_bgc_stat_qa_3 -s 0 -w 0
./estpost -i mcmcout.hdf5 -p zeta-quantile -o arm_bgc_stat_qb_3 -s 0 -w 0
./estpost -i mcmcout.hdf5 -p hi -o arm_bgc_stat_hi_3 -s 2  -w 0

#run4 from the same mcmcout.hdf5:

./estpost -i mcmcout.hdf5 -p LnL -o arm_bgc_stat_LnL_4 -s 2 -w 0
./estpost -i mcmcout.hdf5 -p alpha -o arm_bgc_stat_a0_4 -s 2 -w 0
./estpost -i mcmcout.hdf5 -p beta -o arm_bgc_stat_b0_4 -s 2 -w 0
./estpost -i mcmcout.hdf5 -p gamma-quantile -o arm_bgc_stat_qa_4 -s 0 -w 0
./estpost -i mcmcout.hdf5 -p zeta-quantile -o arm_bgc_stat_qb_4 -s 0 -w 0
./estpost -i mcmcout.hdf5 -p hi -o arm_bgc_stat_hi_4 -s 2  -w 0

#run5 from the same mcmcout.hdf5:

./estpost -i mcmcout.hdf5 -p LnL -o arm_bgc_stat_LnL_5 -s 2 -w 0
./estpost -i mcmcout.hdf5 -p alpha -o arm_bgc_stat_a0_5 -s 2 -w 0
./estpost -i mcmcout.hdf5 -p beta -o arm_bgc_stat_b0_5 -s 2 -w 0
./estpost -i mcmcout.hdf5 -p gamma-quantile -o arm_bgc_stat_qa_5 -s 0 -w 0
./estpost -i mcmcout.hdf5 -p zeta-quantile -o arm_bgc_stat_qb_5 -s 0 -w 0
./estpost -i mcmcout.hdf5 -p hi -o arm_bgc_stat_hi_5 -s 2  -w 0

mv mcmcout.hdf5 /home/rjb/ivilla/HybriSeq/19.bgc/2.genotyped_uncertainty_model/
mv arm_bgc_stat_* /home/rjb/ivilla/HybriSeq/19.bgc/2.genotyped_uncertainty_model/bgc_outputFiles


exit
