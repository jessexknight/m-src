function [pY,YU,U] = pofy(Y,varargin)
% varargin: N  - number of bins
%           mi - minmax (input)
%           mo - minmax (output)
[YU,U] = biny(Y,varargin{:});
YUX = YU(:);
% calculating probabilities
% (kill already counted for speed)
pY = nan(1,numel(U));
for u = 1:numel(U)
  idx      = (YUX==U(u));
  pY(u)    = sum(idx);
  YUX(idx) = [];
end
pY = pY./numel(Y);
