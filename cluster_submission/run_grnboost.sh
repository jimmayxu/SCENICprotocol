#!/bin/bash

outdir="$1"
cores="$2"

set -x

# export DASK_DISTRIBUTED__SCHEDULER__ALLOWED_FAILURES=20
# export DASK_DISTRIBUTED__COMM__TIMEOUTS__CONNECT=5
# export DASK_DISTRIBUTED__COMM__RETRY__COUNT=10
# export DASK_DISTRIBUTED__COMM__TIMEOUTS__TCP=30
# export DASK_DISTRIBUTED__DEPLOY__LOST_WORKER=25

f_loom_path_scenic='pbmc10k_filtered_scenic_full.loom'
f_tfs='HCA_analysis/human-TF2021.txt'

# pyscenic grn "${f_loom_path_scenic}" "${f_tfs}" -o "$outdir/adj.csv" --num_workers $((cores/2))

arboreto_with_multiprocessing.py \
	${f_loom_path_scenic} \
	${f_tfs} \
	--method grnboost2 \
	--output "$outdir/adj.csv" \
	--num_workers $((cores)) \
	--seed 777
