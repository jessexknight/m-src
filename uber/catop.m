function [X] = catop(op,varargin)
varargin = cellfun(@(x)shiftdim(x,-1),varargin,'uniformoutput',0);
X = squeeze(op(cat(1,varargin{:})));


