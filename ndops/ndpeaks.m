% [pks] = ndpeaks(X)
% 
% NDPEAKS finds all peaks in the N-D array X, in all directions. For each
%   direction, local maxima are incremented by 1. Thus, true local maxima will
%   have pks == N for N-D array X, while local maxima in only some directions
%   will have 0 < pks < N. Edges will only have maxima in the non-truncated
%   directions. This method is very fast to find absolute peaks.
% 
% Inputs:
%   X  - N-D array of real-valued data
% 
% Outputs:
%  pks - N-D array (same size as X) comprising the number of direction-specific
%        peaks. Likely (pks == N) will be of most use.
% 
% Jesse Knight 2016

function [pks] = ndpeaks(X)
I     = double(X);
xsize = size(X);      % track input size
pks   = zeros(xsize); % initialize the output
nd    = numel(xsize); % num dim
for d = 1:nd % for all dimensions...
  XN        = shiftdim(X,d-1);  % shift the orientation
  xnsize    = size(XN);         % get size
  PN        = zeros(xnsize);    % initialize peak array in this orientation
  [~,idx]   = findpeaks(XN(:)); % find peaks in rastarized domain
  PN(idx)   = 1;                % logical mapping back to N-D space
  PN(1,:)   = 0;                % ignore the wrapped edges
  PN(end,:) = 0;                % ...
  P         = logical(shiftdim(PN,nd+1-d)); % map back to original orientation
  pks(P)    = pks(P) + 1;       % increment the global peak map
end
  