function [] = axfcn(fig,fcn)
H = findobj(fig,'type','axes');
for h = 1:numel(H)
  fcn(H(h));
end