% Jesse Knight
% 2015

% STUDENTEXCELFEEDBACK ---------------------------------------------------------
function [] = studentexcelfeedback(excelfile,sheetname,formname)

% EXCEL READ PARAMETERS - USER SPECS
% ..............................................................................
X.sym = '#';
X.rowrng     = {'2','48'};
X.totals     = {'L49','T49','V49','AA49','AG49','AL49','AP49'};
X.marks      = {'L#', 'T#', 'V#', 'AA#', 'AG#', 'AL#', 'AP#'};
X.comments   = {'M#', 'U#', 'W#', 'AB#', 'AH#', 'AM#', 'AO#'};
X.group      = {'H#'};
X.username   = {'B#'};
X.lastname   = {'C#'};
X.firstname  = {'D#'};

isprintstudentform     = 1;
isprintgroupform       = 0;
isprintcourslinkupload = 0;
% ..............................................................................

% READING FROM EXCEL
[groups,names,usernames,totals,marks,comments] = readfromexcel(excelfile,sheetname,X);

% PRINTING FEEDBACK FORMS
sumtotal = 50;
if isprintstudentform
  printforms(groups,names,totals,marks,comments,formname,sumtotal);
end
if isprintcourslinkupload
  printcourselink(usernames,marks,totals,formname);
end
if isprintgroupform
  [groups,names,marks,comments] = groupdata(groups,names,marks,comments);
  printforms(groups,names,totals,marks,comments,formname,sumtotal);
end

% READFROMEXCEL ----------------------------------------------------------------
function [groups, names, usernames, totals, marks, comments] = readfromexcel(excelfile, sheetname, X)
nstudents  = numstudents(X.rowrng);
nquestions = numel(X.totals);

% READING IDENTIFICATION
fprintf('...READING I.D. INFORMATION\n');
groups = [];
usernames = {};
if ~isempty(X.group)
  [groups] = xlsread(excelfile,sheetname,buildrange(X.group,    X.sym,X.rowrng));
end
if ~isempty(X.username)
  [~,~,usernames]  = xlsread(excelfile,sheetname,buildrange(X.username, X.sym,X.rowrng));
end
[~,~,lastnames]  = xlsread(excelfile,sheetname,buildrange(X.lastname, X.sym,X.rowrng));
[~,~,firstnames] = xlsread(excelfile,sheetname,buildrange(X.firstname,X.sym,X.rowrng));

for s = 1:nstudents
  names{s} = [firstnames{s},' ',lastnames{s}];
end

% INITIALIZATIONS
totals   = zeros(1,        nquestions);
marks    = zeros(nstudents,nquestions);
comments =  cell(nstudents,nquestions);

% READING MARKS + COMMENTS
for q = 1:nquestions
  fprintf(['...READING QUESTION ',num2str(q),'\n']);
  totals(q)  = xlsread(excelfile,sheetname,X.totals{q});
  marks(:,q) = xlsread(excelfile,sheetname,buildrange(X.marks{q},X.sym,X.rowrng));
  if ~isempty(X.comments)
    [~,~,rawcomments] = xlsread(excelfile,sheetname,buildrange(X.comments{q},X.sym,X.rowrng));
    for s = 1:nstudents
      comments{s,q} = rawcomments{s};
    end
  end
end

% BUILDRANGE -------------------------------------------------------------------
function [rngstr] = buildrange(xdata,sym,xrowrng)
% rngstr looks like: 'A1:A3' - for xlsread syntax
if iscell(xdata)
  xdata = xdata{1};
end
rngstr = [strrep(xdata,sym,xrowrng{1}),':',strrep(xdata,sym,xrowrng{2})];

% NUMSTUDENTS ------------------------------------------------------------------
function [nstu] = numstudents(xrowrng)
nstu = 1 + str2double(xrowrng{2})-str2double(xrowrng{1});

% PRINTCOURSELINK --------------------------------------------------------------
function [] = printcourselink(usernames,marks,totals,formname)
f = fopen([formname,' - COURSELINK.csv'],'wt');
fprintf(f,['Username,',formname,' Points Grade, End-of-Line Indicator\n']);
for s = 1:numel(usernames)
  fprintf(f,[usernames{s},',',...
             num2str(sum(marks(s,:)),'%03.5f'),...%num2str(100*sum(marks(s,:))/sum(totals),'%03.5f'),...
             ',#\n']);
end
fclose(f);
fclose('all');

% GROUPDATA --------------------------------------------------------------------
function [groups,names,marks,comments] = groupdata(sgroups,snames,smarks,scomments)
nameseperator = ', ';
groups = unique(sgroups);
for g = 1:numel(groups)
  names{g} = '';
end
for g = 1:numel(groups)
  gg = groups(g);
  for s = 1:numel(sgroups)
    if sgroups(s) == gg
      names{g} = [names{g},snames{s},', '];
      marks(g,:) = smarks(s,:);
      comments{g,:} = scomments{s,:};
    end
  end
end
for g = 1:numel(groups)
  names{g} = names{g}(1:end-numel(nameseperator));
end

% PRINTFORMS -------------------------------------------------------------------
function printforms(groups, names, totals, marks, comments, formname, sumtotal)
% see below for sample output...
fprintf('...PRINTING FORMS: ');

for s = 1:numel(names)
  fprintf([' ',num2str(s,'%02d')]);
  filename = cat(2,formname,' - ', names{s} ,' - Group ',num2str(groups(s)),'.txt');
  f = fopen(filename,'wt');
  fprintf(f,[formname,'\n',names{s},'\nGroup ',num2str(groups(s)),'\n\n',...
            'Grade: ',num2str(100*sum(marks(s,:))/sumtotal,'%03.1f'),'\n\n']);
  for q = 1:numel(totals)
    comm = comments{s,q};
    if isnan(comm)
        comm = '';
    end
    fprintf(f,['Q',num2str(q),...
               '\n-----\n',...
               num2str(marks(s,q),'%02.01f'),' / ',num2str(totals(q),'%02.01f'),...
               '\n',comm,'\n\n']);
  end
  fclose(f);
end
fclose('all');
fprintf('\n');

% SAMPLE -----------------------------------------------------------------------
function [] = sample()
% SAMPLE FORM OUTPUT -----------------------------------------------------------
% A01 Feedback
% Firstname Lastname
% Group 10
% 
% Grade: 86.7
% 
% Q1
% -----
% 6.5 / 7.0
% First of all: Excellent Appendix!!! (a) Good, but please provide more detail
% in your discussion of the header info, such as the imaging modality, image ...
% 
% Q2
% -----
% 4.0 / 4.0
% Fantastic work all round!
% 
% Q3
% -----
% 4.5 / 5.0
% Excellent explanation!  I had to take a mark off because the filtered images
% are not visible due to contrast scaling, but they are correct in the code! ...
% 
% Q4
% -----
% 11.0 / 14.0
% (a) Nice work, except you've forgotten to note which absorbs more photons.
% -1 mark. (b) Good work. Full Marks. ...
% 
x=0;


% EOF --------------------------------------------------------------------------



