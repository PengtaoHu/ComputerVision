function blob_detection_ResizeImage()
im_Path='..\data\tent.jpg';
threshold=80;
im0=rgb2gray(imread(im_Path));

k0=1;%initial scale
im=imresize(double(im0),1/k0,'bilinear');

filter=fspecial('log',[7 7],5);
r0=3;%radius of circles detected


level_num=15;%number of scales
k=1/((min(size(im0))/40)^(1/level_num));
circles_count=0;



FR=cell(level_num,1);
maximum=zeros(level_num);
minimum=zeros(level_num);
ks=zeros(level_num);

for i=1:level_num
    FR{i}=abs(imfilter(im,filter,'symmetric'));
    maximum(i)=max(FR{i}(:));
    minimum(i)=min(FR{i}(:));
    im=imresize(im,k,'bilinear');
    ks(i)=1/k^(i-1);
end
maximum(1)=max(maximum(:));
minimum(1)=min(minimum(:));
im=imresize(double(im0),1/k0,'bilinear');
for i=1:level_num
    FR{i}=(FR{i}-minimum(1))/(maximum(1)-minimum(1))*255;
    %FR{i}=detect_edges(im,FR{i},r0,i,threshold, 0.5, 5,5);
    FR{i}=nonmaximum_suppression_matrix(FR{i},r0,threshold);
    
    for j=1:size(FR{i},1)
        for u=1:size(FR{i},2)
            if(FR{i}(j,u)>threshold)
                circles_count=circles_count+1;
                circles(circles_count,1)=j*k0*ks(i);
                circles(circles_count,2)=u*k0*ks(i);
                circles(circles_count,3)=r0*k0*ks(i);
                circles(circles_count,4)=FR{i}(j,u);
            end
        end
    end
    im=imresize(im,k,'bilinear');
end
circles=nonmaximum_suppression_list(circles,circles_count);
show_all_circles(im0,circles(:,2),circles(:,1),circles(:,3));
saveas(gcf,strrep(im_Path,'.jpg','_output4.jpg'));