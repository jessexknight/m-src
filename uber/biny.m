function [YB,U] = biny(Y,varargin)
Y = double(Y);
minmax = [min(Y(:)),max(Y(:))];
% parse args
[mi,mo,N] = parseargs(minmax,varargin);
% bin data
% if numel(unique(Y)) < N*2
%   Y = Y + 0.02*std(Y)*randn(size(Y)); % hack to avoid aliasing
% end
[YB] = binit(Y,mi,mo,N);
% bin dummy data
[U] = binit(linspace(mi(1),mi(2),N),mi,mo,N);

function [YB] = binit(Y,mi,mo,N)
% saturate with input minmax
YS = min(mi(2),max(mi(1),Y));
% bin to 0:1
YL = round(((YS - mi(1)) ./ diff(mi)) .* (N-1)) ./ (N-1);
% scale to output minmax
YB = (YL .* diff(mo)) + mo(1);

function [minmaxi,minmaxo,N] = parseargs(minmax,vargs)
% defaults
N       = 256;
minmaxi = minmax;
minmaxo = [0,1];
% parsing
nminmax = 0;
for v = 1:numel(vargs)
  if (numel(size(vargs{v})) == 2) % must be 2D
    if     (all(size(vargs{v}) == [1,1])) % N
      N = vargs{v};
    elseif (all(size(vargs{v}) == [1,2])) % minmax
      if nminmax == 0       % input specified
        minmaxi = vargs{v};
        nminmax = 1;
      elseif nminmax == 1   % output too
        minmaxo = vargs{v};
        nminmax = -1;
      end
    elseif isempty(vargs{v}) && isnumeric(vargs{v})
      if nminmax == 0       % input specified (default)
        minmaxi = minmax;
        nminmax = 1;
      elseif nminmax == 1   % output too (default)
        minmaxo = minmax;
        nminmax = -1;
      end
    end
  end
end

