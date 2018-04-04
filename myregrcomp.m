function myregrcomp(x1,y1,x2,y2)
%MYREGCOMP: Compare two linear regressions.
%This function compares two least-square linear regression.
%Test are implemented as reported by Stanton A. Glantz book
%This routine uses MYREGR function. If it is not present on
%the computer, myregrcomp will try to download it from FEX
%
% SEE also myregr, myregrcomp
%
% Syntax: 	x=myregrcomp(X)
%
%     Inputs:
%           Xn - Array of the independent variable 
%           Yn - Dependent variable. If Y is a matrix, the i-th Y row is a
%           repeated measure of i-th X point. The mean value will be used
%           verbose - Flag to display all information (default=1) 
%     Outputs:
%           - Summary of MYREGR function
%           - Global test
%           - Test on slopes (eventually)
%           - Test on intercepts (eventually)
%
% Example:
% x1=[1 2 3 4 5 6 7 8 9 10];
% y1=[-0.5052 0.2045 0.9586 1.3357 1.1463 2.8586 4.0651 4.2444 5.2673 5.8634]; 
% x2=[3 5 7 9 11 13 15];
% y2=[-3.6517 -6.0197 -9.2270 -11.0558 -14.7402 -17.3678 -19.9047];
%
%   Calling on Matlab the function: 
%             x=myregrcomp(x1,y1,x2,y2)
%
%   Answer is:
%
% First regression parameters estimation
% These points are outliers at 95% fiducial level
%     X      Y   
%     _    ______
% 
%     5    1.1463
% 
% Do you want to delete outliers? Y/N [Y]: n
%  
% Second regression parameters estimation
% Combined regression parameters estimation
% These points are outliers at 95% fiducial level
%     X       Y   
%     __    ______
% 
%     10    5.8634
% 
% Do you want to delete outliers? Y/N [Y]: n
%  
%                      Regr1      Regr2      Regr_Tot
%                     _______    ________    ________
% 
%     Points               10           7         13 
%     Slope           0.72174     -3.9708    -4.0473 
%     Slope_se        0.04707    0.081941     1.0149 
%     Intercept       -1.4257    0.067181     15.228 
%     intercept_se    0.29206     0.80702     8.4446 
%     Regre_se        0.42753     0.86718     15.064 
% 
% GLOBAL TEST
%       F       DF_numerator    DF_denominator    p_value
%     ______    ____________    ______________    _______
% 
%     4230.3    2               13                0      
% 
% These regressions are different
%  
% TEST ON SLOPES
%       t       DF     p_value  
%     ______    __    __________
% 
%     8.6275    13    4.8456e-07
% 
% The slopes are different and these regressions should not be parallel
% Evaluate if the product of slopes = -1 to check perpendicularity
%  
% TEST ON INTERCEPTS
%       t       DF    p_value 
%     ______    __    ________
% 
%     2.1725    13    0.024453
% 
% The intercepts are different
%  
% These regressions cross at the point:
%       xc         yc   
%     _______    _______
% 
%     0.31814    -1.1961
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2007) MyRegressionCOMP: a simple routine to compare two LS
% regression. 
% http://www.mathworks.com/matlabcentral/fileexchange/15953

if exist('myregr.m','file')==0
    filename=unzip('https://it.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/15473/versions/10/download/zip','prova');
    Index = contains(filename,'myregr.m');
    current=cd;
    copyfile(filename{Index},current)
    rmdir('prova','s')
    clear filename Index current 
end

%first regression
disp('First regression parameters estimation')
[m1,q1,stat1]=myregr(x1,y1,0);
%second regression
disp('Second regression parameters estimation')
[m2,q2,stat2]=myregr(x2,y2,0);

n=[stat1.n stat2.n]; m=[m1.value m2.value]; mse=[m1.se m2.se]; 
qse=[q1.se q2.se];q=[q1.value q2.value]; rse=[stat1.rse stat2.rse];

%total regression
disp('Combined regression parameters estimation')
x=sortrows([x1' y1'; x2' y2'],1);
[m3,q3,stat3]=myregr(x(:,1)',x(:,2)',0);

%assemble all
matrix=[n stat3.n; ... %points
        m m3.value; ...%slopes
        mse m3.se; ...%standard errors on slopes
        q q3.value;...%intercepts
        qse q3.se; ...%standard errors on intercepts
        rse stat3.rse];%regressions standard errors
%display results
disp(array2table(matrix,'VariableNames',{'Regr1','Regr2','Regr_Tot'},...
    'RowNames',{'Points','Slope','Slope_se','Intercept','intercept_se','Regre_se'}))
disp('GLOBAL TEST')

vd=(sum(n)-4); %denominator degrees of freedom
%combined variance of separated regressions
cs=(sum((n-2).*rse.^2))/vd;
%variation in variance of separated regressions
vs=((vd+2)*stat3.rse^2-vd*cs)/2;
%F test
F=abs(vs/cs); p=1-fcdf(F,2,vd);
%display results
disp(array2table([F 2 vd p],'VariableNames',{'F' 'DF_numerator' 'DF_denominator' 'p_value'}));
if p>=0.05
    disp('These regressions are equal')
else
    disp('These regressions are different')
    disp(' ')
    disp('TEST ON SLOPES')
    cs=sum((n-2).*mse.^2)/vd;
    cse=realsqrt(cs.*sum(1./((n-1).*mse.^2)));
    t=abs(diff(m))/cse; p1=1-tcdf(t,vd);
    disp(array2table([t vd p1],'VariableNames',{'t' 'DF' 'p_value'}))
    if p1>=0.05
        disp('The slopes are equal and these regressions should be parallel')
    else
        disp('The slopes are different and these regressions should not be parallel')
        disp('Evaluate if the product of slopes = -1 to check perpendicularity')
    end
    disp(' ')
    disp('TEST ON INTERCEPTS')
    cs=sum((n-2).*qse.^2)/vd;
    cse=realsqrt(cs.*sum(1./((n-1).*qse.^2)));
    t=abs(diff(q))/cse; p2=1-tcdf(t,vd);
    disp(array2table([t vd p2],'VariableNames',{'t' 'DF' 'p_value'}))    
    if p2>=0.05
        disp('The intercepts are equal')
    else
        disp('The intercepts are different')
    end
    if p1<0.05
        xc = (q2.value-q1.value)/(m1.value-m2.value);
        yc = m1.value*xc+q1.value;
        disp(' ')
        disp('These regressions cross at the point:')
        disp(table(xc,yc))
    end
end
figure('Color',[1 1 1],'outerposition',get(groot,'ScreenSize'));
hold on
plot(x1,y1,'ro')
plot(x2,y2,'bo')
if exist ('xc','var')
    plot(xc,yc,'k+','MarkerSize',12)
    xg=[min([x1 x2 xc]) max([x1 x2 xc])];
else
    xg=[min([x1 x2]) max([x1 x2])];
end
plot(xg,polyval([m1.value q1.value],xg),'r-','linewidth',2)
plot(xg,polyval([m2.value q2.value],xg),'b-','linewidth',2)
hold off