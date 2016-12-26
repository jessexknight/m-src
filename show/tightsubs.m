% TIGHTSUBS is a function for flexible fine tune control over subplot spacing.
% 
% Input arguments:
%    nx, ny    - the number of plots in x and y directions, respectively.
% 
%    ax        - handles to existing subplots for spacing.
% 
%    pad       - the padding around each axis relative to the total figure size.
%                (3 options by size):
%                1. Scalar     - same amount to all axes, all sides
%                2. 4 Vector   - same amount to all axes: left bottom right top
%                3. Nx4 Matrix - different amout for each of N axes, same order
% 
% Jesse Knight 2016

function [] = tightsubs(nx,ny,ax,pad)
if isscalar(pad)
  pad = 0.5*pad*ones(1,4);
end
if isvector(pad)
  pad = ones(nx*ny,1)*pad;
end
for i = 1:numel(ax)
    [x,y] = ind2sub([nx, ny], i);
    set(ax(i),'position',[((x - 1) / nx)  +  pad(i,1),          ...
                           (1 - (y / ny)) +  pad(i,2),          ...
                                (1 / nx)  - (pad(i,1) + pad(i,3)), ...
                                (1 / ny)  - (pad(i,2) + pad(i,4))]);
end