import csv

def loadCSV(filename):
    dataSet=[]
    with open(filename,'r') as file:
        csvReader=csv.reader(file)
        for line in csvReader:
            dataSet.append(line)
    return dataSet


#create all 1-itemset candidate by scaning data
def create_C1(data):
    C1 = set()
    for d in data:
        for item in d:
            item_set = frozenset([item])
            C1.add(item_set)

    print("bruce force number:" + str(len(C1)))
    return C1

#generate k candidates itemsets from k-1 frequent items
#Fk-1 * Fk-1, the first k-2 must be the same
def apriori_create_Ck1(Fk_1, k):
    Ck = set()
    len_Fk_1 = len(Fk_1)
    list_Fk_1 = list(Fk_1)
    for i in range(len_Fk_1):
        for j in range(1, len_Fk_1):
            l1 = list(list_Fk_1[i])
            l2 = list(list_Fk_1[j])
            l1.sort()
            l2.sort()
            if l1[0:k-2] == l2[0:k-2]:
                Ck_item = list_Fk_1[i] | list_Fk_1[j]
                #check whether satisfy the apriori rule or not
                satisfy = True
                for item in Ck_item:
                    sub_Ck = Ck_item - frozenset([item])
                    if sub_Ck not in Fk_1:
                        satisfy = False
                if satisfy :
                    Ck.add(Ck_item)
    return Ck


#generate k candidates itemsets from k-1 frequent items
#Fk-1 * F1
def apriori_create_Ck2(Fk_1, F1):
    Ck = set()
    len_Fk_1 = len(Fk_1)
    list_Fk_1 = list(Fk_1)
    len_F1 = len(F1)
    list_F1 = list(F1)

    for i in range(len_Fk_1):
        for j in range(len_F1):
            l1 = list(list_Fk_1[i])
            l2 = list(list_F1[j])
            Ck_item = list_Fk_1[i] | list_Fk_1[j]
             #check whether satisfy the apriori rule or not
            satisfy = True
            for item in Ck_item:
                sub_Ck = Ck_item - frozenset([item])
                if sub_Ck not in Fk_1:
                    satisfy = False
            if satisfy :
                Ck.add(Ck_item)
    return Ck

#generate Fk from Ck by deleting not satisfy the min_support
def create_Fk(data, Ck, min_support, support_data ):
    Fk = set()
    item_count= {}
    for d in data:
        for item in Ck:
            if item.issubset(d):
                if item not in item_count:
                    item_count[item] = 1
                else:
                    item_count[item] += 1

    for item in item_count:
        if item_count[item]/float(len(data)) >= min_support:
            Fk.add(item)
            support_data[item] = item_count[item]/float(len(data))
    return Fk

#generate k frequent itemsets
def create_F(data, k, min_support,method):
    support_data = {}
    C1 = create_C1(data)
    F1 = create_Fk(data, C1, min_support,support_data)
    Fk_1 = F1.copy()
    F = []
    F.append(Fk_1)
    for i in range(2, k+1):
        if method == 1:
            Ci = apriori_create_Ck1(Fk_1, i)
        else:
            Ci = apriori_create_Ck2(Fk_1, F1)
        Fi = create_Fk(data, Ci, min_support,support_data)
        Fk_1 = Fi.copy()
        F.append(Fk_1)
    return F,support_data

def creat_association_rule(F, support_data, min_confidence ):
    rule_list = []
    sub_set_list = []
    for i in range(0, len(F)):
        for freq_set in F[i]:
            for sub_set in sub_set_list:
                if sub_set.issubset(freq_set):
                    conf = support_data[freq_set] / support_data[freq_set - sub_set]
                    lift = conf/support_data[sub_set]
                    rule = (freq_set - sub_set, sub_set, conf)
                    if conf >= min_confidence and rule not in rule_list:
                        rule_list.append(rule)
            sub_set_list.append(freq_set)
    return rule_list
if __name__ == "__main__":
    """
    Test
    """
    data_set = loadCSV("car.csv")
    result = set()
    C1 = create_C1(data_set)
    F, support_data = create_F(data_set, k =3, min_support=0.1,method = 2)
    for Fk in F:
        print("frequent " + str(len(list(Fk)[0])) + "-itemsets\t\tsupport")
        print(" the numbers of candidate itemsets: "+str(len(Fk)))
        for freq_set in Fk:
            print(freq_set, support_data[freq_set])


    rule = creat_association_rule(F, support_data, min_confidence= 0.6)
    print(" the numbers of rules: "+str(len(rule)))
    for item in rule:
        print(item[0], "=>", item[1], "conf: ", item[2])
