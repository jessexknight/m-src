function [fname] = fnamex(fname,at,star,num)
dirsym   = '@';
namesym  = '*';
numsym   = '#';
numfmt   = '%02.f';
fname = strrep( fname, dirsym,  at);
fname = strrep( fname, namesym, star);
fname = strrep( fname, numsym,  num2str(num,numfmt));

