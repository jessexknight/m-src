function [] = figresize(h,fsize)
% resizes the current figure while maintaining roughly the same position.
cfpos    = get(h,'position');
sizediff = fsize-cfpos(3:4);
pos      = [cfpos(1:2)-sizediff/2,fsize];
set(h,'position',pos);