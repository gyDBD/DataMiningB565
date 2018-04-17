function genereMatrix=get_genre(rating,userNum)
movieItems = importdata('u.item','|',0);

movieGenre = movieItems.data;
genereMatrix =zeros(userNum,19);
rating(rating(:,:) < 5) = 0;
for i=1:userNum
     mid = find(rating(i,:)>0);
     b = movieGenre(mid,:);
     genereMatrix(i,:) = sum(b);
end

end 