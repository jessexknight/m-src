function [YO] = alphatrimfill(Y, trims, istrim, mask)
% find alphatrims
[~,ytrims] = alphatrim(Y(mask), trims, 0);
% find locations to fill (elements outside alphatrims)
idx = (istrim(1).*(Y < ytrims(1)) | istrim(2)*(Y > ytrims(2)));
if ~isempty(mask)
  idx = idx & (mask);
end
Y(idx) = nan;
% use nan-inpaiting function to fill (3D+ border nans beware, this is 2D)
YO = cast(reshape(inpaint_nans(double(Y),5),size(Y)),class(Y));

