import pandas as pd
import scanpy as sc
import os
import numpy as np
import argparse

"""
python HCA_analysis/data_type_convert.py -H 'covid19cellatlas.vas_GHM.h5ad'
python HCA_analysis/data_type_convert.py -H 'covid19cellatlas.Fetal_liver.h5ad'
python HCA_analysis/data_type_convert.py -H 'vieira19_Nasal_anonymised.processed.h5ad'
python HCA_analysis/data_type_convert.py -H 'vieira19_Bronchi_anonymised.processed.h5ad'
python HCA_analysis/data_type_convert.py -H 'vieira19_Alveoli_and_parenchyma_anonymised.processed.h5ad'

python HCA_analysis/data_type_convert.py -H 'Single_cell_gene_expression_profiling_of_SARS_CoV_2_infected_human_cell_lines_Calu_3-28.h5ad'
python HCA_analysis/data_type_convert.py -H 'lukassen20_lung_orig.processed.h5ad'
python HCA_analysis/data_type_convert.py -H 'lukassen20_airway_orig.processed.h5ad'
python HCA_analysis/data_type_convert.py -H 'deprez19_restricted.processed.h5ad'
python HCA_analysis/data_type_convert.py -H 'Single_cell_gene_expression_profiling_of_SARS_CoV_2_infected_human_cell_lines_H1299-27.h5ad'

python HCA_analysis/data_type_convert.py -H 'adult13_vas_20211026.h5ad'
"""


def init_arg():
    parser = argparse.ArgumentParser()
    parser.add_argument('-IP', '--in_path', type=str, default='../Benchmark_GRN/data/HCA_dataset')
    parser.add_argument('-OP', '--out_path', type=str, default='database')
    parser.add_argument('-H', '--h5ad', type=str, default='covid19cellatlas.Fetal_thymus.h5ad')
    return parser.parse_args()


if __name__ == '__main__':
    args = init_arg()
    in_path = args.in_path
    out_path = args.out_path
    h5ad = args.h5ad

    output_folder = os.path.join(out_path, 'loom_file')
    print('---Data type conversion from adata to loom---')


    loom_name = '.'.join(h5ad.split('.')[:-1]) + '.loom'


    if os.path.isfile(os.path.join(output_folder, loom_name)):
        print('loom file have been stored in %s' % output_folder)
    else:
        print('Start converting')
        adataset = sc.read_h5ad(os.path.join(in_path, h5ad))

        # adataset = adataset[:100, :100]

        adataset.obs.index.name = 'CellID'
        adataset.var.index.name = 'Gene'
        adataset.write_loom(os.path.join(output_folder, loom_name))

        print('loom file is stored in %s' % output_folder)
        """
        aa = np.loadtxt(os.path.join('HCA_analysis/human-TF2021.txt'), dtype=str)
        set(adataset.var.index).intersection(set(aa))
        # d = pd.DataFrame(adataset.X, index=adataset.obs.index, columns=adataset.var.index)
    
        bb = sc.read_loom(os.path.join(output_folder, loom_name))
    
        aa = sc.read_loom('example/expr_mat.loom')
    
        aa.var
    
        """