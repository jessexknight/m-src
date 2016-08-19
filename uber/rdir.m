% Jesse Knight 2015
% Copyright: Khademi Lab (Image Analysis in Medicine Lab).
%            Not to be distributed or copied.
% 
% RDIR builds a directory structure with the recursively found contents found
%      within directory 'dirname'.
%
% Input arguments:
%    dirname - Name of the directory to search.
%
% Output arguments:
%   fulldir - Struct array of the contents (files and folders) of dirname:
%             .name  - name of the file or folder.
%             .date  - date modified
%             .bytes - file size in bytes (folders are 0 regardless of contents)
%             .isdir - boolean
%             .datenum  - number of days since Jan 01, 0000 (for sorting)
%             .pathname - constructed path and filename string from 'dirname'
%                         up to and including .name.

function [fulldir] = rdir(dirname)

basedir = dir(dirname);
fulldir = basedir(3:end);
for d = 3:numel(basedir)
    fulldir(d-2).pathname = [dirname,'\',fulldir(d-2).name];
    if exist( [dirname, '\', basedir(d).name], 'dir')
        appendingdir = rdir( [dirname, '\', basedir(d).name] );
        if ~isempty(appendingdir)
            fulldir = [fulldir; appendingdir];
        end
    end
end
