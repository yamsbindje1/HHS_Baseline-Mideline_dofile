***************************
**                       **
**   CARAMAL Project     **
**                       **
***************************
**   Household Survey    **
***************************

* Analysis of baseline and midline Household Survey 2020 - DRC


** Open main dataset (Enter your own file path)
use "D:\NEXT SURVEY ANALYSIS 20_07_2020\COMPARAISON MENAGE\PREVALENCE 2019.dta"
rename *, lower
gen ras=1
tempfile hf_checkl_PREV1
save hf_checkl_PREV1

use "D:\NEXT SURVEY ANALYSIS 20_07_2020\COMPARAISON MENAGE\HHS PREVALENCE_2020.dta"
rename *, lower
gen ras=2

append using hf_checkl_PREV1, force

label define ras 1 "baseline" 2 "post-ras", replace
label value ras ras

label define level2 101 "IPAMU" 102 "KENGE" 103 "KINGANDU", replace
label value level2
gen id = _n
reshape long cu5_age_year cu5_sex g25cl08_ g25cl09_ g25cl10_ g25cl12_, i(id) j(child_num)
keep hhid cluster level2 cu5_age_year cu5_sex g25cl08_* g25cl09_* g25cl10_* g25cl12_*

* remove trailing underscore
foreach var of varlist _all {
	if (substr("`var'",-1,1)=="_") {
		local no_under = substr("`var'", 1, length("`var'") - 1) 
		rename `var' `no_under'
		}
	}

*------------------------------------------------------------------------------*
** Overview of interviewed households
*------------------------------------------------------------------------------*
** Overview of interviewed households

tab cu5_age_year
drop if cu5_age_year > 4	// drop interviews for children > 4 yea

*------------------------------------------------------------------------------*
/* Description of sampling strategy
In the three Health Zones, 32 villages (Ipamu =11, Kenge =15 and Kingandu =6), 
were randomly sampled (proportional to size). The data collection team listed 
all households with at least one child aged 6-59 months within the village 
boundaries extend to the nearest village if the number of households is <30. 
Among these households, 30 households were randomly selected to participate in 
the survey. Interviews were conducted until 30 interviews were completed. 
Within each sampled household, all household members were listed and the 
household head or another adult household member was interviewed about household
characteristics. */

** weights baseline survey
gen pw_b = .
replace pw_b = 0.706089053114692 if cluster == 8 & ras==1
replace pw_b = 0.537972611896908 if cluster == 59 & ras==1
replace pw_b = 0.54918037464476 if cluster == 64 & ras==1
replace pw_b = 1.17681508852449 if cluster == 66 & ras==1
replace pw_b = 0.515557086401203 if cluster == 83 & ras==1
replace pw_b = 0.444307737504143 if cluster == 84 | cluster == 85 & ras==1
replace pw_b = 0.392271696174829 if cluster == 116 & ras==1
replace pw_b = 1.66957017485247 if cluster == 145 & ras==1
replace pw_b = 0.387961018194885 if cluster == 163 | cluster == 158 & ras==1
replace pw_b = 0.515557086401203 if cluster == 165 & ras==1
replace pw_b = 0.717296815862544 if cluster == 194 & ras==1
replace pw_b = 3.74225021886175 if cluster == 241 & ras==1
replace pw_b = 0.671871178289851 if cluster == 260 & ras==1
replace pw_b = 0.627777296733565 if cluster == 280 & ras==1
replace pw_b = 1.03164735763216 if cluster == 317 & ras==1
replace pw_b = 0.74845004377235 if cluster == 349 & ras==1
replace pw_b = 0.861337452292504 if cluster == 384 & ras==1
replace pw_b = 0.983517764882585 if cluster == 393 & ras==1
replace pw_b = 1.18942871821119 if cluster == 417 & ras==1
replace pw_b = 0.736890969737256 if cluster == 421 & ras==1
replace pw_b = 0.991190598509329 if cluster == 423 & ras==1
replace pw_b = 0.770234452530797 if cluster == 463 & ras==1
replace pw_b = 1.29461629193055 if cluster == 512 & ras==1
replace pw_b = 0.631125442316144 if cluster == 598 & ras==1
replace pw_b = 0.606851386842446 if cluster == 602 & ras==1
replace pw_b = 1.80032578096592 if cluster == 639 & ras==1
replace pw_b = 1.51169788087716 if cluster == 708 & ras==1
replace pw_b = 1.27275208680303 if cluster == 725 & ras==1
replace pw_b = 0.89970406136076 if cluster == 728 | cluster == 729 & ras==1
replace pw_b = 0.658320044898117 if cluster == 835 | cluster == 834 & ras==1
replace pw_b = 2.67716818258568 if cluster == 856 | cluster == 851 & ras==1
replace pw_b = 0.680264046394721 if cluster == 909 | cluster == 919 & ras==1

** weights post-ras survey
gen pw_p = .
replace pw_p =41.200 if cluster== 129 & ras==2
replace pw_p =52.072 if cluster== 133 & ras==2
replace pw_p =25.750 if cluster== 17 & ras==2
replace pw_p =34.946 if cluster== 165 & ras==2
replace pw_p =23.461 if cluster== 79 & ras==2
replace pw_p =17.167 if cluster== 197 & ras==2
replace pw_p =32.617 if cluster== 117 & ras==2
replace pw_p =33.189 if cluster== 1 & ras==2
replace pw_p =34.333 if cluster== 10 & ras==2
replace pw_p =27.467 if cluster== 172 & ras==2
replace pw_p =31.472 if cluster== 161 & ras==2
replace pw_p =68.094 if cluster== 187 & ras==2
replace pw_p =58.161 if cluster== 786 & ras==2
replace pw_p =40.333 if cluster== 759 & ras==2
replace pw_p =45.222 if cluster== 727 & ras==2
replace pw_p =69.667 if cluster== 801 & ras==2
replace pw_p =184.556 if cluster== 902 & ras==2
replace pw_p =212.667 if cluster== 904 & ras==2
replace pw_p =36.214 if cluster== 568 & ras==2
replace pw_p =44.664 if cluster== 342 & ras==2
replace pw_p =51.907 if cluster== 321 & ras==2
replace pw_p =57.943 if cluster== 920 & ras==2
replace pw_p =42.250 if cluster== 390 & ras==2
replace pw_p =44.664 if cluster== 326 & ras==2
replace pw_p =79.671 if cluster== 399 & ras==2
replace pw_p =101.400 if cluster== 231 & ras==2
replace pw_p =45.871 if cluster== 251 & ras==2
replace pw_p =41.043 if cluster== 288 & ras==2
replace pw_p =41.043 if cluster== 551 & ras==2
replace pw_p =43.457 if cluster== 301 & ras==2
replace pw_p =36.214 if cluster== 466 & ras==2
replace pw_p =47.079 if cluster== 573 & ras==2


** combine baseline and post-ras weights into one variable
gen finalwt = pw_b 
	replace finalwt = pw_p if ras==2

* Finite population correction

*baseline
gen fpc1 = .
replace fpc1 = 206 if cluster == 8 & ras==1
replace fpc1 = 206 if cluster == 59 & ras==1
replace fpc1 = 206 if cluster == 64 & ras==1
replace fpc1 = 206 if cluster == 66 & ras==1
replace fpc1 = 206 if cluster == 83 & ras==1
replace fpc1 = 206 if cluster == 84 | cluster == 85 & ras==1
replace fpc1 = 206 if cluster == 116 & ras==1
replace fpc1 = 206 if cluster == 145 & ras==1
replace fpc1 = 206 if cluster == 163 | cluster == 158 & ras==1
replace fpc1 = 206 if cluster == 165 & ras==1
replace fpc1 = 206 if cluster == 194 & ras==1
replace fpc1 = 507 if cluster == 241 & ras==1
replace fpc1 = 507 if cluster == 260 & ras==1
replace fpc1 = 507 if cluster == 280 & ras==1
replace fpc1 = 507 if cluster == 317 & ras==1
replace fpc1 = 507 if cluster == 349 & ras==1
replace fpc1 = 507 if cluster == 384 & ras==1
replace fpc1 = 507 if cluster == 393 & ras==1
replace fpc1 = 507 if cluster == 417 & ras==1
replace fpc1 = 507 if cluster == 421 & ras==1
replace fpc1 = 507 if cluster == 423 & ras==1
replace fpc1 = 507 if cluster == 463 & ras==1
replace fpc1 = 507 if cluster == 512 & ras==1
replace fpc1 = 507 if cluster == 598 & ras==1
replace fpc1 = 507 if cluster == 602 & ras==1
replace fpc1 = 507 if cluster == 639 & ras==1
replace fpc1 = 220 if cluster == 708 & ras==1
replace fpc1 = 220 if cluster == 725 & ras==1
replace fpc1 = 220 if cluster == 728 | cluster == 729 & ras==1
replace fpc1 = 220 if cluster == 835 | cluster == 834 & ras==1
replace fpc1 = 220 if cluster == 856 | cluster == 851 & ras==1
replace fpc1 = 220 if cluster == 909 | cluster == 919 & ras==1

*post-ras
replace fpc1 = 206 if cluster == 129 & ras==2
replace fpc1 = 206 if cluster == 133 & ras==2
replace fpc1 = 206 if cluster == 17 & ras==2
replace fpc1 = 206 if cluster == 165 & ras==2
replace fpc1 = 206 if cluster == 79 & ras==2
replace fpc1 = 206 if cluster == 197 & ras==2
replace fpc1 = 206 if cluster == 117 & ras==2
replace fpc1 = 206 if cluster == 1 & ras==2
replace fpc1 = 206 if cluster == 10 & ras==2
replace fpc1 = 206 if cluster == 172 & ras==2
replace fpc1 = 206 if cluster == 161 & ras==2
replace fpc1 = 206 if cluster == 187 & ras==2
replace fpc1 = 220 if cluster == 786 & ras==2
replace fpc1 = 220 if cluster == 759 & ras==2
replace fpc1 = 220 if cluster == 727 & ras==2
replace fpc1 = 220 if cluster == 801 & ras==2
replace fpc1 = 220 if cluster == 902 & ras==2
replace fpc1 = 220 if cluster == 904 & ras==2
replace fpc1 = 507 if cluster == 568 & ras==2
replace fpc1 = 507 if cluster == 342 & ras==2
replace fpc1 = 507 if cluster == 321 & ras==2
replace fpc1 = 507 if cluster == 920 & ras==2
replace fpc1 = 507 if cluster == 390 & ras==2
replace fpc1 = 507 if cluster == 326 & ras==2
replace fpc1 = 507 if cluster == 399 & ras==2
replace fpc1 = 507 if cluster == 231 & ras==2
replace fpc1 = 507 if cluster == 251 & ras==2
replace fpc1 = 507 if cluster == 288 & ras==2
replace fpc1 = 507 if cluster == 551 & ras==2
replace fpc1 = 507 if cluster == 301 & ras==2
replace fpc1 = 507 if cluster == 466 & ras==2
replace fpc1 = 507 if cluster == 573 & ras==2

** combine baseline and post-ras strata into one variable
*gen finalstrata = fpc1 if ras==1
*replace finalstrata = fpc1_p if ras==2

* Finite population correction
gen fpc2 = .
*baseline
replace fpc2 = 63 if cluster == 8 & ras==1
replace fpc2 = 48 if cluster == 59 & ras==1
replace fpc2 = 49 if cluster == 64 & ras==1
replace fpc2 = 105 if cluster == 66 & ras==1
replace fpc2 = 46 if cluster == 83 & ras==1
replace fpc2 = 37 if cluster == 84 | cluster == 85 & ras==1
replace fpc2 = 35 if cluster == 116 & ras==1
replace fpc2 = 144 if cluster == 145 & ras==1
replace fpc2 = 30 if cluster == 163 | cluster == 158 & ras==1
replace fpc2 = 46 if cluster == 165 & ras==1
replace fpc2 = 64 if cluster == 194 & ras==1
replace fpc2 = 185 if cluster == 241 & ras==1
replace fpc2 = 31 if cluster == 260 & ras==1
replace fpc2 = 30 if cluster == 280 & ras==1
replace fpc2 = 51 if cluster == 317 & ras==1
replace fpc2 = 37 if cluster == 349 & ras==1
replace fpc2 = 44 if cluster == 384 & ras==1
replace fpc2 = 47 if cluster == 393 & ras==1
replace fpc2 = 49 if cluster == 417 & ras==1
replace fpc2 = 34 if cluster == 421 & ras==1
replace fpc2 = 49 if cluster == 423 & ras==1
replace fpc2 = 33 if cluster == 463 & ras==1
replace fpc2 = 64 if cluster == 512 & ras==1
replace fpc2 = 26 if cluster == 598 & ras==1
replace fpc2 = 27 if cluster == 602 & ras==1
replace fpc2 = 89 if cluster == 639 & ras==1
replace fpc2 = 62 if cluster == 708 & ras==1
replace fpc2 = 58 if cluster == 725 & ras==1
replace fpc2 = 41 if cluster == 728 | cluster == 729 & ras==1
replace fpc2 = 28 if cluster == 835 | cluster == 834 & ras==1
replace fpc2 = 122 if cluster == 856 | cluster == 851 & ras==1
replace fpc2 = 31 if cluster == 909 | cluster == 919 & ras==1

*post-ras
replace fpc2 = 72 if cluster == 129 & ras==2
replace fpc2 = 91 if cluster == 133 & ras==2
replace fpc2 = 45 if cluster == 17 & ras==2
replace fpc2 = 57 if cluster == 165 & ras==2
replace fpc2 = 41 if cluster == 79 & ras==2
replace fpc2 = 29 if cluster == 197 & ras==2
replace fpc2 = 57 if cluster == 117 & ras==2
replace fpc2 = 58 if cluster == 1 & ras==2
replace fpc2 = 60 if cluster == 10 & ras==2
replace fpc2 = 48 if cluster == 172 & ras==2
replace fpc2 = 55 if cluster == 161 & ras==2
replace fpc2 = 119 if cluster == 187 & ras==2
replace fpc2 = 39 if cluster == 573 & ras==2
replace fpc2 = 30 if cluster == 466 & ras==2
replace fpc2 = 36 if cluster == 301 & ras==2
replace fpc2 = 34 if cluster == 551 & ras==2
replace fpc2 = 34 if cluster == 288 & ras==2
replace fpc2 = 38 if cluster == 251 & ras==2
replace fpc2 = 84 if cluster == 231 & ras==2
replace fpc2 = 66 if cluster == 399 & ras==2
replace fpc2 = 37 if cluster == 326 & ras==2
replace fpc2 = 35 if cluster == 390 & ras==2
replace fpc2 = 48 if cluster == 920 & ras==2
replace fpc2 = 43 if cluster == 321 & ras==2
replace fpc2 = 37 if cluster == 342 & ras==2
replace fpc2 = 30 if cluster == 568 & ras==2
replace fpc2 = 174 if cluster == 904 & ras==2
replace fpc2 = 151 if cluster == 902 & ras==2
replace fpc2 = 57 if cluster == 801 & ras==2
replace fpc2 = 37 if cluster == 727 & ras==2
replace fpc2 = 33 if cluster == 759 & ras==2
replace fpc2 = 46 if cluster == 786 & ras==2

gen uniqueid = cluster*100+hhid

** append surveys with different weights
egen superstrat = group(ras fpc1), m

svyset cluster [pw=finalwt], strata(superstra) fpc(fpc1) vce(linearized) singleunit(scaled) ///
	|| uniqueid , fpc(fpc2)
svydescribe

*------------------------------------------------------------------------------*	
* Tabulation of indicators
* Derived variables:
gen fever = cond(g25cl09 > 37.5,1,0)			// Fever: temperature > 37.5°C
label values fever yesno
egen anemia = cut(g25cl12), at(0 7 11 100) lab 	// Cut off levels: <7.0g/dl: severe anemia, <11.0g/dl: anemia
label define anemia 0 "Severe anemia" 1 "Anemia" 2 "No anemia", replace
label values anemia anemia

*** Table: Fever, anaemia, severe anaemia and splenomegaly *** 
capture noisily svy, subpop(if level2 == 101): tab g25cl08 ras, col obs count per pearson		// Fever in last 2 days IPAMU
capture noisily svy, subpop(if level2 == 102): tab g25cl08 ras, col obs count per pearson		// Fever in last 2 days KENGE
capture noisily svy, subpop(if level2 == 103): tab g25cl08 ras, col obs count per pearson		// Fever in last 2 day KINGANDU
capture noisily svy, subpop(if level2 == 101): tab fever ras, col obs count per pearson		    // Current fever IPAMU
capture noisily svy, subpop(if level2 == 102): tab fever ras, col obs count per pearson		    // Current fever KENGE
capture noisily svy, subpop(if level2 == 103): tab fever ras, col obs count per pearson		    // Current fever KINGANDU
capture noisily svy, subpop(if level2 == 101): tab g25cl10 ras, col obs count per pearson		// RDT result IPAMU
capture noisily svy, subpop(if level2 == 102): tab g25cl10 ras, col obs count per pearson		// RDT result KENGE
capture noisily svy, subpop(if level2 == 103): tab g25cl10 ras, col obs count per pearson		// RDT result KINGANDU
capture noisily svy, subpop(if level2 == 101): tab anemia  ras, col obs count per pearson		// Hemoglobine (Anemia) IPAMU
capture noisily svy, subpop(if level2 == 102): tab anemia  ras, col obs count per pearson		// Hemoglobine (Anemia) KENGE
capture noisily svy, subpop(if level2 == 103): tab anemia  ras, col obs count per pearson		// Hemoglobine (Anemia) KINGANDU
***-------------------------------------------------------------------------------------------------------

** Additional indicators:
ttest g25cl12 if level2 == 101, by(ras) unpaired         // Mean cumulative number Hb concentration (Mean g/dL) IPAMU
ttest g25cl12 if level2 == 102, by(ras) unpaired         // Mean cumulative number Hb concentration (Mean g/dL) KENGE
ttest g25cl12 if level2 == 103, by(ras) unpaired         // Mean cumulative number Hb concentration (Mean g/dL) KINGANDU

ttest cu5_age_month if level2 == 101, by(ras) unpaired   // Mean age by month IPAMU
ttest cu5_age_month if level2 == 102, by(ras) unpaired   // Mean age by month KENGE
ttest cu5_age_month if level2 == 103, by(ras) unpaired   // Mean age by month KINGANDU

capture noisily svy, subpop(if level2 == 101): tab cu5_age_year  ras, col obs count per pearson		// Age of child
capture noisily svy, subpop(if level2 == 102): tab cu5_age_year  ras, col obs count per pearson		// Age of child
capture noisily svy, subpop(if level2 == 103): tab cu5_age_year  ras, col obs count per pearson		// Age of child

capture noisily svy, subpop(if level2 == 101): tab cu5_sex  ras, col obs count per pearson		    // Sex of child IPAMU
capture noisily svy, subpop(if level2 == 102): tab cu5_sex  ras, col obs count per pearson		    // Sex of child KENGE
capture noisily svy, subpop(if level2 == 103): tab cu5_sex  ras, col obs count per pearson		    // Sex of childd KINGANDU

capture noisily svy, subpop(if level2 == 101): tab g25cl01  ras, col obs count per pearson		    // Current antimalarial intake IPAMU
capture noisily svy, subpop(if level2 == 102): tab g25cl01  ras, col obs count per pearson		    // Current antimalarial intake KENGE
capture noisily svy, subpop(if level2 == 103): tab g25cl01  ras, col obs count per pearson		    // Current antimalarial intake KENGE

clonevar travel = g25cl05
replace travel="2" if travel==""
replace travel="1" if travel!="2"
destring travel, replace
capture noisily svy, subpop(if level2 == 101): tab travel  ras, col obs count per pearson		    // Current antimalarial intake IPAMU
capture noisily svy, subpop(if level2 == 102): tab travel  ras, col obs count per pearson		    // Current antimalarial intake KENGE
capture noisily svy, subpop(if level2 == 103): tab travel  ras, col obs count per pearson		    // Current antimalarial intake KENGE

// cu5_age year/month: Age of child
// cu5_sex: Sex of child
// g25cl01/02/02_oth: Current antimalarial intake
// g25cl04: Travelled outside the village in the last month
// g25cl05/06/07/07_oth: Destination of recent travel
