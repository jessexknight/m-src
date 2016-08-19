function [H,XH] = clrhistpairdata(V,X)

vsize  = size(V);
clrdim = find(vsize == 3);
dims = 1:10;
dims = [clrdim,dims(dims~=clrdim)];
VP = permute(V,dims);

step = max(0.01*range(V(:)), min(diff(unique(sort(V(:))))));
bins = [min(V(:)) : step : max(V(:))]';
nb = numel(bins);
H  = zeros([nb,nb,nb]);
XH = zeros([nb,nb,nb]);

for i = 1:numel(VP(1,:))
    clrs = ceil(VP(:,i)*(nb-1)) + 1;
    H (clrs(1),clrs(2),clrs(3)) = H (clrs(1),clrs(2),clrs(3)) + 1;
    XH(clrs(1),clrs(2),clrs(3)) = XH(clrs(1),clrs(2),clrs(3)) + X(i);
end

XH = XH./H;


