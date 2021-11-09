#!/bin/bash

# ID of run instance (e.g. loop over to submit several jobs)
# ./run_nextflow.sh 'Fetal_thymus' 'HCA_analysis'
# ./run_nextflow.sh 'Fetal_lung' 'HCA_analysis'

DATA_NAME=${1:-data}
BASE_FOLDER=${2:-base_folder}

echo "$DATA_NAME"
echo "$BASE_FOLDER"


INData="covid19cellatlas.${DATA_NAME}"
INDIR="database/loom_file"

# prepare output folder
OUTDIR="${BASE_FOLDER}/${DATA_NAME}"

CPUS=24


python HCA_analysis/data_type_convert.py -DF "database" -H "${INData}.h5ad"


nextflow run aertslab/SCENICprotocol \
    -profile docker \
    --loom_input "$INDIR/${INData}.loom" \
    --loom_output "${OUTDIR}/pyscenic_output.loom" \
    --TFs "${BASE_FOLDER}/human-TF2021.txt" \
    --motifs "${BASE_FOLDER}/motifs-v9-nr.hgnc-m0.001-o0.0.tbl" \
    --outdir "${OUTDIR}" \
    --db "${BASE_FOLDER}/*.feather" \
    --cpus $((CPUS-2)) \
    --num_workers 22 \
	  --seed 777