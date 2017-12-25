source='..\data\part2\';
im1 = imread([source,'house1.jpg']);
im1=rgb2gray(im1);
im1=histogram_equalization(im1);
im2 = imread([source,'house2.jpg']);
im2=rgb2gray(im2);
im2=histogram_equalization(im2);
matches = load([source,'library_matches.txt']); 
%{
%RANSAC
harris_threshold=2^11;
sigma=3;
radius=1;
[cim1,r1,c1]=harris(im1,sigma,harris_threshold,1,0);
[features1,features_side1]=get_features(im1,r1,c1);
[cim2,r2,c2]=harris(im2,sigma,harris_threshold,1,0);
[features2,features_side2]=get_features(im2,r2,c2);
distances=get_distances(features1,features2);
distances_side=zeros(size(features_side1,1),size(features_side2,1),4);
for i=1:4
    distances_side(:,:,i)=get_distances(features_side1(:,:,i),features_side2(:,:,i));
    distances=distances+distances_side(:,:,i)./2;
end

pairs=get_pairs(distances,100,1.1,2);

matches=zeros(size(pairs,1),5);
for i=1:size(pairs,1)
    matches(i,1)=c1(pairs(i,1));
    matches(i,2)=r1(pairs(i,1));
    matches(i,3)=c2(pairs(i,2));
    matches(i,4)=r2(pairs(i,2));
    matches(i,5)=pairs(i,3);
end


im=zeros(max(size(im1,1),size(im2,1)),size(im1,2)+size(im2,2));
im(1:size(im1,1),1:size(im1,2))=im1;
im(1:size(im2,1),size(im1,2)+1:size(im1,2)+size(im2,2))=im2;
figure(1),imagesc(im),axis image, colormap(gray), hold on;

for i=1:size(matches,1)
    y=[matches(i,2) matches(i,4)];
    x=[matches(i,1) size(im1,2)+matches(i,3)];
    plot(x,y,'r--*');
    text(matches(i,1),matches(i,2),num2str(i),'Color','green');
    text(size(im1,2)+matches(i,3),matches(i,4),num2str(i),'Color','green');
end
%}

N = size(matches,1);

%F=fit_fundamental_RANSAC(matches,im1,im);
F=fit_fundamental(matches);
%F=fit_fundamental_norm(matches);
L = (F * [matches(:,1:2) ones(N,1)]')';

L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L .* [matches(:,3:4) ones(N,1)],2);
mean_dist=sum(abs(pt_line_dist))/size(pt_line_dist,1);
closest_pt = matches(:,3:4) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);

pt1 = closest_pt - [L(:,2) -L(:,1)] * 10; % offset from the closest point is 10 pixels
pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;

clf;
imshow(im2); hold on;
plot(matches(:,3), matches(:,4), '+r');
line([matches(:,3) closest_pt(:,1)]', [matches(:,4) closest_pt(:,2)]', 'Color', 'r');
line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');
 