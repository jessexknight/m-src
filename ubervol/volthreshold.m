function [R] = volthreshold(V,thr)
R = zeros(size(V));

for t = 2:numel(thr)
    R(V >= thr(t-1) & V <= thr(t)) = t-1;
end