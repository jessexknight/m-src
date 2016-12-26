% [G] = gaussx(mu,sig,win)
% 
% GAUSS generates an N-D Gaussian probability density function having the mean
%   and standard deviations specified in the vectors mu and sig, and cropped to
%   the size win. The mean mu is treated as an offset from the center of win.
% 
% Jesse Knight 2016

function [G] = gaussx(mu,sig,win)
N = numel(mu);  % num dims
X = cell(1,N);  % N-D grid coordinates
for n = 1:N
  R{n} = (-win(n)/2+0.5 : win(n)/2-0.5); % sampling points in each dim
end
[X{:}] = ndgrid(R{:},1); % transform to grid N-D arrays
for n = 1:N
  X{n} = X{n}(:); % vectorize the grids for mvnpdf below
end
G = mvnpdf(cat(2,X{:}),mu,sig); % compute vectorized kernel values
G = reshape(G,cat(2,win,1)); % reshape to N-D array
