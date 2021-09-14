#!/bin/bash

set -x

outdir="$1"
cores="$2"

f_loom_path_scenic='pbmc10k_filtered_scenic_full.loom'

pyscenic aucell \
	"${f_loom_path_scenic}" \
	"cisTopic_fetal_lung/reg.csv" \
	--output "$outdir/pyscenic_output.loom" \
	--num_workers $((cores-5))
