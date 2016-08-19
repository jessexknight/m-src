function [C] = nd2cell(I4)
for d = 1:size(I4,1)
  C{d} = squeeze(I4(d,:,:,:));
end
