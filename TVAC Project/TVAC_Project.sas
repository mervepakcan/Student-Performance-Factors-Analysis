libname mylib clear;

/* Defining the "libmerv1" library to access the directory containing the data files */
libname libmerv1 "/export/viya/homes/merve.pakcan@stud.acs.upb.ro/casuser/";

/* Importing the dataset */
proc import datafile="/export/viya/homes/merve.pakcan@stud.acs.upb.ro/casuser/StudentPerformanceFactors.csv" 
    dbms=csv out=libmerv1.studperformance replace;
    /*guessingrows=32767; /* Ensures SAS scans all rows to correctly determine column types */
    getnames=yes;       
run;

/* Defining a macro variable for the dataset */
%let dataset = libmerv1.studperformance;

/* Displaying dataset structure and variables */
proc contents data=&dataset;
run;

/* Checking a sample of the dataset to ensure values loaded correctly */
proc print data=&dataset(obs=10);
run;

/* Identifying Missing Values */
/* Using proc means with nmiss to identify missing values in numeric columns. */
proc means data=&dataset n nmiss;
    var Hours_Studied Attendance Sleep_Hours Previous_Scores Exam_Score;
run;

/* Checking for Missing Values in all categorical Variables */
proc freq data=&dataset;
    tables _all_ / missing;
run;

/* Discovered missing values in the categorical variables */
/* Missing values: Teacher_Quality, Parental_Education_Level, and Distance_from_Home */
proc freq data=&dataset;
    tables Teacher_Quality Parental_Education_Level Distance_from_Home / missing;
run;

/* Dropping missing values and outliers */
data &dataset;
    set &dataset;
    where Teacher_Quality ne '' 
      and Parental_Education_Level ne '' 
      and Distance_from_Home ne ''
	  and 0 <= Exam_Score <= 100;
run;

/* Removing duplicates */
proc sort data=&dataset nodupkey;
    by _all_;
run;

/* Univariate statistics on the Cleaned Dataset */
proc univariate data=&dataset;
    var Exam_Score;
run;

/* Verifying that missing values are resolved in the cleaned dataset  */
proc freq data=&dataset;
    tables Teacher_Quality Parental_Education_Level Distance_from_Home / missing;
run;

/* Frequency analysis on the cleaned dataset  */
proc freq data=&dataset;
    tables School_Type Motivation_Level Parental_Education_Level Gender;
run;

/* Descriptive Statistics on the Cleaned Dataset */
proc means data=&dataset;
    var Hours_Studied Attendance Sleep_Hours Previous_Scores Exam_Score;
run;




