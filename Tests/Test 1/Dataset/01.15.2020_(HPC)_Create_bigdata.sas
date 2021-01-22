/********************************************************************************************
Project: High Performance Computing- Testing
Program: This program is designed to create a larger dataset by looping small dataset nhanes
Analyst: Charu Verma
Date: 01.15.2021*/
libname lib "M:\Pine_Piety\Users\Charu\HPC";/*Assign pathname to your folder with dataset*/
data nhanes;
set lib.nhanes3;
run;
*Create a large data file for testing purposes*;
%macro loop;
%do i =1 %to 1000000;
proc append
base=lib.nh
data=nhanes;
run;
%end;
%mend;
%loop;
data new;
set lib.nh;
run;
