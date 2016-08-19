function def()
% DISPLAY
format short g;
format compact;
% FONTS
%fontname = 'Consolas';
%fontname = 'Courier New';
%fontname = 'Calibri';
fontname = 'Helvetica';
%fontname = 'Times';
fontsize = 12;

set(0,'defaultTextFontName',      fontname);
set(0,'defaultAxesFontName',      fontname);
set(0,'defaultUicontrolFontName', fontname);
set(0,'defaultUitableFontName',   fontname);
set(0,'defaultUipanelFontName',   fontname);

set(0,'defaultTextFontSize',      fontsize);
set(0,'defaultAxesFontSize',      fontsize);
set(0,'defaultUicontrolFontSize', fontsize);
set(0,'defaultUitableFontSize',   fontsize);
set(0,'defaultUipanelFontSize',   fontsize);

% PLOT LINE THICKNESS
set(0,'defaultLineLineWidth', 2);
% PLOT COLORS (RAINBOW)
%set(0,'defaultAxesColorOrder',jet(20));
set(0,'defaultAxesColorOrder',jkcolororder);
% IMG COLORS (RAINBOW)
set(0,'defaultFigureColormap',gray);
%set(0,'defaultFigureColormap',rainbow);
% WARNINGS
warning('off', 'Images:initSize:adjustingMag');
close all;

function [clrs] = jkcolororder()
clrs = ...
   [0.00    0.50    1.00
    0.50    0.00    1.00
    0.75    0.00    0.75
    1.00    0.00    0.50
    1.00    0.00    0.00
    1.00    0.25    0.00
    1.00    0.50    0.00
    1.00    0.90    0.00
    0.25    1.00    0.25
    0.00    0.90    0.60];
