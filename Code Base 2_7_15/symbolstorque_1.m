% MAE 511 Group Project Two
% Generates symbolic torque

% Legend:
% d is derivative wrt time
% dd is double derivative wrt time

syms mt xcmb xcmbd xcmbdd ycmb ycmbd ycmbdd zcmb zcmbd zcmbdd ...
    x1 x1d x1dd x2 x2d x2dd x3 x3d x3dd x4 x4d x4dd y1 y1d y1dd ...
    y2 y2d y2dd y3 y3d y3dd y4 y4d y4dd z1 z1d z1dd z2 z2d z2dd ...
    z3 z3d z3dd z4 z4d z4dd wx wxd wy wyd wz wzd I m1 m2 m3 m4 xb ...
    xbd xbdd yb ybd ybdd zb zbd zbdd ib jb kb

ohbi=(mt*(ycmb*(z1d+z2d+z3d+z4d+zbd+wx*yb-wy*xb)-zcmb*(y1d+y2d+y3d+y4d+ybd ...
    +wz*xb-zb*wx))+wx*(m1*(y1*y1+z1*z1)+m2*(y2*y2+z2*z2)+m3*(y3*y3+z3*z3 ...
    )+m4*(y4*y4+z4*z4))-wy*(m1*x1*y1+m2*x2*y2+m3*x3*y3+m4*x4*y4)-wz*( ...
    m1*x1*z1+m2*x2*z2+m3*x3*z3+m4*x4*z4)+I*wx);

ohbj=(mt*(zcmb*(x1d+x2d+x3d+x4d+xbd+wx*yb-wy*xb)-xcmb*(z1d+z2d+z3d+z4d+zbd ...
    +wy*zb-wz*yb))+wy*(m1*(x1*x1+z1*z1)+m2*(x2*x2+z2*z2)+m3*(x3*x3+z3*z3) ...
    +m4*(x4*x4+z4*z4))-wx*(m1*x1*y1+m2*x2*y2+m3*x3*y3+m4*x4*y4)-wz*( ...
    m1*y1*z1+m2*y2*z2+m3*y3*z3+m4*z4*y4)+I*wy);

ohbk=(mt*(xcmb*(y1d+y2d+y3d+y4d+ybd+xb*wz-wx*zb)-ycmb*(x1d+x2d+x3d+x4d+xbd ...
    +wy*zb-wz*yb))+wz*(m1*(x1*x1+y1*y1)+m2*(x2*x2+y2*y2)+m3*(x3*x3+y3*y3) ...
    +m4*(x4*x4+y4*y4))-wx*(m1*x1*z1+m2*x2*z2+m3*x3*z3+m4*x4*z4)-wy*( ...
    m1*y1*z1+m2*y2*z2+m3*y3*z3+m4*y4*z4)+I*wz);

w=[wx wy wz];
ohb=[ohbi ohbj ohbk];
cri=wy*ohbk-wz*ohbj;
crj=wz*ohbi-wx*ohbk;
crk=wx*ohbj-wy*ohbi;

cr=[cri;crj;crk];

addi=(ybd+xb*wz-wx*zb)*(zcmbd+wx*ycmb-wy*xcmb)-(zbd+wx*yb-wy*xb)*(ycmbd+wz*xcmb-wx*zcmb);

addj=(zbd+wx*yb-wy*xb)*(xcmbd+wy*zcmb-wz*ycmb)-(xbd+wy*zb-wz*yb)*(zcmbd+wx*ycmb-wy*xcmb);

addk=(xbd+wy*zb-wz*yb)*(xcmbd+wy*zcmb-wz*ycmb)-(ybd+xb*wz-wx*zb)*(xcmbd+wy*zcmb-wz*ycmb);

add=[addi;addj;addk];
h=cr+add;            % addition of w x hb and mtvbo x ovcmo

Dohbi=mt*(ycmbd*(z1d+z2d+z3d+z4d+zbd+wx*yb-wy*xb)+ycmb*(z1dd+z2dd+z3dd+ ...
    z4dd+zbdd+wxd*yb+wx*ybd-wyd*xb-wx*ybd)-zcmbd*(y1d+y2d+y3d+y4d+ybd+ ...
    wz*xb-zb*wx)-zcmb*(y1dd+y2dd+y3dd+y4dd+ybdd+wz*xbd+wzd*xb-zbd*wx- ...
    zb*wxd))+wx*(m1*(2*y1*y1d+2*z1*z1d)+2*m2*(y2*y2d+z2*z2d)+2*m3*(y3* ...
    y3d+z3*z3d)+2*m4*(y4*y4d+z4*z4d))+wxd*(m1*(y1*y1+z1*z1)+m2*(y2*y2+ ...
    z2*z2)+m3*(y3*y3+z3*z3)+m4*(y4*y4+z4*z4))-wyd*(m1*x1*y1+m2*x2*y2+ ...
    m3*x3*y3+m4*x4*y4)-wy*(m1*(x1*y1d+x1d*y1)+m2*(x2*y2d+x2d*y2)+m3*( ...
    x3*y3d+x3d*y3)+m4*(x4*y4d+x4d*y4))-wzd*(m1*x1*z1+m2*x2*z2+m3*x3*z3+ ...
    m4*x4*z4)-wz*(m1*(x1d*z1+x1*z1d)+m2*(x2d*z2+x2*z2d)+m3*(x3d*z3+x3*z3d) ...
    +m4*(x4d*z4+x4*z4d))+I*wxd;

Dohbj=mt*(zcmbd*(x1d+x2d+x3d+x4d+xbd+wx*yb-wy*xb)+zcmb*(x1dd+x2dd+x3dd+ ...
    x4dd+xbdd+wxd*yb+wx*ybd-wyd*xb-wy*xbd)-xcmbd*(z1d+z2d+z3d+z4d+zbd+ ...
    wy*zb-yb*wz)-xcmb*(z1dd+z2dd+z3dd+z4dd+zbdd+wy*zbd+wyd*zb-ybd*wz- ...
    yb*wzd))+wy*(m1*(2*x1*x1d+2*z1*z1d)+2*m2*(x2*x2d+z2*z2d)+2*m3*(x3* ...
    x3d+z3*z3d)+2*m4*(x4*x4d+z4*z4d))+wyd*(m1*(x1*x1+z1*z1)+m2*(x2*x2+ ...
    z2*z2)+m3*(x3*x3+z3*z3)+m4*(x4*x4+z4*z4))-wxd*(m1*x1*y1+m2*x2*y2+ ...
    m3*x3*y3+m4*x4*y4)-wx*(m1*(x1*y1d+x1d*y1)+m2*(x2*y2d+x2d*y2)+m3*( ...
    x3*y3d+x3d*y3)+m4*(x4*y4d+x4d*y4))-wz*(m1*(y1d*z1+y1*z1d)+m2*(y2d*z2 ...
    +y2*z2d)+m3*(y3d*z3+y3*z3d)+m4*(y4d*z4+y4*z4d))-wzd*(m1*y1*z1+m2*y2*z2+ ...
    m3*y3*z3+m4*y4*z4)+I*wyd;

Dohbk=mt*(xcmbd*(y1d+y2d+y3d+y4d+ybd+xb*wz-wx*zb)+xcmb*(y1dd+y2dd+y3dd+y4dd+ ...
    ybdd+xbd*wz+xb*wzd-wx*zbd-wxd*zb)-ycmbd*(x1d+x2d+x3d+x4d+xbd+wy*zb- ...
    wz*yb)-ycmb*(x1dd+x2dd+x3dd+x4dd+xbdd+wy*zbd+wyd*zb-wz*ybd-wzd*yb))+ ...
    2*wz*(m1*(x1*x1d+y1*y1d)+m2*(x2*x2d+y2*y2d)+m3*(x3*x3d+y3*y3d)+m4*( ...
    x4*x4d+y4*y4d))+wzd*(m1*(x1*x1+y1*y1)+m2*(x2*x2+y2*y2)+m3*(x3*x3+y3*y3)...
    +m4*(x4*x4+y4*y4))-wxd*(m1*x1*z1+m2*x2*z2+m3*x3*z3+m4*x4*z4)-wx*(m1*( ...
    x1*z1d+x1d*z1)+m2*(x2*z2d+x2d*z2)+m3*(x3*z3d+x3d*z3)+m4*(x4*z4d+x4d*z4))...
    -wyd*(m1*y1*z1+m2*y2*z2+m3*y3*z3+m4*y4*z4)-wy*(m1*(y1*z1d+y1d*z1)+m2*( ...
    y2*z2d+y2d*z2)+m3*(y3*z3d+y3d*z3)+m4*(y4*z4d+y4d*z4))+I*wzd;

Dohb=[Dohbi;Dohbj;Dohbk];

T=Dohb+h ;       % torque monster expressed in the B frame

% Setting things to zero
% z1d=z2d=z3d=z4d=0
% z1dd=z2dd=z3dd=z4dd=0
% zbd=zbdd=0 "assumes no horizontal wing"
% zcmb=zcmbd=zcmbdd=0 "assumes that cm is only in iB jB plane"
% m1=balloon, m2=wing, can't move
% x1d=x1dd=x2d=x2dd=0
% y1d=y1dd=y2d=y2dd=0
% z1d=z1dd=z2d=z2dd=0
% assume m3 along i only, then m4 along j only
% y3=y3d=y3dd=0
% x4=x4d=x4dd=0
% Assume masses move at constant speed
% x3dd=y4dd=0
% z3=z4=0 bc in same plane as B

z1d=0;
z2d=0;
z3d=0;
z4d=0;
z1dd=0;
z2dd=0;
z3dd=0;
z4dd=0;
zbd=0;
zbdd=0;
zcmb=0;
zcmbd=0;
zcmbdd=0;
x1d=0;
x1dd=0;
x2d=0;
x2dd=0;
y1d=0;
y1dd=0;
y2d=0;
y2dd=0;
z1d=0;
z1dd=0;
z2d=0;
z2dd=0;
y3=0;
y3d=0;
y3dd=0;
x4=0;
x4d=0;
x4dd=0;
x3dd=0;
y4dd=0;

z3=0;
z4=0;


T=eval(T)

% to get from O frame to B frame we need to rotate by ax about io, ay about
%jo and az about ko
syms ax ax ay ay az az

R1=[1 0 0;0 cos(ax) sin(ax);0 -sin(ax) cos(ax)];
R2=[cos(ay) 0 -sin(ay);0 1 0;sin(ay) 0 cos(ay)];
R3=[cos(az) sin(az) 0;-sin(az) cos(az) 0;0 0 1];

R=R1*R2*R3;

%We will get forces in the O frame from the velocities in O frame and then
%use the rotation matrix to transfer these forces to the O frame
% In the follo calculations all forces are taken to be in the B frame

syms fbx fby fbz %fb is boutant force acting in B frame

t1ib=fbz*y1-z1*fby;
t1jb=z1*fbx-fbz*x1;
t1kb=x1*fby-y1*fbx;

syms fv1x fv1y fv1z %fv1 is wind force on ballon at point m1 in B frame

t2ib=y1*fv1z-z1*fv1y;
t2jb=z1*fv1x-x1*fv1z;
t2kb=x1*fv1y-y1*fv1x;

syms fgx fgy fgz %gravity force in the B frame
t3ib=ycmb*fgz-zcmb*fgy;
t3jb=zcmb*fgx-xcmb*fgz;
t3kb=xcmb*fgy-ycmb*fgx;

syms flx fly flz %lift force components in B frame
t4ib=y2*flz-z2*fly;
t4jb=z2*flx-x2*flz;
t4kb=x2*fly-y2*flx;

syms fdx fdy fdz %drag force components in B frame
t5ib=y2*fdz-z2*fdy;
t5jb=z2*fdx-x2*fdz;
t5kb=x2*fdy-y2*fdx;

ti=t1ib+t2ib+t3ib+t4ib+t5ib;
tj=t1jb+t2jb+t3jb+t4jb+t5jb;
tk=t1kb+t2kb+t3kb+t4kb+t5kb;

Ti=T(1);
Tj=T(2);
Tk=T(3);

ti0=ti-Ti
tj0=tj-Tj
tk0=tk-Tk

x1=2;x2=2;y1=2;y2=2;
xb=4;yb=6;zb=4;

ti0=eval(ti0)














