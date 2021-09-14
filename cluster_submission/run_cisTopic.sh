#!/bin/bash

set -x

outdir="$1"
cores="$2"

f_db_names=$(ls HCA_analysis/*.feather)
f_loom_path_scenic='pbmc10k_filtered_scenic_full.loom'
f_motif_path='HCA_analysis/motifs-v9-nr.hgnc-m0.001-o0.0.tbl'

pyscenic ctx \
	grnboost_fetal_lung/adj.csv \
	${f_db_names} \
	--annotations_fname "${f_motif_path}" \
	--expression_mtx_fname "${f_loom_path_scenic}" \
	--output "$outdir/reg.csv" \
	--mask_dropouts \
	--num_workers $((cores-5))
