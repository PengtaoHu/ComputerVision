function [F_ans]=fit_fundamental_RANSAC(matches,im1,im)
points_vector=zeros(9,8);
F=zeros(3);
eight_points=zeros(8,4);
itinerary=ceil(size(matches,1)^2.5);
error_ans_count=inf;
threshold_error=2;
error=zeros(size(matches,1),1);

for i=1:itinerary
    perm=randperm(size(matches,1));
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
%{
    for j=1:8
        y=[eight_points(j,2) eight_points(j,4)];
        x=[eight_points(j,1) size(im1,2)+eight_points(j,3)];
        plot(x,y,'r--*');
    end
%}
    [U,S,V]=svd(points_vector); 
    F_vector = U(:,8);    

    F(1,:)=F_vector(1:3,1);
    F(2,:)=F_vector(4:6,1);
    F(3,:)=F_vector(7:9,1);

    error_count=0;
    for j=1:size(matches,1)
        y2=[matches(j,3) matches(j,4) 1]';
        y1=[matches(j,1) matches(j,2) 1]';
        y=[matches(j,2) matches(j,4)];
        x=[matches(j,1) size(im1,2)+matches(j,3)];
        line0=F*y1;
        error(j)=y2'*line0/(line0(1)^2+line0(2)^2)^0.5;
        if(abs(error(j))>threshold_error)
            error_count=error_count+1;
            %plot(x,y,'b--o');
        else
            %plot(x,y,'r--o');
        end
        if(error_count>error_ans_count)
            break;
            continue;
        end
    end
    if(error_count<error_ans_count)
        F_ans=F;
        error_ans_count=error_count;
        eight_points_ans=eight_points;
        
        figure(1),clf(),imagesc(im),axis image, colormap(gray), hold on;
        N=size(matches,1);
        L = (F * [matches(:,1:2) ones(N,1)]')';
        
        L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
        pt_line_dist = error;
        error_s=sort(abs(error));
        mean_dis_inliner_ans=mean(error_s(1:N-error_count));
        closest_pt = matches(:,3:4) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);
        
        pt1 = closest_pt - [L(:,2) -L(:,1)] * 10; % offset from the closest point is 10 pixels
        pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;
        
        for j=1:size(matches,1)
            if(abs(error(j))>threshold_error)
                color='y';
            else
                color='g';
            end
            plot(matches(j,3)+size(im1,2),matches(j,4),'r+');
            line([matches(j,3)+size(im1,2) closest_pt(j,1)+size(im1,2)]',[matches(j,4) closest_pt(j,2)]', 'Color',color);
            line([pt1(j,1)+size(im1,2) pt2(j,1)+size(im1,2)]', [pt1(j,2) pt2(j,2)]', 'Color',color);
        end
        %}
    end
end
%{
for j=1:8
    y=[eight_points_ans(j,2) eight_points_ans(j,4)];
    x=[eight_points_ans(j,1) size(im1,2)+eight_points_ans(j,3)];
    plot(x,y,'r--*');
end
%}