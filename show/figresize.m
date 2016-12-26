function [] = figresize(h,fsize)
% resizes the current figure while maintaining roughly the same position.
% if figure goes offscreen, re-adjusts to try to keep onscreen, but still
% permits figures larger than screensize.
cfpos    = get(h,'position');
sizediff = fsize-cfpos(3:4);
pos      = [cfpos(1:2)-sizediff/2,fsize];
% minmax   = [pos(1:2),pos(1)+pos(3),pos(2)+pos(4)];
% screen   = get(0,'screensize');
% dir      = [+1,+1,-1,-1];
% oob      = min(0,(dir.*minmax) + screen);
% hor = [1,3]; ver = [2,4];
% pos(hor) = pos(hor) + oob(hor(1)) + oob(hor(2));
% pos(ver) = pos(ver) + oob(ver(1)) + oob(ver(2));
set(h,'position',pos);