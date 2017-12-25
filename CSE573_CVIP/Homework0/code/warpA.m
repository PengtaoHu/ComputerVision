function [ warp_im ] = warpA( im, A, out_size )
A=A^-1;
warp_im=zeros(out_size(1),out_size(2));
%% 1 Find the nearest.
%{
for i=1:out_size(1)%Sorry. I can't figure out without loops.
    for j=1:out_size(2)
        T=round(A*[j,i,1]');
        if(T(1)>0&&T(1)<=out_size(2)&&T(2)>0&&T(2)<=out_size(1))
            warp_im(i,j)=im(T(2),T(1));
        end
    end
end
%}
%% 2 Compounded.Proportion decided by distance.
for i=1:out_size(1)%Sorry. I can't figure it out without loops.
    for j=1:out_size(2)
        T=A*[j,i,1]';
        P=cell(1,4);
        P{1,1}=[floor(T(1)),floor(T(2)),1]';
        P{1,2}=[ceil(T(1)),floor(T(2)),1]';
        P{1,3}=[floor(T(1)),ceil(T(2)),1]';
        P{1,4}=[ceil(T(1)),ceil(T(2)),1]';
        S=0;
        for k=1:4
            if(P{1,k}(1)>0&&P{1,k}(1)<=out_size(2)&&P{1,k}(2)>0&&P{1,k}(2)<=out_size(1))
                D=1/norm(T-P{1,k});
                S=S+D;
                warp_im(i,j)=warp_im(i,j)+im(P{1,k}(2),P{1,k}(1))*D;
            end
        end
        if(S>0)
            warp_im(i,j)=warp_im(i,j)/S;
        end
    end
end
