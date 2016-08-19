function [IO] = vollvl(V,nlvls)
V = double(V);
lvls = linspace(min(V(:)),max(V(:)),nlvls);
IO = zeros(size(V));
for x = 2:numel(lvls)
    ilvl = (V >= lvls(x-1) & V <= lvls(x));
    Vlvl = V(ilvl);
    IO(ilvl) = mean(Vlvl);
end
