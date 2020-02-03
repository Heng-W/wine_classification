# wine_classification
#### Machine learning: wine classification and origin prediction based on UCI wine data set. 
#### 机器学习：基于UCI葡萄酒数据集进行葡萄酒分类及产地预测 


共包含178组样本数据，来源于三个葡萄酒产地，每组数据包含产地标签及13种化学元素含量，即已知类别标签。
把样本集随机分为训练集和测试集，根据已有数据集训练一个能进行葡萄酒产地预测的模型，以正确区分三个产地所产出的葡萄酒，
分别采用PCA+Kmeans、PCA+LVQ、BP神经网络等方法进行模型的训练与测试，准确率都能达到95%左右。
