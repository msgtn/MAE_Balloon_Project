% Determine the force acting on the balloon from the wind
% INPUTS: 
% pressure = pressure at balloon in N/m2
% temperature = temperature at balloon in degK
% direction = wind direction at balloon (0=coming from north)
% speed = wind speed in m/s
% aoa = [horizontal vertical] angles of attack for the wings
% angles = [ax ay az] current Euler angles
% OUTPUTS:
% force = force vector of B components in N in the B frame and
% wind direction overall; force=[iB,jB,kB,dirO] 

% ASSUMPTION that North=jO, East=iO, South=-jO, West=-iO
% Assume wind acts same on both wings
function force=windF(pressure,temperature,direction,speed,aoa,angles)
% Compontnts of Velocity
phi=direction*pi/180;        % converts angle to radians
vxO=-speed*sin(phi);         % iO component of velocity
vyO=-speed*cos(phi);         % jO component of velocity
vzO=0;                       % assume wind is horizontal
vO=[vxO;vyO;vzO];

% Find Density
rho=Density(pressure,temperature); % density of air kg/m^3

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
vz=vB(3);

% Find Cd for a rectangle (assumed rectangle)
Cd=1.17;

% Horizontal Wing
Axh=0.12;                   % m2, x cross-section area
Ayh=0.87;                   % m2, y cross-section area
C1=liftDrag(aoa(1));   % lift and drag coefficients
if phi>270*pi/180 
    FLhk=(1/2)*rho*vyB*vyB*Ayh*C1(1); % N, kO direction
    FDhj=-(1/2)*rho*vyB*vyB*Ayh*C1(2);% N, jO direction
    FDhi=((1/2)*vxB*vxB*rho)*Axh*Cd;    % N, iO
elseif phi<90*pi/180
    FLhk=(1/2)*rho*vyB*vyB*Ayh*C1(1); % N, kO direction
    FDhj=-(1/2)*rho*vyB*vyB*Ayh*C1(2);% N, jO direction
    FDhi=-((1/2)*vxB*vxB*rho)*Axh*Cd;    % N, iO
else
    FLhk=0;
    FDhj=((1/2)*vyB*vyB*rho)*Ayh*Cd;                % N,jO direction
    FDhi=((1/2)*vxB*vxB*rho)*Axh*Cd*(vxB/(1.01*abs(vxB))); % N,iO
end

% Vertical Wing
Axv=6.1;                    % m2, x cross-section area
Ayv=0.87;                   % m2, y cross-section area
C2=liftDrag(aoa(2));   % lift and drag coefficients
if phi>270*pi/180 
    FLvi=(1/2)*rho*vyB*vyB*Ayv*C2(1); % N, kB direction
    FDvj=-(1/2)*rho*vyB*vyB*Ayv*C2(2); % N, jB direction
    FDvi=((1/2)*vxB*vxB*rho)*Axv*Cd;    % N, iB
elseif phi<90*pi/180
    FLvi=(1/2)*rho*vyB*vyB*Ayv*C2(1); % N, kB direction
    FDvj=-(1/2)*rho*vyB*vyB*Ayv*C2(2); % N, jB direction
    FDvi=-((1/2)*vxB*vxB*rho)*Axv*Cd;    % N, iB
else
    FLvi=0;
    FDvj=((1/2)*vyB*vyB*rho)*Ayv*Cd;     % N,jB direction
    FDvi=((1/2)*vxB*vxB*rho)*Axh*Cd*(vxB/(1.01*abs(vxB))); % N,iB
end

fx=FDhi+FLvi+FDvi;      % N, x direction force
fy=FDhj+FDvj;           % N, y direction force
fz=FLhk;                % N, z direction force
force=[fx,fy,fz,direction];% N, force vector in B frame, deg, direction 
end