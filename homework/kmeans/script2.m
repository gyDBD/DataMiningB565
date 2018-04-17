r1=dm3(1,3000);
r2=dm3(2,3000);
r3=dm3(3,3000);
r4=dm3(4,3000);


x1 = (1:length(r1));
x2 = (1:length(r2));
x3 = (1:length(r3));
x4 = (1:length(r4));
plot(x1,r1,'r',x2,r2,'g',x3,r3,'b',x4,r4,'y')
legend("Edclidean","cosine","dp","dpn");
saveas(gcf,'plot9.jpg')