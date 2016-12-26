function [cmap] = green(m)
% colormap: green
if nargin < 1
   m = size(get(gcf,'colormap'),1);
end
r = zeros(1,m)';
g = linspace(0,1,m)';
b = zeros(1,m)';
cmap = [r,g,b];
