function [] = tightsubs(nx,ny,ax,pad)
if isscalar(pad)
  pad = 0.5*pad*ones(4,1);
end
for i = 1:numel(ax)
    [x,y] = ind2sub([nx, ny], i);
    set(ax(i),'position',[((x - 1) / nx)  + pad(1),          ...
                           (1 - (y / ny)) + pad(2),          ...
                                (1 / nx)  - (pad(1) + pad(3)), ...
                                (1 / ny)  - (pad(2) + pad(4))]);
end