function[FR]=nonmaximum_suppression_matrix(FR,r0,threshold)

r=floor(r0);
for i=1:size(FR,1)
    for j=1:size(FR,2)
        if(FR(i,j)>threshold)
            for k=-r:r
                for u=0:r
                    if(i+k<1||i+k>size(FR,1)||j+u>size(FR,2)||(k==0&&u==0))
                        continue;
                    end
                    if(FR(i,j)>FR(i+k,j+u))
                        FR(i+k,j+u)=0;
                    elseif(FR(i,j)<=FR(i+k,j+u))
                        FR(i,j)=0;
                        break;
                    end
                end
                if(FR(i,j)<threshold)
                    break;
                end
            end
        end
    end
end