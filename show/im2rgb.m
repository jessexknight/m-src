% IM2RGB converts an image (2D or 3D) from grayscale to color using the a
%        specified colormap.
% 
% Input:
%    images    - any image (2D or 3D)
% 
%    map       - colormap (Mx3) matrix
%                e.g. result from calling any of MATLAB default colormaps.
% Dependencies:
% 
%    biny      - function for binning data, for lookup in map array.
% 
% Examples:
% 
%    >> I = imread('moon.tif');
%    >> timshow(im2rgb(I,gray),im2rgb(I,jet));
%    Load the moon image. Show it side by side in grayscale & with jet colormap.
% 
% Jesse Knight 2016

function [RGB] = im2rgb(I,map)
% get the size of the colormap
M = size(map,1);
% bin the image data
IU = biny(I,[],[1,M],M);
% parse the RGB channels
RGB(:,1) = map(IU,1);
RGB(:,2) = map(IU,2);
RGB(:,3) = map(IU,3);
% reshape to the appropriate size
RGB = reshape(RGB,[size(I),3]);

