#!/bin/bash

#######################################################################
#                  submit job for run_AUCell.sh                       #
#######################################################################

#./cluster_submission/submit_AUCell.sh "fetal_lung" "covid19cellatlas.Fetal_lung.loom"
#./cluster_submission/submit_AUCell.sh "fetal_liver" "covid19cellatlas.Fetal_liver.loom"



# ID of run instance (e.g. loop over to submit several jobs)
runID="$1"
LOOM="$2"
OUTDIR="HCA_analysis/AUCell_$runID"

mkdir -p "$OUTDIR/FarmOut"
rm -f \
	"$OUTDIR/FarmOut/stderr.log" \
	"$OUTDIR/FarmOut/stdout.log"

# submit job
echo "submitting job for $runID..."

MEM=100000
CORES=30
bsub \
	-q long \
	-J"AUCellJob$runID" \
	-e "$OUTDIR/FarmOut/stderr.log" \
	-o "$OUTDIR/FarmOut/stdout.log" \
	-n "$CORES" \
	-M"$MEM" \
	-R"select[mem>$MEM] rusage[mem=$MEM] span[hosts=1]" \
	"bash run_AUCell.sh $runID $CORES $LOOM 1>&2"

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
