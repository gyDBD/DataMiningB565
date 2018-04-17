function mad = get_mad(rating)

test = load('u5.test');
test = test(:,1:3);

movieItems = importdata('u.item','|',0);
%get all movie ids
movieIds = movieItems.textdata(:,1);
%read user data
users = load('u.user');
[itemNum,v]=size(movieIds);
[userNum,v]=size(users);
[testNum,v] = size(test);
testrating =zeros(userNum,itemNum);
for n=1:testNum
	baseLine = test(n,:);
	userId = baseLine(1);
	itemId = baseLine(2);
	rate = baseLine(3);
	testrating(userId,itemId) = rate;
end
save('testrating.mat','testrating');
mad = 0.0;
s = 0;

for i=1:userNum
    for j=1:itemNum
        if (isnan(testrating(i,j)) ||testrating(i,j)==0 || isnan(rating(i,j)) )
            continue
        else 
            s= s + 1;
            
            mad = mad + abs(rating(i,j) - testrating(i,j));
            
        end
    end
end
mad = mad / s;

end

