%%merge a region into a most similar connected region if it's too small or
%%too similar to a connected region.
%"im0" is the image to segment
%"seg" is the segmentation result
%"Tm" is the mass threshold
%"Ts" is the similarity threshold
function[seg]=Merge(im0,seg,Tm,Ts,X)
    if(size(im0,3)==1)
        im(:,:,1)=im0;
        im(:,:,2)=im0;
        im(:,:,3)=im0;
    else
        im=im0;
    end
    r=size(seg,1);
    c=size(seg,2);
    labelmax=max(max(seg));
    lb_mass=zeros(labelmax,1);
    pr=zeros(labelmax,1);
    pc=zeros(labelmax,1);
    for i=1:r
        for j=1:c
            lb_mass(seg(i,j))=lb_mass(seg(i,j))+1;
            pr(seg(i,j))=i;
            pc(seg(i,j))=j;    
        end
    end
    for j=1:labelmax-1
        [~,i]=min(lb_mass);
        [Xn,Xrate]=FloodRep(seg,pr(i),pc(i),i,i,X);
        if(lb_mass(i)<Tm||Xrate>0.4)
            [simi,~]=getSimiConnect(im,seg,pr(i),pc(i),labelmax);
            [simiMin,new]=min(simi);
            if(simiMin<Ts||lb_mass(i)<100)
                [~,~,seg]=FloodRep(seg,pr(i),pc(i),i,new,0);
                lb_mass(new)=lb_mass(new)+lb_mass(i);
            end
        end
        lb_mass(i)=inf;
    end
    