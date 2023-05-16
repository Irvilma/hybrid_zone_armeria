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
cp -p /home/rjb/ivilla/bgcdist/bgc $SCRATCHDIR
cp -p /home/rjb/ivilla/bgcdist/estpost $SCRATCHDIR

cd $SCRATCHDIR
./bgc -a arm_bgc_p0in.txt -b arm_bgc_p1in.txt -h arm_bgc_admixedin.txt -O 0 -x 25000 -n 5000 -t 5 -p 1 -q 1 -N 1 -m 0 -d 1 -s 1 -I 1 -T 0 -E 0.003

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
