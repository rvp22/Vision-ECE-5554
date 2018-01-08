function siftpositionlabel=calc_position(coordinates)

siftpositionlabel=zeros(2,size(coordinates,2));
siftpositionlabel=[coordinates;siftpositionlabel];

for m=4:-1:1
    for n=4:-1:1
        [~,j]=find((siftpositionlabel(1,:))<m*64 & (siftpositionlabel(2,:)<n*64));
        siftpositionlabel(3,j)=m;
        siftpositionlabel(4,j)=n;
    end
end
siftpositionlabel=siftpositionlabel(3:4,:);
siftpositionlabel=(siftpositionlabel(1,:)-1)*4+siftpositionlabel(2,:);
end
