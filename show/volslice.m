% VOLSLICE is a flexible function for displaying multiple volume images tightly
%         on the same figure. Mouse scroll wheel scrolls the z dimension.
%         Padding between images, grid dimensions, contrast scale, and
%         colourmaps can be specified. Attributes apply to all images. Best
%         results with same sized images. Grayscale or colour images.
% 
% Input arguments: (any order)
%    images(s) - any number of 3D grayscale or colour images. Rendered in the
%                order they are presented, top to bottom, left to right. 
%                * The x-dimension of any image should not have a size of 3,
%                  else it will be confused for a colourmap.
%                * multiple volumes should have the same 3rd dimension.
%                * if using colour volumes, the colour channels should be the
%                  last dimension.
% 
%    minmax    - minmax specification for contrast scaling, as in imshow(I,[]).
%                array of size: 1 by 2, or a empty array: []
%                Default: []
% 
%    colourmap - colourmap used for displaying images:
%                array of size: M by 3 or a colourmap function
%                Default: curent default figure colormap
% 
%              * if 2+ non-image arguments are given, only the last one is used.
% 
% Examples:
% 
%    volslice(I1, I2, I3, I4, hot, 0, [0,1], '4x1');
%                Show volumes I1, I2, I3, I4 using the hot colourmap, with no
%                space between, contrast from 0 to 1, and in a horizontal line.
% 
%    volslice(DB(:).I);
%                Show all volume fields .I in the struct array DB using the
%                default figure colourmap, automatic contrast scaling per image,
%                with 0.5% of total figure size padded between, and arranged as
%                close to square as possible.
% 
% Jesse Knight 2015

function varargout = volslice(varargin)
% -- do not edit: MATLAB GUIDE 
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @volslice_OpeningFcn, ...
    'gui_OutputFcn',  @volslice_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end % -- end do not edit

% --- Executes just before volslice is made visible.
function volslice_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output  = hObject;
handles.badcall = 0;
set(0,'defaultTextFontName','Courier New');

try % if any errors: abort and give invalid input warning
    % default values
    handles.img       = [];
    handles.plot      = [];
    handles.minmax    = [];
    handles.colourmap = get(0,'defaultfigurecolormap');
    handles.pad       = 0.005;
    
    % handle input arguments based on their dimensions
    for v = 1:numel(varargin)
        sizev = size(varargin{v});
        % image volume (possibly including colour in 3rd dimension)
        if numel(sizev) >= 3
            if islogical(varargin{v}), varargin{v} = single(varargin{v}); end
            handles.img(end+1).data  = varargin{v};
            handles.img(end).size    = size(handles.img(end).data);
            handles.img(end).slice   = round(handles.img(end).size(end)*0.5);
            handles.img(end).textpos = [round(handles.img(end).size(1)/20 + 1),...
                                        round(handles.img(end).size(2)/20 + 1)];
        % plotted data
        elseif iscell(varargin{v})
            for d = 1:numel(varargin{v}) 
              handles.plot(end+1).data = varargin{v}{d};
              handles.plot(end).size   = size(handles.plot(end).data);
              handles.plot(end).slice  = round(handles.plot(end).size(end)*0.5);
            end
        % minmax (numerical)
        elseif all(sizev == [1,2])
            handles.minmax = varargin{v};
        % minmax ([])
        elseif sizev(1) == 0
            handles.minmax = [];
        % gridstr
        elseif ischar(varargin{v}) && numel(sscanf(varargin{v},'%dx%d')) == 2
            xy = sscanf(varargin{v},'%dx%d');
            handles.nSubx = xy(1);
            handles.nSuby = xy(2);
        % colourmap
        elseif sizev(2) == 3
            handles.colourmap = varargin{v};
        % argument not recognized: ignoring
        else
            warning(['Ignoring argument number ',num2str(v),'.']);
        end
    end
    % count number of rendered volumes and plotted data
    handles.N = numel(handles.img) + 1;
    % optimize display grid square-ish if not user specified
    if ~all(isfield(handles,{'nSubx','nSuby'}))
        handles.nSubx = ceil(sqrt(handles.N));
        handles.nSuby = ceil(handles.N/handles.nSubx);
    end
    % defining per-image minmax's
    for n = 1:numel(handles.img)
      if isempty(handles.minmax)
        handles.img(n).minmax = [min(handles.img(n).data(:)),...
                                 max(handles.img(n).data(:))];
      else
        handles.img(n).minmax = handles.minmax;
      end
    end
    % subplot handles initialization
    for a = 1:handles.N
      handles.ax(a) = subplot(handles.nSuby,handles.nSubx,a);
    end
    % subplot spacing (separate for overlap issue)
    for a = 1:handles.N
        y = ceil(a / handles.nSubx);
        x = mod(a, handles.nSubx);
        x(~x) = handles.nSubx;
        
        set(handles.ax(a),'position',[(x - 1) / handles.nSubx + 0.5*handles.pad,  ...
                                       1 - (y / handles.nSuby - 0.5*handles.pad), ...
                                            1 / handles.nSubx - handles.pad,      ...
                                            1 / handles.nSuby - handles.pad]);
    end
    % optimize figure display size for the current monitor and first image size
    % centres the figure in onscreen too.
    screensize = get(0,'screensize');
    imgSize = min(500, (0.4*screensize(3)) / handles.nSubx);
    set(gcf,'position',...
        [(screensize(3) - (imgSize*handles.nSubx))/2,...
         (screensize(4) - (imgSize*handles.nSuby))/2,...
         (imgSize*handles.nSubx),...
         (imgSize*handles.nSuby)]);
    % render the middle slice of each volume to start
    imupdate(handles);
% input argument parsing failed: exit (could be more graceful)
catch ME
    disp( getReport( ME, 'extended', 'hyperlinks', 'on' ) );
    handles.badcall = 1;
end

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = volslice_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;
if handles.badcall
    figure1_CloseRequestFcn(hObject, eventdata, handles);
end

% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
% for all volumes
for i = 1:numel(handles.img)
    handles.img(i).slice = calculateslice(...
    handles.img(i).slice,handles.img(i).size(end),eventdata.VerticalScrollCount);
end
% for all data plots
for i = 1:numel(handles.plot)
    handles.plot(i).slice = calculateslice(...
    handles.plot(i).slice,handles.plot(i).size(end),eventdata.VerticalScrollCount);
end
% update the slices onscreen
guidata(hObject, handles);
imupdate(handles);

% --- Called by other functions on WindowScrollWheelFcn movement.
function [slice] = calculateslice(slice,maxsize,scroll)
% adjust the slice index by the scroll count
slice = slice + scroll;
% wrap around if z is less than 1 or larger than size
if slice > maxsize
    slice = 1;
elseif slice < 1
    slice = maxsize;
end

% --- Called by other functions on WindowScrollWheelFcn movement.
function imupdate(handles)
% for all volumes
for i = 1:numel(handles.img)
    % show the current slice
    imshow(squeeze(handles.img(i).data(:,:,handles.img(i).slice,:)),handles.img(i).minmax,...
        'parent',handles.ax(i));
    % print the current slice number in the top left corner
    text(handles.img(i).textpos(2),handles.img(i).textpos(1),...
        num2str(handles.img(i).slice),'color','r','parent',handles.ax(i));
end
% for all data plots
X = [];
for i = 1:numel(handles.plot)
    % add the current slice data to a new arrray for plotting
    X = cat(2,X,handles.plot(i).data(:,handles.plot(i).slice));
end
% plot the array
plot(X,'parent',handles.ax(numel(handles.img)+1));
colormap(handles.colourmap);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
delete(hObject);
