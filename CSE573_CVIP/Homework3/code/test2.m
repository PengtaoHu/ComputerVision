clf();
L = (F * [eight_points(:,1:2) ones(8,1)]')'; % transform points from 
% the first image to get epipolar lines in the second image

% find points on epipolar lines L closest to matches(:,3:4)
L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L .* [eight_points(:,4:5) ones(8,1)],2);
closest_pt = eight_points(:,4:5) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);
mean_dist=sum((pt_line_dist).^2)/size(pt_line_dist,1);

% find endpoints of segment on epipolar line (for display purposes)
pt1 = closest_pt - [L(:,2) -L(:,1)] * 10; % offset from the closest point is 10 pixels
pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;

% display points and segments of corresponding epipolar lines
clf;

plot(eight_points(:,4), eight_points(:,5), '+r');
line([eight_points(:,4) closest_pt(:,1)]', [eight_points(:,5) closest_pt(:,2)]', 'Color', 'r');
line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');