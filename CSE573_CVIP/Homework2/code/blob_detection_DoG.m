function blob_detection_DoG()
im_Path='..\data\palace.jpg';
threshold=140;
im0=rgb2gray(imread(im_Path));

k0=1;%initial scale
im=imresize(double(im0),1/k0,'bilinear');

level_num=15;%number of scales
k=1/(min(size(im0))/0.8/10)^(1/level_num);
circles_count=0;

FR=zeros(size(im,1),size(im,2),level_num);
i=0:14;
ks=k.^i;
kg=2;
filter0=fspecial('gaussian',5,0.8)-fspecial('gaussian',5,kg*0.8);
s0=sum(sum(abs(filter0)));
r=zeros(level_num);

for i=1:level_num
    mask_size=round(1.5/ks(i))*2+1;
    filter=fspecial('gaussian',mask_size,kg*0.8/ks(i))-fspecial('gaussian',mask_size,0.8/ks(i));
    s=sum(sum(abs(filter)));
    mid=ceil(size(filter,1)/2);
    for j=1:size(filter,2)
        if(filter(mid,j)<0)
            r(i)=r(i)+1;
        end
    end
    r(i)=r(i)/2;    
    FR(:,:,i)=abs(imfilter(im,filter,'symmetric'))/s*s0;
end
maximum=max(max(max(FR)));
minimum=min(min(min(FR)));
FR=(FR-minimum)/(maximum-minimum)*255;
for i=1:level_num
    FR(:,:,i)=nonmaximum_suppression_matrix(FR(:,:,i),r(i),threshold);
    
    for j=1:size(im,1)
        for u=1:size(im,2)
            if(FR(j,u,i)>threshold)
                circles_count=circles_count+1;
                circles(circles_count,1)=j*k0;
                circles(circles_count,2)=u*k0;
                circles(circles_count,3)=r(i)*k0;
                circles(circles_count,4)=FR(j,u,i);
            end
        end
    end
end
circles=nonmaximum_suppression_list(circles,circles_count);
show_all_circles(im0,circles(:,2),circles(:,1),circles(:,3));
saveas(gcf,strrep(im_Path,'.jpg','_output2.jpg'));
