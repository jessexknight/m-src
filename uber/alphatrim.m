function [idx, ytrims] = alphatrim(Y, trims, mask)
if ~isempty(mask)
  YB = Y(logical(mask));
  if isempty(YB)
    idx = []; ytrims = []; return;
  end
else
  YB = Y(:);
end
NY     = numel(YB);
[YS]   = sort(YB);
ntrims = NY.*trims;
ytrims = [YS(round(max(1, ntrims(1)))),...
          YS(round(min(NY,ntrims(2))))];
idx    = (Y > ytrims(1)) & (Y < ytrims(2));

