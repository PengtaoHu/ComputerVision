function[Labels]=rMNISTl(path,n)
%file_p = fopen('..\data\train-labels.idx1-ubyte','r','b'); % first we have to open the binary file
file_p = fopen(path,'r','b');
MagicNumber=fread(file_p,1,'int32');
nLabels= fread(file_p,1,'int32');% Read the number of labels
nLabels=min(nLabels,n);
Labels=zeros(10,nLabels);
fseek(file_p,8,'bof');
for i=1:nLabels
    label=fread(file_p,1,'uchar');
    if(label==0)
        label=10;
    end
    Labels(label,i)=1;
end