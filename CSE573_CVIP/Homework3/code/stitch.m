function [im_ans]=stitch(im_path1,im_path2,im_path3,f)
%im_path1='..\data\part1\pier\2.jpg';
%im_path2='..\data\part1\pier\3.jpg';
im10=imread(im_path1);
im20=imread(im_path2);
if(size(im20,1)>size(im10,1))
    im_temp=im10;im10=im20;im20=im_temp;
end
im1=rgb2gray(im10);
im1=histogram_equalization(im1);
im2=rgb2gray(im20);
im2=histogram_equalization(im2);
harris_threshold=2^12;
sigma=3;
[~,r1,c1]=harris(im1,sigma,harris_threshold,1,0);
[features1,features_side1]=get_features(im1,r1,c1);
[~,r2,c2]=harris(im2,sigma,harris_threshold,1,0);
[features2,features_side2]=get_features(im2,r2,c2);
distances=get_distances(features1,features2);
distances_side=zeros(size(features_side1,1),size(features_side2,1),4);
for i=1:4
    distances_side(:,:,i)=get_distances(features_side1(:,:,i),features_side2(:,:,i));
    distances=distances+distances_side(:,:,i)./2;
end

pairs=get_pairs(distances,50,1.1,2);

if(f==1)
    im_ans=sum(pairs(:,3));
    return ;
end

putative_matches=zeros(size(pairs,1),5);
for i=1:size(pairs,1)
    putative_matches(i,1)=r1(pairs(i,1));
    putative_matches(i,2)=c1(pairs(i,1));
    putative_matches(i,3)=r2(pairs(i,2));
    putative_matches(i,4)=c2(pairs(i,2));
    putative_matches(i,5)=pairs(i,3);
end

%{
im=zeros(max(size(im1,1),size(im2,1)),size(im1,2)+size(im2,2));
im(1:size(im1,1),1:size(im1,2))=im1;
im(1:size(im2,1),size(im1,2)+1:size(im1,2)+size(im2,2))=im2;
figure(1),imagesc(im),axis image, colormap(gray), hold on;
for i=1:size(putative_matches,1)
    y=[putative_matches(i,1) putative_matches(i,3)];
    x=[putative_matches(i,2) size(im1,2)+putative_matches(i,4)];
    plot(x,y,'r--*');
    text(putative_matches(i,2),putative_matches(i,1),num2str(i),'Color','blue');
    text(size(im1,2)+putative_matches(i,4),putative_matches(i,3),num2str(i));
end
%}

four_points=zeros(4,4);
points_4vectors=zeros(8,9);
H_matrix=zeros(3,3);
itinerary=ceil(size(putative_matches,1)^3.5);
threshold_error=2;
error_ans_count=inf;
error=zeros(1,size(putative_matches,1));

for i=1:itinerary
    perm=randperm(size(putative_matches,1));
    for j=1:4
        four_points(j,1:4)=putative_matches(perm(j),1:4);
        points_4vectors(j*2-1,1)=four_points(j,1);
        points_4vectors(j*2-1,2)=four_points(j,2);
        points_4vectors(j*2-1,3)=1;
        points_4vectors(j*2-1,4:6)=0;
        points_4vectors(j*2-1,7)=-four_points(j,1)*four_points(j,3);
        points_4vectors(j*2-1,8)=-four_points(j,2)*four_points(j,3);
        points_4vectors(j*2-1,9)=-four_points(j,3);
        points_4vectors(j*2,1:3)=0;
        points_4vectors(j*2,4)=four_points(j,1);
        points_4vectors(j*2,5)=four_points(j,2);
        points_4vectors(j*2,6)=1;
        points_4vectors(j*2,7)=-four_points(j,1)*four_points(j,4);
        points_4vectors(j*2,8)=-four_points(j,2)*four_points(j,4);
        points_4vectors(j*2,9)=-four_points(j,4);
    end
    A=points_4vectors'*points_4vectors;
    [U,S,V]=svd(A);
    h=V(:,end);
    H_matrix(1,:)=h(1:3,:);
    H_matrix(2,:)=h(4:6,:);
    H_matrix(3,:)=h(7:9,:);
    
    im=zeros(max(size(im1,1),size(im2,1)),size(im1,2)+size(im2,2));
    im(1:size(im1,1),1:size(im1,2))=im1;
    im(1:size(im2,1),size(im1,2)+1:size(im1,2)+size(im2,2))=im2;
    figure(1),imagesc(im),axis image, colormap(gray), hold on;
    %{
    for j=1:4
        point1=[four_points(j,1) four_points(j,2) 1]';
        point2=[four_points(j,3) four_points(j,4) 1]';
        point20=H_matrix*point1;
        point20=point20/point20(3,1);
                
        error(1,j)=sum((point2-point20).^2);
        
        y=[point1(1) point2(1)];
        x=[point1(2) size(im1,2)+point2(2)];
        plot(x,y,'r--*');
        
        yy=[point1(1) point20(1)];
        xx=[point1(2) size(im1,2)+point20(2)];
        plot(xx,yy,'b--o');
    end
    %}
    error_count=0;
    for j=1:size(putative_matches,1)
        point1=[putative_matches(j,1) putative_matches(j,2) 1]';
        point2=[putative_matches(j,3) putative_matches(j,4) 1]';
        point20=H_matrix*point1;
        point20=point20/point20(3,1);
                
        error(1,j)=sum((point2-point20).^2)^0.5;
        
        y=[point1(1) point2(1)];
        x=[point1(2) size(im1,2)+point2(2)];
        %plot(x,y,'b--o');
        
        yy=[point1(1) point20(1)];
        xx=[point1(2) size(im1,2)+point20(2)];
        %plot(xx,yy,'r--o');
        
        if(error(1,j)>threshold_error)
            %plot(x,y,'b--o');
            error_count=error_count+1;
        else
            plot(x,y,'r--o');
        end
        if(error_count>error_ans_count)
            break;
        end
    end
    error_s=sort(error);
    mean_dist=sum(error_s(1:24))/24;
    if(error_count==error_ans_count)
        if(error_ans_count==13)
            
        end
        S1=triangle_area(four_points(1,1:2),four_points(2,1:2),four_points(3,1:2))+...
            triangle_area(four_points(1,1:2),four_points(2,1:2),four_points(4,1:2));
        S2=triangle_area(four_points_ans(1,1:2),four_points_ans(2,1:2),four_points_ans(3,1:2))+...
            triangle_area(four_points_ans(1,1:2),four_points_ans(2,1:2),four_points_ans(4,1:2));
        if(S1>S2)
            error_ans_count=error_count;
            four_points_ans=four_points;
            H_matrix_ans=H_matrix;
        end
    end
    if(error_count<error_ans_count)
        error_ans_count=error_count;
        four_points_ans=four_points;
        H_matrix_ans=H_matrix;
    end
    
end


%{
im=zeros(max(size(im1,1),size(im2,1)),size(im1,2)+size(im2,2));
im(1:size(im1,1),1:size(im1,2))=im1;
im(1:size(im2,1),size(im1,2)+1:size(im1,2)+size(im2,2))=im2;
figure(1),imagesc(im),axis image, colormap(gray), hold on;
set(gca,'XLim',[0 size(im1,2)+size(im2,2)]);
set(gca,'YLim',[0 size(im1,1)]);
for j=1:4
        point1=[four_points(j,1) four_points(j,2) 1]';
        point2=[four_points(j,3) four_points(j,4) 1]';
        
        y=[point1(1) point2(1)];
        x=[point1(2) size(im1,2)+point2(2)];
        plot(x,y,'r--*');
end

for j=1:4
    point1=[four_points(j,1) four_points(j,2) 1]';
    point2=[four_points(j,3) four_points(j,4) 1]';
    point20=H_matrix*point1;
    point20=point20/point20(3,1);
                
    error(1,j)=sum((point2-point20).^2);
        
    y=[point1(1) point2(1)];
    x=[point1(2) size(im1,2)+point2(2)];
    plot(x,y,'r--*');
        
    yy=[point1(1) point20(1)];
    xx=[point1(2) size(im1,2)+point20(2)];
    plot(xx,yy,'b--o');
end
%}
%{
for j=1:size(putative_matches,1)
    point1=[putative_matches(j,1) putative_matches(j,2) 1]';
    point2=[putative_matches(j,3) putative_matches(j,4) 1]';
    point20=H_matrix_ans*point1;
    point20=point20/point20(3,1);
                
    error(1,j)=sum((point2-point20).^2);
    
    if(error(1,j)<threshold_error)
        continue;
    end
    figure(1),clf(),imagesc(im),axis image, colormap(gray), hold on;
    y=[point1(1) point2(1)];
    x=[point1(2) size(im1,2)+point2(2)];
    plot(x,y,'b--o');
        
    yy=[point1(1) point20(1)];
    xx=[point1(2) size(im1,2)+point20(2)];
    plot(xx,yy,'r--*');
end
%}
im_ans=uint8(zeros(size(im1,1)*3,size(im1,2)*3,3));
for k=1:3
    [warp_im,warp_mark]=warp(im10(:,:,k),H_matrix_ans);
    for i=size(im1,1)+1:size(im1,1)+size(im2,1)
        for j=size(im1,2)+1:size(im1,2)+size(im2,2)
            %if(warp_mark(i,j)==0)
            if(warp_im(i,j)<5)
                warp_im(i,j)=im20(i-size(im1,1),j-size(im1,2),k);
            else
                warp_im(i,j)=uint8((double(warp_im(i,j))+double(im20(i-size(im1,1),j-size(im1,2),k)))/2);
            end
        end
    end
    [~,up,down,left,right]=cut_edge(warp_im);
    im_ans(:,:,k)=warp_im;
end
im_ans=im_ans(up:down,left:right,:);
figure(3);
imshow(im_ans);
imwrite(im_ans, im_path3);

%{


temp=(E_vector_ans')*points_vector_ans;
im=zeros(max(size(im1,1),size(im2,1)),size(im1,2)+size(im2,2));
im(1:size(im1,1),1:size(im1,2))=im1;
im(1:size(im2,1),size(im1,2)+1:size(im1,2)+size(im2,2))=im2;
figure(1),imagesc(im),axis image, colormap(gray), hold on;
for i=1:8
    y=[eight_points_ans(i,1) eight_points_ans(i,3)];
    x=[eight_points_ans(i,2) size(im1,2)+eight_points_ans(i,4)];
    plot(x,y,'r--*');
    text(x(1),y(1),num2str(i),'Color','red');
end

    save('E.mat','E_ans'); 
    [U,S,V]=svd(E_ans);
    S=[(S(1,1)+S(2,2))/2 0 0;0 (S(1,1)+S(2,2))/2 0;0 0 0];
    E_ans=U*S*V';

[U,S,V]=svd(E_ans);
W=[0 -1 0;1 0 0;0 0 1];
t_=U*W*S*U';
t=[t_(3,2) t_(1,3) t_(2,2)];
R=U*W^(-1)*V';
t2=-t;
R2=U*W*V';
%}