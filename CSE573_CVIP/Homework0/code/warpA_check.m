function warp_im=warpA_check(im, A, out_size)
A = A(1:2, :)';
tform = maketform( 'affine', A);
 % change 'nearest' to 'bilinear' to compare with 'warpAbilinear'
warp_im = imtransform( im, tform, 'nearest', ...
'XData', [1 out_size(2)], ...
'YData', [1 out_size(1)], 'Size', out_size );

end
