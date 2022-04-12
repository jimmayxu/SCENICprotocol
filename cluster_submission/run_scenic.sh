#!/bin/bash
#./cluster_submission/run_scenic.sh 'vas13capillary_0' 60 'vas13capillary_0.loom'
#./cluster_submission/run_scenic.sh 'vas13capillary1' 60 'vas13capillary.loom'
#./cluster_submission/run_scenic.sh 'PanFetalImmune_SUBTH' 60 'PAN.A01.v01.raw_count.20210429.PFI.embedding_SUBTH.loom' 'Vasculature/Mito_genes.csv'
#./cluster_submission/run_scenic.sh 'PanFetalImmune_YS' 60 'PAN.A01.v01.raw_count.20210429.PFI.embedding_YS.loom'
#./cluster_submission/run_scenic.sh 'PanFetalImmune_200' 60 'PAN.A01.v01.raw_count.20210429.PFI.embedding.loom' 'Pan_fetal_immune/marker_gene_HVG200.csv'

#./cluster_submission/run_scenic.sh 'PanFetalImmune|0-10' 60 'PAN.A01.v01.raw_count.20210429.PFI.embedding.loom' 'Pan_fetal_immune/marker_gene_HVG|0-10.csv'
set -x

runID="$1"
cores="$2"
loom_name="$3"
TG_path="$4"

f_loom_path_scenic="database/loom_file/$loom_name"
f_tfs='HCA_analysis/human-TF2021.txt'
f_TGs="HCA_analysis/$TG_path"

outdir="HCA_analysis/grnboost_$runID"
# pyscenic grn "${f_loom_path_scenic}" "${f_tfs}" -o "$outdir/adj.csv" --num_workers $((cores/2))
# arboreto_with_multiprocessing.py \
python arboreto_with_multiprocessing_tg.py \
	${f_loom_path_scenic} \
	${f_tfs} \
	--method grnboost2 \
	--output "${outdir}/adj.csv" \
	--num_workers $((cores)) \
	--seed 777 \
	--targets_fpath ${f_TGs}



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
