% Jesse Knight
% 2015
% Courselink Group submission unpacking

function [D] = groupunpack(directory)
templatekeyword = ' Group $ ';
templatedirname = [directory,'\Group $\'];

if exist(directory,'dir')
  dirnumzeropad(directory,2,{'- Group ',' - '});
  D = dir(directory);
else
  error(['Could not find directory: ''',directory,'''']);
end

for g = 1:100
  % define group keyword and dir name
  keyword = strrep(templatekeyword,'$',num2str(g,'%02d'));
  dirname = strrep(templatedirname,'$',num2str(g,'%02d'));
  for d = 1:numel(D)
    % find group
    if ~isempty(strfind(D(d).name,keyword)) && ~D(d).isdir
      % make new groupd dir if first group file
      if ~exist(dirname,'dir');
        fprintf(['Unpacking ',keyword,10]);
        mkdir(dirname);
      end
      % move file to group dir
      movefile([directory,'\',D(d).name],dirname);
      if strcmp(D(d).name(end-2:end),'zip')
        if ~isempty(unzip([dirname,D(d).name],dirname))
          delete([dirname,D(d).name]);
        end
      end
    end
  end
end

D = rdir(directory);

