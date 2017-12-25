function[Images]=rMNISTim(path,n)
%file_p = fopen('../data/train-images.idx3-ubyte','r','b'); % first we have to open the binary file
file_p = fopen(path,'r','b');
MagicNumber=fread(file_p,1,'int32');
nImages= fread(file_p,1,'int32');% Read the number of images
nRows= fread(file_p,1,'int32');% Read the number of rows in each image
nCols= fread(file_p,1,'int32');% Read the number of columns in each image
nImages=min(nImages,n);
Images=cell(1,nImages);
fseek(file_p,16,'bof');
img2=zeros(28,28);
for i=1:nImages
    img= fread(file_p,28*28,'uchar');% each image has 28*28 pixels in unsigned byte format
    for k=1:28
        img2(k,:)=img((k-1)*28+1:k*28);
    end   
    img1=img2;
    %img1(:,:)=img2(5:24,5:24);
    img=img1./255;
    %imshow(img);
    Images{i}=img;
end