function [cmap] = blue(m)
% colormap: blue
if nargin < 1
   m = size(get(gcf,'colormap'),1);
end
r = zeros(1,m)';
g = zeros(1,m)';
b = linspace(0,1,m)';
cmap = [r,g,b];
