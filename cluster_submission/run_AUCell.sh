#!/bin/bash

set -x

runID="$1"
cores="$2"
loom_name="$3"
outdir="HCA_analysis/cisTopic_${runID}"

f_loom_path_scenic="database/loom_file/$loom_name"

pyscenic aucell \
	"${f_loom_path_scenic}" \
	"$outdir/reg.csv" \
	--output "$outdir/pyscenic_output.loom" \
	--num_workers $((cores-5))
