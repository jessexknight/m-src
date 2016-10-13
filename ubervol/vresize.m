function [IO] = vresize(I,vsize,varargin)
isosize  = size(I).*vsize;
[y,x,z]  = ndgrid(linspace(1,size(I,1),isosize(1)),...
                  linspace(1,size(I,2),isosize(2)),...
                  linspace(1,size(I,3),isosize(3)));
IO = interpn(double(I),y,x,z,varargin{:});
% what about just:
% I = imresize(I,isize.*[vsize(1),vsize(2)],'method','bilinear');
% 2D only? Faster?
