
function result=dm3(type,k)
r=zeros(1,10000);
data=normrnd(0,1,10000,k);
if type==1
distance=pdist(data);
elseif type==2
distance=pdist(data,'cosine'); 
elseif type==3
distance=pdist(data,@problemfour); 
elseif type==4
distance=pdist(data,@problemfive); 
end
        
Z = squareform(distance);

        for i=1:10000
            [b,j] = sort(Z(:,i));
            for p = j(2:6)
                r(j(p)) = r(j(p)) + 1;
            end
        end
        result = zeros(1,max(r));
        for q = 1:length(r)
            if(r(q)~=0)
               result(r(q)) = result(r(q)) + 1;
            end
        end

end   

