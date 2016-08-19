function [pks] = ndpeaks(I)
I     = double(I);
isize = size(I);
pks   = zeros(isize);
nd    = numel(isize);
for d = 1:nd
  IX      = shiftdim(I,d-1);
  xsize   = size(IX);
  PX      = zeros(xsize);
  [~,idx] = findpeaks(IX(:));
  PX(idx) = 1;
  P       = logical(shiftdim(PX,nd+1-d));
  pks(P)  = pks(P) + 1;
end

  
  
  