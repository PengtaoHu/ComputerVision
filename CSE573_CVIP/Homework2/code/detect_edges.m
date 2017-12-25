function [FR]=detect_edges(im,FR,r0,time,threshold, sigma, threshold1,threshold2)


    dx=[-1 0 1];     % Derivative masks
    dy = dx';
    
    Ix = imfilter(im, dx, 'symmetric');    % Image derivatives
    Iy = imfilter(im, dy, 'symmetric');
    
    % Generate Gaussian filter of size 6*sigma (+/- 3sigma) and of
    % minimum size 1x1.
    g = fspecial('gaussian',max(1,fix(6*sigma)), sigma);
    
    Ix2 = imfilter(Ix.^2, g, 'symmetric'); % Smoothed squared image derivatives
    Iy2 = imfilter(Iy.^2, g, 'symmetric');
    Ixy = imfilter(Ix.*Iy, g, 'symmetric');
    
    v1=0.5*(Ix2+Iy2+(4*Ixy.^2+(Ix2-Iy2).^2).^0.5);
    v2=0.5*(Ix2+Iy2-(4*Ixy.^2+(Ix2-Iy2).^2).^0.5);
    
    maximum=max(max([v1,v2]));
    v1=v1./maximum*255;
    v2=v2./maximum*255;

    %count=0;
    %circles_count=0;
    edges=zeros(size(im));
    for i=1:size(im,1)%narrow edges
        for j=1:size(im,2)
            if(FR(i,j)<threshold&&v1(i,j)>threshold1&&v1(i,j)/v2(i,j)>threshold2||v2(i,j)>threshold1&&v2(i,j)/v1(i,j)>threshold2)
                %count=count+1;
                %cx(count)=i;
                %cy(count)=j;
                edges(i,j)=1;
            end
        end
    end
    limit=2-0.3*(time-1)/14;
    for i=1:size(im,1)%reject blobs on edges
        for j=1:size(im,2)
            if(edges(i,j)==1)
                for k=-3:3
                    for u=-3:3
                        if((k^2+u^2)^0.5<=limit&&i+k>0&&i+k<=size(im,1)&&j+u>0&&j+u<=size(im,2))
                            FR(i+k,j+u)=0;
                        end
                    end
                end
            end
        end
    end
    %{
    for i=1:size(im,1)
        for j=1:size(im,2)
            if(FR(i,j)>threshold)
                circles_count=circles_count+1;
                cx(circles_count)=i;
                cy(circles_count)=j;
            end
        end
    end
        %figure, imagesc(im), axis image, colormap(gray), hold on
        %plot(y,x,'b+','MarkerSize',3),plot(cy,cx,'ro','MarkerSize',5);
    %}
    
    