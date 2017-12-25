function [F]=fit_fundamental_(matches)
points_vector=zeros(9,8);
F=zeros(3);
eight_points=zeros(8,4);
perm=randperm(size(matches,1));
perm=[1 2 3 4 5 6 7 8];
for j=1:8
    eight_points(j,1:4)=matches(perm(j),1:4);
    points_vector(1,j)=eight_points(j,3)*eight_points(j,1);
    points_vector(2,j)=eight_points(j,3)*eight_points(j,2);
    points_vector(3,j)=eight_points(j,3);
    points_vector(4,j)=eight_points(j,4)*eight_points(j,1);
    points_vector(5,j)=eight_points(j,4)*eight_points(j,2);
    points_vector(6,j)=eight_points(j,4);
    points_vector(7,j)=eight_points(j,1);
    points_vector(8,j)=eight_points(j,2);
    points_vector(9,j)=1;
end
eight_points0=eight_points;
[U,~,~]=svd(points_vector);
F_vector = U(:,8);
F(1,:)=F_vector(1:3,1);
F(2,:)=F_vector(4:6,1);
F(3,:)=F_vector(7:9,1);
[U,S,V]=svd(F);
S(3,3)=0;
F=U*S*V';
%{
clf();

L = (F * [eight_points(:,1:2) ones(8,1)]')'; % transform points from 
% the first image to get epipolar lines in the second image

% find points on epipolar lines L closest to matches(:,3:4)
L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L .* [eight_points(:,3:4) ones(8,1)],2);
closest_pt = eight_points(:,3:4) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);
mean_dist=sum((pt_line_dist).^2)/size(pt_line_dist,1);

% find endpoints of segment on epipolar line (for display purposes)
pt1 = closest_pt - [L(:,2) -L(:,1)] * 1000; % offset from the closest point is 10 pixels
pt2 = closest_pt + [L(:,2) -L(:,1)] * 1000;

% display points and segments of corresponding epipolar lines
figure(1);

clf;
plot(eight_points(:,1), eight_points(:,2), '*b');hold on;
plot(eight_points(:,3), eight_points(:,4), '+r');
line([eight_points(:,3) closest_pt(:,1)]', [eight_points(:,4) closest_pt(:,2)]', 'Color', 'r');
line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');
axis([0 400 0 400])


%=========================================================================
eight_points=ones(8,6);
for j=1:8
    eight_points(j,1:2)=matches(perm(j),1:2);
    eight_points(j,4:5)=matches(perm(j),3:4);
end
origin1=sum(eight_points(:,1:2),1);
origin2=sum(eight_points(:,4:5),1);
origin1=origin1/8;
origin2=origin2/8;
scale1=sum(sum((eight_points(:,1:2)-origin1).^2,2),1);
scale2=sum(sum((eight_points(:,4:5)-origin2).^2,2),1);
scale1=(2/(scale1/8))^0.5;
scale2=(2/(scale2/8))^0.5;
T1=[scale1 0 0;0 scale1 0;0 0 1]*[1 0 -origin1(1);0 1 -origin1(2);0 0 1];
T2=[scale2 0 0;0 scale2 0;0 0 1]*[1 0 -origin2(1);0 1 -origin2(2);0 0 1];
eight_points(1:8,1:3)=(T1*eight_points(1:8,1:3)')';
eight_points(1:8,4:6)=(T2*eight_points(1:8,4:6)')';

%points(:,1:3)=(T1*points(:,1:3)')';
%points(:,4:6)=(T2*points(:,4:6)')';


%clf();
%plot(eight_points(:,4),eight_points(:,5),'*r');
for j=1:8
    points_vector(1,j)=eight_points(j,4)*eight_points(j,1);
    points_vector(2,j)=eight_points(j,4)*eight_points(j,2);
    points_vector(3,j)=eight_points(j,4);
    points_vector(4,j)=eight_points(j,5)*eight_points(j,1);
    points_vector(5,j)=eight_points(j,5)*eight_points(j,2);
    points_vector(6,j)=eight_points(j,5);
    points_vector(7,j)=eight_points(j,1);
    points_vector(8,j)=eight_points(j,2);
    points_vector(9,j)=1;
end
[U,S,V]=svd(points_vector);
F_vector = U(:,8);
F(1,:)=F_vector(1:3,1);
F(2,:)=F_vector(4:6,1);
F(3,:)=F_vector(7:9,1);
[U,S,V]=svd(F);
S(3,3)=0;
F=U*S*V';

L = (F * [eight_points(:,1:2) ones(8,1)]')'; % transform points from 
% the first image to get epipolar lines in the second image

% find points on epipolar lines L closest to matches(:,3:4)
L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L .* [eight_points(:,4:5) ones(8,1)],2);
closest_pt = eight_points(:,4:5) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);
mean_dist=sum((pt_line_dist).^2)/size(pt_line_dist,1)/scale2^2;

% find endpoints of segment on epipolar line (for display purposes)
pt1 = closest_pt - [L(:,2) -L(:,1)] * 3; % offset from the closest point is 10 pixels
pt2 = closest_pt + [L(:,2) -L(:,1)] * 3;

% display points and segments of corresponding epipolar lines
figure(2);

%clf;
plot(eight_points(:,1), eight_points(:,2), '+b');hold on;
plot(eight_points(:,4), eight_points(:,5), '+r');
line([eight_points(:,4) closest_pt(:,1)]', [eight_points(:,5) closest_pt(:,2)]', 'Color', 'r');
line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');
axis([-5 5 -5 5]);
%================================================================================

F=T2'*F*T1;
L = (F * [eight_points0(:,1:2) ones(8,1)]')'; % transform points from 
% the first image to get epipolar lines in the second image

% find points on epipolar lines L closest to matches(:,3:4)
L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L .* [eight_points0(:,3:4) ones(8,1)],2);
closest_pt = eight_points0(:,3:4) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);
mean_dist=sum((pt_line_dist).^2)/size(pt_line_dist,1)/scale2^2;

% find endpoints of segment on epipolar line (for display purposes)
pt1 = closest_pt - [L(:,2) -L(:,1)] * 1000; % offset from the closest point is 10 pixels
pt2 = closest_pt + [L(:,2) -L(:,1)] * 1000;

% display points and segments of corresponding epipolar lines
figure(3);

%clf;
plot(eight_points0(:,1), eight_points0(:,2), '+b');hold on;
plot(eight_points0(:,3), eight_points0(:,4), '+r');
line([eight_points0(:,3) closest_pt(:,1)]', [eight_points0(:,4) closest_pt(:,2)]', 'Color', 'r');
line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');
axis([0 400 0 400]);
%}