% This M-file performs a 2nd-order numerical integration step. 
% INPUTS: 
% file  -   name of the file that contains the state equations 
% x     -   1 x n vector of state variables at time t 
% t     -   time 
% deltaT-   time step 
% OUTPUTS: 
% xnew  -   n x 1 vector of state variables at time t + deltaT 
% 
function xnew = step2_7(file,x,deltaT) 
% Christopher D Yoder
% MAE 511 Project Two
% Second Order Runga-Kutta code
% 
eval(['f1 = ',file,'(x);'])             % evaluates function for d,dd terms
deltax1 = deltaT*f1;                    % dd*dt=d; d*dt=p
n=[deltax1(1:12)',zeros(1,19)];         % adds zeros to deltax1 for length 
eval(['f2 = ',file,'(x + n);']) % evaluates function for d,dd news
n1=x(1:12);                             % extracts old p,d values
xnew = n1' + 0.5*deltaT*(f1 + f2);       % integrates old values w/new values

% f=[xbd;ybd;zbd; xbdd;ybdd;zbdd; wx;wy;wz; axdd;aydd;azdd] - column vector
%   (1-3)         (4-6)           (7-9)     (10-12)

% x=[x;y;z ;xd;yd;zd; ax;ay;az; wx;wy;wz; x3;y4;x3d;y4d; dt; xcmb;ycmb;xcmbd;ycmbd; fBalloon;fWing;fGravity;fBuoy]
%   (1-3)  (4-6)      (7-9)     (10-12)   (13-16)       (17) (18-21)               (22-24)  (25-17) (28-31) 