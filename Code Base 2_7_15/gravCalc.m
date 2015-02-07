% Calculates force of gravity and rotates into the B frame
% INPUTS:
%   height = height of center of mass of the system
%   angles = Eulers angles 
%   mass = system mass
% OUTPUTS:
%   fgravity = gravitational force in the B frame

function fgravity=gravCalc(heightCM,angles,mass)
    g0=9.80665;     % m/s2, gravity at earth's center
    re=6371000;     % m, mean radius of the earth
    
    gh=g0*((re/(re+heightCM))^2);     % m/s2, gravity
    fgO=-[0;0;mass*gh];               % N, force of gravity in O frame
    
    % Get from O frame to B frame, we need to rotate by ax about io, ay about
    % jo and az about ko
    ax=angles(1);
    ay=angles(2);
    az=angles(3);
    Rx=[1 0 0;0 cos(ax) sin(ax);0 -sin(ax) cos(ax)];
    Ry=[cos(ay) 0 -sin(ay);0 1 0;sin(ay) 0 cos(ay)];
    Rz=[cos(az) sin(az) 0;-sin(az) cos(az) 0;0 0 1];
    BCO=Rz*Ry*Rx;
    
    fgravity=BCO*fgO;       % N, force of gravity in B frame
end