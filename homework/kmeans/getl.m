function [newcentroids,number] = getl(X,centroids,s,indices)
  K = size(centroids, 1);
  u = Inf(size(X,1), 1);
  m = size(X,1);
  l = zeros(size(X,1), K);
  number = 0;
  for i=1:m
      if (u(i) <= s(indices(i))) 
          continue
      end
      r = true;
      for j = 1:K
          z = max(l(i,j), pdist2(centroids(indices(i),:),centroids(j,:))/2);
          number = number + 1;
          if (j == indices(i) || u(i) <= z)
              continue
          end
          if (r)
              u(i) = pdist2(X(i,:),centroids(indices(i),:));
              number = number + 1;
              r = false;
              if u(i) <= z
                  continue
              end
          end
          l(i,j) = pdist2(X(i,:),centroids(j,:));
          number = number + 1;
          if l(i,j) < u(i)
              indices(i) = j;
          end
      end
  end

  newcentroids = zeros(K,size(X,2)); 
  g = zeros(K, 1);
  for i=1:K
    xi = X(indices==i,:);
    ck = size(xi,1);
    newcentroids(i, :) = (1/ck) * sum(xi);
    g(i) =  pdist2(newcentroids(i, :),centroids(i,:));
    number = number + 1;
  end
  for i=1:m
      u(i) = u(i) + g(indices(i));
      for j = 1:K
         l(i,j) = l(i,j)-g(j);
      end
  end
end