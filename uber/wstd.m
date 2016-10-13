% [mu] = wstd(Y,X)
% 
% WSTD gives the standard deviation of Y, weighted by X
% 
% Jesse Knight 2016

function [sig] = wstd(Y,X)
sig = sqrt(sum(((Y(:)-wmean(Y,X)).^2).*X(:)) / sum(X(:)));