function [str] = structdisp(X)
[str] = buildstring(X);
[str] = alignstrs(str);
if nargout == 0
  for s = 1:numel(str)
    fprintf([str{s},'\n']);
  end
end

function [str] = alignstrs(str)
simax = 1;
for s = 1:numel(str)
  si(s) = find(str{s}==':',1,'first');
  simax = max(simax,si(s));
end
for s = 1:numel(str)
  str{s} = [str{s}(1:si(s)),repmat(' ',[1,simax-si(s)]),str{s}(si(s)+1:end)];
end

function [str] = buildstring(X,varargin)
% building string from structure (recursive)
if nargin == 2
  slug = varargin{1}; % existing slug (from recursion)
else
  slug = 'x';
end
str = {};
F    = fields(X); 
for f = 1:numel(F)
  if isstruct(X.(F{f}))  % dig deeper
    try
      toadd = buildstring(X.(F{f}),[slug,'.',F{f}]);
      str   = [str,toadd];
    end
  else                   % append to vector
    switch class(X.(F{f}));
      case {'double','logical'}
        op = @(x)vec2str(x,'');
      case {'char'}
        op = @(x)(x);
      case {'function_handle'}
        op = @(x)func2str(x);
      case {'cell'}
        op = @(x)('~');
      otherwise
        op = @(x)('~');
    end
    toadd = [slug,'.',F{f},': ',op(X.(F{f}))];
    str   = [str,toadd];
  end
end

function [str] = vec2str(v,fmt)
if ~isempty(fmt)
  str = ['[',num2str(v(:),[' ',fmt]),']'];
else
  str = ['[',num2str(v(:)'),']'];
end





