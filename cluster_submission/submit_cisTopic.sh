#!/bin/bash

#######################################################################
#                  submit job for run_cisTopic.sh                    #
#######################################################################

#./cluster_submission/submit_cisTopicAUCell.sh "vas_13" "adult13_vas_20211026.loom"




# ID of run instance (e.g. loop over to submit several jobs)
runID="$1"
LOOM="$2"
OUTDIR="HCA_analysis/cisTopic_$runID"

# prepare output folder

mkdir -p "$OUTDIR/FarmOut"
rm -f \
	"$OUTDIR/FarmOut/stderr.log" \
	"$OUTDIR/FarmOut/stdout.log"

# submit job
echo "submitting job for $runID..."

MEM=200000
CORES=60
bsub \
	-q long \
	-J"cisTopicJob$runID" \
	-e "$OUTDIR/FarmOut/stderr.log" \
	-o "$OUTDIR/FarmOut/stdout.log" \
	-n "$CORES" \
	-M"$MEM" \
	-R"select[mem>$MEM] rusage[mem=$MEM] span[hosts=1]" \
	"bash ./cluster_submission/run_cisTopic.sh $runID $CORES $LOOM 1>&2"

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
