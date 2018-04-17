function result = get_similarity4_2(uid,mid,k,trainItems,itemNum)
    
    trainsUid = trainItems{1};
    trainsMid = trainItems{2};
    trainsRate = trainItems{3};
    %have seen the mid 
    uids = find(trainsMid(:)==mid);
    
    s = size(uids);
    if (s <= k)  
        result = mean(trainsRate(uids));
    else 
        %all items with uid
        items = find(trainsUid(:) == uid);
        
        %calculate top k uid
        [num,v] = size(uids);
        rating = zeros(num,itemNum);
        rating(1,trainsMid(items)) = trainsRate(items);
        for n=2:num
            userId = uids(n);
            itemId = find(trainsUid(:) == userId);
            rating(n,trainsMid(itemId))= trainsRate(itemId);
        end
        all_pair_distance=pdist2(rating(1,:),rating(:,:),'minkowski');
        [~,I]=sort(all_pair_distance);
        result = mean(trainsRate(uids(I(1:k))));
    end
    
end

