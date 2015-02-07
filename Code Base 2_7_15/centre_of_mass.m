clc
clear all;

%the point B (0,0,0) is assumed to be origin

% syms v3i v4j m3 m4 m1 m2

% v3i=velocity of mass 3;v4j=velocity of mass 4
m1=203;m2=300;m3=10;m4=10;
v3i=0.25;v4j=0.25;      % velocities in m/s wrt B frame
time=20;                % travel time in seconds

for t=1:time    % for the time of 20 seconds
r4i=0;          % mass 4 cannot move in x direction
r3j=0;          % mass 3 cannot move in the y direction

t=(i-1)*time;
r3i=v3i*t;      % mass 3 x position 
r4j=v4j*t;      % mass 4 y position

rcmi(t)=(m3*r3i+m4*r4i)/(m1+m2+m3+m4);  % x center of mass of system, xcmb
rcmj(t)=(m3*r3j+m4*r4j)/(m1+m2+m3+m4);  % y center of mass of system, ycmb
plot(rcmi,t)
% hold on
%  plot(rcmj,t)

end




