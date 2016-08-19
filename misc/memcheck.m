function [memratio] = memcheck(X,nk)
Mdata = memory;
Xdata = whos('X');
memratio = (Xdata.bytes*nk) / Mdata.MaxPossibleArrayBytes;
if memratio > 1
  if nargout == 0
    error('Failed memory check: data too big!');
  end
end