function [] = mhtml()
dirname = 'C:\Users\jesse\Google Drive\dev\html\website\mfiles\';
template = getfiletext([dirname,'m.html']);

D = rdir(dirname);
for d = 1:numel(D)
  if strcmp(filetype(D(d).name),'.m')
    % get contents
    [buffer] = getfiletext(D(d).pathname);
    % edits
    [buffer] = edits(D(d).name,buffer,template);
    % write contents
    writefile(D(d).pathname,buffer)
  end
end

function [buffer] = getfiletext(fname)
buffer = {};
b = 1;
fid = fopen(fname);
while ~feof(fid)
  buffer{b} = fgetl(fid);
  b = b + 1;
end
fclose(fid);
  
function [buffer] = edits(fname, mfile, template)
code = 0;
for l = 1:numel(template)
  buffer{l} = strrep(template{l},'###',fname);
  if strcmp(template{l},'@@@');
    code = l;
    for m = 1:numel(mfile)
      buffer{l+m-1} = mfile{m};
    end
    break;
  end
end
for l = 1:numel(template)-code
  buffer{end+1} = template{code+l};
end

function [] = writefile(fname,buffer)
newname = [fname(1:end-numel(filetype(fname))),'.html'];
fid = fopen(newname,'w');
for b = 1:numel(buffer)
  fprintf(fid,'%s\n',buffer{b});
end
fclose(fid);



