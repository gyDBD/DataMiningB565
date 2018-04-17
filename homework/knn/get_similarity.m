function result = get_similarity(uid,mid,k,rating,I )
    %we have our initial rating matirx 
    midUsersId = find(rating(:,mid)>0);
    midSort = ismember(I, midUsersId);
    midI = find(midSort(:)>0);
    [s,v] = size(midI);
    if (s <= k) 
       % disp(s);
        result = mean(rating(midUsersId,mid));
    else 
        
        %disp(rating(midUsers(I(1:k),1),mid));
        result = mean(rating(I(midI(1:k)),mid));
        
    end
    
end

