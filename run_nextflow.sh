#!/bin/bash

# ID of run instance (e.g. loop over to submit several jobs)
runID="HCA_analysis/fetal_thymus"
INData="covid19cellatlas.Fetal_thymus"

INDIR='HCA_analysis/loom_file'
# prepare output folder
OUTDIR="${runID}"

python HCA_analysis/data_type_convert.py -H "${INData}.h5ad"


nextflow run aertslab/SCENICprotocol \
    -profile docker \
    --loom_input "$INDIR/${INData}.loom" \
    --loom_output "$OUTDIR/pyscenic_output.loom" \
    --TFs human-TF2021.txt \
    --motifs motifs-v9-nr.hgnc-m0.001-o0.0.tbl \
    --outdir OUTDIR \
    --db *.feather