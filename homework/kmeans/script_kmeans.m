A=readtable('covtype.dat');
T = A(:,:);
X = table2array(T);
K = 3;
max_iterations = 10;
centroids = init_centroids(X, K);

numberIteration = 0;
numberDistance = 0;
while (true) 
    numberIteration = numberIteration + 1;
    [indices,number2] = get_closest_centroids(X, centroids);
    numberDistance = numberDistance + number2;
    newcentroids = compute_centroids(X, indices, K);
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
numberIteration
numberDistance
sumSSE

centroids 
