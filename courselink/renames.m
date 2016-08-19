function [] = renames(directory)
% remove courselink junk filename for .m files
D = rdir(directory);

for d = 1:numel(D)
  fname = D(d).pathname;
  idx = strfind(fname,'M -'); % as in "AM - filename" or "PM - filename"
  newname = fname(idx+4:end);
  evalstr = ['!mv "',fname,'" "',directory,'\',newname,'"'];
  eval(evalstr);
end