function [X] = nanterp(X,varargin)
X(isnan(X)) = interp1(find(~isnan(X)), X(~isnan(X)), find(isnan(X)), varargin{:}); 