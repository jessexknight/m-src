function [names] = mendeleynames(str)
pat = '(?<first>\w+)\s+(?<last>\w+)|(?<last>\w+),\s+(?<first>\w+)';
names = regexp(str,pat,'names');
if nargout == 0
  for n = 1:numel(names)
    fprintf('%s, %s\n',names(n).last,names(n).first);
  end
end