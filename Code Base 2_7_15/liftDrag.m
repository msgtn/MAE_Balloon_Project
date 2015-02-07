% Function to determine the lift and drag coefficients for a
% NACA 0015 airfoil based on data
% INPUT:
% alpha = angle of attack
% OUTPUT:
% coeffs = [lift,drag] is a vector of coefficients

function coeffs=liftDrag(alpha)
% Christopher D. Yoder
% MAE 511: Dynamics Two project

% Assume NACA 0015 Airfoil
% From http://airfoiltools.com/polar/details?polar=xf-naca0015-il-50000

values=[
-11.00	-0.8022	0.07748
-10.75	-0.8442	0.07035
-10.50	-0.8851	0.06475
-10.25	-0.9176	0.05969
-10.00	-0.9434	0.05517
-9.75	-0.9165	0.05358
-9.50	-0.9248	0.0503
-9.25	-0.9332	0.04694
-9.00	-0.9132	0.04547
-8.75	-0.9076	0.0431
-8.50	-0.8997	0.04122
-8.25	-0.8818	0.03986
-8.00	-0.868	0.03838
-7.75	-0.8545	0.03697
-7.50	-0.8402	0.03572
-7.25	-0.8248	0.03461
-7.00	-0.8089	0.03359
-6.75	-0.7934	0.03263
-6.50	-0.7795	0.03164
-6.25	-0.7622	0.03086
-6.00	-0.7431	0.03032
-5.75	-0.7273	0.02963
-5.50	-0.7103	0.02904
-5.25	-0.691	0.02869
-5.00	-0.6765	0.02808
-4.75	-0.6558	0.0279
-4.50	-0.638	0.02761
-4.25	-0.6209	0.02729
-4.00	-0.6011	0.02725
-3.75	-0.586	0.02691
-3.50	-0.5652	0.02701
-3.25	-0.5463	0.02705
-3.00	-0.5299	0.02694
-2.75	-0.5069	0.02726
-2.50	-0.4886	0.02733
-2.25	-0.4624	0.02772
-2.00	-0.4322	0.02817
-1.75	-0.3985	0.02859
-1.50	-0.3429	0.02935
-1.25	-0.2907	0.02981
-1.00	-0.2043	0.03039
-0.75	-0.1382	0.03057
-0.50	-0.0601	0.03056
-0.25	0.023	0.0303
0.00	0	0.0303
0.25	-0.023	0.03035
0.50	0.06	0.03056
0.75	0.1382	0.03056
1.00	0.2042	0.03039
1.25	0.2906	0.02981
1.50	0.3428	0.02934
1.75	0.3983	0.02858
2.00	0.4321	0.02816
2.25	0.4623	0.02771
2.50	0.4886	0.02733
2.75	0.5068	0.02726
3.00	0.5298	0.02694
3.25	0.5462	0.02704
3.50	0.5651	0.02701
3.75	0.5859	0.02691
4.00	0.6009	0.02725
4.25	0.6208	0.02729
4.50	0.6379	0.0276
4.75	0.6556	0.0279
5.00	0.6764	0.02807
5.25	0.6909	0.02869
5.50	0.7102	0.02904
5.75	0.7272	0.02962
6.00	0.743	0.0303
6.25	0.7621	0.03086
6.50	0.7795	0.03163
6.75	0.7934	0.03263
7.00	0.8088	0.03359
7.25	0.8247	0.0346
7.50	0.8401	0.03572
7.75	0.8544	0.03697
8.00	0.868	0.0383
8.25	0.8818	0.03986
8.50	0.8996	0.04122
8.75	0.9077	0.0431
9.00	0.9132	0.04547
9.25	0.9334	0.04694
9.50	0.9249	0.0503
9.75	0.9167	0.05358
10.00	0.9434	0.05519
10.25	0.9177	0.05971
10.50	0.8853	0.06478
10.75	0.8443	0.07039
11.00	0.8024	0.07755];

[L,m]=size(values);
for j=1:L
    if values(j,1)==alpha
        clift(j)=values(j,2);
        cdrag(j)=values(j,3);
    else
        clift(j)=0;
        cdrag(j)=0;
    end
coeffs=[sum(clift'),sum(cdrag')];
end