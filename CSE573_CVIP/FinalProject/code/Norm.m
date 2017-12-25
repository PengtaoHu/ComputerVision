%%change the range of "mat" to 0,1,2..."n".
function [mat]=Norm(mat,n)
mat=double(mat);
maxi=max(max(mat));
mini=min(min(mat));
mat=(mat-mini)/(maxi-mini)*n;
mat=uint8(mat);