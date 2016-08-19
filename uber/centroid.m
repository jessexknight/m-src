function [cen] = centroid(BW)
RP = regionprops(BW,'Centroid');
cen = RP.Centroid;
cen([1,2]) = cen([2,1]);