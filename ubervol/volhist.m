function [varargout] = volhist(I,N,varargin)
isize = size(I);
I = double(I(:));

[X,xop] = parseinputs(isize, varargin);
[U,I,ui] = definelevels(I,N);

H  = zeros([numel(U),1]);
XH = zeros([numel(U),size(X,2)]);
parfor u = 1:numel(U)
  idx  = (I == U(u));
  H(u) = mean(idx);
  if ~isempty(X)
    XH(u,:) = xop(X(idx,:),1);
  end
  pause(0);
end
H (isnan(H))  = 0;
XH(isnan(XH)) = 0;

if nargout == 0
    stem(H,'k','marker','none','linewidth',2);
end

[varargout] = {[H,XH],ui};

function [X,xop] = parseinputs(isize, vargs)
xop = @mean;
X = [];
x = 1;
for v = 1:numel(vargs)
    Vo = vargs{v};
    if isa(Vo,'function_handle')
        xop = Vo;
    elseif size(Vo) == isize;
        X(:,x) = double(Vo(:));
        x = x + 1;
    end
end

function [U,I,ui] = definelevels(I,N)
iminmax = [min(I),max(I)];
I  = floor(I*(N-1)/diff(iminmax));
U  = unique(I);
U  = min(U) : min(diff(U)) : max(U);
ui = iminmax(1) + diff(iminmax).*U;
