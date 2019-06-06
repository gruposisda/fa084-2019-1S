from sklearn import cluster
from sklearn import datasets
import matplotlib.pyplot as plt
from itertools import cycle
import pandas as pd

class Blobs:
    def __init__(self,id,n_centers,std,random_state=None):
        self.n_centers = n_centers
        self.random_state = random_state
        self.id = id
        self.std = std
        self.blobs = datasets.make_blobs(n_samples=1000, centers=n_centers,
                                cluster_std=self.std, center_box=(-20,20),
                                random_state=random_state)
        self.data = self.blobs[0]
        self.df = pd.DataFrame({'X':self.data[:,0],'Y':self.data[:,1]})
        self.labels = pd.DataFrame({'label':self.blobs[1]})

    def plot_self(self):
        plt.scatter(self.data[:,0],self.data[:,1],c= self.blobs[1])

    def write(self,filepath):
        #print(filepath+self.id+'_data.csv')
        self.df.to_csv(filepath+self.id+'_data.csv',index=False)
        self.labels.to_csv(filepath+self.id+'_labels.csv',index=False)

Blobs(id = 'first',n_centers=5,std=2,random_state=10).plot_self()
Blobs(id = 'first',n_centers=5,std=2,random_state=10).write('./data/')
Blobs(id = 'second',n_centers=5,std=5,random_state=10).write('./data/')
Blobs(id = 'third',n_centers=5,std=7,random_state=10).write('./data/')


Blobs(id = 'second',n_centers=5,std=7,random_state=10).plot_self()
