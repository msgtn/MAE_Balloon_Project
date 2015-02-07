% Main code and parameters
% MAE 511: Dynamics Second project
% MAE 789: Dynamics Project

clear all;
clc;
close all;
fclose('all');

% Naming Convention
% Goal is to make all variables more "readable" within the code
% oVcmbO  =  o_d/dt V of cm wrt b, expressed in O frame
% oVXcmbO  =  x-component of o_d/dt V of cm wrt b, expressed in O frame
% FgravO  =  Force of gravity in the O frame

% Unit Convention
% All units for calculation purposes should be in one of the following:
% meters (m) for distance
% radians (rad) for angles
% seconds (s) for time
% kilogram (kg) for mass
% Any other unit, such as degrees latitude/longitude, etc should be
% converted for calculation purposes. 

% Initial conditions
% Desired location - will be used for controls code
lat_d = 42;     % deg, desired latitude for point b
lon_d = -101;   % deg, desired longitude for point b
h_d = 20000;    % meters, desired height of point b
% present location
lat_p = 41.13;  % deg, present latitude
lon_p = -100.68;% deg, present longitude
% Initial position, velocity, acceleration of system
x0 = 0;         % m, x position, B frame
xd0 = 0;        % m/s, x velocity, B frame
xdd0 = 0;       % m/s2, x accelereration, B frame
y0 = 0;         % m, y position, B frame
yd0 = 0;        % m/s, y velocity, B frame
ydd0 = 0;       % m/s2, y acceleration, B frame
z0 = 35000;     % m, height of the center of balloon mass, B frame
zd0 = 0;        % m/s, z acceleration, B frame
zdd0 = 0;       % m/s2, z acceleration, B frame
% Initial rotational parameters
ax0 = 0;        % rad, initial angle x (of body wrt inertial reference)
ay0 = 0;        % rad, initial angle y (of body wrt inertial reference)
az0 = 0;        % rad, initial angle z (of body wrt inertial reference)
wx0 = 0;        % rad/s, initial angle rate x (of body wrt inertial reference)
wy0 = 0;        % rad/s, initial angle rate y (of body wrt inertial reference)
wz0 = 0;        % rad/s, initial angle rate z (of body wrt inertial reference)
%simst = '72562'; % station
ye = '2014';    % year, initially
mo = '04';      % month, initially
da = '05';      % day, initially
hr = '11';      % time, initially
% Balt = 35000;   % m, height of the center of balloon mass, z0
alt_b = z0;     % m, height of the center of balloon mass
aoaH = 0;                   % deg, angle of attack of the horizontal wing
% angle_of_attackH = 0;                   % deg, angle of attack of the horizontal wing
aoaV = 0;                   % deg, angle of attack of the vertical wing 
% angle_of_attackV = 0;                   % deg, angle of attack of the vertical wing 
v_b = 1.823482849e5;      % m3, volume of the balloon of He
re = 6.3*10^6;              % Reynolds number (???)
% Geometry of system
l_t = 14000;                    % m, tether length, O&B frame
h_sys = 4681.1210;              % m, height of CM of system relative to wing cm
h_b = 14034.98;                 % m, height of cm of balloon relative to wing cm
h_sys_e = alt_b - h_b + h_sys;  % m, height of the CM relative to Earth, O frame
h_w = alt_b - h_b;              % m, height of wing avg cm relative to Earth, O frame
alpha = [aoaH,aoaV];            % vector of angles of attack
% Masses of sytem
m_b = 203.77;                   % kg, mass of the balloon
m_w = 300;                      % kg, mass of the wing
m_a = 20;                       % kg, mass of the actuated masses
m1 = m_b;                       % kg, mass of the balloon
m2 = m_w;                       % kg, mass of the wing
m3 = m_a;                       % kg, mass of the x only mass
m4 = m_a;                       % kg, mass of the y only mass
simMw = m_w;                    % kg, mass of the wing
simMass = m_b + simMw + m3 + m4;    % kg, total system mass
mt = simMass;                   % kg, total system mass

% Initial configurations of actuated masses
% Positions
x3B = 0;        % m, position of mass 3, B frame
y4B = 0;        % m, position of mass 4, B frame
% Velocities; consider changing to v instead of xd
x3dB = 0.1;     % m/s, velocity of mass 3, B frame
y4dB = 0;       % m/s, velocity of mass 4, B frame
%v3i = 0.25;     % m/s, velocity of moving mass in B frame
%v4j = 0.25;     % m/s, velocity of moving mass in B frame
% Restrictions
r4i = 0;        % mass 4 cannot move in x direction of B frame
r3j = 0;        % mass 3 cannot move in y direction of B frame

% Applying conditions from initial conditions
xbB = x0;       % m, x position of B in B frame
ybB = y0;       % m, y position of B in B frame
zbB = z0;       % m, z position of B in B frame
xbdB = xd0;     % m/s, x velocity of B in B frame   
ybdB = yd0;     % m/s, y velocity of B in B frame
zbdB = zd0;     % m/s, z velocity of B in B frame
wxB = wx0;      % rad/s, angular velocity about body x axis, B frame
wyB = wy0;      % rad/s, angular velocity about body y axis, B frame
wzB = wz0;      % rad/s, angular velocity about body z axis, B frame

% Simulation estimate output
numbs = 3750;               % number of iterations
dt = 0.5;                   % seconds per time step
run_S = (4.483232*numbs/10);% s, estimates runtime
run_M = num2str(run_S/60);  % min, estimates runtime
run_S = num2str(run_s);     % convert runtime (s) to string
DT = num2str(numbs*dt);     % s, calculates simulation duration
disp(['Number of iterations: ', num2str(numbs)])
disp(['Simulation time: ', DT, ' seconds'])
disp(['Estimated calculation time: ',run_M,' minutes (', run_S, ' seconds)'])

tic
for i = 1:numbs
  %I = num2str(i);
  %disp(['Iteration ',I])
    
  % Calculations of time
    t(i) = (i - 1)*dt;          % s, calculates simulation time 
    elap = (i - 1)*dt/3600;     % hr, calculates simulation time elapsed
    hro = str2num(hr);          % converts current hour to number
    hrn = round(hro + elap);    % adds hour and time elapsed (hr) and rounds
    hrnn = num2str(hrn);        % converts the number back to a string
    leng = length(hrnn);        % length of the string form of the hour
    if leng =  = 1              % if the length is a single digit
        hrnn = ['0', hrnn];     % add a zero infront of the length number
    end                         % carry on
    Daten = [ye, mo, da, hrnn]; % current date
    Pointb = [lat_p, lon_p];      % starting latitude, longitude
    angs = [ax0, ay0, az0];     % simulated Euler angles
    
  % Construct properties and forces
  % [pressure, temperature, wind direction, wind speed]
    out1 = prop(alt_b, Pointb, Daten);  % properties of atmo/wind @balloon @time
    out2 = prop(h_w,Pointb,Daten);      % properties of atmo/wing @wing @time
  % = windF(pressure,temperature,direction,speed,aoa)
    fBalloon = windB(out1(1),out1(2),out1(3),out1(4),angs); % balloon force B frame, Fv
    rhoa = fBalloon(4);         % extracts density
    rhoHe = fBalloon(5);        % extracts density of He
    fBalloon = fBalloon(1:3);   % eliminates density from the force vector
    fWing = windF(out2(1),out2(2),out2(3),out2(4),alpha,angs); % wing force B frame, Fd
    wdirO = fWing(4);           % extracts wind direction
    fWing = fWing(1:3);         % eliminates wind direction from force vector
    fGravity = gravCalc(h_sys_e,angs,simMass);  % gravity force in B frame, Fg
    
  % Buoyancy forces
    fBuoy = v_b*(rhoHe-rhoa);   % calculates net force on the balloon
    
  % Calculate mass position from decision outputs
    r3i = x3dB*dt+x3B;    % mass 3 x position 
    if r3i>5
        r3i = 5;
    end
    r4j = y4d*dt+y4B;    % mass 4 y position * do not double count w/ decision code
    if r4j>5
        r4j = 5;
    end
    xcmb = (m3*r3i+m4*r4i)/(m1+m2+m3+m4);% m, x center of mass of system, xcmb
    ycmb = (m3*r3j+m4*r4j)/(m1+m2+m3+m4);% m, y center of mass of system, ycmb
    xcmbd = (m3/mt)*(x3dB); % m/s, rate of change of xcmb
    ycmbd = (m4/mt)*(y4d); % m/s, rate of change of xcmb
    
  % For loop
  %z = [xb;yb;zb ;xbd;ybd;zbd; ax;ay;az; wx;wy;wz; x3;y4;x3d;y4d; dt; xcmb;ycmb;xcmbd;ycmbd; fBalloon;fWing;fGravity;]
  %  (1-3)     (4-6)        (7-9)     (10-12)   (13-16)       (17) (18-21)                (22-24)  (25-17) (28-30)
    conds = [xbB,ybB,zbB,xbdB,ybdB,zbdB,ax0,ay0,az0,wxB,wyB,wzB,x3B,y4B,...
    x3dB,y4d,dt,xcmb,ycmb,xcmbd,ycmbd,fBalloon,fWing,fGravity',fBuoy];
    
    newV = step2_7('name_state7',conds,dt);
  % Results
  % newV = [xb;yb;zb; xbd;ybd;zbd; ax;ay;az; wx;wy;wz]
  %      (1-3)      (4-6)        (7-9)     (10-12)
    btravel = [newV(1),newV(2),newV(3)];% m, xb,yb,zb in B frame
    bfast = [newV(4),newV(5),newV(6)];  % m/s, xbd,ybd,zbd in B frame
    wdirOv = [-sin(wdirO),-cos(wdirO),0]';% wind direction in component form        
    
  % Rotating from the B frame to the O frame
    Rx = [1 0 0;0 cos(ax0) sin(ax0);0 -sin(ax0) cos(ax0)];% X rotation matrix
    Ry = [cos(ay0) 0 -sin(ay0);0 1 0;sin(ay0) 0 cos(ay0)];% Y rotation matrix
    Rz = [cos(az0) sin(az0) 0;-sin(az0) cos(az0) 0;0 0 1];% Z rotation matrix
    BCO = Rz*Ry*Rx;     % BCO matrix
    OCB = BCO';         % OCB matrix
    Owhere = OCB*(conds(1:3))';
    
    otravel = OCB*btravel';  % x,y,z travel in the o frame of the point b
    ofast = OCB*bfast';      % xd,yd,zd in the o frame of point b
    wdirB = BCO*wdirOv;     % wind in the B frame in component form
    
    xbv(i) = otravel(1);    % plotting xb in the O frame
    ybv(i) = otravel(2);
    zbv(i) = otravel(3);
    axv(i) = newV(7);
    ayv(i) = newV(8);
    azv(i) = newV(9);
    
  % Updating Values
    lat_p = lat_p+atand((otravel(2)-Owhere(2))/re)% deg, new latitude
    lon_p = lon_p+atand((otravel(1)-Owhere(1))/re)% deg, new longitude
    xbB = btravel(1)-xbB;      % m, xb in O frame
    ybB = btravel(2)-ybB;      % m, yb in O frame
    zbB = h_sys_e+btravel(3)-zbB;      % m, zb in O frame
    xbdB = bfast(1)-xbdB;
    ybdB = bfast(2)-ybdB;
    zbdB = bfast(3)-zbdB;
    ax0 = newV(7);             % ax 
    ay0 = newV(8);             % ay
    az0 = newV(9);             % az
    wxB = newV(10);
    wyB = newV(11);
    wzB = newV(12);
    angs = [ax0,ay0,az0];
    
    fclose all;

    
  %{
  % Controls Code here -\/-------------------------------------------- %
    
    Opos = [Plat,Plon,zb];
    Dpos = [Dlat,Dlon,Dhei];
    
    newvecs = CurrentP(Ovec,angs,Dpos,alpha,wdirB);
    
    x3d = newvecs(1);   % New desired velocity of mass 3
    y4d = newvecs(2);   % New desired velocity of mass 4
    alpha = [newvecs(3),newvecs(4)];% New desired angles of attack, [H,V]
    
  % Controls Code here -/\-------------------------------------------- %
  %}
    

end
toc

%% Plotting results in the O frame
scn = get(0,'ScreenSize');              % gets screen dimensions
figure('Position',[1 1 scn(3) scn(4)])% makes the image full screen
subplot(3,2,1)                        % creates subplot
plot(t,xbv)
title('X position')
xlabel('Time (s)')
ylabel('X Position (m)')
subplot(3,2,3)                        % creates subplot
plot(t,ybv)
title('Y Position')
xlabel('Time (s)')
ylabel('Y Position (m)')
subplot(3,2,5)                        % creates subplot
plot(t,zbv)
title('Z Position')
xlabel('Time (s)')
ylabel('Z Position (m)')
subplot(3,2,2)                        % creates subplot
plot(t,axv)
title('Angle about X')
xlabel('Time (s)')
ylabel('ax (deg)')
subplot(3,2,4)                        % creates subplot
plot(t,ayv)
title('Angle about Y')
xlabel('Time (s)')
ylabel('ay (deg)')
subplot(3,2,6)                        % creates subplot
plot(t,azv)
title('Angle about Z')
xlabel('Time (s)')
ylabel('az (deg)')
figure
hold on 
grid on
plot([0,xbv],[0,ybv])
title('Flight Path')
xlabel('Distance (m)')
ylabel('Distance (m)')
%{
hold off
figure 
hold on 
grid on
plot([0,t],[0,rax])
xlabel('Time (s)')
ylabel('Remainder')
title('Remainder AX')
hold off
figure 
hold on 
grid on
plot(t,ray)
xlabel('Time (s)')
ylabel('Remainder')
title('Remainder AY')
hold off
figure 
hold on 
grid on
plot(t,raz)
xlabel('Time (s)')
ylabel('Remainder')
title('Remainder AZ')
%}