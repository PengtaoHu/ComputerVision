function [features,features_side] = get_features(im,r,c)
    radius=10;
    im=im+1;
    length=256;
    features=zeros(size(r,1),length);
    for j=1:size(r,1)
        for u=-radius:radius
            if(r(j)+u<1||r(j)+u>size(im,1))
                continue;
            end
            k0=floor((radius^2-u^2)^0.5);
            for k=-k0:k0
                if(c(j)+k<1||c(j)+k>size(im,2))
                    continue;
                end
                features(j,im(r(j)+u,c(j)+k))=features(j,im(r(j)+u,c(j)+k))+1;
            end
        end
    end
    point=[1 0 2;0 0 0;3 0 4];
    ra=radius;
    features_side=zeros(size(r,1),length,4);
    for k=1:size(r,1)
        for i=-1:2:1
            for j=-1:2:1
                u=point(i+2,j+2);
                rr=r(k)+i*ra;
                cc=c(k)+j*ra;
                for t=-ra:ra
                    for p=-ra:ra
                        features_side(k,im(rr+t,cc+p),u)=features_side(k,im(rr+t,cc+p),u)+1;
                    end
                end
            end
        end
    end
    
    %{
    for i=1:size(r,1)
        m=mean(features0(i,:));
        s=std(features0(i,:));
        for j=1:256
            features0(i,j)=(features0(i,j)-m)/s;
        end
    end
    %}
    
    features=fuzzy_features(features);
    
    for i=1:4
        features_side(:,:,i)=fuzzy_features(features_side(:,:,i));
    end
    
    