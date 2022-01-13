#!/bin/bash

#######################################################################
#                  submit job for run_grnboost.sh                     #
#######################################################################

#!./cluster_submission/submit_grnboost.sh "vas_GHM" "covid19cellatlas.vas_GHM.loom"
#!./cluster_submission/submit_grnboost.sh "Fetal_lung" "covid19cellatlas.Fetal_lung.loom"
#!./cluster_submission/submit_grnboost.sh "Fetal_liver" "covid19cellatlas.Fetal_liver.loom"
#./cluster_submission/submit_grnboost.sh "Fetal_thymus" "covid19cellatlas.Fetal_thymus.loom"

#!./cluster_submission/submit_grnboost.sh "vas_13" "adult13_vas_20211026.loom"

#!./cluster_submission/submit_grnboost.sh "vieira19_Nasal" "vieira19_Nasal_anonymised.processed.loom"
#!./cluster_submission/submit_grnboost.sh "vieira19_Bronchi" "vieira19_Bronchi_anonymised.processed.loom"
#!./cluster_submission/submit_grnboost.sh "vieira19_Alveoli" "vieira19_Alveoli_and_parenchyma_anonymised.processed.loom"


#!./cluster_submission/submit_grnboost.sh "Calu_3-28" "Single_cell_gene_expression_profiling_of_SARS_CoV_2_infected_human_cell_lines_Calu_3-28.loom"
#!./cluster_submission/submit_grnboost.sh "lukassen20_lung_orig" "lukassen20_lung_orig.processed.loom"
#!./cluster_submission/submit_grnboost.sh "lukassen20_airway_orig" "lukassen20_airway_orig.processed.loom"
#!./cluster_submission/submit_grnboost.sh "deprez19_restricted" "deprez19_restricted.processed.loom"
#!./cluster_submission/submit_grnboost.sh "H1299-27" "Single_cell_gene_expression_profiling_of_SARS_CoV_2_infected_human_cell_lines_H1299-27.loom"

#!./cluster_submission/submit_grnboost.sh "madissoon19_lung" "madissoon19_lung.loom"
#!./cluster_submission/submit_grnboost.sh "baron16" "baron16.processed.loom"
#!./cluster_submission/submit_grnboost.sh "cheng18" "cheng18.processed.loom"
#!./cluster_submission/submit_grnboost.sh "guo18_donor" "guo18_donor.processed.loom"
#!./cluster_submission/submit_grnboost.sh "habib17" "habib17.processed.loom"
#!./cluster_submission/submit_grnboost.sh "aldinger20" "aldinger20.processed.loom"
#!./cluster_submission/submit_grnboost.sh "henry18_0" "henry18_0.processed.loom"
#!./cluster_submission/submit_grnboost.sh "james20" "james20.processed.loom"
#!./cluster_submission/submit_grnboost.sh "lako_cornea" "lako_cornea.processed.loom"
#!./cluster_submission/submit_grnboost.sh "litvinukova20_restricted" "litvinukova20_restricted.processed.loom"
#!./cluster_submission/submit_grnboost.sh "macparland18" "macparland18.processed.loom"
#!./cluster_submission/submit_grnboost.sh "vallier_restricted" "vallier_restricted.processed.loom"
#!./cluster_submission/submit_grnboost.sh "byrd20_gingiva" "byrd20_gingiva.processed.loom"
#!./cluster_submission/submit_grnboost.sh "warner20_salivary_gland" "warner20_salivary_gland.processed.loom"
#!./cluster_submission/submit_grnboost.sh "byrd_warner_integrated" "byrd_warner_integrated.processed.loom"
#!./cluster_submission/submit_grnboost.sh "smillie19_epi" "smillie19_epi.processed.loom"
#!./cluster_submission/submit_grnboost.sh "stewart19_adult" "stewart19_adult.processed.loom"

# ID of run instance (e.g. loop over to submit several jobs)

# prepare output folder

runID="$1"
LOOM="$2"
OUTDIR="HCA_analysis/grnboost_$runID"

mkdir -p "$OUTDIR/FarmOut"
rm -f \
	"$OUTDIR/FarmOut/stderr.log" \
	"$OUTDIR/FarmOut/stdout.log"

# submit job
echo "submitting job for $runID..."

MEM=200000
CORES=60
bsub \
	-q parallel \
	-J "grnboostJob$runID" \
	-e "$OUTDIR/FarmOut/stderr.log" \
	-o "$OUTDIR/FarmOut/stdout.log" \
	-n "$CORES" \
	-M"$MEM" \
	-R"select[mem>$MEM] rusage[mem=$MEM] span[hosts=1]" \
	"bash ./cluster_submission/run_grnboost.sh $runID $CORES $LOOM" 1>&2

# watch
echo "PEND ...waiting for job to start"
while [ -n "$(bjobs -w | grep $runID | grep PEND)" ]
do
	sleep 10s
done
if [ -n "$(bjobs -w | grep $runID | grep RUN)" ]
then
	echo "RUN ...showing stderr:"
	tail -f "$OUTDIR/FarmOut/stderr.log"
else
	echo "terminated ...showing stdout:"
	tail -f "$OUTDIR/FarmOut/stdout.log"
fi
