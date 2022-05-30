# Operation Manual of The Tri-MVC-UM

The proposed method Tri-MVC-UM considers that the clustering results on the feature dimension are often closely related to the clustering results on the data dimension. The clustering results on the feature dimension can be used to promote the clustering representation on the data dimension. The original data matrix can be decomposed into the coefficient matrix representing the feature dimension and the coefficient matrix representing the data dimension. Therefore, the proposed method redefines a new formula to guide the representation learning of each view.



In the whole experiment, the `WINE` data set was used as a representation for analysis. The `X_WINE.mat` is the raw dataset of features, the `Y_WINE.mat` is the raw dataset of labels, and `M_WINE.mat` is the real mapping relationships between cross-view samples.

In the parameter setting part of the `WINE` dataset, we suggest that alpha=`0.1`, beta=`1e-5`. And for other datasets, the range of parameters is determined by searching. See the original paper for specific steps.

The Tri-MVC-UM will generate a file at the end. The contents in the file are the following table information:

| MACC@1   | MACC@3   | MACC@10  | NMI (1)  | ACC(1)   | F-score (1) | NMI(2)   | ACC(2)   | F-score (2) | alpha    | beta     |
| -------- | -------- | -------- | -------- | -------- | ----------- | -------- | -------- | ----------- | -------- | -------- |
| 1.000000 | 1.000000 | 1.000000 | 0.684546 | 0.893258 | 0.798786    | 0.628077 | 0.870787 | 0.762040    | 0.100000 | 0.000010 |







