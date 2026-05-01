import torch
import torch_geometric 
from torch.nn import Linear
from torch_geometric.nn import GCNConv

class GCN(torch.nn.Module):
    def __init__(self, dataset, n_embed):
        super().__init__()
        self.gcn = GCNConv(dataset.num_features, n_embed)
        self.out = Linear(n_embed, dataset.num_classes)

    def forward(self, x, edge_index):
        # hidden
        h = self.gcn(x, edge_index).relu()
        ## output
        z = self.out(h)
        return h, z

class Trainer():
    def __init__(self, mod, dat, crit=torch.nn.CrossEntropyLoss()):
        self.model = mod
        self.data = dat
        self.crit = crit
        self.optim=torch.optim.Adam(mod.parameters(), lr=0.02)
        ## most recent state
        self.hidden = []
        self.out = []
        ## training history
        self.pred = []
        self.acc = []

    def accuracy(self, pred, obs):
        return (pred == obs).sum() / len(obs)

    def step(my):
        # Clear gradients
        my.optim.zero_grad()
        hidden, out = my.model(my.data.x, my.data.edge_index)
        loss = my.crit(out, my.data.y)
        # Compute gradients
        loss.backward()
        # Tune parameters
        my.optim.step()

        # Calculate accuracy
        pred = out.argmax(dim=1)
        acc = my.accuracy(pred, my.data.y)
        ## record
        my.hidden = hidden
        my.out = out
        my.pred.append(pred)
        my.acc.append(acc)
    
    def train(self, nstep):
        for epoch in range(nstep):
            self.step()
