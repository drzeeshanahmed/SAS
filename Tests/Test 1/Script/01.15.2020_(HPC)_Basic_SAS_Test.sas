/********************************************************************************************
Project: High Performance Computing- Testing
Program: Running some basic functions 
Run twice
Dataset: nhanes3 (smaller), nh(big data)
Analyst: Charu Verma
Date: 01.15.2021*/
libname lib "M:\Pine_Piety\Users\Charu\HPC";
data test;
set lib.nhanes3;
run;
proc contents data=test;
run;
options number pageno=1 ls=79 ps=59 ;
options formchar = "|----|+|---+=|-/\<>*";
proc printto new print='M:\Pine_Piety\Users\Charu\HPC\01152020_(HPC)_BasicSAS_test.txt';
run;
/*Descriptive statistics*/
title 'Descriptive statistics';
proc means data = test;
 var _numeric_;
run;
proc anova data=test;
 class sex;
 model age education sbp dbp  = sex;
run;
proc freq data=test;
 tables sex  dmaethnr dmaracer dmarethn dmpmetro death dentalhealth hipfract marital  
 cancer cholesterol colon cvd diabetes hypertension health stroke;
run;
title 'Correlation-Age and Diastolic BP';
proc corr data=test nomiss spearman;
 var age dbp;
run;
proc summary data=test;
  var hipfract cancer colon cvd stroke;
  class seqn;
  output out=work.summary1 (drop=_type_freq_)
  sum= hipfracttot cancertot colontot cvdtot stroketot;
run;
proc sort data=work.summary1 out=total;by seqn;run;
proc sort data=test; by seqn;run;
proc sql;
	create table tot_summary as
	 select *
		from summary1  a inner join test b
	on a.seqn =b.seqn;
quit;
proc tabulate data= tot_summary;
title 'Table';
    class sex;
	var hipfracttot cancertot colontot cvdtot stroketot;
	table sex * (N Mean Max) ,
            hipfracttot cancertot colontot cvdtot stroketot;
run; 
proc format;
value race
1=	"Non-Hispanic white"
2=	"Non-Hispanic black"
3=	"Mexican-American"	
4=	"Other"	
;
value gender
1=	"Male"	
2=	"Female"
;
value health
1=	"Excellent"	
2=	"Very good"	
3=	"Good"	
4=	"Fair"	
5=	"Poor"	
8=	"Blank but applicable"	
9=	"Dont know"
;

value smoke
1=	"Current"
2=	"Former"
3=	"Never"
; 
run;
data summary_rep;
set tot_summary;
 format sex gender. smoking smoke. health health. dmarethn race.;
 run;

proc report data= summary_rep;
	title 'Data Report';
	column sex health smoking hipfracttot cancertot colontot cvdtot stroketot;
	define sex/group;
	define health/group;
	define smoking/group;
	define hipfracttot/analysis sum width=5;
	define cancertot/analysis sum width=5;
	define colontot/analysis sum width=5;
	define stroketot/analysis sum width=5;
	
run;

