% Jesse Knight 2015
% IAMLAB
%
% This function computes the magnitude of a matrix along a single dimension,
%   usefule for vector image (e.g. colour) processing.
%
% [A] = MAGNITUDE(A, dim, type)
%
% Inputs:
%   A      - Input matrix
%   dim    - Dimension along which to compute the magnitude
%   method - One of:
%            'euclidean' - RMS of all components in dimension dim
%            'cityblock' - sum all components in dimension dim
% 
% Outputs:
%   M      - Matrix of size(A), except dimension dim is singleton
%            representing the magnitude of vectors

function [M] = magnitude(A,varargin)

asize = size(A);
[dim, distfun] = parseargs(numel(asize), varargin);

switch distfun
    case 'cityblock'
        M = sum(A, dim);
    case 'euclidean'   
        M = sqrt(sum(A.^2, dim));
end

function [dim, distfun] = parseargs(dim, vargs)

distfun = 'euclidean';

for v = 1:numel(vargs)
    if ischar(vargs{v})
        switch vargs{v}
            case 'euclidean'
                distfun = 'euclidean';
            case 'cityblock'
                distfun = 'cityblock';
        end
    elseif isnumeric(vargs{v}) && all(size(vargs{v} == [1,1]))
        dim = vargs{v};
    else
        warning(['Ignoring Argument ',num2str(v)]);
    end
end