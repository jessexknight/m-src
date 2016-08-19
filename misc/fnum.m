function [fname] = fnum(fname,num)
wildcard = '#';
format   = '%02.f';
fname = strrep(fname,wildcard,num2str(num,format));
