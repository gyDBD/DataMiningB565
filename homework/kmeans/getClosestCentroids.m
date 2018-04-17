function [indices,number] = getClosestCentroids(X, centroids)
  K = size(centroids, 1);
  indices = zeros(size(X,1), 1);
  m = size(X,1);

  number = 0;
  for i=1:m
    k = 1;
    min_dist = pdist2(X(i,:),centroids(1,:));
    number = number +1;
    for j=2:K
        dist = pdist2(X(i,:),centroids(j,:));
        number = number +1;
        if(dist < min_dist)
          min_dist = dist;
          k = j;
        end
    end
    indices(i) = k;
  end
end