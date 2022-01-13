#!/bin/bash

set -x

runID="$1"
cores="$2"
loom_name="$3"

outdir="HCA_analysis/grnboost_$runID"

f_loom_path_scenic="database/loom_file/$loom_name"
f_tfs='HCA_analysis/human-TF2021.txt'

# pyscenic grn "${f_loom_path_scenic}" "${f_tfs}" -o "$outdir/adj.csv" --num_workers $((cores/2))
arboreto_with_multiprocessing.py \
	${f_loom_path_scenic} \
	${f_tfs} \
	--method grnboost2 \
	--output "${outdir}/adj.csv" \
	--num_workers $((cores)) \
	--seed 777



f_db_names=$(ls HCA_analysis/*.feather)
f_motif_path='HCA_analysis/motifs-v9-nr.hgnc-m0.001-o0.0.tbl'


outdir="HCA_analysis/cisTopic_${runID}"
pyscenic ctx \
	"HCA_analysis/grnboost_${runID}/adj.csv" \
	${f_db_names} \
	--annotations_fname "${f_motif_path}" \
	--expression_mtx_fname "${f_loom_path_scenic}" \
	--output "${outdir}/reg.csv" \
	--mask_dropouts \
	--num_workers $((cores-5))



indir="HCA_analysis/cisTopic_${runID}"
OUTDIR="HCA_analysis/AUCell_${runID}"

mkdir -p "$OUTDIR"

pyscenic aucell \
	"${f_loom_path_scenic}" \
	"$indir/reg.csv" \
	--output "$OUTDIR/pyscenic_output.loom" \
	--num_workers $((cores-5))
