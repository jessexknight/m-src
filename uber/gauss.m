function [G] = gauss(sig)
% N-D Gaussian Kernel (just give N sigs)
% guarenteed unit norm.

N = numel(sig);
X = cell(1,N);
W = cell(1,N);
for n = 1:N
  R{n} = floor(-4*sig(n)):ceil(+4*sig(n));
end
[X{:}] = ndgrid(R{:},1);
W(:)   = cellfun(@numel,R,'uni',false);
for n = 1:N
  X{n} = X{n}(:);
end
G = mvnpdf(cat(2,X{:}),zeros(1,N),sig);
G = reshape(G,cat(2,W{:},1));
G = G./sum(G(:));