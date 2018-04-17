function mad = get_mad4_2(k)
movie = fopen('movies.dat');
movieItems = textscan(movie, '%f %s %s','Delimiter', {'::'});
movieIds = unique(movieItems{1});
[itemNum,v]=size(movieIds);
base = fopen('r3.train');
trainItems = textscan(base, '%f %f %f','Delimiter', {'::'});


base = fopen('r3.test');
testItems = textscan(base, '%f %f %f','Delimiter', {'::'});
[testNum,v] = size(testItems{2});
mad = 0.0;
s = 0;
for n=1:testNum
    disp(n);
    %userid
	userId = testItems{1}(n);
    %itemid
	itemId = testItems{2}(n);
	testrate = testItems{3}(n);
    %calculate the rating(userId, itemId)
    rating = get_similarity4_2(userId, itemId,k,trainItems,itemNum);
    if (isnan(rating) || isnan(testrate)) 
        continue
    else 
        s = s + 1;
        mad = mad + abs(rating - testrate);
    end
end
mad = mad / s;

end

