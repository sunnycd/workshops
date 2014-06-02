*______________________________________________________________________
*Intro to graphics with stata              
*Ista Zahn 
*Spring 2013
*--------------------------------------------------------------------
*--------------------------------------------------------------------

cd "~/StataGraphics"

use TimePollPubSchools.dta, clear

*****Graphs of Single Variables*****

codebook F1
histogram F1
hist F1, bin(10) percent title(TITLE) subtitle(SUBTITLE) caption(CAPTION) note(NOTES) xtitle(Here's your x-axis title) ytitle(here's your y-axis title)

/*Suppress axis titles*/
hist F1, bin(10) percent title(TITLE) subtitle(SUBTITLE) caption(CAPTION) note(NOTES) xtitle("") ytitle("")

/*Histogram of discrete variable*/
codebook F4
hist F4, title(Racial breakdown of Time Poll Sample) xtitle(Race) ytitle(Percent) xlabel(1 "White" 2 "Black" 3 "Asian" 4 "Hispanic" 5 "Other") discrete percent addlabels

/*Tabplot - compares responses across categorical variables*/

findit  tabplot
codebook rvb Q8
tabplot rvb Q8
tabplot rvb Q8, showval
recode Q8 (9=3)
tabplot rvb Q8, percent(Q8) title("Do you think public schools are" ///
 "teaching students the skills they need?") subtitle ("") xtitle("") ytitle("") ///
 xlabel(1 "Yes" 2 "No" 3"No Answer")
 
tabplot rep78 mpg, xasis barw(1) bstyle(histogram)
egen mean = mean(mpg), by(rep78)
gen rep78_2 = 6 - rep78 - 0.05
bysort rep78 : gen byte tag = _n == 1
tabplot rep78 mpg, xasis barw(1) bstyle(histogram) plot(scatter rep78_2 mean if tag)


******Twoway graphs******

use NatNeighCrimeStudy.dta, clear

/*Basic twoway graphs*/

twoway scatter T_PERCAP T_VIOLNT, title("Comparison of Per Capita Income" "and Violent Crime Rate at Tract level") xtitle(Violent Crime Rate) ytitle(Per Capita Income)
twoway dropline T_PERCAP T_VIOLNT
twoway lfitci T_PERCAP T_VIOLNT

/*The By Statement*/

sum T_UNEMP, detail
gen DICEMP=0 if T_UNEMP <6.62
recode DICEMP (.=1) if T_UNEMP >= 6.62
la var DICEMP "Median split of unemployment"
la define dicemplbl 1 "Unemployment Rate in Upper 50%" 0 "Unemployment in Lower 50%"
la val DICEMP dicemplbl

twoway scatter T_PERCAP T_VIOLNT, by(DICEMP)

/*Adding title features to twoway graphs*/

twoway scatter T_PERCAP T_VIOLNT, title(Comparison of Per Capita Income and Violent Crime Rate at Tract level) ///
xtitle(Violent Crime Rate) ytitle(Per Capita Income) note(Source: National Neighborhood Crime Study 2000) 

*Correct title so it goes on two lines - I do this by separating each line into quotations

twoway scatter T_PERCAP T_VIOLNT, title("Comparison of Per Capita Income" "and Violent Crime Rate at Tract level") ///
xtitle(Violent Crime Rate) ytitle(Per Capita Income) note(Source: National Neighborhood Crime Study 2000) 

/*Playing around with Appearance*/

*Change symbol appearance with "msymbol()"
palette symbolpalette
twoway scatter T_PERCAP T_VIOLNT, title("Comparison of Per Capita Income" "and Violent Crime Rate at Tract level") ///
xtitle(Violent Crime Rate) ytitle(Per Capita Income) note(Source: National Neighborhood Crime Study 2000) ///
msymbol(Sh) 

*Change symbol color with "mcolor()"

twoway scatter T_PERCAP T_VIOLNT, title("Comparison of Per Capita Income" "and Violent Crime Rate at Tract level") ///
xtitle(Violent Crime Rate) ytitle(Per Capita Income) note(Source: National Neighborhood Crime Study 2000) ///
msymbol(S) mcolor(red)

/*Overlaying two graphs*/

twoway (scatter T_PERCAP T_VIOLNT) (lfit T_PERCAP T_VIOLNT), title("Comparison of Per Capita Income" "and Violent Crime Rate at Tract level") ///
xtitle(Violent Crime Rate) ytitle(Per Capita Income) note(Source: National Neighborhood Crime Study 2000) 

tab T_VIOLNT
twoway (scatter T_PERCAP T_VIOLNT if T_VIOLNT==1976, mlabel(CITY)) (scatter T_PERCAP T_VIOLNT), ///
title("Comparison of Per Capita Income" "and Violent Crime Rate at Tract level") xlabel(0(200)2400) ///
note(Source: National Neighborhood Crime Study 2000) legend(off)

******Line Graphs*****

/*Call up one of Stata's datasets from the web*/
webuse uslifeexp, clear

line le_male le_female year

line le_wfemale le_wmale le_bf le_bm year

*Change the pattern for your lines

line le_wfemale le_wmale le_bf le_bm year, lpattern(dot solid dot solid)

*Change line color, width

line le_wfemale le_wmale le_bf le_bm year, lpattern(dot solid dot solid) ///
lcolor(red blue red blue) lwidth(thick thin thick thin) 

*****Profile Plots*****

use NatNeighCrimeStudy.dta

findit profileplot

use NatNeighCrimeStudy.dta, clear

sum T_UNEMP, detail
gen unempquart=1 if T_UNEMP < 3.27
replace unempquart=2 if T_UNEMP >=3.27 & T_UNEMP < 6.62
replace unempquart=3 if T_UNEMP >=6.62 & T_UNEMP < 11.23
replace unempquart=4 if T_UNEMP > 11.23 & T_UNEMP != .
la define unempquartlbl 1 "Lowest 25th" 2 "25-50th" 3 "50-75th" 4 "Highest 25th"
la val unempquart unempquartlbl

profileplot T_MURDRT T_AGASRT T_VIOLRT T_PROPRT, by(unempquart)

profileplot T_MURDRT T_AGASRT T_VIOLRT T_PROPRT, by(unempquart) xlabel(1 "Murder" 2 "Assault" 3 "Violent" 4 "Property") ///
ytitle(Average Crime Rate) title("Average Tract Crime Rates by Unemployment Level") xtitle("")

***Graphing with Regression***

use NatNeighCrimeStudy.dta, clear

regress T_HSGRAD T_POVRTY T_PERCAP T_PCVAC T_FEMHED

predict yhat
predict residual, resid

*Graph of residuals versus fitted values

rvfplot

*Graph of actual vs. predicted values
twoway scatter yhat T_HSGRAD T_POVRTY

*****Answers to Exercises*****

/*Exercise 1*/

*1.
hist T_POVRTY
*2.
hist T_POVRTY, normal
*3.
hist T_POVRTY, normal percent
*4.
*A variety of options are available here such as: title() xtitle() ytitle()

use TimePollPubSchools.dta, clear
*5.
codebook Q11
hist Q11, discrete
*6.
*Again, there are several options available here and are up to the users' discression
*7.
codebook Q33 Q17
tabplot Q33 Q17

/*Exercise 2*/

use NatNeighCrimeStudy.dta

*1.
twoway scatter C_UNEMP C_SSLOW
*2. 
twoway scatter C_UNEMP C_SSLOW, by(C_SOUTH)
*3. 
*Use mcolor() option
*4. 
*Use msymbol() option
*5.
codebook C_UNEMP
twoway (scatter C_UNEMP C_SSLOW if C_UNEMP >= 15, mlabel(CITY)) (scatter C_UNEMP C_SSLOW), ///
by(C_SOUTH)
*6.
help twoway_options

/*Exercise 3*/

webuse sp500.dta

*1.
line volume date

*2.
line high low date

*3.
line high low date, lpattern(dot solid) lcolor(orange blue)

*Questions 4&5 are based on user preferences

*6.
cd �S:\DataClass\GraphingStata�
graph export mynewgraph.esp, replace


*****Additional Descriptive Graphs with Continuous Variables*****
  
/*several variables on a similar scale against another variable*/
webuse auto, clear
scatter mpg headroom turn weight 

/*display labels on scatterplot*/
webuse auto, clear
scatter mpg weight in 1/15, mlabel(make)

/*display a third variable on scatterplot*/
webuse census, clear
scatter death medage [w=pop65p], msymbol(circle_hollow)

/*many scatterplots */
sysuse lifeexp, clear
generate lgnppc = ln(gnppc)
graph matrix popgr lgnp safe lexp, half /*have DV as last; use half option*/

/*time series*/
webuse uslifeexp, clear
line le_wm le_bm year, legend(size(small))
  
/*minimum maximum*/
webuse sp500, clear
twoway rcap high low date in 1/15

/*growth and decline*/
webuse gnp96, clear
twoway area d.gnp96 date 

webuse sp500, clear
twoway area high close low date in 1/15

tsset  date, daily
graph twoway tsline  high low , tline(01apr2001 01jul2001 01oct2001)
graph twoway tsline  high low if tin(01jan2001, 30jun2001)


/*box plots*/
webuse bplong, clear
graph box bp, over(agegrp)  

webuse bpwide, clear
graph box bp_before bp_after
graph box bp_before bp_after, over(agegrp)

/*Additional options for describing data*/
  
/*sum stats by variable*/  
webuse citytemp, clear
graph bar tempjan, over(region)
graph hbar tempjan tempjuly, over(region) /*hbar makes it horizontal*/
gr bar ttl_exp tenure, over(married) over(race) by(union, missing total)


/*WHERE YOU CAN GO FROM HERE: ADVANCED GRAPHING*/

sysuse uslifeexp, clear
gen diff = le_wm - le_bm 
label var diff "Difference"

#delimit ;
line le_wm year, yaxis(1 2) xaxis(1 2) 
  || line le_bm year 
  || line diff  year 
  || lfit diff  year 
  ||, 
  ylabel(0(5)20, axis(2) gmin angle(horizontal)) 
  ylabel(0 20(10)80,     gmax angle(horizontal)) 
  ytitle("", axis(2)) 
  xlabel(1918, axis(2)) xtitle("", axis(2)) 
  ytitle("Life expectancy at birth (years)")
  title("White and black life expectancy")
  subtitle("USA, 1900-1999")
  note("Source: National Vital Statistics, Vol 50, No. 6" 
       "(1918 dip caused by 1918 Influenza Pandemic)")
  legend(label(1 "White males") label(2 "Black males"))
  legend(col(1) pos(3))
  ;
#delimit cr


