/*
Legend for milecats.csv category codes

CONTENT: Subject?

Hdem = Human demographics
(Mortality, births, disease, crime)

Pdem = Physical demographics
(Astronomy, agriculture, weather, production, transportation, measurements, colour, elements, investment, chemistry, depth perception, motion, industrial processes)

Other
(Film, photography, invention, logic/reasoning)

Math = Mathematical/Statistical properties
(Coordinates, density, data points, error, matrices, distance, speed/velocity, trigonometry, probabilities, calculation, relations)

FORM: Aspect

Stats = Statistics
(Graphs, statistical methods, formulae, curves, lines,courses, exhibitions, textbooks, computation, analysis, theory, term)

Cart = Cartography
(Flow maps, physical maps, population maps)

Tech = Technology
(paper, machinery e.g., printing press, pantograph, instruments)

Other
(Book, periodic table)
*/

%include goptions;
goptions vsize=5.5in hsize=5.5in htext=1.9 htitle=2.8;

proc format;
	value yrgrp
		low-1599  = '<1600'
		1600-1699 = '17C'
		1700-1799 = '18C'
		1800-1899 = '19C'
		1900-1949 = '1900-'
		1950-1974 = '1950-'
		1975-high = '1975+';
	value $newsub
		'Hdem' = 'Human'
		'Pdem' = 'Physical'
		'Math' = 'Math-Stats';
	value $newasp
		'Cart' = 'Maps'
		'Stats'= 'Diagrams'
		'Tech' = 'Technology';
				
data years;
    infile 'milecats.csv' dsd missover firstobs=2;
    length key $12 ;
	
    input key $ year  where $ Subject $ Aspect $;
	Epoch = put(year, yrgrp.);
    label year='Year'
		Subject = 'Subject'
		Aspect = 'Aspect';

data years;
	length Subject Aspect $14;
	set years;
	where Subject ^= 'Other' and Aspect ^= 'Other';
	*format Subject $newsub. Aspect $newasp.;
	Subject = put(Subject, $newsub.);
	Aspect  = put(Aspect, $newasp.);
	
proc freq order=data data=years;
	where Aspect ^= 'Other';
	tables Aspect * Subject * Epoch / norow nocol nopercent;
	tables Subject * Aspect * Epoch / norow nocol nopercent;
	
	tables Subject * Epoch / norow nocol nopercent;
	tables Aspect * Epoch / norow nocol nopercent;


*gdispla(OFF);	
%table(data=years, var=Epoch Aspect, order=data, format= Aspect $newasp.);
*proc print data=table;

%mosaic(data=table, vorder=Epoch Aspect, plots=2, htext=2.4, devtype=adj lr
	, cellfill=freq
/*	,title=Model: &MODEL */
	);
*gskip;

%table(data=years, var=Epoch Subject, order=data, format=Subject $newsub. );
proc print data=table;

%mosaic(data=table, vorder=Epoch Subject, plots=2,
	lorder=Subject: Physical Human Math-Stats, htext=2.4, devtype=adj lr
	, cellfill=freq
/*	,title=Model: &MODEL */

	);

*gskip;
%table(data=years, var=Aspect Subject, order=data,
	format=Subject $newsub. Aspect $newasp.);
*proc print data=table;

%mosaic(data=table, vorder=Aspect Subject, plots=2,
	lorder=Subject: Physical Human Math-Stats, htext=2.4, devtype=adj lr
	, cellfill=freq
/*	,cellfill=size 2 */
/*	,title=Model: &MODEL */
	);
	;
*gskip;

%gdispla(ON);	
%panels(rows=1, cols=2, first=2);

/*
proc sort data=years;
	by Subject Aspect year;

proc print;
	id Subject Aspect;
	by Subject Aspect;
	var year key;
*/
