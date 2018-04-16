#Calculate the Entropy for a split dataset
from math import log2
def gini_index(groups,classes):
    #count all samples at splot point
    n_samples=0
    for group in groups:
        n_samples=n_samples+float(len(group))
    #sum weighted Gini index for each group
    gain =0.0
    for group in groups:
        size=float(len(group))
        if size==0:
            continue
        score=0.0
        for class_val in classes:
            proption=0.0;
            for row in group:
                #row[-1]is the calss column, we need to count how many rows is in this class
                if row[-1]==class_val:
                    proption+=1;
            #then we get the propotion of this class
            p=proption/size
            score+=p*log2(p)
        #weight the group score
        gain += -score*(size/n_samples)
    return gain


