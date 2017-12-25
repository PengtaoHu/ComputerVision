% Problem 1: Image Alignment

%% 1. Load images (all 3 channels)
load('..\data\red.mat');
load('..\data\green.mat');
load('..\data\blue.mat');
%% 2. Find best alignment
% Hint: Lookup the 'circshift' function
rgbResult = alignChannels(red, green, blue);
imshow(rgbResult);

%% 3. Save result to rgb_output.jpg (IN THE "results" folder)
set(gcf, 'Color', [1 1 1]);
set(gcf, 'PaperPositionMode', 'auto');
outname = fullfile('../results/', 'rgb_output.jpg');
saveas(gcf, outname);