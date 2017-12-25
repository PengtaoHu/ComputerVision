%%rough-set-based segmentation for "im" using "X"
function [seg]=RSBsegment(im,X)
    %imshow(uint8(im));
    r=size(im,1);
    c=size(im,2);
    maxi=max(max(im));
    mini=min(min(im));
    len=maxi-mini+1;
    seg=zeros(r,c);
    histogram=zeros(len,1);
    histon=zeros(len,1);
    peak0=ones(len,1);
    peak=zeros(len,1);
    label=zeros(len,1);
    im=im+1-mini;
    for i=1:r
        for j=1:c
            histogram(im(i,j))=histogram(im(i,j))+1;
        end
    end
    for i=1:r
        for j=1:c
            histon(im(i,j))=histon(im(i,j))+(X(i,j)+1);
        end
    end
    
    rough=(1-histogram./histon);
    for i=1:len
        if(histon(i)==0)
            rough(i)=0;
        end
    end
    rough=Fuzzy(rough);
    
    i=1;
    while(i<=len)
        if(i>1&&rough(i-1)>rough(i))
            peak0(i)=0;
        end
        j=i+1;
        if(peak0(i)==1)
            while(j<=len&&rough(j)==rough(i))
                j=j+1;
            end
            peak0(i:j-1)=zeros(j-i,1);
            if(j<=len&&rough(j)<rough(i)||i==len)
                peak0(round((i+j-1)/2))=1;
            end
        end
        i=j;
    end
    
    
    count0=sum(peak0);
    height0=zeros(count0,1);
    j=1;
    for i=1:len
        if(peak0(i)==1)
            height0(j)=rough(i);
            j=j+1;
        end
    end
    avgh=sum(height0)/count0;
    sigmah=(sum((height0-avgh).^2)/count0)^0.5;
    
    dist0=zeros(count0-1,1);
    left=find(peak0,1);
    j=1;
    for i=left+1:len
        if(peak0(i)==1)
            dist0(j)=i-left;
            left=i;
            j=j+1;
        end
    end
    avgd=sum(dist0)/(count0-1);
    sigmad=(sum((dist0-avgd).^2)/(count0-1))^0.5;
    
    Th=avgh-sigmah;
    Td=avgd-sigmad;
    
    right=find(peak0);
    right=right(length(right));
    peak(right)=1;
    for i=right-1:-1:1
        if(peak0(i)==1&&rough(i)>Th&&right-i>=Td)
            peak(i)=1;
            right=i;
        end
    end
    
    left=find(peak,1);
    for i=left+1:len
        if(peak(i)==1)
            fragment=rough(left:i);
            [~,id0]=min(fragment);
            for j=id0:length(fragment)
                if(fragment(j)==fragment(id0))
                    id1=j;
                end
            end
            label(left+floor((id0+id1)/2)-1)=1;
            left=i;
        end
    end
    
    label(1)=1;
    for i=2:len
        if(label(i)==1)
            label(i)=label(i-1)+1;
        else
            label(i)=label(i-1);
        end
    end
        
    for i=1:r
        for j=1:c
            seg(i,j)=-label(im(i,j));
        end
    end
    
    label0=1;
    for i=1:r
        for j=1:c
            if(seg(i,j)<0)
                [~,~,seg]=FloodRep(seg,i,j,seg(i,j),label0,0);
                label0=label0+1;
            end
        end
    end