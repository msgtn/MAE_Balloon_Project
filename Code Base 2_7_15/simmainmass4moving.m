% Main code and parameters
% MAE 511: Dynamics Second project

clear all;
clc;
close all;
fclose('all');

% Initial conditions
Dlat=42;        % deg, desired latitude for point b
Dlon=-101;      % deg, desired longitude for point b
Dhei=20000;     % meters, desired height of point b
Plat=41.13;     % deg, initial latitude
Plon=-100.68;   % deg, initial longitude
x0=0;           % m, x position, B frame
xd0=0;           % m/s, x velocity, B frame
xdd0=0;         % m/s2, x accelereration, B frame
y0=0;           % m, y position, B frame
yd0=0;          % m/s, y velocity, B frame
ydd0=0;         % m/s2, y acceleration, B frame
zd0=0;
ax=0;           % rad, initial angle x
ay=0;           % rad, initial angle y
az=0;           % rad, initial angle z
wx0=0;          % rad/s, initial angle rate x
wy0=0;          % rad/s, initial angle rate y
wz0=0;          % rad/s, initial angle rate z
%simst='72562';  % station
ye='2014';      % year, initially
mo='04';        % month, initially
da='05';        % day, initially
hr='11';        % time, initially
Balt=35000;     % m, height of the center of balloon mass, z0
aoaH=0;                     % deg, angle of attack of the horizontal wing
aoaV=0;                     % deg, angle of attack of the vertical wing 
Vol=1.823482849e5;          % m3, volume of the balloon of He
re=6.3*10^6;
% Geometry
Tlen=14000;                 % m, teather length, O&B frame
Cm=4681.1210;               % m, height of CM of system relative to wing cm
balCm=14034.98;             % m, height of cm of balloon relative to wing cm
Cmhei=Balt-balCm+Cm;        % m, height of the CM relative to Earth, O frame
Wing=Balt-balCm;            % m, height of wing avg cm relative to Earth, O frame
alpha=[aoaH,aoaV];          % vector of aoa's
simMb=203.77;               % kg, mass of the balloon
m1=203.77;                  % kg, mass of the balloon
m2=300;                     % kg, mass of the wing
m3=20;                      % kg, mass of the x only mass
m4=20;                      % kg, mass of the y only mass
simMw=m2;                   % kg, mass of the wing
simMass=simMb+simMw+m3+m4;  % kg, total system mass
mt=simMass;                 % kg, total system mass

% Initial Configuration of Moving Masses
x3=0;
y4=0;
x3d=0;
y4d=0.1;
%v3i=0.25;       % m/s, velocity of moving mass in B frame
%v4j=0.25;       % m/s, velocity of moving mass in B frame
r4i=0;          % mass 4 cannot move in x direction
r3j=0;          % mass 3 cannot move in the y direction

% Applying conditions from initial conditions
xb=x0;
yb=y0;
zb=Cmhei;
xbd=xd0;
ybd=yd0;
zbd=zd0;
wx=wx0;
wy=wy0;
wz=wz0;

% Simulation
numbs=3750;                   % number of iterations
dt=0.5;                       % seconds per time step
estiS=(4.483232*numbs/10);  % s, estimates run time
estiM=estiS/60;             % min, estimates run time
strNumbs=num2str(numbs);    % converts iterations to string
estiS=num2str(estiS);       % converts run time to string
estiM=num2str(estiM);       % converts run time to string
DT=numbs*dt;                % s, calculates simulation duration
DT=num2str(DT);             % converts simulation time to string
disp(['Number of iterations: ',strNumbs])
disp(['Simulation time: ',DT,' seconds'])
disp(['Estimated calculation time: ',estiM,' minutes (',estiS,' seconds)'])

tic
for i=1:numbs
    %I=num2str(i);
    %disp(['Iteration ',I])
    
    % Calculations of time
    t(i)=(i-1)*dt;          % s, calculates simulation time 
    elap=(i-1)*dt/3600;     % hr, calculates simulation time elapsed
    hro=str2num(hr);        % converts current hour to number
    hrn=round(hro+elap);    % adds hour and time elapsed (hr) and rounds
    hrnn=num2str(hrn);      % converts the number back to a string
    leng=length(hrnn);      % length of the string form of the hour
    if leng==1              % if the length is a single digit
        hrnn=['0',hrnn];    % add a zero infront of the length number
    else                    % otherwise,
    end                     % carry on
    Daten=[ye,mo,da,hrnn];  % current date
    Pointb=[Plat,Plon];     % starting latitude, longitude
    angs=[ax,ay,az];        % simulated Euler angles
    
    % Construct properties and forces
    %[pressure, temperature, wind direction, wind speed]
    out1=prop(Balt,Pointb,Daten);  % properties of atmo/wind @balloon @time
    out2=prop(Wing,Pointb,Daten);  % properties of atmo/wing @wing @time
    %=windF(pressure,temperature,direction,speed,aoa)
    fBalloon=windB(out1(1),out1(2),out1(3),out1(4),angs); % balloon force B frame, Fv
    rhoa=fBalloon(4);           % extracts density
    rhoHe=fBalloon(5);          % extracts density of He
    fBalloon=fBalloon(1:3);     % eliminates density from the force vector
    fWing=windF(out2(1),out2(2),out2(3),out2(4),alpha,angs); % wing force B frame, Fd
    wdirO=fWing(4);             % extracts wind direction
    fWing=fWing(1:3);           % eliminates wind direction from force vector
    fGravity=gravCalc(Cmhei,angs,simMass);    % gravity force in B frame, Fg
    
    % Buoyancy forces
    fBuoy=Vol*(rhoHe-rhoa);     % calculates net force on the balloon
    
    % Calculate mass position from decision outputs
    r3i=x3d*dt+x3;      % mass 3 x position 
    if r3i>5
        r3i=5;
    end
    r4j=y4d*dt+y4;      % mass 4 y position * do not double count w/ decision code
    if r4j>5
        r4j=5;
    end
    xcmb=(m3*r3i+m4*r4i)/(m1+m2+m3+m4);  % m, x center of mass of system, xcmb
    ycmb=(m3*r3j+m4*r4j)/(m1+m2+m3+m4);  % m, y center of mass of system, ycmb
    xcmbd=(m3/mt)*(x3d);   % m/s, rate of change of xcmb
    ycmbd=(m4/mt)*(y4d);   % m/s, rate of change of xcmb
    
    % For loop
    %z=[xb;yb;zb ;xbd;ybd;zbd; ax;ay;az; wx;wy;wz; x3;y4;x3d;y4d; dt; xcmb;ycmb;xcmbd;ycmbd; fBalloon;fWing;fGravity;]
    %  (1-3)     (4-6)        (7-9)     (10-12)   (13-16)       (17) (18-21)                (22-24)  (25-17) (28-30)
    conds=[xb,yb,zb,xbd,ybd,zbd,ax,ay,az,wx,wy,wz,x3,y4,...
    x3d,y4d,dt,xcmb,ycmb,xcmbd,ycmbd,fBalloon,fWing,fGravity',fBuoy];
    
    newV=step2_7('name_state7',conds,dt);
    % Results
    % newV=[xb;yb;zb; xbd;ybd;zbd; ax;ay;az; wx;wy;wz]
    %      (1-3)      (4-6)        (7-9)     (10-12)
    btravel=[newV(1),newV(2),newV(3)];  % m, xb,yb,zb in B frame
    bfast=[newV(4),newV(5),newV(6)];    % m/s, xbd,ybd,zbd in B frame
    wdirOv=[-sin(wdirO),-cos(wdirO),0]';% wind direction in component form        
    
    % Rotating from the B frame to the O frame
    Rx=[1 0 0;0 cos(ax) sin(ax);0 -sin(ax) cos(ax)];  % X rotation matrix
    Ry=[cos(ay) 0 -sin(ay);0 1 0;sin(ay) 0 cos(ay)];  % Y rotation matrix
    Rz=[cos(az) sin(az) 0;-sin(az) cos(az) 0;0 0 1];  % Z rotation matrix
    BCO=Rz*Ry*Rx;       % BCO matrix
    OCB=BCO';           % OCB matrix
    Owhere=OCB*(conds(1:3))';
    
    otravel=OCB*btravel';    % x,y,z travel in the o frame of the point b
    ofast=OCB*bfast';        % xd,yd,zd in the o frame of point b
    wdirB=BCO*wdirOv;       % wind in the B frame in component form
    
    xbv(i)=otravel(1);      % plotting xb in the O frame
    ybv(i)=otravel(2);
    zbv(i)=otravel(3);
    axv(i)=newV(7);
    ayv(i)=newV(8);
    azv(i)=newV(9);
    
    % Updating Values
    Plat=Plat+atand((otravel(2)-Owhere(2))/re)  % deg, new latitude
    Plon=Plon+atand((otravel(1)-Owhere(1))/re)  % deg, new longitude
    xb=btravel(1)-xb;        % m, xb in O frame
    yb=btravel(2)-yb;        % m, yb in O frame
    zb=Cmhei+btravel(3)-zb;        % m, zb in O frame
    xbd=bfast(1)-xbd;
    ybd=bfast(2)-ybd;
    zbd=bfast(3)-zbd;
    ax=newV(7);               % ax 
    ay=newV(8);               % ay
    az=newV(9);               % az
    wx=newV(10);
    wy=newV(11);
    wz=newV(12);
    angs=[ax,ay,az];
    
    fclose all;

    
    %{
    % Controls Code here -\/-------------------------------------------- %
    
    Opos=[Plat,Plon,zb];
    Dpos=[Dlat,Dlon,Dhei];
    
    newvecs=CurrentP(Ovec,angs,Dpos,alpha,wdirB);
    
    x3d=newvecs(1);     % New desired velocity of mass 3
    y4d=newvecs(2);     % New desired velocity of mass 4
    alpha=[newvecs(3),newvecs(4)];  % New desired angles of attack, [H,V]
    
    % Controls Code here -/\-------------------------------------------- %
    %}
    

end
toc

% Plotting results in the O frame
scn=get(0,'ScreenSize');                % gets screen dimensions
figure('Position',[1 1 scn(3) scn(4)])  % makes the image full screen
subplot(3,2,1)                          % creates subplot
plot(t,xbv)
title('X position')
xlabel('Time (s)')
ylabel('X Position (m)')
subplot(3,2,3)                          % creates subplot
plot(t,ybv)
title('Y Position')
xlabel('Time (s)')
ylabel('Y Position (m)')
subplot(3,2,5)                          % creates subplot
plot(t,zbv)
title('Z Position')
xlabel('Time (s)')
ylabel('Z Position (m)')
subplot(3,2,2)                          % creates subplot
plot(t,axv)
title('Angle about X')
xlabel('Time (s)')
ylabel('ax (deg)')
subplot(3,2,4)                          % creates subplot
plot(t,ayv)
title('Angle about Y')
xlabel('Time (s)')
ylabel('ay (deg)')
subplot(3,2,6)                          % creates subplot
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