function [] = plotscroll(x,win,varargin)
h = plot(x,varargin{:});
xdata = get(h,'xdata');
ydata = get(h,'ydata');
if iscell(xdata), xdata = xdata{1}; end
if iscell(ydata), ydata = cat(2,ydata{:}); end
ymm = [min(ydata(:)),max(ydata(:))];
set(gca,'xlim',[xdata(1),xdata(win)]);
set(gca,'ylim',ymm);
set(gcf,'WindowScrollWheelFcn',@(h,e)scroll(h,e,win));

function [] = scroll(handle,event,win)
ax = get(handle,'children');
% for all axes
for a = 1:numel(ax)
  alims = get(ax(a),'xlim');
  data  = get(ax(a),'children');
  % find extrema in x (based on data)
  for d = 1:numel(data)
    xdata = get(data(d),'Xdata');
    datamin(d) = min(xdata);
    datamax(d) = max(xdata);
  end
  dmin = min(datamin);
  dmax = max(datamax);
  % move axis limits by window size
  % but also don't allow going out of bounds
  if ~isempty(data)
    newlims = alims - win*event.VerticalScrollCount;
    if newlims(1) < dmin
      newlims = [dmin,dmin+diff(alims)];
    end
    if newlims(2) > dmax
      newlims = [dmax-diff(alims)-1,dmax-1];
    end
    xlim(ax(a),newlims);
  end
end