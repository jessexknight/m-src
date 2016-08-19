function [] = jshtml()
fname = 'C:\Users\jesse\Google Drive\dev\html\website\navbar.html';
% get contents
[buffer] = getfiletext(fname);
% edits
[buffer,optype] = edits(fname,buffer);
% write contents
writefile(fname,buffer,optype)

function [buffer] = getfiletext(fname)
buffer = {};
b = 1;
fid = fopen(fname);
while ~feof(fid)
  buffer{b} = fgetl(fid);
  b = b + 1;
end
fclose(fid);
  
function [buffer,optype] = edits(fname,buffer)

if strcmp(filetype(fname),'.html') % to js
  optype = '.js';
  for b = 2:numel(buffer)
    buffer{b} = addjs(buffer{b});
  end
  buffer{end}(end) = ';';
elseif strcmp(filetype(fname),'.js') % to html
  optype = '.html';
  for b = 2:numel(buffer)
    buffer{b} = rmjs(buffer{b});
  end
end

function [line] = addjs(line)
line = ['"',line,'" +'];

function [line] = rmjs(line)
q1 = find(line=='"',1,'first');
q2 = find(line=='"',1,'last');
line = line(q1+1 : q2-1);

function [] = writefile(fname,buffer,optype)
newname = [fname(1:end-numel(filetype(fname))),optype];
fid = fopen(newname,'w');
for b = 1:numel(buffer)
  fprintf(fid,'%s\n',buffer{b});
end
fclose(fid);



