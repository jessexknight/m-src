function [] = dirdelete(dir,deletestr)
% generate random key
key = round(999*rand(1));
% warn the user and ask for the key
validstr = input(['WARNING:\n',...
                  'Deleting all files containing: *',repsep(deletestr,'/'),'*\n',...
                  '             in the directory: ',repsep(dir,'/'),'\n',...
                  '       Type ''',num2str(key,'%03.f'),''' to continue: ']);
% abort unless keys match
if validstr == key
  fprintf('DELETING...\n');
else
  fprintf('ABORTED\n');
  return
end
% do the deleting, and tell the user
k = 1;
D = rdir(dir);
for d = 1:numel(D)
  if strfind(D(d).pathname,deletestr)
    fprintf('  %03.f > Deleting: %s\n', k, repsep(D(d).pathname,'/'));
    delete(D(d).pathname);
    k = k + 1;
  end
end
fprintf('DONE\n');

% work around funky slash printing
function [name] = repsep(name,sep)
name = strrep(strrep(name,'\',sep),'/',sep);

