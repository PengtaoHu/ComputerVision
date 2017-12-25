%%Integration of color and texture cues in a rough set¨Cbased segmentation method
im_path='..\data\test6.jpg';
d=10;%standard deviation map window size
Ex=320/1.2;%distance threshold for X
Wd=3;%neighbors window size
w=[1.6 0.15 0.15];%weights of channels
im0=imread(im_path);
Tm=size(im0,1)*size(im0,2)*0.002;%mass threshold for merging
Ts=35;%similarity threshold for merging
im1=rgb2lab(im0);%color space transformation
im=im1;

%intensity adjustment
rangea0=max(max(im(:,:,2)))-min(min(im(:,:,2)));
rangeb0=max(max(im(:,:,3)))-min(min(im(:,:,3)));
rangea=round(200*rangea0/(rangea0+rangeb0));
rangeb=round(200*rangeb0/(rangea0+rangeb0));
rangea=min(100,min(rangea,rangea0*2.5));
rangeb=min(100,min(rangeb,rangeb0*2.5));
im(:,:,2)=Norm(im(:,:,2),rangea);
im(:,:,3)=Norm(im(:,:,3),rangeb);

X_a=getX(im(:,:,2),Ex,Wd,w);
    imshow(X_a);
    saveas(gcf,'..\record\20_a.jpg');
seg_a=RSBsegment(im(:,:,2),X_a);
    ShowBorder(Norm(im(:,:,2),255),getBorder(seg_a));
    saveas(gcf,'..\record\21_a.jpg');
seg_a=Merge(im(:,:,2),seg_a,Tm,Ts*rangea/(rangea+rangeb),X_a);
    ShowBorder(Norm(im(:,:,2),255),getBorder(seg_a));
    saveas(gcf,'..\record\22_a.jpg');

X_b=getX(im(:,:,3),Ex,Wd,w);
    imshow(X_b);
    saveas(gcf,'..\record\30_b.jpg');
seg_b=RSBsegment(im(:,:,3),X_b);
    ShowBorder(Norm(im(:,:,3),255),getBorder(seg_b));
    saveas(gcf,'..\record\31_b.jpg');
seg_b=Merge(im(:,:,3),seg_b,Tm,Ts*rangeb/(rangea+rangeb),X_b);
    ShowBorder(Norm(im(:,:,3),255),getBorder(seg_b));
    saveas(gcf,'..\record\32_b.jpg');

X_ab=getX(im,Ex,Wd,[0 0.85 0.85]);
    imshow(X_ab);
border=getBorder(seg_a)+getBorder(seg_b);
    ShowBorder(im0,border);
seg=reSeg(border);
    ShowBorder(im0,getBorder(seg));
    saveas(gcf,'..\record\40_Lab.jpg');
im_ab=im;
im_ab(:,:,1)=zeros(size(im,1),size(im,2),1);
seg=Merge(im_ab,seg,Tm,Ts,X_ab);
    ShowBorder(im0,getBorder(seg));
    saveas(gcf,'..\record\41_Lab.jpg');

im(:,:,1)=StdMap2(im1(:,:,1),d,seg);
    imshow(Norm(im(:,:,1),255));
    saveas(gcf,'..\record\50_SDM.jpg');
im(:,:,1)=Norm(im(:,:,1),100);
X=getX(im,Ex,Wd,w);
    imshow(X);
    saveas(gcf,'..\record\51_X.jpg');

X_L=getX(im(:,:,1),Ex*1.1,Wd,w);
    imshow(X_L);
    saveas(gcf,'..\record\60_L.jpg');
seg_L=RSBsegment(im(:,:,1),X_L);
    ShowBorder(Norm(im(:,:,1),255),getBorder(seg_L));
    saveas(gcf,'..\record\61_L.jpg');
seg_L=Merge(im(:,:,1),seg_L,Tm,Ts,X_L);
    ShowBorder(Norm(im(:,:,1),255),getBorder(seg_L));
    saveas(gcf,'..\record\62_L.jpg');

border=border+getBorder(seg_L);
seg=reSeg(border);
    ShowBorder(im0,getBorder(seg));
    saveas(gcf,'..\record\70_Lab.jpg');
seg=Merge(im,seg,Tm,Ts,X);
    ShowBorder(im0,getBorder(seg));
    saveas(gcf,'..\record\71_Lab.jpg');