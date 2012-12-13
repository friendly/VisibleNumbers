%include goptions;

data monarchs;
   length Monarch $12;
   input Monarch $& from to;
datalines;
Elizabeth        1558  1603
James I          1603  1628
Charles I        1628  1649
Cromwell         1649  1661
Charles II       1661  1683
James II         1683  1689
Wm. & Mary       1689  1702
Anne             1702  1714
George I         1714  1727
George II        1727  1762
George III       1762  1819
George IV        1811  1830
;
data bars;
	set monarchs end=eof;
	xsys='2'; ysys='3';   *-- % of output area;
	x = max(from, 1560);
	style = 'solid'; color='gray ';
	line=3;
	y = 75 + 1.1 * mod(_n_,2);
	function='move    '; output;
	x = min(to, 1820);
	y = y-0.9;
	function='bar    '; output;
	if eof
		then x = from;
		else x = (from+to)/2;
	*y = 75 + 1 * mod(1+_n_,2);
	y = y - 0.75;
	text = Monarch; color='black';
	size=0.75;
	function = 'label'; output;
	
data wheat;
	input Year   Wheat   Wages   Monarch $&;
	ratio = Wages / Wheat;
	ratio1 =  Wheat / Wages;
	label Wheat='Price of Wheat (Shillings/Quarter)'
		Wages = 'Weekly wage (Shillings)'
		Ratio = 'Wheat purchasing power (Quarters/week)'
		Ratio1 = 'Labour cost of wheat (Weeks/Quarter)'
		;
datalines;
1570   45   5.1   Elizabeth
1580   49   5.4   Elizabeth
1590   47   5.6   Elizabeth
1600   27   5.9   Elizabeth
1610   33   6.1   James I
1620   35   6.4   James I
1630   45   6.6   Charles I
1640   39   6.9   Charles I
1650   41   7.0   Charles I
1660   46   7.4   Cromwell
1670   38   7.8   Charles II
1680   35   8.2   Charles II
1690   40   8.6   James II
1700   30   9.0   William & Mary
1710   44   10.6   Anne
1720   29   11.7   Anne
1730   25   12.8   George I
1740   27   13.9   George II
1750   31   15.0   George II
1760   31   17.0   George II
1770   48   19.0   George III
1780   46   22.0   George III
1790   48   26.0   George III
1800   79   29.0   George III
1810   99   30.0   George III
1820   54   30.0   George IV
;
/*
proc gplot data=wheat;
	plot ratio * year / vaxis=axis1 haxis=axis2 vm=1 hm=1;
	symbol1 v=dot h=2 i=join;
	axis1 label=(a=90 r=0) order=(0 to .7 by .1)
		length=60 pct;
	axis2 order=(1560 to 1820 by 20);
run;
%gskip;
*/


data caption;
x = 1740;
input y size text $50.;
xsys='2'; ysys='1';
style='centxi';
y=y-8;
datalines;
92 2.6 CHART
82 2 Shewing in One View the Work 
75 2 Required to Purchase 
68 2 One Quarter of Wheat
;
%lowess(data=wheat, x=Year, Y=Ratio1, f=, outanno=smooth, gplot=no,
in=caption bars);

proc gplot data=wheat;
	plot ratio1 * year=1
	/ vaxis=axis1 haxis=axis2 vm=1 hm=1
		anno=smooth
	;
	symbol1 v=dot h=2 i=join c=black;
	*symbol2 v=none i=sm60 c=red w=2;
	axis1 label=(a=90 r=0)
		length=50 pct offset=(,4);
	axis2 order=(1560 to 1820 by 20);
run;
%gskip;

/*
proc gplot data=wheat;
	plot wheat * wages / vaxis=axis1 haxis=axis2 vm=1;
	axis1 label=(a=90 r=0) order=(0 to 100 by 10)
		length=50 pct;
	axis2  order=(0 to 30 by 5) offset=(,4);
	symbol1 v=dot h=2 i=join c=black ci=gray;
*/

	
proc gplot data=wheat;
	plot wages * wheat=1
	     wages * wheat=2
	 / overlay vaxis=axis2 haxis=axis1 vm=1;
	axis1  order=(0 to 100 by 10)
		;
	axis2 label=(a=90 r=0)  order=(0 to 30 by 5) offset=(,2) length=50 pct
		;
	symbol1 v=dot  h=2  i=join c=black ci=gray;
	symbol2 v=none i=rl   c=black ci=red l=3;
	
	
