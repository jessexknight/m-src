% Jesse Knight 2015
% Copyright: Khademi Lab (Image Analysis in Medicine Lab).
%            Not to be distributed or copied.
%
% VOLSHOWX is a flexible function for displaying volume images with contrast and
%         colourmap specifications.  Mouse wheel scrolls through frames along
%         3rd dimension. Contrast and colourmaps apply to all volumes.
%
% Input arguments: (any order)
%    volume(s) - any number of 3D grayscale or 4D colour volumes. Volumes will
%                be rendered in the order they are presented, top to bottom,
%                left to right.
%                * multiple volumes should have the same 3rd dimension.
%                * if using colour volumes, the colour channels should be the
%                  last dimension.
%
%    minmax    - minmax specification for contrast scaling override, as in
%                imshow(I,[]). Array of size: 1 by 2, or a null: []
%                * if 2+ minmax values are provided, only the last one is used.
%
%    colourmap - colourmap used for displaying each frame:
%                array of size: M by 3 or a colourmap function
%                * if 2+ colourmaps are provided, only the last one is used.

function varargout = volshowx(varargin)
% MATLAB GUIDE -- do not edit
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
  'gui_Singleton',  gui_Singleton, ...
  'gui_OpeningFcn', @volshowx_OpeningFcn, ...
  'gui_OutputFcn',  @volshowx_OutputFcn, ...
  'gui_LayoutFcn',  [] , ...
  'gui_Callback',   []);
if nargin && ischar(varargin{1})
  gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
  [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
  gui_mainfcn(gui_State, varargin{:});
end

% --- Executes just before volshowx is made visible.
function volshowx_OpeningFcn(hObject, ~, h, varargin)

% Variables overview
%   All inputs are stored in the GUI handles structure (h):
%     h.img(:)    - an array of structures containing image data:
%                         .data is the 3-4D image data
%                         .size is the size of .data
%                         .frame is the index of current frame being displayed
%                         .minmax is the contrast range for viewing
%                         .textpos is the position of frame number text (y,x)
%     h.colourmap - colourmap applied to all frames during display,
%                         as used by imshow
%     h.N         - number of image volumes given by the user
%     h.ax(:)     - handle array to subplots for each volume frame
%     h.pad       - closeness of rendered images to one another
%     h.psize     - patch size for augmented patch function
%     h.patchfcn  - augmented patch function handle - function should take a
%                         cell array of patch data and an axes handle, and then
%                         do whatever is useful - e.g. plot pdfs from the patch
%     h. minmax   - optional global override min-max specification
%     h.badcall   - boolean variable to abort program if starting fails

h.output  = hObject;
h.badcall = 0;
set(0,'defaultTextFontName','Courier New');

try % if any errors: abort and give invalid input warning
  h = parseinputs(h, varargin);
  h = initaxes(h);
catch %#ok<CTCH> % input argument parsing failed
  warning('Error using input arguments.'); %#ok<WNTAG>
  h.badcall = 1;
end

guidata(hObject, h);

% --- Outputs from this function are returned to the command line.
function varargout = volshowx_OutputFcn(hObject, eventdata, h)
varargout{1} = h.output;
if h.badcall
  figure1_CloseRequestFcn(hObject, eventdata, h);
end

% --- Parse inputs
function h = parseinputs(h, vargs)
% default values
h.pad   = 0.005;      % padding between axes
h.psize = [15,15,01]; % patch size
h.img   = [];         % image array
h.colourmap = get(0,'defaultfigurecolormap'); % colourmap
h.patchfcn = [];

% handle input arguments based on their dimensions
for v = 1:numel(vargs)
  sizev = size(vargs{v});
  
  % volume info (possibly including colour in 3rd D)
  if numel(sizev) == 3 || numel(sizev) == 4
    h.img(end+1).data  = vargs{v};
    h.img(end).size    = size(h.img(end).data);
    h.img(end).frame   = round(h.img(end).size(end)/2);
    h.img(end).minmax  = [min(vargs{v}(:)),max(vargs{v}(:))];
    h.img(end).textpos = [round(h.img(end).size(1)/20 + 1),...
                          round(h.img(end).size(2)/20 + 1)];

  % patch data function
  elseif isa(vargs{v},'function_handle')
    h.patchfcn = vargs{v};
      
  % histogram window size
  elseif all(sizev == [1,3])
    h.psize = vargs{v};
    
  % min-max values
  elseif all(sizev == [1,2])
    h.minmax = vargs{v};
  
  % min-max is []
  elseif sizev(1) == 0
    h.minmax = [];
  
  % colourmap
  elseif sizev(2) == 3
    h.colourmap = vargs{v};
    
  % argument not recognized: ignoring
  else
    warning(['Ignoring argument number ',num2str(v),'.']); %#ok<WNTAG>
  end
end

% min-max global override
if isfield(h,'minmax');
  for i = 1:numel(h.img)
    h.img(i).minmax = h.minmax;
  end
end

% --- Initialize Axes
function h = initaxes(h)

% optimize frame display grid + 1 for histogram
h.N = numel(h.img);
if ~isempty(h.patchfcn)
  h.N = h.N + 1;
end
if h.N == 3
  nSubx = 3;
  nSuby = 1;
else
  nSubx = ceil(sqrt(h.N));
  nSuby = ceil(h.N/nSubx);
end
% subplot handles initialization
for a = 1:h.N
  h.ax(a) = subplot(nSuby,nSubx,a,...
    'ButtonDownFcn',{@clickfcn,h},...
    'HitTest','off','NextPlot','replacechildren');
end
for a = 1:h.N
  y = ceil(a / nSubx);
  x = mod(a, nSubx);
  x(~x) = nSubx;
  pad = h.pad;
  if a == h.N && ~isempty(h.patchfcn)
    pad = pad + 0.1;
    set(h.ax(a),'xcolor',[1,1,1],'ycolor',[1,1,1]);
  end
  set(h.ax(a),'position',[(x - 1) / nSubx + 0.5*pad,  ...
                           1 - (y / nSuby - 0.5*pad), ...
                                1 / nSubx - pad,      ...
                                1 / nSuby - pad]);
end
% optimize figure display size for the current monitor
screensize = get(0,'screensize');
imgSize = min(500, (0.4*screensize(3)) / nSubx);
set(gcf,'position',...
    [(screensize(3) - (imgSize*nSubx))/2,...
    (screensize(4) - (imgSize*nSuby))/2,...
    (imgSize*nSubx),...
    (imgSize*nSuby)]);

% render the middle frame of each volume to start
imupdate(h);

% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, h) %#ok<DEFNU>
% for all volumes
for i = 1:numel(h.img)
  % adjust the frame index by the scroll count
  h.img(i).frame = h.img(i).frame + eventdata.VerticalScrollCount;
  % wrap around if z is less than 1 or larger than img.size
  if h.img(i).frame > h.img(i).size(3)
    h.img(i).frame = 1;
  elseif h.img(i).frame < 1
    h.img(i).frame = h.img(i).size(3);
  end
end
% update the frames onscreen
guidata(hObject, h);
imupdate(h);

% --- Called by other functions on WindowScrollWheelFcn movement.
function imupdate(h)
% for all volumes
for i = 1:numel(h.img)
  % show the current frame
  ha = imshow(squeeze(h.img(i).data(:,:,h.img(i).frame,:)),...
              h.img(i).minmax,...
              'parent',h.ax(i));
  set(ha,'ButtonDownFcn',{@clickfcn,h});
  
  % print the current frame number in the top left corner
  text(h.img(i).textpos(2), h.img(i).textpos(1),...
       num2str(h.img(i).frame),'color','r','parent',h.ax(i));
end
colormap(h.colourmap);

% --- Executes on any button click function within axes.
function clickfcn(hObject, ~, h)
% need to do anything?
if isempty(h.patchfcn)
  return
end
% determing calling axes
for i = 1:numel(h.img)
  if get(hObject,'Parent') == h.ax(i)
    img = h.img(i);
  end
end
% click for cursor position (double click to init this fcn + ginput)
[x,y] = ginput(1);
z     = img.frame;
% get the local patch coords
isize = img.size;
yy = floor(max(1,        y - h.psize(1)/2)) : ...
     floor(min(isize(1), y + h.psize(1)/2));
xx = floor(max(1,        x - h.psize(2)/2)) : ...
     floor(min(isize(2), x + h.psize(2)/2));
zz = floor(max(1,        z - h.psize(3)/2)) : ...
     floor(min(isize(3), z + h.psize(3)/2));
% highlight patch
minmax = highlightpatch(hObject,yy,xx,img.minmax);
drawnow;
% gather patch data
patch{1} = img.data(yy,xx,zz);
patch{1}(1:2) = minmax; % (!) HACK to keep range constant (!)
for i = 1:numel(h.img)
  if get(hObject,'Parent') ~= h.ax(i)
    patch{end+1} = h.img(i).data(yy,xx,zz);
  end
end
% call external function, passing the patch data and the empty axis
h.patchfcn(patch,h.ax(end));
imupdate(h);

% --- called by clickfcn
function [minmax] = highlightpatch(ax,yy,xx,minmax)
I2 = get(ax,'CData');
if isempty(minmax)
  minmax = [min(I2(:)),max(I2(:))];
end
I2(yy,xx) = minmax(2);
I2(yy(2:end-1),xx(2:end-1)) = minmax(1);
set(ax,'CData',I2);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, ~, ~)
delete(hObject);





