import torch
import torch_geometric 
import importlib
#import numpy as np
from pandas import DataFrame as df
import MyGCN;
importlib.reload(MyGCN)
from torch_geometric.datasets import KarateClub
#import matplotlib.pyplot as plt

torch.manual_seed(67) 
dataset = KarateClub()
data = dataset[0]
model = MyGCN.GCN(dataset, 3)
trainer = MyGCN.Trainer(model, data)
trainer.train(30)

model_a = MyGCN.GCN(dataset, 10)
trainer_a = MyGCN.Trainer(model, data)
trainer_a.train(30)

## output
res = df({
    'index':range(len(trainer.acc)),
    'small.acc':trainer.acc,
    'big.acc':trainer_a.acc
})
for ii in [res.head(5), res.tail(8)]:   print(ii)
## equivalently:
#[print(ii) for ii in [res.head(5), res.tail(8)] ]
#list(map(print, [res.head(5), res.tail(8)]))
