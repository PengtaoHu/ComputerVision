function [distances]=get_distances(v1,v2)
distances=zeros(size(v1,1),size(v2,1));
length=256;

for i=1:size(v1,1)
    for j=1:size(v2,1)
        seq=1:length;
        s1=sum(seq.*v1(i,:));
        s2=sum(seq.*v2(j,:));
        diff=floor(s1/sum(v1(i,:))-s2/sum(v2(j,:)));
        diff_max=50;
        if(diff>diff_max)
            diff=diff_max;
        end
        if(diff<-diff_max)
            diff=-diff_max;
        end
        v20=zeros(1,length);
        if(diff<0)
            v20(1)=sum(v2(j,1:-diff+1));
            v20(2:length+diff)=v2(j,-diff+2:length);
        else
            v20(length)=sum(v2(j,length-diff:length));
            v20(1+diff:length-1)=v2(j,1:length-diff-1);
        end
        d1=sum(abs(v1(i,:)-v20));
        v21(2:length)=v20(1:length-1);
        v21(1)=0;
        d2=sum(abs(v1(i,:)-v21));
        distances(i,j)=min(d1,d2);
    end
end
