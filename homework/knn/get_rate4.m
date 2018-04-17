function r=get_rate4(type, k)
movie = fopen('/l/b565/ml-10M100K/movies.dat');
movieItems = textscan(movie, '%f %s %s','Delimiter', {'::'});
movieIds = unique(movieItems{1});

base = fopen('/l/b565/ml-10M100K/r1.train');
trainItems = textscan(base, '%f %f %f','Delimiter', {'::'});
userIds = unique(trainItems{1});
[itemNum,v]=size(movieIds);
[userNum,v]=size(userIds);

%user item matrix
rating =zeros(userNum,itemNum);
%trainsUid = trainItems{1};
%trainsMid = trainItems{2};
%transRate = trainItems{3};
[trainingNum,v] = size(trainItems{2});
%add value to result
for n=1:trainingNum
	userId = trainItems{1}(n);
	itemId = trainItems{2}(n);
	rate = trainItems{3}(n);
	rating(userId,itemId) = rate;
end
oldrating = rating;
for i=1:userNum
    disp(i);
        if type == 1
            all_pair_distance=pdist2(oldrating(i,:),oldrating(:,:));
        elseif type == 2
            all_pair_distance=pdist2(oldrating(i,:),oldrating(:,:),'cosine');
           
        elseif type == 3
            all_pair_distance=pdist2(oldrating(i,:),oldrating(:,:),'cityblock');
        end
        [~,I]=sort(all_pair_distance);
        
	for j=1:itemNum
        if (rating(i,j) == 0)
            newRate=get_similarity(i, j, k,oldrating,I);
            
            rating(i,j) = newRate;
        else
            continue
        end
	end
end
save('rating1.mat','rating');
r = get_mad4(rating);
end