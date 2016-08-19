function [str] = parsepath(str)
for s = 1:numel(str)
  fprintf('%s',str(s));
  if str(s) == ';'
    fprintf('\n');
  end
end
fprintf('\n');

