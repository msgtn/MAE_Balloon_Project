% Function to hand solve for the bilinear interpolation
% INPUTS:
% x = x coordinates
% y = y coordinates
% vals = values at coordinates
% xwant = wanted x position
% ywant = wanted y position
% OUTPUTS:
% outs = array of values at wanted coordinates

clear all
clc
close all

xvals=1.0e+05*[0
   0.789483979176376
   4.792501338380484
  -4.659067426407009];
yvals=1.0e+05*[0
  -3.736149535257173
   0.211270360624659
  -1.523370495030460];

hold on
grid on
plot(xvals,yvals,'-o')