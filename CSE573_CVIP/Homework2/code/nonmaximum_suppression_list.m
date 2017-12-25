function[circles_new]=nonmaximum_suppression_list(circles,count)

for i=count:-1:1
    if(circles(i,4)==0)
        continue;
    end
   for j=count:-1:1
        if(circles(j,4)==0)
            continue;
        end
        d=((circles(i,1)-circles(j,1))^2+(circles(i,2)-circles(j,2))^2)^0.5;
        dr=abs(circles(i,3)-circles(j,3));
        if(d<max(circles(i,3),circles(j,3))&&(d>=dr-1/2*min(circles(i,3),circles(j,3))||d<1/2*min(circles(i,3),circles(j,3))))
            if(circles(i,4)<circles(j,4))
                circles(i,4)=0;
                break;
            end
        end
    end
end
count_new=0;
for i=1:count
    if(circles(i,4)>0)
        count_new=count_new+1;
        circles_new(count_new,1)=circles(i,1);
        circles_new(count_new,2)=circles(i,2);
        circles_new(count_new,3)=circles(i,3);
    end
end
