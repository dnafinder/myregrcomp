# myregrcomp
Compare two linear regressions.<br/>
This function compares two least-square linear regression.
Test are implemented as reported by Stanton A. Glantz book
This routine uses MYREGR function. If it is not present on
the computer, myregrcomp will try to download it from FEX.
Syntax: 	x=myregrcomp(x1,y1,x2,y2)

    Inputs:
          x1,y1 - data of first regression
          x2,y2 - data of second regression
    Outputs:
          - Summary of MYREGR function
          - Global test
          - Test on slopes (eventually)
          - Test on intercepts (eventually)

          Created by Giuseppe Cardillo
          giuseppe.cardillo-edta@poste.it

To cite this file, this would be an appropriate format:
Cardillo G. (2007) MyRegressionCOMP: a simple routine to compare two LS
regressions. 
http://www.mathworks.com/matlabcentral/fileexchange/15953
