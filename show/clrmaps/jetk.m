function J = jetk(m)
%JETK    Variant of JET
%   JETK(M), a variant of HSV(M), is an M-by-3 matrix containing
%   the default colormap used by CONTOUR, SURF and PCOLOR.
%   The colors begin with black, range through shades of
%   blue, cyan, green, yellow and red, and end with dark red.
%   JET, by itself, is the same length as the current figure's
%   colormap. If no figure exists, MATLAB creates one.
%
%   See also HSV, HOT, PINK, FLAG, COLORMAP, RGBPLOT.

%   Copyright 1984-2004 The MathWorks, Inc.
%   $Revision: 5.7.4.2 $  $Date: 2005/06/21 19:31:40 $

if nargin < 1
   m = size(get(gcf,'colormap'),1);
end
m1 = round(m*15/16);
m0 = m - m1 + 1;
J = jet(m1);
bk = linspace(0,J(1,3),m0)';
rk = zeros(size(bk));
gk = zeros(size(bk));
k  = [rk,gk,bk];
J  = [k;J(2:end,:)];



