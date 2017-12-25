source='..\data\part2\';
%{
im1 = imread([source,'house1.jpg']);
im2 = imread([source,'house2.jpg']);
matches = load([source,'house_matches.txt']); 
P1 = load([source 'house1_camera.txt']);
P2 = load([source 'house2_camera.txt']);
%}
im1 = imread([source,'library1.jpg']);
im2 = imread([source,'library2.jpg']);
matches = load([source,'library_matches.txt']); 
P1 = load([source 'library1_camera.txt']);
P2 = load([source 'library2_camera.txt']);

im1=rgb2gray(im1);
im2=rgb2gray(im2);
[~,~,V]=svd(P1);
C1=V(:,end);
C1=C1/C1(4,1);
[~,~,V]=svd(P2);
C2=V(:,end);
C2=C2/C2(4,1);
N=size(matches,1);
equation=zeros(4,4);

im=zeros(max(size(im1,1),size(im2,1)),size(im1,2)+size(im2,2));
im(1:size(im1,1),1:size(im1,2))=im1;
im(1:size(im2,1),size(im1,2)+1:size(im1,2)+size(im2,2))=im2;
figure(1),imagesc(im),axis image, colormap(gray), hold on;

for i=1:size(matches,1)
    y=[matches(i,2) matches(i,4)];
    x=[matches(i,1) size(im1,2)+matches(i,3)];
    plot(x,y,'r--*');
    text(matches(i,1),matches(i,2),num2str(i),'Color','green');
    text(size(im1,2)+matches(i,3),matches(i,4),num2str(i),'Color','green');
end

X=zeros(168,4);
for i=1:N
    equation(1,:)=matches(i,1)*P1(3,:)-P1(1,:);
    equation(2,:)=matches(i,2)*P1(3,:)-P1(2,:);
    equation(3,:)=matches(i,3)*P2(3,:)-P2(1,:);
    equation(4,:)=matches(i,4)*P2(3,:)-P2(2,:);
    [~,~,V]=svd(equation);
    X(i,:) = V(:,end)';
    X(i,:)=X(i,:)/X(i,4);
end
figure(2);
plot3(C1(1),C1(2),C1(3),'*r');hold on;
plot3(C2(1),C2(2),C2(3),'*r');
plot3(X(:,1),X(:,2),X(:,3),'.k');

%{
%lines for house
lines(1,:)=[12,63,1,0,0];
lines(2,:)=[63,64,1,0,0];
lines(3,:)=[12,13,1,0,0];
lines(4,:)=[13,64,1,0,0];
lines(5,:)=[1,3,0,0,1];
lines(6,:)=[14,15,0,0,1];
lines(7,:)=[1,15,0,0,1];
lines(8,:)=[3,14,0,0,1];
lines(9,:)=[14,80,0,1,0];
lines(10,:)=[80,30,0,1,0];
lines(11,:)=[30,20,0,1,0];
lines(12,:)=[20,14,0,1,0];
lines(13,:)=[100,135,1,1,0];
lines(14,:)=[135,157,1,1,0];
lines(15,:)=[157,134,1,1,0];
lines(16,:)=[134,111,1,1,0];
lines(17,:)=[111,100,1,1,0];
lines(18,:)=[121,168,0,1,1];
lines(19,:)=[168,161,0,1,1];
lines(20,:)=[161,123,0,1,1];
lines(21,:)=[123,121,0,1,1];
%}

lines(1,:)=[297,301,1,0,0];
lines(2,:)=[301,217,1,0,0];
lines(3,:)=[217,297,1,0,0];
lines(4,:)=[298,299,0,0,1];
lines(5,:)=[299,300,0,0,1];
lines(6,:)=[300,298,0,0,1];
lines(7,:)=[225,242,0,1,0];
lines(8,:)=[242,124,0,1,0];
lines(9,:)=[124,147,0,1,0];
lines(10,:)=[147,225,0,1,0];
lines(11,:)=[239,150,1,1,0];
lines(12,:)=[150,212,1,1,0];
lines(13,:)=[212,239,1,1,0];
lines(14,:)=[271,178,0,1,1];
lines(15,:)=[178,108,0,1,1];
lines(16,:)=[108,271,0,1,1];

for i=1:size(lines,1)
    plot3([X(lines(i,1),1),X(lines(i,2),1)],[X(lines(i,1),2),X(lines(i,2),2)]...
        ,[X(lines(i,1),3),X(lines(i,2),3)]...
        ,'Color',lines(i,3:5),'LineStyle','-');
end

