#!/bin/bash
# ./cluster_submission/run_AUCell.sh "Fetal_lung" 30 "covid19cellatlas.Fetal_lung.loom"
# ./cluster_submission/run_AUCell.sh "vas_13" 30 "adult13_vas_20211026.loom"

set -x

runID="$1"
cores="$2"
loom_name="$3"
indir="HCA_analysis/cisTopic_${runID}"
OUTDIR="HCA_analysis/AUCell_${runID}"
f_loom_path_scenic="database/loom_file/$loom_name"

mkdir -p "$OUTDIR"


pyscenic aucell \
	"${f_loom_path_scenic}" \
	"$indir/reg.csv" \
	--output "$OUTDIR/pyscenic_output.loom" \
	--num_workers $((cores-5))
