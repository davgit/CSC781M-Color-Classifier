pkg load image;
pkg load signal;
close all;

% (1) Read and display the image
I = imread('sample.png');
% imshow(I);
% title("Original sample image");

% (2) Convert to CIELab colorspace
LAB = RGB2Lab(I);

% (10)  "First we initialize a color label array img(i, j )"
img = zeros(120,120);

%       "and a mask array imgm(i, j)"
imgm = ones(120,120);
%        This mask array determines whether an image pixel 
%        is still considered to be part of the data set 
%        for cluster detection, or whether it has already
%        been classified.

% (11) "compute the histograms of the color features c1, c2, and c3, one by one."

number_of_bins = 128;

% [b, c] = classifyImageRegions(img, imgm, LAB,0);
 [b, c] = try2classify(LAB, img, imgm, number_of_bins, 0);

img = b;
imgm = c;

m = max(max(img));

if (m == 0)
  img = img ./ m;
endif

imshow(mat2gray(img));
title(strcat("You win!"));
% plot(img);
