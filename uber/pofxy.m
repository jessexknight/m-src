function [pXY,pY] = pofxy(Y,X,op,varargin)
% binning source data values & storing bins
[YU,U] = biny(Y,varargin{:});
% calculating source and paired data probabilities
[YS,s] = sort(YU(:));            % sorting source data
XS     = X(s);                   % sorting paired data same order
% counting source data bins (histogram)
% (kill already counted for speed)
%clearvars('Y','X','s'); % cleanup memory
NY = nan(1,numel(U));
for u = 1:numel(U)
  idx     = (YS(:)==U(u));
  NY(u)   = sum(idx);
  YS(idx) = [];
end
% finish calculations
pY     = NY'./numel(XS);         % source data probability (normalizing)
NYC    = [0,cumsum(NY)];         % indexing ranges in sorted XS
pXY    = zeros(numel(U),1);      % calculating paired image histogram:
for u = 1:numel(U)
  if NYC(u+1) > NYC(u)+1
    pXY(u,:) = op(XS(NYC(u)+1:NYC(u+1)));
  else
    pXY(u,:) = nan;
  end
end

