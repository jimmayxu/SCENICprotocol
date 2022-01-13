#!/bin/bash

#######################################################################
#                  submit job for run_scenic.sh                    #
#######################################################################


#./cluster_submission/submit_scenic.sh "Fetal_thymus" "covid19cellatlas.Fetal_thymus.loom"
#./cluster_submission/submit_scenic.sh "Fetal_thymus" "covid19cellatlas.Fetal_thymus.loom"
#./cluster_submission/submit_scenic.sh "Fetal_thymus" "covid19cellatlas.Fetal_thymus.loom"
#./cluster_submission/submit_scenic.sh "Fetal_thymus" "covid19cellatlas.Fetal_thymus.loom"
#./cluster_submission/submit_scenic.sh "Fetal_thymus" "covid19cellatlas.Fetal_thymus.loom"
#./cluster_submission/submit_scenic.sh "Fetal_thymus" "covid19cellatlas.Fetal_thymus.loom"


#./cluster_submission/submit_scenic.sh 'voigt19' 'voigt19.processed.loom'
#./cluster_submission/submit_scenic.sh 'menon19' 'menon19.processed.loom'
#./cluster_submission/submit_scenic.sh 'lukowski19' 'lukowski19.processed.loom'
#./cluster_submission/submit_scenic.sh 'vento18_10x' 'vento18_10x.processed.loom'
#./cluster_submission/submit_scenic.sh 'vento18_ss2' 'vento18_ss2.processed.loom'
#./cluster_submission/submit_scenic.sh 'wang20_colon' 'wang20_colon.processed.loom'
#./cluster_submission/submit_scenic.sh 'martin19' 'martin19.processed.loom'
#./cluster_submission/submit_scenic.sh 'wang20_ileum' 'wang20_ileum.processed.loom'
#./cluster_submission/submit_scenic.sh 'wang20_rectum' 'wang20_rectum.processed.loom'
#./cluster_submission/submit_scenic.sh 'madissoon20_spleen' 'madissoon20_spleen.processed.loom'

# ID of run instance (e.g. loop over to submit several jobs)
runID="$1"
LOOM="$2"
queue="parallel"

OUTDIR="HCA_analysis/scenic_$runID"
# prepare output folder
mkdir -p "$OUTDIR/FarmOut"
mkdir -p "HCA_analysis/grnboost_$runID/FarmOut"
mkdir -p "HCA_analysis/cisTopic_$runID/FarmOut"
mkdir -p "HCA_analysis/AUCell_$runID/FarmOut"
rm -f \
	"$OUTDIR/FarmOut/stderr.log" \
	"$OUTDIR/FarmOut/stdout.log"

# submit job
echo "submitting job for $runID..."

MEM=200000
CORES=60
bsub \
	-q "$queue" \
	-J"scenic_Job$runID" \
	-e "$OUTDIR/FarmOut/stderr.log" \
	-o "$OUTDIR/FarmOut/stdout.log" \
	-n "$CORES" \
	-M"$MEM" \
	-R"select[mem>$MEM] rusage[mem=$MEM] span[hosts=1]" \
	"bash ./cluster_submission/run_cisTopicAUCell.sh $runID $CORES $LOOM 1>&2"

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


