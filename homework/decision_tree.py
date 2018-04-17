# CART on the Bank Note dataset
from random import seed
from random import randrange
from csv import reader
from math import log2
import sys, getopt
import xlrd

#Load a xlsx file
def loadXLSX(filename):
    file=xlrd.open_workbook(filename)
    table=file.sheet_by_index(0)
    nrows=table.nrows
    dataset=list(table.get_rows())
    return dataset

def floatXLSX(dataset, column):
    for row in dataset:
        row[column] = float(row[column].value)

# Split a dataset into n folds
def splitToNFolds(dataset, n):
    result=list()
    fold_size = int(len(dataset) / n)
    data=list(dataset)
    for i in range(n):
        newData = list()
        while len(newData) < fold_size:
            index = randrange(len(data))
            newData.append(data.pop(index))
        result.append(newData)
    return result


def gain_index(groups,classes):
    #count all samples at splot point
    n_samples=0
    for group in groups:
        n_samples=n_samples+float(len(group))
    #sum weighted gain index for each group
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
            if p == 0:
                continue
            score+=p*log2(p)
        #weight the group score
        gain += -score*(size/n_samples)
    return gain


def gini_index(groups,classes):
    #count all samples at splot point
    n_samples=0
    for group in groups:
        n_samples=n_samples+float(len(group))
    #sum weighted Gini index for each group
    gini =0.0
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
            score+=p*p
        #weight the group score
        gini += (1.0-score)*(size/n_samples)
    return gini

#Split a database based on an attribute and an attribute value
def test_split(index,value,dataset):
    left,right=list(),list()
    for row in dataset:
        if row[index]<value:
            left.append(row)
        else:
            right.append(row)
    return left,right

#Select the best split point fot a dataset
def get_split(dataset,type):
    class_values=list(set(row[-1] for row in dataset))
    best_attribute, best_value, best_score, best_groups=1024,1024,1024,None
    for index in range(len(dataset[0])-1):
        for row in dataset:
            groups=test_split(index,row[index],dataset)
            if type=='gini':
                gini=gini_index(groups,class_values)
            else:
                gini = gain_index(groups, class_values)
            if gini<best_score:
                best_attribute=index
                best_value=row[index]
                best_score=gini
                best_groups=groups
    return {'index':best_attribute,'value':best_value, 'groups':best_groups}


def to_terminal(group):
    classes = [row[-1] for row in group]
    return max(set(classes), key=classes.count)


#recursively to split all node to terminal node
def split(node,dataset,type):
    left,right=node['groups']
    del (node['groups'])
    classesLeft =[row[-1] for row in left]
    classesRight =[row[-1] for row in right]

    #no left or right
    if not left or not right:
        node['left']=node['right']=to_terminal(left+right)
        return


    if max(set(classesLeft), key=classesLeft.count)==len(left):
        node['left'] = to_terminal(left)
    else:
        node['left'] = get_split(left,type)
        split(node['left'],dataset,type)


    if max(set(classesRight), key=classesRight.count)==len(right):
        node['right'] = to_terminal(right)
    else:
        node['right'] = get_split(right,type)
        split(node['right'], dataset,type)



#Build a decision tree
def build_tree(train,type):
    root=get_split(train,type)
    split(root,train,type)
    return root



def predict(node, row):
    if row[node['index']] < node['value']:
        if isinstance(node['left'], dict):
            return predict(node['left'], row)
        else:
            return node['left']
    else:
        if isinstance(node['right'], dict):
            return predict(node['right'], row)
        else:
            return node['right']


def decision_tree(train, test,type):
	tree = build_tree(train,type)
	predictions = list()
	for row in test:
		prediction = predict(tree, row)
		predictions.append(prediction)
	return(predictions)


def accuracyPercentage(actual, predicted):
    correct = 0
    for i in range(len(actual)):
        if actual[i] == predicted[i]:
            correct += 1
    return correct / float(len(actual)) * 100.0


def evaluateAlgorithm(dataset, algorithm, n,type):
    folds = splitToNFolds(dataset, n)
    scores = list()
    for fold in folds:
        train_set = list(folds)
        train_set.remove(fold)
        train_set = sum(train_set, [])
        test_set = list()
        for row in fold:
            row_copy = list(row)
            test_set.append(row_copy)
            row_copy[-1] = None
        predicted = algorithm(train_set, test_set,type)
        actual = [row[-1] for row in fold]
        accuracy = accuracyPercentage(actual, predicted)
        scores.append(accuracy)
    return scores


def main(argv):
   inputfile = ''
   type= ''
   try:
      opts, args = getopt.getopt(argv,"hm:i:",["gini=","ifile="])
   except getopt.GetoptError:
      print('DT.py -m <gini-i <inputfile>')
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print('DT.py -m <gini> -i <inputfile>')
         sys.exit()
      elif opt in ("-m", "--gini"):
         type = arg
      elif opt in ("-i", "--ifile"):
         inputfile = arg

   seed(1)
   dataset = loadXLSX(inputfile)
   for i in range(len(dataset[0])):
       floatXLSX(dataset, i)
   n = 5
   scores = evaluateAlgorithm(dataset, decision_tree, n, type)
   print('Scores: %s' % scores)
   print('Mean: %.3f%%' % (sum(scores) / float(len(scores))))


if __name__ == "__main__":
   main(sys.argv[1:])

