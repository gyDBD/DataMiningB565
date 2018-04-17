function r=get_rate2(type, k)
movieItems = importdata('u.item','|',0);
%get all movie ids
movieIds = movieItems.textdata(:,1);
%read u1 training data
%userid itemid rating timestamp
%base = load('/l/b565/ml-100k/u4.base');
base = load('u2.base');
training = base(:,1:3);
%read user data
users = load('u.user');
fileID = fopen('u.user');
usersItems = textscan(fileID, '%f %f %s %s %s','Delimiter', '|');
usersItems{3} = grp2idx(usersItems{3});
usersItems{4} = grp2idx(usersItems{4});
edges = 0:10:100;
age = discretize(usersItems{2},edges);
gender = usersItems{3};
occupation = usersItems{4};
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
%first try, add three coloumn
%newMatrix = [rating gender];
%newMatrix = [newMatrix age];
%newMatrix = [newMatrix occupation];
oldrating = rating;
for i=1:userNum
        disp(i);
        if type == 1
            all_pair_distance=pdist2(rating(i,:),rating(:,:));
            
        elseif type == 2
            all_pair_distance=pdist2(rating(i,:),rating(:,:),'cosine');
           
        elseif type == 3
            all_pair_distance=pdist2(rating(i,:),rating(:,:),'cityblock');
        elseif type == 4
            all_pair_distance=pdist2(rating(i,:),rating(:,:),'minkowski');
        end
        %disp(age(i));
        %second try: only count the same
        %age(age(:) ~= age(i)) = 0;
        %age(age(:) == age(i)) = 1;
        %gender(gender(:) ~= gender(i)) = 0;
        %gender(gender(:) == gender(i)) = 1;
        
        age(age(:) ~= age(i)) = 1;
        age(age(:) == age(i)) = 0.5;
        gender(gender(:) ~= gender(i)) = 1;
        gender(gender(:) == gender(i)) = 0.5;
        all_pair_distance = all_pair_distance';
        all_pair_distance = all_pair_distance .* age;
        all_pair_distance = all_pair_distance .* gender;
        %all_pair_distance (all(all_pair_distance == 0, 2),:) = [];
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
r = get_mad(rating);
end