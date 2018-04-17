function s = getBetweenCentroids(centroids)
  K = size(centroids, 1);
  s = zeros(size(centroids,1), 1);

  for i=1:K
    min_dist = +inf;
    for j=1:K
        if ( i ~= j)
            dist = pdist2(centroids(i,:),centroids(1,:))/2;
            if(dist < min_dist)
              min_dist = dist;
            end
        end
    end
    s(i) = min_dist;
  end
end