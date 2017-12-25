function [F]=fit_fundamental_norm(matches0)

N=size(matches0,1);
matches=ones(N,6);
matches(:,1:2)=matches0(:,1:2);
matches(:,4:5)=matches0(:,3:4);

%{
points=ones(size(matches,1),6);
points(:,1:2)=matches(:,1:2);
points(:,4:5)=matches(:,3:4);
%}
points_vector=zeros(9,N);
F=zeros(3);
origin1=sum(matches(:,1:2),1);
origin2=sum(matches(:,4:5),1);
origin1=origin1/N;
origin2=origin2/N;
scale1=sum(sum((matches(:,1:2)-origin1).^2,2),1);
scale2=sum(sum((matches(:,4:5)-origin2).^2,2),1);
scale1=(2/(scale1/N))^0.5;
scale2=(2/(scale2/N))^0.5;
T1=[scale1 0 0;0 scale1 0;0 0 1]*[1 0 -origin1(1);0 1 -origin1(2);0 0 1];
T2=[scale2 0 0;0 scale2 0;0 0 1]*[1 0 -origin2(1);0 1 -origin2(2);0 0 1];
matches(:,1:3)=(T1*matches(:,1:3)')';
matches(:,4:6)=(T2*matches(:,4:6)')';

%points(:,1:3)=(T1*points(:,1:3)')';
%points(:,4:6)=(T2*points(:,4:6)')';


%clf();
%plot(matches(:,4),matches(:,5),'*r');
for j=1:N
    points_vector(1,j)=matches(j,4)*matches(j,1);
    points_vector(2,j)=matches(j,4)*matches(j,2);
    points_vector(3,j)=matches(j,4);
    points_vector(4,j)=matches(j,5)*matches(j,1);
    points_vector(5,j)=matches(j,5)*matches(j,2);
    points_vector(6,j)=matches(j,5);
    points_vector(7,j)=matches(j,1);
    points_vector(8,j)=matches(j,2);
    points_vector(9,j)=1;
end
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
L = (F * [matches(:,1:2) ones(8,1)]')'; % transform points from 
% the first image to get epipolar lines in the second image

% find points on epipolar lines L closest to matches(:,3:4)
L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L .* [matches(:,4:5) ones(8,1)],2);
closest_pt = matches(:,4:5) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);
mean_dist=sum((pt_line_dist).^2)/size(pt_line_dist,1)/scale2^2;

% find endpoints of segment on epipolar line (for display purposes)
pt1 = closest_pt - [L(:,2) -L(:,1)] * 3; % offset from the closest point is 10 pixels
pt2 = closest_pt + [L(:,2) -L(:,1)] * 3;

% display points and segments of corresponding epipolar lines
clf;

plot(matches(:,4), matches(:,5), '+r');
line([matches(:,4) closest_pt(:,1)]', [matches(:,5) closest_pt(:,2)]', 'Color', 'r');
line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');
%plot(matches(:,4),matches(:,5),'*b');
%}
F=T2'*F*T1;