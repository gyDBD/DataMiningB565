function distance=problemfour(a,b)
[n,temp]=size(b);

distance=zeros(n,1);
for i=1:n
    difference=a-b(i,:);
    positive=difference(difference>0);
    negative=difference(difference<0);
    
    distance(i)=sqrt(sum(positive)^2+sum(negative)^2);
    

end

end