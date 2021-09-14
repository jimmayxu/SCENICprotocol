import pandas as pd
import scanpy as sc
import os
import numpy as np
import argparse

def init_arg():
    parser = argparse.ArgumentParser()
    parser.add_argument('-DF', '--data_path', type=str, default='database')
    parser.add_argument('-I', '--input_folder', type=str, default='HCA_analysis/loom_file')
    parser.add_argument('-H', '--h5ad', type=str, default='covid19cellatlas.Fetal_thymus.h5ad')
    return parser.parse_args()


if __name__ == '__main__':
    args = init_arg()
    data_path = args.data_path
    input_folder = args.input_folder
    h5ad = args.h5ad

    print('---Data type conversion from adata to loom---')


    loom_name = '.'.join(h5ad.split('.')[:-1]) + '.loom'


    if os.path.isfile(os.path.join(input_folder, loom_name)):
        print('loom file have been stored in %s' % input_folder)
    else:
        print('Start converting')
        adataset = sc.read_h5ad(os.path.join(data_path, h5ad))

        # adataset = adataset[:100, :100]

        adataset.obs.index.name = 'CellID'
        adataset.var.index.name = 'Gene'
        adataset.write_loom(os.path.join(input_folder, loom_name))

        print('loom file is stored in %s' % input_folder)
        """
        aa = np.loadtxt(os.path.join('HCA_analysis/human-TF2021.txt'), dtype=str)
        set(adataset.var.index).intersection(set(aa))
        # d = pd.DataFrame(adataset.X, index=adataset.obs.index, columns=adataset.var.index)
    
        bb = sc.read_loom(os.path.join(input_folder, loom_name))
    
        aa = sc.read_loom('example/expr_mat.loom')
    
        aa.var
    
        """