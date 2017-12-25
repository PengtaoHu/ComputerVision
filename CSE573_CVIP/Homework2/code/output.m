load('..\data\list.mat');
for i=1:length(list)
    path=['..\data\',list{i},'.jpg'];
    %blob_detection_ChangeFilter(path);
    %blob_detection_DoG(path);
    blob_detection_ResizeImage(path);
end