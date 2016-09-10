function [DI] = divfilter(I)
[~,E] = edgefilter(I,'diff');
DI = divergence(E{:});
