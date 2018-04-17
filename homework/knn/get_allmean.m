
    movieItems = importdata('u.item','|',0);

    movieIds = movieItems.textdata(:,1);

    base = load('u5.base');
    training = base(:,1:3);

    users = load('u.user');
    [itemNum,v]=size(movieIds);
    [userNum,v]=size(users);

    rating =zeros(userNum,itemNum);
    [trainingNum,v] = size(training);

    for n=1:trainingNum
        baseLine = training(n,:);
        userId = baseLine(1);
        itemId = baseLine(2);
        rate = baseLine(3);
        rating(userId,itemId) = rate;
    end
oldrating = rating;
    for mid =1:itemNum
        midUsersId = find(oldrating(:,mid)>0);
        midNotId = find(oldrating(:,mid)==0);
        result = mean(oldrating(midUsersId,mid));
        rating(midNotId, mid) = result;

    end
save('rating2.mat','rating');
mad = get_mad(rating);
disp(mad);


