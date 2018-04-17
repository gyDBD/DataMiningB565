function r=get_rate(type, k)
movieItems = importdata('u.item','|',0);
%get all movie ids
movieIds = movieItems.textdata(:,1);
%read u1 training data
%userid itemid rating timestamp
%base = load('/l/b565/ml-100k/u4.base');
base = load('u3.base');
training = base(:,1:3);
%read user data
users = load('u.user');
[itemNum,v]=size(movieIds);
[userNum,v]=size(users);
%user item matrix
rating =zeros(userNum,itemNum);
[trainingNum,v] = size(training);
%add value to result
for n=1:trainingNum
	baseLine = training(n,:);
	userId = baseLine(1);
	itemId = baseLine(2);
	rate = baseLine(3);
	rating(userId,itemId) = rate;
end

for i=1:userNum
    
        if type == 1
            all_pair_distance=pdist2(rating(i,:),rating(:,:));
        elseif type == 2
            all_pair_distance=pdist2(rating(i,:),rating(:,:),'cosine');
           
        elseif type == 3
            all_pair_distance=pdist2(rating(i,:),rating(:,:),'cityblock');
        end
        [~,I]=sort(all_pair_distance);
        
	for j=1:itemNum
        if (rating(i,j) == 0)
            newRate=get_similarity(i, j, k,rating,I);
           
            rating(i,j) = newRate;
        else
            continue
        end
	end
end
save('rating1.mat','rating');
r = get_mad(rating);
end