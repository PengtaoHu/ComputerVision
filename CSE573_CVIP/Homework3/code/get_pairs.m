function [pairs]=get_pairs(distances,pairs_size,threshold_distance,threshold_count)
count=0;
count2=zeros(1,size(distances,2));
for i=1:size(distances,1)
    count_old=count;

    [minimum,pos]=min(distances(i,:));
    if(count2(pos)<threshold_count)
        count=count+1;
        count2(pos)=count2(pos)+1;
        pairs(count,1)=i;
        pairs(count,2)=pos;
        pairs(count,3)=distances(i,pos);
    end
    for j=1:size(distances,2)
        if(count-count_old==threshold_count)
            break;
        end
        if(distances(i,j)/minimum<threshold_distance&&j~=pos&&count2(j)<threshold_count)
            count=count+1;
            count2(j)=count2(j)+1;
            pairs(count,1)=i;
            pairs(count,2)=j;
            pairs(count,3)=distances(i,j);
        end
    end
end
pairs=pairs(1:count,:);
pairs=sortrows(pairs,3);
pairs=pairs(1:min(size(pairs,1),pairs_size),:);