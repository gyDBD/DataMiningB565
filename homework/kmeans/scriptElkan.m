A=readtable('covtype.dat');
T = A(:,:);
X = table2array(T);

K = 3;
centroids = initCentroids(X, K);
number = 0;
numberDistance = 0;
while (true) 
    number = number + 1;
    s = getBetweenCentroids(centroids);
    [indices,number2] = getClosestCentroids(X, centroids);
    numberDistance = numberDistance + number2;
    [newcentroids,number3] = getl(X,centroids,s,indices);
    numberDistance = numberDistance + number3;
    if (newcentroids == centroids) 
        break
    else 
        centroids = newcentroids;
    end
end

sumSSE = 0;
m = size(X,1);
for i = 1:m
    sumSSE = sumSSE + pdist2(centroids(indices(i),:),X(i,:));
end
number
numberDistance
sumSSE

centroids 