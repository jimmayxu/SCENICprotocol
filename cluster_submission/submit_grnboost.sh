#!/bin/bash

#######################################################################
#                  submit job for run_grnboost.sh                     #
#######################################################################

#!./cluster_submission/submit_grnboost.sh "vas_GHM" "covid19cellatlas.vas_GHM.loom"
#!./cluster_submission/submit_grnboost.sh "fetal_lung" "covid19cellatlas.Fetal_lung.loom"
#!./cluster_submission/submit_grnboost.sh "fetal_liver" "covid19cellatlas.Fetal_liver.loom"
#./cluster_submission/submit_grnboost.sh "fetal_thymus" "covid19cellatlas.Fetal_thymus.loom"

#!./cluster_submission/submit_grnboost.sh "vieira19_Nasal" "vieira19_Nasal_anonymised.processed.loom"
#!./cluster_submission/submit_grnboost.sh "vieira19_Bronchi" "vieira19_Bronchi_anonymised.processed.loom"
#!./cluster_submission/submit_grnboost.sh "vieira19_Alveoli" "vieira19_Alveoli_and_parenchyma_anonymised.processed.loom"

#!./cluster_submission/submit_grnboost.sh "vas_13" "covid19cellatlas.vas_GHM.loom"

#./cluster_submission/submit_grnboost.sh "Calu_3-28" "Single_cell_gene_expression_profiling_of_SARS_CoV_2_infected_human_cell_lines_Calu_3-28.loom"
#./cluster_submission/submit_grnboost.sh "lukassen20_lung_orig" "lukassen20_lung_orig.processed.loom"
#./cluster_submission/submit_grnboost.sh "lukassen20_airway_orig" "lukassen20_airway_orig.processed.loom"
#./cluster_submission/submit_grnboost.sh "deprez19_restricted" "deprez19_restricted.processed.loom"
#./cluster_submission/submit_grnboost.sh "H1299-27" "Single_cell_gene_expression_profiling_of_SARS_CoV_2_infected_human_cell_lines_H1299-27.loom"


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
