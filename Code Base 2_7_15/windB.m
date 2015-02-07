% Determine the force acting on the balloon from the wind
% INPUTS: 
% pressure = pressure at balloon in N/m2
% temperature = temperature at balloon in degK
% direction = wind direction at balloon (0=coming from north)
% speed = wind speed in m/s
% angles = [ax ay az] current Euler angles
% OUTPUTS:
% force = force vector of [iB,jB,kB] components in N in B frame

% ASSUMPTION that North=jO, East=iO, South=-jO, West=-iO
function force=windB(pressure,temperature,direction,speed,angles)
% Compontnts of Velocity in the O frame
phi=direction*pi/180;       % converts angle to radians
vxO=-speed*sin(phi);         % iO component of velocity
vyO=-speed*cos(phi);         % jO component of velocity
vzO=0;                       % assume wind is horizontal
vO=[vxO;vyO;vzO];

% Find Density
rho=Density(pressure,temperature); % density of air kg/m^3
m=0.004002;     % molar mass of He (?)
k=1.38e-23;     % constant
Na=6.022e23;    % avogadros number
rhoHe=pressure*m/(k*temperature*Na); % density of He in kg/m3

% Get from O frame to B frame, we need to rotate by ax about io, ay about
% jo and az about ko
ax=angles(1);
ay=angles(2);
az=angles(3);
Rx=[1 0 0;0 cos(ax) sin(ax);0 -sin(ax) cos(ax)];
Ry=[cos(ay) 0 -sin(ay);0 1 0;sin(ay) 0 cos(ay)];
Rz=[cos(az) sin(az) 0;-sin(az) cos(az) 0;0 0 1];
BCO=Rz*Ry*Rx;

% Velocities in the B frame
vB=BCO*vO;
vxB=vB(1);
vyB=vB(2);
vzB=vB(3);

% Calculate Pressure load in x,y,z
pmx=(1/2)*vxB*vxB*rho;
pmy=(1/2)*vyB*vyB*rho;
pmz=(1/2)*vzB*vzB*rho;

% Crozz sectional area of the balloon (Solidworks)
Ax=3570.78;     % m2
Ay=3570.78;     % m2
Az=4261.41;     % m2

% Cd for the balloon (assumed to be spherical)
Cd=0.5;

% Calculate Forces
Fx=pmx*Cd*Ax;      % O frame Fx
Fy=pmy*Cd*Ay;      % O frame Fy
Fz=pmz*Cd*Az;      % O frame Fz
force=[Fx,Fy,Fz,rho,rhoHe]; % forces in N and density in kg/m3
end