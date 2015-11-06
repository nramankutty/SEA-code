
%load disaster-year complete data
load GroupComp_input.dat

%perform quadratic transform
bycropDPt = bycrop_DP.^2;
bycropDYt = bycrop_DY.^2;
bycropDAt = bycrop_DA.^2;
bycropHWPt = bycrop_HWP.^2;
bycropHWYt = bycrop_HWY.^2;
bycropHWAt = bycrop_HWA.^2;

%perform Levene's test on transformed data 
transform_square_DP_levene = vartestn(bycropDPt,'TestType','LeveneAbsolute');
transform_square_DY_levene = vartestn(bycropDYt,'TestType','LeveneAbsolute');
transform_square_DA_levene = vartestn(bycropDAt,'TestType','LeveneAbsolute');
transform_square_HWP_levene = vartestn(bycropHWPt,'TestType','LeveneAbsolute');
transform_square_HWY_levene = vartestn(bycropHWYt,'TestType','LeveneAbsolute');
transform_square_HWA_levene = vartestn(bycropHWAt,'TestType','LeveneAbsolute');
%results: mixed, reject null hypothesis that variances differ across
%groupings in some cases, failure to reject in others

%Anderson-Darling test for normality (example): 
%column 1 = wheat, column 2 = rice, column 3 = maize
adtest(bycropDPt(:,1))
adtest(bycropDPt(:,2))
adtest(bycropDPt(:,3))
adtest(bycropDYt(:,3))
adtest(bycropDYt(:,2))
adtest(bycropDYt(:,1))
adtest(bycropDAt(:,1))
adtest(bycropDAt(:,2))
adtest(bycropDAt(:,3))
%results: reject null hypothesis that sample distributions are from
%population with normal distribution -> normal assumption not met

%Kruskal-Wallis test on group distributions (example)
kruskalwallis(bycropDPt)
kruskalwallis(bycropDYt)
kruskalwallis(bycropDAt)
%results: mixed, some significant differences in distribution, not
%significant in other cases

