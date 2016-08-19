function [BB,A] = biggestbw(B)
BW = bwlabeln(B);
A  = 0;
bb = 1;
for b = 1:numel(unique(BW));
  Ab = sum(BW(:)==b);
  if Ab > A
    A = Ab;
    bb = b;
  end
end
BB = (BW == bb);
