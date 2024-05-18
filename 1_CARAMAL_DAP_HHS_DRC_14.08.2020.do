***************************
**                       **
**   CARAMAL Project     **
**                       **
***************************
**   Household Survey    **
***************************

* Analysis of baseline and Midline Household Survey 2020 - DRC


**** INDICATORS: HHS_DRC ****

*begin Post-RAS
** Open dataset (Enter your own file path)
use "C:\Users\JUNIOR KASONGA\Desktop\Etude_comparative_HHS\HHS_2\Merge_2\Nouveau_merge2\HHS_FORM_v6_DRC-2.dta",clear
rename *, lower 
**-------------------------------------------------------------------------------*
drop if setofg4hhroster == ""
rename setofg4hhroster setofhhroster
** merge with HH Member List (hhroster dataset)
preserve
* Open dataset (Enter your own file path)
use "C:\Users\JUNIOR KASONGA\Desktop\Etude_comparative_HHS\HHS_2\Merge_2\Nouveau_merge2\HHS_FORM_v6_DRC-hhroster.dta",clear
rename *, lower 
drop if hh_education == .				// keep only entries of HH head
duplicates tag setofhhroster , gen(dup)

drop if dup == 1 & hh_sno == "2"
keep hh_education  hh_age hh_gender hh_marital religion hh_mem hh_member hh_member_name hh_relationship caregiver_ethnic caregiver_ethnic_oth setofhhroster
rename *, lower 
tempfile rosterPostRas
save `rosterPostRas'
restore
merge 1:1 setofhhroster  using `rosterPostRas'		// add education, age, gender, marital status, religion  hh_mem hh_member hh_member_name hh_relationshipof HH head to main dataset
drop if _merge==2
drop if level2==.
** rename "other" variables (to reference other variable with _*)
rename *_oth* *oth*
rename *, lower
gen ras=2
tempfile hhs_v6_PostRAS
rename *, lower 
save `hhs_v6_PostRAS'
*End Post-RAS

*Beging baseline
** Open dataset Baseline (Enter your own file path)
use "C:\Users\JUNIOR KASONGA\Desktop\Etude_comparative_HHS\HHS_1\Merge_1\HHS_FORM_v5_DRC_clean.dta", clear
rename SET_OF_g4_hhroster SETOFhhroster

** merge with HH Member List (hhroster dataset)
preserve
* Open dataset (Enter your own file path)
use "C:\Users\JUNIOR KASONGA\Desktop\Etude_comparative_HHS\HHS_1\Merge_1\HHS_FORM_v5_DRC-g4-hhroster_clean2.dta",clear
drop if hh_education == .					// keep only entries of HH head
duplicates tag SETOFhhroster, gen(dup)
drop if dup == 1 & hh_sno == 2
keep hh_education* hh_age hh_gender hh_marital religion SETOFhhroster
tempfile rosterbaseline
save `rosterbaseline'
restore
merge 1:1 SETOFhhroster using `rosterbaseline'		// add education, age, gender, marital status, religion of HH head to main dataset
drop if level2==.
** rename "other" variables (to reference other variable with _*)
rename *_oth* *oth*
rename *, lower
gen ras=1
*End Baseline

*Append dataset
rename *, lower 
append using `hhs_v6_PostRAS',force
drop if level2==.

label define ras 1 "baseline" 2 "post-ras", replace
label value ras ras	

label define yesno 0 "No" 1 "Yes", replace
label define yesnonk 0 "No" 1 "Yes" -98 "NK", replace


*-------------------------------------------------------------------------------*
** Overview of interviewed households

* Derived variable: 
** Interview completed, based on availability of a competent responent 
** and provision of informed consent
gen xcomplete = 0
replace xcomplete = 1 if confirm_household_head == 1 & consent == 1
replace xcomplete = 1 if confirm_substitute == 1 & consent == 1

tab consent, m  	// total hh that provided consent
tab xcomplete, m  	// total hh that provided consent and were interviewed 

drop if xcomplete != 1 // drop incomplete hh interviews

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

svyset cluster [pw=finalwt], strata(superstrat)  vce(linearized) singleunit(scaled) ///
	|| uniqueid , fpc(fpc2)
svydescribe

*-------------------------------------------------------------------------------*		
/* The following indicators need to be stratified by HF level(Ipamu, Kenge, Kingandu).
	Please use the code below to select the category that is analyzed. */

*-------------------------------------------------------------------------------*
*** Sample ***
** Survey sample: Number of households interviewed by Survey
tab level2 ras	
* Tabulation of indicators
*** HH head ***
* Derived variables: 
egen age_cat = cut(hh_age), at(15,20,30,40,200) lab

** Table: Household head characteristics
capture noisily svy,subpop(if level2 == 101 ): tab age_cat ras , col obs per pearson 		// HH head age: categories of IPAMU
capture noisily svy,subpop(if level2 == 102): tab age_cat ras, col obs per pearson 		// HH head age: categories of KENGE
capture noisily svy,subpop(if level2 == 103): tab age_cat ras, col obs per pearson 		// HH head age: categories of KINGANDU

capture noisily svy,subpop(if level2 == 101): tab hh_gender ras, col obs per pearson 		// HH head sex of IPAMU
capture noisily svy,subpop(if level2 == 102): tab hh_gender ras, col obs per pearson 		// HH head sex of KENGE
capture noisily svy,subpop(if level2 == 103): tab hh_gender ras, col obs per pearson 		// HH head sex of KINGANDU

capture noisily svy ,subpop(if level2 == 101): tab hh_marital ras, col obs per pearson		// HH head marital status of IPAMU
capture noisily svy ,subpop(if level2 == 102): tab hh_marital ras, col obs per pearson		// HH head marital status of KENGE
capture noisily svy ,subpop(if level2 == 103): tab hh_marital ras, col obs per pearson		// HH head marital status of KINGANDU

capture noisily svy ,subpop(if level2 == 101): tab religion ras, col obs per pearson		// HH head religion of IPAMU
capture noisily svy ,subpop(if level2 == 102): tab religion ras, col obs per pearson		// HH head religion of KENGE
capture noisily svy ,subpop(if level2 == 103): tab religion ras, col obs per pearson		// HH head religion of KINGANDU

capture noisily svy ,subpop(if level2 == 101): tab hh_education ras, col obs count per  pearson	// Household head education of IPAMU
capture noisily svy ,subpop(if level2 == 102): tab hh_education ras, col obs per pearson	// Household head education of KENGE
capture noisily svy ,subpop(if level2 == 103): tab hh_education ras, col obs per pearson	// Household head education of KINGANDU

tab hh_educationoth ras // Please check if any other response fits into one of the categories above 

** Additional indicators: Household head characteristics / Demographics of households
 
bysort ras :tabstat hh_age if level2==101, statistics(median p25 p75) 			// HH head age: Median (IQR)
bysort ras :tabstat hh_age if level2==102, statistics(median p25 p75) 			// HH head age: Median (IQR)
bysort ras :tabstat hh_age if level2==103, statistics(median p25 p75) 			// HH head age: Median (IQR)
ttest hh_age ,by(ras)

bysort ras :tabstat total_hh_member if level2==101, statistics(median p25 p75)	// Number of household members: Median (IQR)
bysort ras :tabstat total_hh_member if level2==102, statistics(median p25 p75)	// Number of household members: Median (IQR)
bysort ras :tabstat total_hh_member if level2==103, statistics(median p25 p75)	// Number of household members: Median (IQR)
ttest hh_age ,by(ras)

bysort ras :tabstat hh_age_sum if level2==101, statistics(median p25 p75)		// Number of children <5 years per household: Median (IQR)
bysort ras :tabstat hh_age_sum if level2==102, statistics(median p25 p75)		// Number of children <5 years per household: Median (IQR)
bysort ras :tabstat hh_age_sum if level2==103, statistics(median p25 p75)		// Number of children <5 years per household: Median (IQR)
ttest hh_age ,by(ras)

*** Households ***
* Derived variables:
label define water 1 "Piped into dwelling/yard/plot" ///
	2 "Piped into neighbourhood/public tap" 3 "Tanker truck/cart with drum" ///
	4 "Borehole, protected well/spring" 5 "Rainwater" 6 "Bottled water" ///
	7 "Unprotected well/spring" 8 "Surface water" -96 "Other"
label define toilet 1 "Pit latrine" 2 "Septic tank/piped sewer system" ///
	3 "Composting toilet" 4 "Open pit latrine/hanging latrine/flush not to sewer" ///
	5 "Bucket" -96 "Other" -77 "Open defecation"
label define yesno 1 "Yes" 0 "No", replace
clonevar drinking_wat2 = drinking_wat
recode drinking_wat2 6=1 7=2 3=3 8/10=4 11=5 12=6 1/2=7 4=8 -96=-96
clonevar toilet_facility2 = toilet_facility
recode toilet_facility2 (5/7=1) (8/9=2) (10=3) (1 3 4=4) (2=5) (-96=-96) (-77=-77)
gen cow = cond(no_milk_cows!=.,1,0)
gen horse = cond(no_horses_donkeys!=.,1,0)
gen goat = cond(no_goats!=.,1,0)
gen sheep = cond(no_sheep!=.,1,0)
gen poultry = cond(no_chickenother_poultry!=.,1,0)
gen pig = cond(no_pig!=.,1,0)

label values cow horse goat sheep poultry pig yesno
label values drinking_wat2 water
label values toilet_facility2 toilet

** Table: Household characteristics **
tab level2,m
tab level3,m
capture noisily svy ,subpop(if level2 == 101): tab income_household ras, col obs per pearson	// Main source of income of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab income_household ras, col obs per pearson	// Main source of income of Kenge
capture noisily svy ,subpop(if level2 == 103): tab income_household ras, col obs per pearson	// Main source of income of Kingandu
tab income_householdoth	       // Please check if any other response fits into one of the categories above

capture noisily svy ,subpop(if level2 == 101): tab drinking_wat2 ras, col obs per pearson		// Main source of drinking water of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab drinking_wat2 ras, col obs per pearson		// Main source of drinking water of Kenge
capture noisily svy ,subpop(if level2 == 103): tab drinking_wat2 ras, col obs per pearson		// Main source of drinking water of Kingandu
tab drinking_watoth		// Please check if any other response fits into one of the categories above

capture noisily svy ,subpop(if level2 == 101): tab toilet_facility2 ras, col obs per pearson	// Type of toilet of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab toilet_facility2 ras, col obs per pearson	// Type of toilet of Kenge
capture noisily svy ,subpop(if level2 == 103): tab toilet_facility2 ras, col obs per pearson	// Type of toilet of Kingandu
tab toilet_facilityoth		// Please check if any other response fits into one of the categories above

capture noisily svy ,subpop(if level2 == 101): tab cooking_fuel ras, col obs per pearson		// Fuel used for cooking of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab cooking_fuel ras, col obs per pearson		// Fuel used for cooking of Kenge
capture noisily svy ,subpop(if level2 == 103): tab cooking_fuel ras, col obs per pearson		// Fuel used for cooking of Kingandu
tab cooking_fueloth		// Please check if any other response fits into one of the categories above

capture noisily svy ,subpop(if level2 == 101): tab source_lightning ras, col obs per pearson	// Main source of lighting of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab source_lightning ras, col obs per pearson	// Main source of lighting of Kenge
capture noisily svy ,subpop(if level2 == 103): tab source_lightning ras, col obs per pearson	// Main source of lighting of Kingandu
tab source_lightningoth		// Please check if any other response fits into one of the categories above

* Livestock ownership: 
capture noisily svy ,subpop(if level2 == 101): tab cow ras, col obs per pearson 		// Milk cows of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab cow ras, col obs per pearson 		// Milk cows of Kenge
capture noisily svy ,subpop(if level2 == 103): tab cow ras, col obs per pearson 		// Milk cows of Kingandu

capture noisily svy ,subpop(if level2 == 101): tab horse ras, col obs per pearson 		// Horse and Donkey of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab horse ras, col obs per pearson 		// Horse and Donkey of Kenge
capture noisily svy ,subpop(if level2 == 103): tab horse ras, col obs per pearson 		// Horse and Donkey Of Kingandu

capture noisily svy ,subpop(if level2 == 101): tab goat ras, col obs per pearson 		// Goat  of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab goat ras, col obs per pearson 		// Goat of Kenge
capture noisily svy ,subpop(if level2 == 103): tab goat ras, col obs per pearson 		// Goat of Kingandu

capture noisily svy ,subpop(if level2 == 101): tab sheep ras, col obs per pearson 		// Sheep of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab sheep ras, col obs per pearson 		// Sheep of Kenge
capture noisily svy ,subpop(if level2 == 103): tab sheep ras, col obs per pearson 		// Sheep of Kingandu

capture noisily svy ,subpop(if level2 == 101): tab poultry ras, col obs per pearson 	// Chicken/ducks of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab poultry ras, col obs per pearson 	// Chicken/ducks of Kenge
capture noisily svy ,subpop(if level2 == 103): tab poultry ras, col obs per pearson 	// Chicken/ducks of Kingandu

capture noisily svy ,subpop(if level2 == 101): tab pig ras, col obs per pearson 		// Pigs of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab pig ras, col obs per pearson 		// Pigs of Kenge
capture noisily svy ,subpop(if level2 == 103): tab pig ras, col obs per pearson 		// Pigs of Kingandu

* Household assets: 
label values land_agriculture yesno
capture noisily svy ,subpop(if level2 == 101): tab land_agriculture ras, col obs per pearson	// Agricultural land of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab land_agriculture ras, col obs per pearson	// Agricultural land of Kenge
capture noisily svy ,subpop(if level2 == 103): tab land_agriculture ras, col obs per pearson	// Agricultural land of Kingandu

capture noisily svy ,subpop(if level2 == 101): tab hh_electricity ras, col obs per pearson		// Electricity ofIpamu 
capture noisily svy ,subpop(if level2 == 102): tab hh_electricity ras, col obs per pearson		// Electricity of Kenge
capture noisily svy ,subpop(if level2 == 103): tab hh_electricity ras, col obs per pearson		// Electricity of Kingandu

capture noisily svy ,subpop(if level2 == 101): tab hh_radio ras, col obs per pearson			// Radio of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab hh_radio ras, col obs per pearson			// Radio of Kenge
capture noisily svy ,subpop(if level2 == 103): tab hh_radio ras, col obs per pearson			// Radio of Kingandu

capture noisily svy ,subpop(if level2 == 101): tab hh_television ras, col obs per pearson		// TV of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab hh_television ras, col obs per pearson		// TV of Kenge
capture noisily svy ,subpop(if level2 == 103): tab hh_television ras, col obs per pearson		// TV of Kingandu

capture noisily svy ,subpop(if level2 == 101): tab hh_computer ras, col obs per pearson		// Computer/tablet of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab hh_computer ras, col obs per pearson		// Computer/tablet of Kenge
capture noisily svy ,subpop(if level2 == 103): tab hh_computer ras, col obs per pearson		// Computer/tablet of Kingandu

capture noisily svy ,subpop(if level2 == 101): tab hh_refrigerator ras, col obs per pearson	// Refrigerator of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab hh_refrigerator ras, col obs per pearson	// Refrigerator of Kenge
capture noisily svy ,subpop(if level2 == 103): tab hh_refrigerator ras, col obs per pearson	// Refrigerator of Kingandu

capture noisily svy ,subpop(if level2 == 101): tab hh_bed ras, col obs per pearson				// Bed of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab hh_bed ras, col obs per pearson				// Bed of Kenge
capture noisily svy ,subpop(if level2 == 103): tab hh_bed ras, col obs per pearson				// Bed of Kingandu

capture noisily svy ,subpop(if level2 == 101): tab hh_mattress ras, col obs per pearson		// Mattress of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab hh_mattress ras, col obs per pearson		// Mattress of Kenge
capture noisily svy ,subpop(if level2 == 103): tab hh_mattress ras, col obs per pearson		// Mattress of Kingandu

capture noisily svy ,subpop(if level2 == 101): tab hh_table ras, col obs per pearson			// Table of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab hh_table ras, col obs per pearson			// Table of Kenge
capture noisily svy ,subpop(if level2 == 103): tab hh_table ras, col obs per pearson			// Table Kingandu

capture noisily svy ,subpop(if level2 == 101): tab hh_chair ras, col obs per pearson			// Chair of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab hh_chair ras, col obs per pearson			// Chair of Kenge
capture noisily svy ,subpop(if level2 == 103): tab hh_chair ras, col obs per pearson			// Chair of Kingandu

capture noisily svy ,subpop(if level2 == 101): tab hh_sofa ras, col obs per pearson			// Sofa of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab hh_sofa ras, col obs per pearson			// Sofa of Kenge
capture noisily svy ,subpop(if level2 == 103): tab hh_sofa ras, col obs per pearson			// Sofa of Kingandu

capture noisily svy ,subpop(if level2 == 101): tab hh_grain_grinder ras, col obs per pearson	// Grain grinder of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab hh_grain_grinder ras, col obs per pearson	// Grain grinder of Kenge
capture noisily svy ,subpop(if level2 == 103): tab hh_grain_grinder ras, col obs per pearson	// Grain grinder of Kingandu

capture noisily svy ,subpop(if level2 == 101): tab hh_fan ras, col obs per pearson			// Electric fan of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab hh_fan ras, col obs per pearson			// Electric fan of Kenge
capture noisily svy ,subpop(if level2 == 103): tab hh_fan ras, col obs per pearson			// Electric fan of Kingandu

capture noisily svy ,subpop(if level2 == 101): tab hh_generator ras, col obs per pearson		// Generator of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab hh_generator ras, col obs per pearson		// Generator of Kenge
capture noisily svy ,subpop(if level2 == 103): tab hh_generator ras, col obs per pearson		// Generator of Kingandu

capture noisily svy ,subpop(if level2 == 101): tab hh_washing_machine ras, col obs per pearson	// Washing machine of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab hh_washing_machine ras, col obs per pearson	// Washing machine of Kenge
capture noisily svy ,subpop(if level2 == 103): tab hh_washing_machine ras, col obs per pearson	// Washing machine of Ipamu


* Household member assets:
capture noisily svy,subpop(if level2 == 101): tab hhm_watch ras, col obs per pearson 			// Watch of Ipamu
capture noisily svy,subpop(if level2 == 102): tab hhm_watch ras, col obs per pearson 			// Watch of Kenge
capture noisily svy,subpop(if level2 == 103): tab hhm_watch ras, col obs per pearson 			// Watch of Kingandu

capture noisily svy,subpop(if level2 == 101): tab hhm_mobilephone ras, col obs per pearson	// Mobile phone of Ipamu
capture noisily svy,subpop(if level2 == 102): tab hhm_mobilephone ras, col obs per pearson	// Mobile phone of kenge
capture noisily svy,subpop(if level2 == 103): tab hhm_mobilephone ras, col obs per pearson	// Mobile phone of Kingandu

capture noisily svy,subpop(if level2 == 101): tab hhm_bicycle ras, col obs per pearson		// Bicycle of Ipamu
capture noisily svy,subpop(if level2 == 102): tab hhm_bicycle ras, col obs per pearson		// Bicycle of Kenge
capture noisily svy,subpop(if level2 == 103): tab hhm_bicycle ras, col obs per pearson		// Bicycle of Kingandu

capture noisily svy,subpop(if level2 == 101): tab hhm_motorcycle ras, col obs per pearson	// Motorcycle/scooter of Ipamu
capture noisily svy,subpop(if level2 == 102): tab hhm_motorcycle ras, col obs per pearson	// Motorcycle/scooter of Kenge
capture noisily svy,subpop(if level2 == 103): tab hhm_motorcycle ras, col obs per pearson	// Motorcycle/scooter of Kingandu

capture noisily svy,subpop(if level2 == 101): tab hhm_animaldrawn ras, col obs per pearson	// Animal drawn cart of Ipamu
capture noisily svy,subpop(if level2 == 102): tab hhm_animaldrawn ras, col obs per pearson	// Animal drawn cart of Kenge
capture noisily svy,subpop(if level2 == 103): tab hhm_animaldrawn ras, col obs per pearson	// Animal drawn cart of Kingandu

capture noisily svy,subpop(if level2 == 101): tab hhm_car ras, col obs per pearson			// Car/truck of Ipamu
capture noisily svy,subpop(if level2 == 102): tab hhm_car ras, col obs per pearson			// Car/truck of Kenge
capture noisily svy,subpop(if level2 == 103): tab hhm_car ras, col obs per pearson			// Car/truck of Kingandu

capture noisily svy,subpop(if level2 == 101): tab hhm_motorboat ras, col obs per pearson		// Motorboat of Ipamu
capture noisily svy,subpop(if level2 == 102): tab hhm_motorboat ras, col obs per pearson		// Motorboat of Kenge
capture noisily svy,subpop(if level2 == 1013): tab hhm_motorboat ras, col obs per pearson		// Motorboat of Kingandu

capture noisily svy,subpop(if level2 == 101): tab hhm_bankaccount ras, col obs per pearson	// Bank account of Ipamu
capture noisily svy,subpop(if level2 == 102): tab hhm_bankaccount ras, col obs per pearson	// Bank account of Kenge
capture noisily svy,subpop(if level2 == 103): tab hhm_bankaccount ras, col obs per pearson	// Bank account of Kingandu


* Characteristics of dwelling
replace mat_floor = if mat_floor==.
capture noisily svy,subpop(if level2 == 101): tab mat_floor ras, col obs per pearson			// Main material of floor of Ipamu
capture noisily svy,subpop(if level2 == 102): tab mat_floor ras, col obs per pearson			// Main material of floor of Kenge
capture noisily svy,subpop(if level2 == 103): tab mat_floor ras, col obs per pearson			// Main material of floor of Kingandu
tab mat_flooroth ras		// Please check if any other response fits into one of the categories above


capture noisily svy ,subpop(if level2 == 101): tab mat_roof ras, col obs per pearson			// Main material of roof of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab mat_roof ras, col obs per pearson			// Main material of roof of Kenge
capture noisily svy ,subpop(if level2 == 103): tab mat_roof ras, col obs per pearson			// Main material of roof of Kingandu
tab mat_roofoth	ras	// Please check if any other response fits into one of the categories above


capture noisily svy,subpop(if level2 == 101): tab mat_exwall ras, col obs per pearson			// Main material of external walls of Ipamu
capture noisily svy,subpop(if level2 == 102): tab mat_exwall ras, col obs per pearson			// Main material of external walls of Kenge
capture noisily svy,subpop(if level2 == 103): tab mat_exwall ras, col obs per pearson			// Main material of external walls of Kingandu
tab mat_exwalloth ras 

capture noisily svy,subpop(if level2 == 101): tab window_screen ras, col obs per pearson		// Screened windows of Ipamu
capture noisily svy,subpop(if level2 == 102): tab window_screen ras, col obs per pearson		// Screened windows of Kenge
capture noisily svy,subpop(if level2 == 103): tab window_screen ras, col obs per pearson		// Screened windows of Kingandu


*** Interventions ***
* Derived variables: 
* Households with at least one net per 2 people
gen xnetpp = no_mosquito_nets/total_hh_member	// N nets per person
gen xnet2ppl = .								// Households with min. 1 net/2 people
replace xnet2ppl = 0 if xnetpp < 0.5
replace xnet2ppl = 1 if xnetpp >=0.5 & xnetpp < . 
label values xnet2ppl yesno
* Reasons for not owning a mosquito net

egen reason_nonet = concat(why_no_mosquito_nets*), punct(" ")
replace reason_nonet = " " + reason_nonet + " "
gen nonet_noreason = cond(regexm(reason_nonet,"-77")==1,1,0)
gen nonet_discomfort = cond(regexm(reason_nonet," 1 ")==1,1,0)
gen nonet_hot = cond(regexm(reason_nonet," 2 ")==1,1,0)
gen nonet_nohang = cond(regexm(reason_nonet," 3 ")==1,1,0)
gen nonet_smell = cond(regexm(reason_nonet," 4 ")==1,1,0)
gen nonet_night = cond(regexm(reason_nonet," 5 ")==1,1,0)
gen nonet_nomosquito = cond(regexm(reason_nonet," 6 ")==1,1,0)
gen nonet_nomalaria = cond(regexm(reason_nonet," 7 ")==1,1,0)
gen nonet_spare = cond(regexm(reason_nonet," 8 ")==1,1,0)
gen nonet_damaged = cond(regexm(reason_nonet," 9 ")==1,1,0)
gen nonet_user = cond(regexm(reason_nonet," 10 ")==1,1,0)
gen nonet_other = cond(regexm(reason_nonet,"-96")==1,1,0)
gen nonet_noresponse = cond(regexm(reason_nonet,"-98")==1,1,0)
label values nonet_* yesno

* Information on malaria in last 3 months
egen malaria_information = concat(hear_info_malaria*), punct(" ")
replace malaria_information = " " + malaria_information + " "
gen info_radio = cond(regexm(malaria_information," 1 ")==1,1,0)
gen info_newspaper = cond(regexm(malaria_information," 2 ")==1,1,0)
gen info_poster = cond(regexm(malaria_information," 3 ")==1,1,0)
gen info_tv = cond(regexm(malaria_information," 4 ")==1,1,0)
gen info_hf = cond(regexm(malaria_information," 5 ")==1,1,0)
gen info_friend = cond(regexm(malaria_information," 6 ")==1,1,0)
gen info_ngo = cond(regexm(malaria_information," 7 ")==1,1,0)
gen info_hhvisit = cond(regexm(malaria_information," 8 ")==1,1,0)
gen info_community = cond(regexm(malaria_information," 9 ")==1,1,0)
gen info_netcamp = cond(regexm(malaria_information," 10 ")==1,1,0)
gen info_church = cond(regexm(malaria_information," 11 ")==1,1,0)
gen info_netpack = cond(regexm(malaria_information," 12 ")==1,1,0)
gen info_other = cond(regexm(malaria_information,"-96")==1,1,0)
label values info_* yesno

* IRS provider
egen provider_irs = concat(who_sprayed*), punct(" ")
replace provider_irs = " " + provider_irs + " "
gen irs_government = cond(regexm(provider_irs," 1 ")==1,1,0)
gen irs_employer = cond(regexm(provider_irs," 2 ")==1,1,0)
gen irs_private = cond(regexm(provider_irs," 3 ")==1,1,0)
gen irs_hhm = cond(regexm(provider_irs," 4 ")==1,1,0)
gen irs_other = cond(regexm(provider_irs,"96")==1,1,0)
gen irs_dk = cond(regexm(provider_irs,"98")==1,1,0)

** Table: Intervention coverage or exposure **
capture noisily svy,subpop(if level2 == 101): tab spray_interiorwalls ras, col obs per pearson	// IRS in last 12 months of Ipamu 
capture noisily svy,subpop(if level2 == 102): tab spray_interiorwalls ras, col obs per pearson	// IRS in last 12 months of Kenge 
capture noisily svy,subpop(if level2 == 103): tab spray_interiorwalls ras, col obs per pearson	// IRS in last 12 months of Kingandu

capture noisily svy,subpop(if level2 == 101): tab who_sprayed ras, col obs per pearson	// who_sprayed of Ipamu 
capture noisily svy,subpop(if level2 == 102): tabwho_sprayed ras, col obs per pearson	// who_sprayed of Kenge 
capture noisily svy,subpop(if level2 == 103): tab who_sprayed ras, col obs per pearson	// who_sprayed of Kingandu

* Mosquito net ownership
capture noisily svy,subpop(if level2 == 101): tab hh_mosquito_nets ras, col obs per pearson		// Own at least one mosquito net of Ipamu
capture noisily svy,subpop(if level2 == 102): tab hh_mosquito_nets ras, col obs per pearson		// Own at least one mosquito net of Kenge
capture noisily svy,subpop(if level2 == 103): tab hh_mosquito_nets ras, col obs per pearson		// Own at least one mosquito net of Kingandu

// Own at least one LLIN: Not applicable (net_brand disabled)
capture noisily svy,subpop(if level2 == 101): mean no_mosquito_nets, over(ras)		// Average number of nets per household of Ipamu
ttest no_mosquito_nets if level2==101, by(ras) unpaired
capture noisily svy,subpop(if level2 == 102): mean no_mosquito_nets, over(ras)		// Average number of nets per household of Kenge
ttest no_mosquito_nets if level2==102, by(ras) unpaired
capture noisily svy,subpop(if level2 == 103): mean no_mosquito_nets, over(ras)		// Average number of nets per household of Kingandu
ttest no_mosquito_nets if level2==103, by(ras) unpaired

// Average number of LLIN per household: Not applicable (net_brand disabled)
capture noisily svy,subpop(if level2 == 101): tab xnet2ppl ras, col obs per pearson				// Households with at least one net per 2 people of Ipamu
capture noisily svy,subpop(if level2 == 102): tab xnet2ppl ras, col obs per pearson				// Households with at least one net per 2 people of Kenge
capture noisily svy,subpop(if level2 == 103): tab xnet2ppl ras, col obs per pearson				// Households with at least one net per 2 people of Kingandu
 
// Households with at least one LLIN per 2 people: Not applicable (net_brand disabled)								

* Reasons for not hanging a mosquito net
capture noisily svy,subpop(if level2 == 101): tab nonet_noreason ras, col obs per pearson		// No reason of Ipamu
capture noisily svy,subpop(if level2 == 102): tab nonet_noreason ras, col obs per pearson		// No reason of Kenge
capture noisily svy,subpop(if level2 == 103): tab nonet_noreason ras, col obs per pearson		// No reason of Kingandu

capture noisily svy,subpop(if level2 == 101): tab nonet_discomfort ras, col obs per pearson	// Discomfort of Ipamu
capture noisily svy,subpop(if level2 == 102): tab nonet_discomfort ras, col obs per pearson	// Discomfort of Kenge
capture noisily svy,subpop(if level2 == 103): tab nonet_discomfort ras, col obs per pearson	// Discomfort of Kingandu

capture noisily svy,subpop(if level2 == 101): tab nonet_hot ras, col obs per pearson		// Too hot of Ipamu
capture noisily svy,subpop(if level2 == 102): tab nonet_hot ras, col obs per pearson		// Too hot of Kenge
capture noisily svy,subpop(if level2 == 103): tab nonet_hot ras, col obs per pearson		// Too hot of Kingandu

capture noisily svy,subpop(if level2 == 101): tab nonet_nohang ras, col obs per pearson		// Inability to hang them of Ipamu 
capture noisily svy,subpop(if level2 == 102): tab nonet_nohang ras, col obs per pearson		// Inability to hang them of Kenge
capture noisily svy,subpop(if level2 == 103): tab nonet_nohang ras, col obs per pearson		// Inability to hang them of Kingandu

capture noisily svy,subpop(if level2 == 101): tab nonet_smell ras, col obs per pearson		// Factors of smell and constraint of Ipamu
capture noisily svy,subpop(if level2 == 102): tab nonet_smell ras, col obs per pearson		// Factors of smell and constraint of Kenge
capture noisily svy,subpop(if level2 == 103): tab nonet_smell ras, col obs per pearson		// Factors of smell and constraint of Kingandu

capture noisily svy,subpop(if level2 == 101): tab nonet_night ras, col obs per pearson	// Spending the night elsewhere of Ipamu
capture noisily svy,subpop(if level2 == 102): tab nonet_night ras, col obs per pearson	// Spending the night elsewhere of Kenge
capture noisily svy,subpop(if level2 == 103): tab nonet_night ras, col obs per pearson	// Spending the night elsewhere of Kingandu

capture noisily svy,subpop(if level2 == 101): tab nonet_nomosquito ras, col obs per pearson	// No mosquitoes of Ipamu
capture noisily svy,subpop(if level2 == 102): tab nonet_nomosquito ras, col obs per pearson	// No mosquitoes of Kenge
capture noisily svy,subpop(if level2 == 103): tab nonet_nomosquito ras, col obs per pearson	// No mosquitoes of Kingandu

capture noisily svy,subpop(if level2 == 101): tab nonet_nomalaria ras, col obs per pearson	// No malaria of Ipamu
capture noisily svy,subpop(if level2 == 102): tab nonet_nomalaria ras, col obs per pearson	// No malaria of Kenge
capture noisily svy,subpop(if level2 == 103): tab nonet_nomalaria ras, col obs per pearson	// No malaria of Kingandu

capture noisily svy,subpop(if level2 == 101): tab nonet_spare ras, col obs per pearson		// Net spared/reserved of Ipamu
capture noisily svy,subpop(if level2 == 102): tab nonet_spare ras, col obs per pearson		// Net spared/reserved of Kenge
capture noisily svy,subpop(if level2 == 103): tab nonet_spare ras, col obs per pearson		// Net spared/reserved of Kingandu

capture noisily svy,subpop(if level2 == 101): tab nonet_damaged ras, col obs per pearson		// Net expired/damaged of Ipamu
capture noisily svy,subpop(if level2 == 102): tab nonet_damaged ras, col obs per pearson		// Net expired/damaged of Kenge
capture noisily svy,subpop(if level2 == 103): tab nonet_damaged ras, col obs per pearson		// Net expired/damaged of Kingandu

capture noisily svy,subpop(if level2 == 101): tab nonet_user ras, col obs per pearson		// User did not sleep here of Ipamu
capture noisily svy,subpop(if level2 == 102): tab nonet_user ras, col obs per pearson		// User did not sleep here of Kenge
capture noisily svy,subpop(if level2 == 103): tab nonet_user ras, col obs per pearson		// User did not sleep here of Kingandu

capture noisily svy,subpop(if level2 == 101): tab nonet_other ras, col obs per pearson		// Other of Ipamu
capture noisily svy,subpop(if level2 == 102): tab nonet_other ras, col obs per pearson		// Other of Kenge
capture noisily svy,subpop(if level2 == 103): tab nonet_other ras, col obs per pearson		// Other of Kingandu

capture noisily svy,subpop(if level2 == 101): tab nonet_noresponse ras, col obs per pearson	// No response of Ipmau
capture noisily svy,subpop(if level2 == 102): tab nonet_noresponse ras, col obs per pearson	// No response of Kenge
capture noisily svy,subpop(if level2 == 103): tab nonet_noresponse ras, col obs per pearson	// No response of Kingandu

tab why_no_mosquito_netsoth ras	// Please check if any other response fits into one of the categories above

* Information on malaria in last three months
capture noisily svy,subpop(if level2 == 101): tab info_radio ras, col obs per pearson			// Radio of Ipamu
capture noisily svy,subpop(if level2 == 102): tab info_radio ras, col obs per pearson			// Radio of Kenge
capture noisily svy,subpop(if level2 == 103): tab info_radio ras, col obs per pearson			// Radio of Kingandu

capture noisily svy,subpop(if level2 == 101): tab info_newspaper ras, col obs per pearson		// Newspaper/magazine of Ipamu
capture noisily svy,subpop(if level2 == 102): tab info_newspaper ras, col obs per pearson		// Newspaper/magazine of Kenge
capture noisily svy,subpop(if level2 == 103): tab info_newspaper ras, col obs per pearson		// Newspaper/magazine of Kingandu

capture noisily svy,subpop(if level2 == 101): tab info_poster ras, col obs per pearson		// Posters of Ipamu
capture noisily svy,subpop(if level2 == 102): tab info_poster ras, col obs per pearson		// Posters of Kenge
capture noisily svy,subpop(if level2 == 103): tab info_poster ras, col obs per pearson		// Posters of Kingandu

capture noisily svy,subpop(if level2 == 101): tab info_tv ras, col obs per pearson			// Television of Ipamu
capture noisily svy,subpop(if level2 == 102): tab info_tv ras, col obs per pearson			// Television of Kenge
capture noisily svy,subpop(if level2 == 103): tab info_tv ras, col obs per pearson			// Television of Kingandu

capture noisily svy,subpop(if level2 == 101): tab info_hf ras, col obs per pearson			// Health center / Hospital of Ipamu
capture noisily svy,subpop(if level2 == 102): tab info_hf ras, col obs per pearson			// Health center / Hospital of Kenge
capture noisily svy,subpop(if level2 == 103): tab info_hf ras, col obs per pearson			// Health center / Hospital of Kingandu

capture noisily svy,subpop(if level2 == 101): tab info_friend ras, col obs per pearson		// Relative / Friend of Ipamu
capture noisily svy,subpop(if level2 == 102): tab info_friend ras, col obs per pearson		// Relative / Friend of Kenge
capture noisily svy,subpop(if level2 == 103): tab info_friend ras, col obs per pearson		// Relative / Friend of Kingandu

capture noisily svy,subpop(if level2 == 101): tab info_ngo ras, col obs per pearson			// Non-government organization (NGO) of Ipamu  
capture noisily svy,subpop(if level2 == 102): tab info_ngo ras, col obs per pearson			// Non-government organization (NGO) of Kenge
capture noisily svy,subpop(if level2 == 103): tab info_ngo ras, col obs per pearson			// Non-government organization (NGO) of Kingandu

capture noisily svy,subpop(if level2 == 101): tab info_hhvisit ras, col obs per pearson		// Household visit of Ipamu
capture noisily svy,subpop(if level2 == 102): tab info_hhvisit ras, col obs per pearson		// Household visit of Kenge
capture noisily svy,subpop(if level2 == 103): tab info_hhvisit ras, col obs per pearson		// Household visit of Kingandu

capture noisily svy,subpop(if level2 == 101): tab info_community ras, col obs per pearson		// Community meeting of Ipamu
capture noisily svy,subpop(if level2 == 102): tab info_community ras, col obs per pearson		// Community meeting of Kenge
capture noisily svy,subpop(if level2 == 103): tab info_community ras, col obs per pearson		// Community meeting of Kingandu

capture noisily svy,subpop(if level2 == 101): tab info_netcamp ras, col obs per pearson	// Net distribution of Ipamu
capture noisily svy,subpop(if level2 == 102): tab info_netcamp ras, col obs per pearson	// Net distribution of kenge
capture noisily svy,subpop(if level2 == 103): tab info_netcamp ras, col obs per pearson	// Net distribution of Kingandu

capture noisily svy,subpop(if level2 == 101): tab info_church ras, col obs per pearson		// Church meeting of Ipamu
capture noisily svy,subpop(if level2 == 102): tab info_church ras, col obs per pearson		// Church meeting of Kenge
capture noisily svy,subpop(if level2 == 103): tab info_church ras, col obs per pearson		// Church meeting of Kingandu

capture noisily svy,subpop(if level2 == 101): tab info_netpack ras, col obs per pearson		// In mosquito net package of Ipamu
capture noisily svy,subpop(if level2 == 102): tab info_netpack ras, col obs per pearson		// In mosquito net package of Kenge
capture noisily svy,subpop(if level2 == 103): tab info_netpack ras, col obs per pearson		// In mosquito net package of Kingandu

capture noisily svy,subpop(if level2 == 101): tab info_other ras, col obs per pearson		// Other of Ipamu
capture noisily svy,subpop(if level2 == 102): tab info_other ras, col obs per pearson		// Other of Kenge
capture noisily svy,subpop(if level2 == 103): tab info_other ras, col obs per pearson		// Other of Kingandu
tab hear_info_malariaoth  ras                      // Please check if any other response fits into one of the categories 

** Additional indicators: Intervention coverage
* IRS provider
capture noisily svy,subpop(if level2 == 101): tab irs_government ras, col obs per pearson		// Government worker/program of Ipamu
capture noisily svy,subpop(if level2 == 102): tab irs_government ras, col obs per pearson		// Government worker/program of Kenge
capture noisily svy,subpop(if level2 == 103): tab irs_government ras, col obs per pearson		// Government worker/program of Kingandu

capture noisily svy,subpop(if level2 == 101): tab irs_employer ras, col obs per pearson		// Employer of Ipamu
capture noisily svy,subpop(if level2 == 102): tab irs_employer ras, col obs per pearson		// Employer of Kenge
capture noisily svy,subpop(if level2 == 103): tab irs_employer ras, col obs per pearson		// Employer of Kingandu

capture noisily svy,subpop(if level2 == 101): tab irs_private ras, col obs per pearson		// Private company of Ipamu
capture noisily svy,subpop(if level2 == 102): tab irs_private ras, col obs per pearson		// Private company of Kenge
capture noisily svy,subpop(if level2 == 103): tab irs_private ras, col obs per pearson		// Private company of Kingandu

capture noisily svy,subpop(if level2 == 101): tab irs_hhm ras, col obs per pearson			// Household member of Ipamu
capture noisily svy,subpop(if level2 == 102): tab irs_hhm ras, col obs per pearson			// Household member of Kenge
capture noisily svy,subpop(if level2 == 103): tab irs_hhm ras, col obs per pearson			// Household member of Kingandu

capture noisily svy,subpop(if level2 == 101): tab irs_other ras, col obs per pearson			// Other of Ipamu
capture noisily svy,subpop(if level2 == 102): tab irs_other ras, col obs per pearson			// Other of Kenge
capture noisily svy,subpop(if level2 == 103): tab irs_other ras, col obs per pearson			// Other of Kingandu

capture noisily svy,subpop(if level2 == 101): tab irs_dk ras, col obs per pearson				// Don't know of Ipamu
capture noisily svy,subpop(if level2 == 102): tab irs_dk ras, col obs per pearson				// Don't know of Kenge
capture noisily svy,subpop(if level2 == 103): tab irs_dk ras, col obs per pearson				// Don't know of Kingandu

tab who_sprayedoth	ras  // Please check if any other response fits into one of the categories above

*** KAP malaria ***
* Derived variables:
* Mentioned symptoms of malaria
egen malaria_symptom = concat(q157_* q157), punct(" ")
replace malaria_symptom = " " + malaria_symptom + " "
gen symptom_none = cond(regexm(malaria_symptom,"77")==1,1,0)
gen symptom_headache = cond(regexm(malaria_symptom," 1 ")==1,1,0)
gen symptom_dizzy = cond(regexm(malaria_symptom," 2 ")==1,1,0)
gen symptom_cough = cond(regexm(malaria_symptom," 3 ")==1,1,0)
gen symptom_sputum = cond(regexm(malaria_symptom," 4 ")==1,1,0)
gen symptom_breathing = cond(regexm(malaria_symptom," 5 ")==1,1,0)
gen symptom_nausea = cond(regexm(malaria_symptom," 6 ")==1,1,0)
gen symptom_vomit = cond(regexm(malaria_symptom," 7 ")==1,1,0)
gen symptom_diarrhea = cond(regexm(malaria_symptom," 8 ")==1,1,0)
gen symptom_watery_diarrhea = cond(regexm(malaria_symptom," 9 ")==1,1,0)
gen symptom_stomach = cond(regexm(malaria_symptom," 10 ")==1,1,0)
gen symptom_skin = cond(regexm(malaria_symptom," 11 ")==1,1,0)
gen symptom_convulsion = cond(regexm(malaria_symptom," 12 ")==1,1,0)
gen symptom_shiver = cond(regexm(malaria_symptom," 13 ")==1,1,0)
gen symptom_bpain = cond(regexm(malaria_symptom," 14 ")==1,1,0)
gen symptom_jpain = cond(regexm(malaria_symptom," 15 ")==1,1,0)
gen symptom_sleepy = cond(regexm(malaria_symptom," 16 ")==1,1,0)
gen symptom_bloody_diarrhea = cond(regexm(malaria_symptom," 17 ")==1,1,0)
gen symptom_fever = cond(regexm(malaria_symptom," 18 ")==1,1,0)
gen symptom_nodrink = cond(regexm(malaria_symptom," 19 ")==1,1,0)
gen symptom_swelling = cond(regexm(malaria_symptom," 20 ")==1,1,0)
gen symptom_nosit = cond(regexm(malaria_symptom," 21 ")==1,1,0)
gen symptom_stiffneck = cond(regexm(malaria_symptom," 22 ")==1,1,0)
gen symptom_other = cond(regexm(malaria_symptom,"96")==1,1,0)
gen symptom_dk = cond(regexm(malaria_symptom,"98")==1,1,0)

* Mentioned treatment of child with malaria
egen malaria_treatment = concat(q159_* q159), punct(" ")
replace malaria_treatment = " " + malaria_treatment + " "
gen treatment_amoxi = cond(regexm(malaria_treatment," 1 ")==1,1,0)
gen treatment_ampi = cond(regexm(malaria_treatment," 2 ")==1,1,0)
gen treatment_ceftri = cond(regexm(malaria_treatment," 3 ")==1,1,0)
gen treatment_cotri = cond(regexm(malaria_treatment," 4 ")==1,1,0)
gen treatment_genta = cond(regexm(malaria_treatment," 5 ")==1,1,0)
gen treatment_metro = cond(regexm(malaria_treatment," 6 ")==1,1,0)
gen treatment_penic = cond(regexm(malaria_treatment," 7 ")==1,1,0)
gen treatment_alu = cond(regexm(malaria_treatment," 8 ")==1,1,0)
gen treatment_aq = cond(regexm(malaria_treatment," 9 ")==1,1,0)
gen treatment_as = cond(regexm(malaria_treatment," 10 ")==1,1,0)
gen treatment_ras = cond(regexm(malaria_treatment," 21 ")==1,1,0)
gen treatment_am = cond(regexm(malaria_treatment," 11 ")==1,1,0)
gen treatment_asaq = cond(regexm(malaria_treatment," 12 ")==1,1,0)
gen treatment_chloro = cond(regexm(malaria_treatment," 13 ")==1,1,0)
gen treatment_quin = cond(regexm(malaria_treatment," 14 ")==1,1,0)
gen treatment_sp = cond(regexm(malaria_treatment," 15 ")==1,1,0)
gen treatment_diaz = cond(regexm(malaria_treatment," 16 ")==1,1,0)
gen treatment_gluc = cond(regexm(malaria_treatment," 17 ")==1,1,0)
gen treatment_ferr = cond(regexm(malaria_treatment," 18 ")==1,1,0)
gen treatment_ors = cond(regexm(malaria_treatment," 19 ")==1,1,0)
gen treatment_para = cond(regexm(malaria_treatment," 20 ")==1,1,0)
gen treatment_other = cond(regexm(malaria_treatment,"96")==1,1,0)
gen treatment_none = cond(regexm(malaria_treatment,"77")==1,1,0)
gen treatment_dk = cond(regexm(malaria_treatment,"98")==1,1,0)
label values symptom_* treatment_* yesno

** Table: Knowledge related to malaria **
* Respondent head has heard of...
label values q156 q160 q161 q162 yesno
capture noisily svy,subpop(if level2 == 101): tab q156 ras, col obs per pearson	// Malaria
capture noisily svy,subpop(if level2 == 102): tab q156 ras, col obs per pearson	// Malaria
capture noisily svy,subpop(if level2 == 103): tab q156 ras, col obs per pearson	// Malaria

capture noisily svy,subpop(if level2 == 101): tab q160 ras, col obs per pearson	// Rapid diagnostic test(RDT)
capture noisily svy,subpop(if level2 == 102): tab q160 ras, col obs per pearson	// Rapid diagnostic test(RDT)
capture noisily svy,subpop(if level2 == 103): tab q160 ras, col obs per pearson	// Rapid diagnostic test(RDT)

capture noisily svy,subpop(if level2 == 101): tab q161 ras, col obs per pearson	// Artemisinin-based combination therapy (ACT)
capture noisily svy,subpop(if level2 == 102): tab q161 ras, col obs per pearson	// Artemisinin-based combination therapy (ACT)
capture noisily svy,subpop(if level2 == 103): tab q161 ras, col obs per pearson	// Artemisinin-based combination therapy (ACT)

capture noisily svy,subpop(if level2 == 101): tab q162 ras, col obs per pearson	// Rectal artesunate (RAS)
capture noisily svy,subpop(if level2 == 102): tab q162 ras, col obs per pearson	// Rectal artesunate (RAS)
capture noisily svy,subpop(if level2 == 103): tab q162 ras, col obs per pearson	// Rectal artesunate (RAS)


* Mentioned symptoms of malaria
capture noisily svy,subpop(if level2 == 101): tab symptom_none ras, col obs per pearson 		// None
capture noisily svy,subpop(if level2 == 102): tab symptom_none ras, col obs per pearson 		// None
capture noisily svy,subpop(if level2 == 103): tab symptom_none ras, col obs per pearson 		// None

capture noisily svy,subpop(if level2 == 101): tab symptom_headache ras, col obs per pearson 	// Headache
capture noisily svy,subpop(if level2 == 102): tab symptom_headache ras, col obs per pearson 	// Headache
capture noisily svy,subpop(if level2 == 103): tab symptom_headache ras, col obs per pearson 	// Headache

capture noisily svy,subpop(if level2 == 101): tab symptom_dizzy ras, col obs per pearson 		// Dizziness
capture noisily svy,subpop(if level2 == 102): tab symptom_dizzy ras, col obs per pearson 		// Dizziness
capture noisily svy,subpop(if level2 == 103): tab symptom_dizzy ras, col obs per pearson 		// Dizziness

capture noisily svy,subpop(if level2 == 101): tab symptom_cough ras, col obs per pearson 		// Cough 
capture noisily svy,subpop(if level2 == 102): tab symptom_cough ras, col obs per pearson 		// Cough 
capture noisily svy,subpop(if level2 == 103): tab symptom_cough ras, col obs per pearson 		// Cough 

capture noisily svy,subpop(if level2 == 101): tab symptom_sputum ras, col obs per pearson	// Cough with sputum
capture noisily svy,subpop(if level2 == 102): tab symptom_sputum ras, col obs per pearson	// Cough with sputum
capture noisily svy,subpop(if level2 == 103): tab symptom_sputum ras, col obs per pearson	// Cough with sputum

capture noisily svy,subpop(if level2 == 101): tab symptom_breathing ras, col obs per pearson 	// Fast or difficulty in breathing
capture noisily svy,subpop(if level2 == 102): tab symptom_breathing ras, col obs per pearson 	// Fast or difficulty in breathing
capture noisily svy,subpop(if level2 == 103): tab symptom_breathing ras, col obs per pearson 	// Fast or difficulty in breathing

capture noisily svy,subpop(if level2 == 101): tab symptom_nausea ras, col obs per pearson	// Nausea
capture noisily svy,subpop(if level2 == 102): tab symptom_nausea ras, col obs per pearson	// Nausea
capture noisily svy,subpop(if level2 == 103): tab symptom_nausea ras, col obs per pearson	// Nausea

capture noisily svy,subpop(if level2 == 101): tab symptom_vomit ras, col obs per pearson		// Vomiting
capture noisily svy,subpop(if level2 == 102): tab symptom_vomit ras, col obs per pearson		// Vomiting
capture noisily svy,subpop(if level2 == 103): tab symptom_vomit ras, col obs per pearson		// Vomiting

capture noisily svy,subpop(if level2 == 101): tab symptom_diarrhea ras, col obs per pearson 	// Diarrhea
capture noisily svy,subpop(if level2 == 102): tab symptom_diarrhea ras, col obs per pearson 	// Diarrhea
capture noisily svy,subpop(if level2 == 103): tab symptom_diarrhea ras, col obs per pearson 	// Diarrhea

capture noisily svy,subpop(if level2 == 101): tab symptom_watery_diarrhea ras, col obs per pearson 	// Watery diarrhea
capture noisily svy,subpop(if level2 == 102): tab symptom_watery_diarrhea ras, col obs per pearson 	// Watery diarrhea
capture noisily svy,subpop(if level2 == 103): tab symptom_watery_diarrhea ras, col obs per pearson 	// Watery diarrhea

capture noisily svy,subpop(if level2 == 101): tab symptom_stomach ras, col obs per pearson 	// Stomach ache
capture noisily svy,subpop(if level2 == 102): tab symptom_stomach ras, col obs per pearson 	// Stomach ache
capture noisily svy,subpop(if level2 == 103): tab symptom_stomach ras, col obs per pearson 	// Stomach ache

capture noisily svy,subpop(if level2 == 101): tab symptom_skin ras, col obs per pearson 		// Skin rash
capture noisily svy,subpop(if level2 == 102): tab symptom_skin ras, col obs per pearson 		// Skin rash
capture noisily svy,subpop(if level2 == 103): tab symptom_skin ras, col obs per pearson 		// Skin rash

capture noisily svy,subpop(if level2 == 101): tab symptom_convulsion ras, col obs per pearson // Convulsions
capture noisily svy,subpop(if level2 == 102): tab symptom_convulsion ras, col obs per pearson // Convulsions
capture noisily svy,subpop(if level2 == 103): tab symptom_convulsion ras, col obs per pearson // Convulsions

capture noisily svy,subpop(if level2 == 101): tab symptom_shiver ras, col obs per pearson 	// Shivering
capture noisily svy,subpop(if level2 == 102): tab symptom_shiver ras, col obs per pearson 	// Shivering
capture noisily svy,subpop(if level2 == 103): tab symptom_shiver ras, col obs per pearson 	// Shivering

capture noisily svy,subpop(if level2 == 101): tab symptom_bpain ras, col obs per pearson 		// Body pain
capture noisily svy,subpop(if level2 == 102): tab symptom_bpain ras, col obs per pearson 		// Body pain
capture noisily svy,subpop(if level2 == 103): tab symptom_bpain ras, col obs per pearson 		// Body pain

capture noisily svy,subpop(if level2 == 101): tab symptom_jpain ras, col obs per pearson		// Joint pain
capture noisily svy,subpop(if level2 == 102): tab symptom_jpain ras, col obs per pearson		// Joint pain
capture noisily svy,subpop(if level2 == 103): tab symptom_jpain ras, col obs per pearson		// Joint pain

capture noisily svy,subpop(if level2 == 101): tab symptom_sleepy ras, col obs per pearson	// Unusually sleepy or unconscious
capture noisily svy,subpop(if level2 == 102): tab symptom_sleepy ras, col obs per pearson	// Unusually sleepy or unconscious
capture noisily svy,subpop(if level2 == 103): tab symptom_sleepy ras, col obs per pearson	// Unusually sleepy or unconscious

capture noisily svy,subpop(if level2 == 101): tab symptom_bloody_diarrhea ras, col obs per pearson	// Diarrhea with blood
capture noisily svy,subpop(if level2 == 102): tab symptom_bloody_diarrhea ras, col obs per pearson	// Diarrhea with blood
capture noisily svy,subpop(if level2 == 103): tab symptom_bloody_diarrhea ras, col obs per pearson	// Diarrhea with blood

capture noisily svy,subpop(if level2 == 101): tab symptom_fever ras, col obs per pearson		// Fever
capture noisily svy,subpop(if level2 == 102): tab symptom_fever ras, col obs per pearson		// Fever
capture noisily svy,subpop(if level2 == 103): tab symptom_fever ras, col obs per pearson		// Fever

capture noisily svy,subpop(if level2 == 101): tab symptom_nodrink ras, col obs per pearson 	// Unable to drink or eat
capture noisily svy,subpop(if level2 == 102): tab symptom_nodrink ras, col obs per pearson 	// Unable to drink or eat
capture noisily svy,subpop(if level2 == 103): tab symptom_nodrink ras, col obs per pearson 	// Unable to drink or eat

capture noisily svy,subpop(if level2 == 101): tab symptom_swelling ras, col obs per pearson	// Swelling of both feet
capture noisily svy,subpop(if level2 == 102): tab symptom_swelling ras, col obs per pearson	// Swelling of both feet
capture noisily svy,subpop(if level2 == 103): tab symptom_swelling ras, col obs per pearson	// Swelling of both feet

capture noisily svy,subpop(if level2 == 101): tab symptom_nosit ras, col obs per pearson 		// Unable to sit or stand up
capture noisily svy,subpop(if level2 == 102): tab symptom_nosit ras, col obs per pearson 		// Unable to sit or stand up
capture noisily svy,subpop(if level2 == 103): tab symptom_nosit ras, col obs per pearson 		// Unable to sit or stand up

capture noisily svy,subpop(if level2 == 101): tab symptom_stiffneck ras, col obs per pearson 	// Stiff neck
capture noisily svy,subpop(if level2 == 102): tab symptom_stiffneck ras, col obs per pearson 	// Stiff neck
capture noisily svy,subpop(if level2 == 103): tab symptom_stiffneck ras, col obs per pearson 	// Stiff neck

capture noisily svy,subpop(if level2 == 101): tab symptom_other ras, col obs per pearson 		// Other
capture noisily svy,subpop(if level2 == 102): tab symptom_other ras, col obs per pearson 		// Other
capture noisily svy,subpop(if level2 == 103): tab symptom_other ras, col obs per pearson 		// Other

capture noisily svy,subpop(if level2 == 101): tab symptom_dk ras, col obs per pearson 		// Don't know
capture noisily svy,subpop(if level2 == 102): tab symptom_dk ras, col obs per pearson 		// Don't know
capture noisily svy,subpop(if level2 == 103): tab symptom_dk ras, col obs per pearson 		// Don't know

tab q157oth	 ras	// Please check if any other response fits into one of the categories above

*Mentioned treatment of child with malaria
capture noisily svy,subpop(if level2 == 101): tab treatment_amoxi ras, col obs per pearson	// Amoxicillin
capture noisily svy,subpop(if level2 == 102): tab treatment_amoxi ras, col obs per pearson	// Amoxicillin
capture noisily svy,subpop(if level2 == 103): tab treatment_amoxi ras, col obs per pearson	// Amoxicillin

capture noisily svy,subpop(if level2 == 101): tab treatment_ampi ras, col obs per pearson	// Ampicillin
capture noisily svy,subpop(if level2 == 102): tab treatment_ampi ras, col obs per pearson	// Ampicillin
capture noisily svy,subpop(if level2 == 103): tab treatment_ampi ras, col obs per pearson	// Ampicillin

capture noisily svy,subpop(if level2 == 101): tab treatment_ceftri ras, col obs per pearson	// Ceftriaxone
capture noisily svy,subpop(if level2 == 102): tab treatment_ceftri ras, col obs per pearson	// Ceftriaxone
capture noisily svy,subpop(if level2 == 103): tab treatment_ceftri ras, col obs per pearson	// Ceftriaxone

capture noisily svy,subpop(if level2 == 101): tab treatment_cotri ras, col obs per pearson	// Cotrimoxazole
capture noisily svy,subpop(if level2 == 102): tab treatment_cotri ras, col obs per pearson	// Cotrimoxazole
capture noisily svy,subpop(if level2 == 103): tab treatment_cotri ras, col obs per pearson	// Cotrimoxazole

capture noisily svy,subpop(if level2 == 101): tab treatment_genta ras, col obs per pearson	// Gentamycin
capture noisily svy,subpop(if level2 == 102): tab treatment_genta ras, col obs per pearson	// Gentamycin
capture noisily svy,subpop(if level2 == 103): tab treatment_genta ras, col obs per pearson	// Gentamycin

capture noisily svy,subpop(if level2 == 101): tab treatment_metro ras, col obs per pearson	// Metronidazole
capture noisily svy,subpop(if level2 == 102): tab treatment_metro ras, col obs per pearson	// Metronidazole
capture noisily svy,subpop(if level2 == 103): tab treatment_metro ras, col obs per pearson	// Metronidazole

capture noisily svy,subpop(if level2 == 101): tab treatment_penic ras, col obs per pearson	// Penicillin
capture noisily svy,subpop(if level2 == 102): tab treatment_penic ras, col obs per pearson	// Penicillin
capture noisily svy,subpop(if level2 == 103): tab treatment_penic ras, col obs per pearson	// Penicillin

capture noisily svy,subpop(if level2 == 101): tab treatment_alu ras, col obs per pearson		// Artemether-Lumefantrine
capture noisily svy,subpop(if level2 == 102): tab treatment_alu ras, col obs per pearson		// Artemether-Lumefantrine
capture noisily svy,subpop(if level2 == 103): tab treatment_alu ras, col obs per pearson		// Artemether-Lumefantrine

capture noisily svy,subpop(if level2 == 101): tab treatment_am ras, col obs per pearson		// Amodiaquine
capture noisily svy,subpop(if level2 == 102): tab treatment_am ras, col obs per pearson		// Amodiaquine
capture noisily svy,subpop(if level2 == 103): tab treatment_am ras, col obs per pearson		// Amodiaquine

capture noisily svy,subpop(if level2 == 101): tab treatment_as ras, col obs per pearson		// Artesunate
capture noisily svy,subpop(if level2 == 102): tab treatment_as ras, col obs per pearson		// Artesunate
capture noisily svy,subpop(if level2 == 103): tab treatment_as ras, col obs per pearson		// Artesunate

capture noisily svy,subpop(if level2 == 101): tab treatment_ras ras, col obs per pearson		// Rectal artesunate (suppository)
capture noisily svy,subpop(if level2 == 102): tab treatment_ras ras, col obs per pearson		// Rectal artesunate (suppository)
capture noisily svy,subpop(if level2 == 103): tab treatment_ras ras, col obs per pearson		// Rectal artesunate (suppository)

capture noisily svy,subpop(if level2 == 101): tab treatment_am ras, col obs per pearson		// Artemether
capture noisily svy,subpop(if level2 == 102): tab treatment_am ras, col obs per pearson		// Artemether
capture noisily svy,subpop(if level2 == 103): tab treatment_am ras, col obs per pearson		// Artemether

capture noisily svy,subpop(if level2 == 101): tab treatment_asaq ras, col obs per pearson		// Artesunate-Amodiaquine
capture noisily svy,subpop(if level2 == 102): tab treatment_asaq ras, col obs per pearson		// Artesunate-Amodiaquine
capture noisily svy,subpop(if level2 == 103): tab treatment_asaq ras, col obs per pearson		// Artesunate-Amodiaquine

capture noisily svy,subpop(if level2 == 101): tab treatment_chloro ras, col obs per pearson	// Chloroquine
capture noisily svy,subpop(if level2 == 102): tab treatment_chloro ras, col obs per pearson	// Chloroquine
capture noisily svy,subpop(if level2 == 103): tab treatment_chloro ras, col obs per pearson	// Chloroquine

capture noisily svy,subpop(if level2 == 101): tab treatment_quin ras, col obs per pearson	// Quinine
capture noisily svy,subpop(if level2 == 102): tab treatment_quin ras, col obs per pearson	// Quinine
capture noisily svy,subpop(if level2 == 103): tab treatment_quin ras, col obs per pearson	// Quinine

capture noisily svy,subpop(if level2 == 101): tab treatment_sp ras, col obs per pearson		// Sulphadoxine-Pyrimethamine (SP) / Fansidar
capture noisily svy,subpop(if level2 == 102): tab treatment_sp ras, col obs per pearson		// Sulphadoxine-Pyrimethamine (SP) / Fansidar
capture noisily svy,subpop(if level2 == 103): tab treatment_sp ras, col obs per pearson		// Sulphadoxine-Pyrimethamine (SP) / Fansidar

capture noisily svy,subpop(if level2 == 101): tab treatment_diaz ras, col obs per pearson	// Diazepam
capture noisily svy,subpop(if level2 == 102): tab treatment_diaz ras, col obs per pearson	// Diazepam
capture noisily svy,subpop(if level2 == 103): tab treatment_diaz ras, col obs per pearson	// Diazepam

capture noisily svy,subpop(if level2 == 101): tab treatment_gluc ras, col obs per pearson	// Glucose
capture noisily svy,subpop(if level2 == 102): tab treatment_gluc ras, col obs per pearson	// Glucose
capture noisily svy,subpop(if level2 == 103): tab treatment_gluc ras, col obs per pearson	// Glucose

capture noisily svy,subpop(if level2 == 101): tab treatment_ferr ras, col obs per pearson		// Ferrous sulphate
capture noisily svy,subpop(if level2 == 102): tab treatment_ferr ras, col obs per pearson		// Ferrous sulphate
capture noisily svy,subpop(if level2 == 103): tab treatment_ferr ras, col obs per pearson		// Ferrous sulphate

capture noisily svy,subpop(if level2 == 101): tab treatment_ors ras, col obs per pearson		// Oral rehydration salt (ORS)
capture noisily svy,subpop(if level2 == 102): tab treatment_ors ras, col obs per pearson		// Oral rehydration salt (ORS)
capture noisily svy,subpop(if level2 == 103): tab treatment_ors ras, col obs per pearson		// Oral rehydration salt (ORS)

capture noisily svy,subpop(if level2 == 101): tab treatment_para ras, col obs per pearson	// Paracetamol
capture noisily svy,subpop(if level2 == 102): tab treatment_para ras, col obs per pearson	// Paracetamol
capture noisily svy,subpop(if level2 == 103): tab treatment_para ras, col obs per pearson	// Paracetamol

capture noisily svy,subpop(if level2 == 101): tab treatment_other ras, col obs per pearson	// Other
capture noisily svy,subpop(if level2 == 102): tab treatment_other ras, col obs per pearson	// Other
capture noisily svy,subpop(if level2 == 103): tab treatment_other ras, col obs per pearson	// Other

capture noisily svy,subpop(if level2 == 101): tab treatment_none ras, col obs per pearson	// None
capture noisily svy,subpop(if level2 == 102): tab treatment_none ras, col obs per pearson	// None
capture noisily svy,subpop(if level2 == 103): tab treatment_none ras, col obs per pearson	// None

capture noisily svy,subpop(if level2 == 101): tab treatment_dk ras, col obs per pearson		// Don't know
capture noisily svy,subpop(if level2 == 102): tab treatment_dk ras, col obs per pearson		// Don't know
capture noisily svy,subpop(if level2 == 103): tab treatment_dk ras, col obs per pearson		// Don't know

tab q159oth	ras	// Please check if any other response fits into one of the categories above

*** KAP RAS iCCM ***
* Derived variables: 
* Symptoms of the child when RAS was given
egen ras_symptom = concat(q166_*  q166), punct(" ")
replace ras_symptom = " " + ras_symptom + " "
gen symptom_ras_none = cond(q163==1,cond(regexm(ras_symptom,"77")==1,1,0),.)
gen symptom_ras_headache = cond(q163==1,cond(regexm(ras_symptom," 1 ")==1,1,0),.)
gen symptom_ras_dizzy = cond(q163==1,cond(regexm(ras_symptom," 2 ")==1,1,0),.)
gen symptom_ras_cough = cond(q163==1,cond(regexm(ras_symptom," 3 ")==1,1,0),.)
gen symptom_ras_sputum = cond(q163==1,cond(regexm(ras_symptom," 4 ")==1,1,0),.)
gen symptom_ras_breathing = cond(q163==1,cond(regexm(ras_symptom," 5 ")==1,1,0),.)
gen symptom_ras_nausea = cond(q163==1,cond(regexm(ras_symptom," 6 ")==1,1,0),.)
gen symptom_ras_vomit = cond(q163==1,cond(regexm(ras_symptom," 7 ")==1,1,0),.)
gen symptom_ras_diarrhea = cond(q163==1,cond(regexm(ras_symptom," 8 ")==1,1,0),.)
gen symptom_ras_watery_diarrhea = cond(q163==1,cond(regexm(ras_symptom," 9 ")==1,1,0),.)
gen symptom_ras_stomach = cond(q163==1,cond(regexm(ras_symptom," 10 ")==1,1,0),.)
gen symptom_ras_skin = cond(q163==1,cond(regexm(ras_symptom," 11 ")==1,1,0),.)
gen symptom_ras_convulsion = cond(q163==1,cond(regexm(ras_symptom," 12 ")==1,1,0),.)
gen symptom_ras_shiver = cond(q163==1,cond(regexm(ras_symptom," 13 ")==1,1,0),.)
gen symptom_ras_bpain = cond(q163==1,cond(regexm(ras_symptom," 14 ")==1,1,0),.)
gen symptom_ras_jpain = cond(q163==1,cond(regexm(ras_symptom," 15 ")==1,1,0),.)
gen symptom_ras_sleepy = cond(q163==1,cond(regexm(ras_symptom," 16 ")==1,1,0),.)
gen symptom_ras_bloody_diarrhea = cond(q163==1,cond(regexm(ras_symptom," 17 ")==1,1,0),.)
gen symptom_ras_fever = cond(q163==1,cond(regexm(ras_symptom," 18 ")==1,1,0),.)
gen symptom_ras_nodrink = cond(q163==1,cond(regexm(ras_symptom," 19 ")==1,1,0),.)
gen symptom_ras_swelling = cond(q163==1,cond(regexm(ras_symptom," 20 ")==1,1,0),.)
gen symptom_ras_nosit = cond(q163==1,cond(regexm(ras_symptom," 21 ")==1,1,0),.)
gen symptom_ras_stiffneck = cond(q163==1,cond(regexm(ras_symptom," 22 ")==1,1,0),.)
gen symptom_ras_other = cond(q163==1,cond(regexm(ras_symptom,"96")==1,1,0),.)
gen symptom_ras_dk = cond(q163==1,cond(regexm(ras_symptom,"98")==1,1,0),.)

* Details of (CHW) service used
egen chw_service = concat(q179_* q179), punct(" ")
replace chw_service = " " + chw_service + " "
gen cservice_none = cond(regexm(chw_service,"77")==1,1,0)
gen cservice_advice = cond(regexm(chw_service," 1 ")==1,1,0)
gen cservice_diagnosis = cond(regexm(chw_service," 2 ")==1,1,0)
gen cservice_test = cond(regexm(chw_service," 3 ")==1,1,0)
gen cservice_treat_child = cond(regexm(chw_service," 4 ")==1,1,0)
gen cservice_treat_adult = cond(regexm(chw_service," 5 ")==1,1,0)
gen cservice_refer = cond(regexm(chw_service," 6 ")==1,1,0)
gen cservice_medicine = cond(regexm(chw_service," 7 ")==1,1,0)
gen cservice_net = cond(regexm(chw_service," 8 ")==1,1,0)
gen cservice_other = cond(regexm(chw_service,"96")==1,1,0)
gen cservice_dk = cond(regexm(chw_service,"98")==1,1,0)

* Reason for choosing CHW over other provider
egen chw_reason= concat(q180_* q180), punct(" ")
replace chw_reason = " " + chw_reason + " "
gen creason_know = cond(regexm(chw_reason," 1 ")==1,1,0)
gen creason_trust = cond(regexm(chw_reason," 2 ")==1,1,0)
gen creason_near = cond(regexm(chw_reason," 3 ")==1,1,0)
gen creason_service = cond(regexm(chw_reason," 4 ")==1,1,0)
gen creason_free = cond(regexm(chw_reason," 5 ")==1,1,0)
gen creason_cheap = cond(regexm(chw_reason," 6 ")==1,1,0)
gen creason_hfclosed = cond(regexm(chw_reason," 7 ")==1,1,0)
gen creason_noother = cond(regexm(chw_reason," 8 ")==1,1,0)
gen creason_advice = cond(regexm(chw_reason," 9 ")==1,1,0)
gen creason_other = cond(regexm(chw_reason,"96")==1,1,0)
gen creason_dk = cond(regexm(chw_reason,"98")==1,1,0)

* Reason for never using services of CHW
egen nochw_reason = concat(q181_* q181), punct(" ")
replace nochw_reason = " " + nochw_reason + " "	
gen nocreason_nochw = cond(regexm(nochw_reason," 1 ")==1,1,0)
gen nocreason_notavailable = cond(regexm(nochw_reason," 2 ")==1,1,0)
gen nocreason_nofind = cond(regexm(nochw_reason," 3 ")==1,1,0)
gen nocreason_dkservice = cond(regexm(nochw_reason," 4 ")==1,1,0)
gen nocreason_wrongservice = cond(regexm(nochw_reason," 5 ")==1,1,0)
gen nocreason_medicine = cond(regexm(nochw_reason," 6 ")==1,1,0)
gen nocreason_dkchw = cond(regexm(nochw_reason," 7 ")==1,1,0)
gen nocreason_trust = cond(regexm(nochw_reason," 8 ")==1,1,0)
gen nocreason_knowledge = cond(regexm(nochw_reason," 9 ")==1,1,0)
gen nocreason_cost = cond(regexm(nochw_reason," 10 ")==1,1,0)
gen nocreason_treat = cond(regexm(nochw_reason," 11 ")==1,1,0)
gen nocreason_badexp = cond(regexm(nochw_reason," 12 ")==1,1,0)
gen nocreason_advice = cond(regexm(nochw_reason," 13 ")==1,1,0)
gen nocreason_other = cond(regexm(nochw_reason,"96")==1,1,0)
gen nocreason_dk = cond(regexm(nochw_reason,"98")==1,1,0)

* Knows services offered by CHW
egen chw_service2 = concat(q182_* q182), punct(" ")
replace chw_service2 = " " + chw_service2 + " "
gen cservice2_none = cond(regexm(chw_service2,"77")==1,1,0)
gen cservice2_advice = cond(regexm(chw_service2," 1 ")==1,1,0)
gen cservice2_diagnosis = cond(regexm(chw_service2," 2 ")==1,1,0)
gen cservice2_test = cond(regexm(chw_service2," 3 ")==1,1,0)
gen cservice2_treat_child = cond(regexm(chw_service2," 4 ")==1,1,0)
gen cservice2_treat_adult = cond(regexm(chw_service2," 5 ")==1,1,0)
gen cservice2_refer = cond(regexm(chw_service2," 6 ")==1,1,0)
gen cservice2_medicine = cond(regexm(chw_service2," 7 ")==1,1,0)
gen cservice2_net = cond(regexm(chw_service2," 8 ")==1,1,0)
gen cservice2_other = cond(regexm(chw_service2,"96")==1,1,0)
gen cservice2_dk = cond(regexm(chw_service2,"98")==1,1,0)

* Which services offered by CHW are useful
egen chw_service3 = concat(q183_* q183), punct(" ") 
replace chw_service3 = " " + chw_service3 + " "
gen cservice3_none = cond(regexm(chw_service3,"77")==1,1,0)
gen cservice3_advice = cond(regexm(chw_service3," 1 ")==1,1,0)
gen cservice3_diagnosis = cond(regexm(chw_service3," 2 ")==1,1,0)
gen cservice3_test = cond(regexm(chw_service3," 3 ")==1,1,0)
gen cservice3_treat_child = cond(regexm(chw_service3," 4 ")==1,1,0)
gen cservice3_treat_adult = cond(regexm(chw_service3," 5 ")==1,1,0)
gen cservice3_refer = cond(regexm(chw_service3," 6 ")==1,1,0)
gen cservice3_medicine = cond(regexm(chw_service3," 7 ")==1,1,0)
gen cservice3_net = cond(regexm(chw_service3," 8 ")==1,1,0)
gen cservice3_other = cond(regexm(chw_service3,"96")==1,1,0)
gen cservice3_dk = cond(regexm(chw_service3,"98")==1,1,0)

* Which services offered by CHW are not useful
egen chw_service4 = concat(q185_* q185), punct(" ")
replace chw_service4 = " " + chw_service4 + " "
gen cservice4_none = cond(regexm(chw_service4,"77")==1,1,0)
gen cservice4_advice = cond(regexm(chw_service4," 1 ")==1,1,0)
gen cservice4_diagnosis = cond(regexm(chw_service4," 2 ")==1,1,0)
gen cservice4_test = cond(regexm(chw_service4," 3 ")==1,1,0)
gen cservice4_treat_child = cond(regexm(chw_service4," 4 ")==1,1,0)
gen cservice4_treat_adult = cond(regexm(chw_service4," 5 ")==1,1,0)
gen cservice4_refer = cond(regexm(chw_service4," 6 ")==1,1,0)
gen cservice4_medicine = cond(regexm(chw_service4," 7 ")==1,1,0)
gen cservice4_net = cond(regexm(chw_service4," 8 ")==1,1,0)
gen cservice4_other = cond(regexm(chw_service4,"96")==1,1,0)
gen cservice4_dk = cond(regexm(chw_service4,"98")==1,1,0)

* Specific problems to access CHW
egen chw_access = concat(q189_* q189), punct(" ")
replace chw_access = " " + chw_access + " "	
gen access_nochw = cond(regexm(chw_access," 1 ")==1,1,0)
gen access_notavailable = cond(regexm(chw_access," 2 ")==1,1,0)
gen access_nofind = cond(regexm(chw_access," 3 ")==1,1,0)
gen access_knowledge = cond(regexm(chw_access," 9 ")==1,1,0)
gen access_cost = cond(regexm(chw_access," 10 ")==1,1,0)
gen access_other = cond(regexm(chw_access,"96")==1,1,0)
gen access_dk = cond(regexm(chw_access,"98")==1,1,0)

label values symptom_ras_* cservice* creason_* nocreason_* access_* yesno

** Table: Knowledge related to rectal artesunate and iCCM
label values q163 yesno
capture noisily svy,subpop(if level2 == 101): tab q163 ras, col obs per pearson			// Child has previously received RAS
capture noisily svy,subpop(if level2 == 102): tab q163 ras, col obs per pearson			// Child has previously received RAS
capture noisily svy,subpop(if level2 == 103): tab q163 ras,col obs per pearson			// Child has previously received RAS


* Symptoms of the child when RAS was given
capture noisily svy,subpop(if level2 == 101): tab symptom_ras_none ras, col obs per pearson	 		// None
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_none ras, col obs per pearson	 		// None
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_none ras, col obs per pearson	 		// None

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_headache ras, col obs per pearson		// Headache
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_headache ras, col obs per pearson		// Headache
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_headache ras, col obs per pearson		// Headache

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_dizzy ras, col obs per pearson	 		// Dizziness
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_dizzy ras, col obs per pearson	 		// Dizziness
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_dizzy ras, col obs per pearson	 		// Dizziness

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_cough ras, col obs per pearson			// Cough 
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_cough ras, col obs per pearson			// Cough 
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_cough ras, col obs per pearson			// Cough 

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_sputum ras, col obs per pearson		// Cough with sputum
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_sputum ras, col obs per pearson		// Cough with sputum
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_sputum ras, col obs per pearson		// Cough with sputum

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_breathing ras, col obs per pearson	 	// Fast or difficulty in breathing
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_breathing ras, col obs per pearson	 	// Fast or difficulty in breathing
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_breathing ras, col obs per pearson	 	// Fast or difficulty in breathing

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_nausea ras, col obs per pearson	 	// Nausea
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_nausea ras, col obs per pearson	 	// Nausea
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_nausea ras, col obs per pearson	 	// Nausea

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_vomit ras, col obs per pearson	 		// Vomiting
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_vomit ras, col obs per pearson	 		// Vomiting
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_vomit ras, col obs per pearson	 		// Vomiting

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_diarrhea ras, col obs per pearson	 	// Diarrhea
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_diarrhea ras, col obs per pearson	 	// Diarrhea
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_diarrhea ras, col obs per pearson	 	// Diarrhea

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_watery_diarrhea ras, col obs per pearson	 	// Watery diarrhea
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_watery_diarrhea ras, col obs per pearson	 	// Watery diarrhea
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_watery_diarrhea ras, col obs per pearson	 	// Watery diarrhea

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_stomach ras, col obs per pearson	 	// Stomach ache
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_stomach ras, col obs per pearson	 	// Stomach ache
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_stomach ras, col obs per pearson	 	// Stomach ache

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_skin ras, col obs per pearson			// Skin rash
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_skin ras, col obs per pearson			// Skin rash
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_skin ras, col obs per pearson			// Skin rash

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_convulsion ras, col obs per pearson	// Convulsions
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_convulsion ras, col obs per pearson	// Convulsions
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_convulsion ras, col obs per pearson	// Convulsions

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_shiver ras, col obs per pearson		// Shivering
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_shiver ras, col obs per pearson		// Shivering
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_shiver ras, col obs per pearson		// Shivering

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_bpain ras, col obs per pearson	 		// Body pain
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_bpain ras, col obs per pearson	 		// Body pain
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_bpain ras, col obs per pearson	 		// Body pain

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_jpain ras, col obs per pearson	 		// Joint pain
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_jpain ras, col obs per pearson	 		// Joint pain
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_jpain ras, col obs per pearson	 		// Joint pain

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_sleepy ras, col obs per pearson	 	// Unusually sleepy or unconscious
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_sleepy ras, col obs per pearson	 	// Unusually sleepy or unconscious
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_sleepy ras, col obs per pearson	 	// Unusually sleepy or unconscious

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_bloody_diarrhea ras, col obs per pearson	 	// Diarrhea with blood
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_bloody_diarrhea ras, col obs per pearson	 	// Diarrhea with blood
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_bloody_diarrhea ras, col obs per pearson	 	// Diarrhea with blood

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_fever ras, col obs per pearson	 		// Fever
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_fever ras, col obs per pearson	 		// Fever
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_fever ras, col obs per pearson	 		// Fever

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_nodrink ras, col obs per pearson	 	// Unable to drink or eat
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_nodrink ras, col obs per pearson	 	// Unable to drink or eat
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_nodrink ras, col obs per pearson	 	// Unable to drink or eat

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_swelling ras, col obs per pearson	 	// Swelling of both feet
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_swelling ras, col obs per pearson	 	// Swelling of both feet
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_swelling ras, col obs per pearson	 	// Swelling of both feet

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_nosit ras, col obs per pearson	 		// Unable to sit or stand up
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_nosit ras, col obs per pearson	 		// Unable to sit or stand up
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_nosit ras, col obs per pearson	 		// Unable to sit or stand up

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_stiffneck ras, col obs per pearson	 	// Stiff neck
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_stiffneck ras, col obs per pearson	 	// Stiff neck
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_stiffneck ras, col obs per pearson	 	// Stiff neck

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_other ras, col obs per pearson	 		// Other
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_other ras, col obs per pearson	 		// Other
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_other ras, col obs per pearson	 		// Other

capture noisily svy,subpop(if level2 == 101): tab symptom_ras_dk ras, col obs per pearson			// Don't know
capture noisily svy,subpop(if level2 == 102): tab symptom_ras_dk ras, col obs per pearson			// Don't know
capture noisily svy,subpop(if level2 == 103): tab symptom_ras_dk ras, col obs per pearson			// Don't know

tab q166oth	ras	// Please check if any other response fits into one of the categories above

capture noisily svy,subpop(if level2 == 101): tab q167 ras, col obs per pearson				// Source of RAS
capture noisily svy,subpop(if level2 == 102): tab q167 ras, col obs per pearson				// Source of RAS
capture noisily svy,subpop(if level2 == 103): tab q167 ras, col obs per pearson				// Source of RAS
tab q167oth	ras	// Please check if any other response fits into one of the categories above

capture noisily svy,subpop(if level2 == 101): tab q196 ras, col obs per pearson				// Would want RAS again for child
capture noisily svy,subpop(if level2 == 102): tab q196 ras, col obs per pearson				// Would want RAS again for child
capture noisily svy,subpop(if level2 == 103): tab q196 ras, col obs per pearson				// Would want RAS again for child

capture noisily svy,subpop(if level2 == 101): tab q178 ras, col obs per pearson				// Has used CHW service before
capture noisily svy,subpop(if level2 == 102): tab q178 ras, col obs per pearson				// Has used CHW service before
capture noisily svy,subpop(if level2 == 103): tab q178 ras, col obs per pearson				// Has used CHW service before


* Details of service used
capture noisily svy,subpop(if level2 == 101): tab cservice_none ras, col obs per pearson	 			// None / no service
capture noisily svy,subpop(if level2 == 102): tab cservice_none ras, col obs per pearson	 			// None / no service
capture noisily svy,subpop(if level2 == 103): tab cservice_none ras, col obs per pearson	 			// None / no service

capture noisily svy,subpop(if level2 == 101): tab cservice_advice ras, col obs per pearson	 		// Advice / counselling
capture noisily svy,subpop(if level2 == 102): tab cservice_advice ras, col obs per pearson	 		// Advice / counselling
capture noisily svy,subpop(if level2 == 103): tab cservice_advice ras, col obs per pearson	 		// Advice / counselling

capture noisily svy,subpop(if level2 == 101): tab cservice_diagnosis ras, col obs per pearson		// Diagnose an illness
capture noisily svy,subpop(if level2 == 102): tab cservice_diagnosis ras, col obs per pearson		// Diagnose an illness
capture noisily svy,subpop(if level2 == 103): tab cservice_diagnosis ras, col obs per pearson		// Diagnose an illness

capture noisily svy,subpop(if level2 == 101): tab cservice_test ras, col obs per pearson			// Malaria test
capture noisily svy,subpop(if level2 == 102): tab cservice_test ras, col obs per pearson			// Malaria test
capture noisily svy,subpop(if level2 == 103): tab cservice_test ras, col obs per pearson			// Malaria test

capture noisily svy,subpop(if level2 == 101): tab cservice_treat_child ras, col obs per pearson	 	// Treatment of child
capture noisily svy,subpop(if level2 == 102): tab cservice_treat_child ras, col obs per pearson	 	// Treatment of child
capture noisily svy,subpop(if level2 == 103): tab cservice_treat_child ras, col obs per pearson	 	// Treatment of child

capture noisily svy,subpop(if level2 == 101): tab cservice_treat_adult ras, col obs per pearson		// Treatment of adult
capture noisily svy,subpop(if level2 == 102): tab cservice_treat_adult ras, col obs per pearson		// Treatment of adult
capture noisily svy,subpop(if level2 == 103): tab cservice_treat_adult ras, col obs per pearson		// Treatment of adult

capture noisily svy,subpop(if level2 == 101): tab cservice_refer ras, col obs per pearson			// Referral to a health facility
capture noisily svy,subpop(if level2 == 102): tab cservice_refer ras, col obs per pearson			// Referral to a health facility
capture noisily svy,subpop(if level2 == 103): tab cservice_refer ras, col obs per pearson			// Referral to a health facility

capture noisily svy,subpop(if level2 == 101): tab cservice_medicine ras, col obs per pearson			// Provision of medicine
capture noisily svy,subpop(if level2 == 102): tab cservice_medicine ras, col obs per pearson			// Provision of medicine
capture noisily svy,subpop(if level2 == 103): tab cservice_medicine ras, col obs per pearson			// Provision of medicine

capture noisily svy,subpop(if level2 == 101): tab cservice_net ras, col obs per pearson				// Provision of mosquito net
capture noisily svy,subpop(if level2 == 102): tab cservice_net ras, col obs per pearson				// Provision of mosquito net
capture noisily svy,subpop(if level2 == 103): tab cservice_net ras, col obs per pearson				// Provision of mosquito net

capture noisily svy,subpop(if level2 == 101): tab cservice_other ras, col obs per pearson			// Other
capture noisily svy,subpop(if level2 == 102): tab cservice_other ras, col obs per pearson			// Other
capture noisily svy,subpop(if level2 == 103): tab cservice_other ras, col obs per pearson			// Other

capture noisily svy,subpop(if level2 == 101): tab cservice_dk ras, col obs per pearson	 			// Don't know
capture noisily svy,subpop(if level2 == 102): tab cservice_dk ras, col obs per pearson	 			// Don't know
capture noisily svy,subpop(if level2 == 103): tab cservice_dk ras, col obs per pearson	 			// Don't know

tab q179oth	ras	// Please check if any other response fits into one of the categories above

* Reason for choosing CHW over other provider
capture noisily svy,subpop(if level2 == 101): tab creason_know ras, col obs per pearson	 			// I know the CHW
capture noisily svy,subpop(if level2 == 102): tab creason_know ras, col obs per pearson	 			// I know the CHW
capture noisily svy,subpop(if level2 == 103): tab creason_know ras, col obs per pearson	 			// I know the CHW

capture noisily svy,subpop(if level2 == 101): tab creason_trust ras, col obs per pearson	 			// I trust the CHW
capture noisily svy,subpop(if level2 == 102): tab creason_trust ras, col obs per pearson	 			// I trust the CHW
capture noisily svy,subpop(if level2 == 103): tab creason_trust ras, col obs per pearson	 			// I trust the CHW

capture noisily svy,subpop(if level2 == 101): tab creason_near ras, col obs per pearson	 			// The CHW is nearby / is easily reachable
capture noisily svy,subpop(if level2 == 102): tab creason_near ras, col obs per pearson	 			// The CHW is nearby / is easily reachable
capture noisily svy,subpop(if level2 == 103): tab creason_near ras, col obs per pearson	 			// The CHW is nearby / is easily reachable

capture noisily svy,subpop(if level2 == 101): tab creason_service ras, col obs per pearson			// The CHW provides a good service
capture noisily svy,subpop(if level2 == 102): tab creason_service ras, col obs per pearson			// The CHW provides a good service
capture noisily svy,subpop(if level2 == 103): tab creason_service ras, col obs per pearson			// The CHW provides a good service

capture noisily svy,subpop(if level2 == 101): tab creason_free ras, col obs per pearson	 			// The service is free of charge
capture noisily svy,subpop(if level2 == 102): tab creason_free ras, col obs per pearson	 			// The service is free of charge
capture noisily svy,subpop(if level2 == 103): tab creason_free ras, col obs per pearson	 			// The service is free of charge

capture noisily svy,subpop(if level2 == 101): tab creason_cheap ras, col obs per pearson	 			// The service is cheap / cheaper than other options
capture noisily svy,subpop(if level2 == 102): tab creason_cheap ras, col obs per pearson	 			// The service is cheap / cheaper than other options
capture noisily svy,subpop(if level2 == 103): tab creason_cheap ras, col obs per pearson	 			// The service is cheap / cheaper than other options

capture noisily svy,subpop(if level2 == 101): tab creason_hfclosed ras, col obs per pearson	 		// The health facility was closed
capture noisily svy,subpop(if level2 == 102): tab creason_hfclosed ras, col obs per pearson	 		// The health facility was closed
capture noisily svy,subpop(if level2 == 103): tab creason_hfclosed ras, col obs per pearson	 		// The health facility was closed

capture noisily svy,subpop(if level2 == 101): tab creason_noother ras, col obs per pearson			// I didn't know where else to go
capture noisily svy,subpop(if level2 == 102): tab creason_noother ras, col obs per pearson			// I didn't know where else to go
capture noisily svy,subpop(if level2 == 103): tab creason_noother ras, col obs per pearson			// I didn't know where else to go

capture noisily svy,subpop(if level2 == 101): tab creason_advice ras, col obs per pearson	 		// I was advised to consult the CHW
capture noisily svy,subpop(if level2 == 102): tab creason_advice ras, col obs per pearson	 		// I was advised to consult the CHW
capture noisily svy,subpop(if level2 == 103): tab creason_advice ras, col obs per pearson	 		// I was advised to consult the CHW

capture noisily svy,subpop(if level2 == 101): tab creason_other ras, col obs per pearson	 			// Other
capture noisily svy,subpop(if level2 == 102): tab creason_other ras, col obs per pearson	 			// Other
capture noisily svy,subpop(if level2 == 103): tab creason_other ras, col obs per pearson	 			// Other

capture noisily svy,subpop(if level2 == 101): tab creason_dk ras, col obs per pearson	 			// Don't know
capture noisily svy,subpop(if level2 == 102): tab creason_dk ras, col obs per pearson	 			// Don't know
capture noisily svy,subpop(if level2 == 103): tab creason_dk ras, col obs per pearson	 			// Don't know

tab q180oth	ras	// Please check if any other response fits into one of the categories above

* Reason for never using services of CHW
capture noisily svy,subpop(if level2 == 101): tab nocreason_nochw ras, col obs per pearson	 		// There is no CHW nearby
capture noisily svy,subpop(if level2 == 102): tab nocreason_nochw ras, col obs per pearson	 		// There is no CHW nearby
capture noisily svy,subpop(if level2 == 103): tab nocreason_nochw ras, col obs per pearson	 		// There is no CHW nearby

capture noisily svy,subpop(if level2 == 101): tab nocreason_notavailable ras, col obs per pearson	 // The CHW is not readily available / is not at work
capture noisily svy,subpop(if level2 == 102): tab nocreason_notavailable ras, col obs per pearson	 // The CHW is not readily available / is not at work
capture noisily svy,subpop(if level2 == 103): tab nocreason_notavailable ras, col obs per pearson	 // The CHW is not readily available / is not at work

capture noisily svy,subpop(if level2 == 101): tab nocreason_nofind ras, col obs per pearson	 		// I don't know where / how to find the CHW
capture noisily svy,subpop(if level2 == 102): tab nocreason_nofind ras, col obs per pearson	 		// I don't know where / how to find the CHW
capture noisily svy,subpop(if level2 == 103): tab nocreason_nofind ras, col obs per pearson	 		// I don't know where / how to find the CHW

capture noisily svy,subpop(if level2 == 101): tab nocreason_dkservice ras, col obs per pearson	 	// I don't know what services the CHW offers
capture noisily svy,subpop(if level2 == 102): tab nocreason_dkservice ras, col obs per pearson	 	// I don't know what services the CHW offers
capture noisily svy,subpop(if level2 == 103): tab nocreason_dkservice ras, col obs per pearson	 	// I don't know what services the CHW offers

capture noisily svy,subpop(if level2 == 101): tab nocreason_wrongservice ras, col obs per pearson	 // The CHW does not offer the services I need
capture noisily svy,subpop(if level2 == 102): tab nocreason_wrongservice ras, col obs per pearson	 // The CHW does not offer the services I need
capture noisily svy,subpop(if level2 == 103): tab nocreason_wrongservice ras, col obs per pearson	 // The CHW does not offer the services I need

capture noisily svy,subpop(if level2 == 101): tab nocreason_medicine ras, col obs per pearson	 	// The CHW does not have medicines
capture noisily svy,subpop(if level2 == 102): tab nocreason_medicine ras, col obs per pearson	 	// The CHW does not have medicines
capture noisily svy,subpop(if level2 == 103): tab nocreason_medicine ras, col obs per pearson	 	// The CHW does not have medicines

capture noisily svy,subpop(if level2 == 101): tab nocreason_dkchw ras, col obs per pearson			// I don't know the CHW
capture noisily svy,subpop(if level2 == 102): tab nocreason_dkchw ras, col obs per pearson			// I don't know the CHW
capture noisily svy,subpop(if level2 == 103): tab nocreason_dkchw ras, col obs per pearson			// I don't know the CHW

capture noisily svy,subpop(if level2 == 101): tab nocreason_trust ras, col obs per pearson			// I don't trust the CHW
capture noisily svy,subpop(if level2 == 102): tab nocreason_trust ras, col obs per pearson			// I don't trust the CHW
capture noisily svy,subpop(if level2 == 103): tab nocreason_trust ras, col obs per pearson			// I don't trust the CHW

capture noisily svy,subpop(if level2 == 101): tab nocreason_knowledge ras, col obs per pearson	 	// The CHW is not knowledgeable
capture noisily svy,subpop(if level2 == 102): tab nocreason_knowledge ras, col obs per pearson	 	// The CHW is not knowledgeable
capture noisily svy,subpop(if level2 == 103): tab nocreason_knowledge ras, col obs per pearson	 	// The CHW is not knowledgeable

capture noisily svy,subpop(if level2 == 101): tab nocreason_cost ras, col obs per pearson	 		// The CHW charges money
capture noisily svy,subpop(if level2 == 102): tab nocreason_cost ras, col obs per pearson	 		// The CHW charges money
capture noisily svy,subpop(if level2 == 103): tab nocreason_cost ras, col obs per pearson	 		// The CHW charges money

capture noisily svy,subpop(if level2 == 101): tab nocreason_treat ras, col obs per pearson	 		// The CHW cannot treat my child
capture noisily svy,subpop(if level2 == 102): tab nocreason_treat ras, col obs per pearson	 		// The CHW cannot treat my child
capture noisily svy,subpop(if level2 == 103): tab nocreason_treat ras, col obs per pearson	 		// The CHW cannot treat my child

capture noisily svy,subpop(if level2 == 101): tab nocreason_badexp ras, col obs per pearson	 		// Other people have had bad experiences with the CHW
capture noisily svy,subpop(if level2 == 102): tab nocreason_badexp ras, col obs per pearson	 		// Other people have had bad experiences with the CHW
capture noisily svy,subpop(if level2 == 103): tab nocreason_badexp ras, col obs per pearson	 		// Other people have had bad experiences with the CHW

capture noisily svy,subpop(if level2 == 101): tab nocreason_advice ras, col obs per pearson	 		// I was advised not to consult the CHW
capture noisily svy,subpop(if level2 == 102): tab nocreason_advice ras, col obs per pearson	 		// I was advised not to consult the CHW
capture noisily svy,subpop(if level2 == 103): tab nocreason_advice ras, col obs per pearson	 		// I was advised not to consult the CHW

capture noisily svy,subpop(if level2 == 101): tab nocreason_other ras, col obs per pearson			// Other
capture noisily svy,subpop(if level2 == 102): tab nocreason_other ras, col obs per pearson			// Other
capture noisily svy,subpop(if level2 == 103): tab nocreason_other ras, col obs per pearson			// Other

capture noisily svy,subpop(if level2 == 101): tab nocreason_dk ras, col obs per pearson	 			// Don't know
capture noisily svy,subpop(if level2 == 102): tab nocreason_dk ras, col obs per pearson	 			// Don't know
capture noisily svy,subpop(if level2 == 103): tab nocreason_dk ras, col obs per pearson	 			// Don't know

tab q181oth	ras	// Please check if any other response fits into one of the categories above

* Knows services offered by CHW
capture noisily svy,subpop(if level2 == 101): tab cservice2_none ras, col obs per pearson			// None / no service
capture noisily svy,subpop(if level2 == 102): tab cservice2_none ras, col obs per pearson			// None / no service
capture noisily svy,subpop(if level2 == 103): tab cservice2_none ras, col obs per pearson			// None / no service

capture noisily svy,subpop(if level2 == 101): tab cservice2_advice ras, col obs per pearson	 		// Advice / counselling
capture noisily svy,subpop(if level2 == 102): tab cservice2_advice ras, col obs per pearson	 		// Advice / counselling
capture noisily svy,subpop(if level2 == 103): tab cservice2_advice ras, col obs per pearson	 		// Advice / counselling

capture noisily svy,subpop(if level2 == 101): tab cservice2_diagnosis ras, col obs per pearson		// Diagnose an illness
capture noisily svy,subpop(if level2 == 102): tab cservice2_diagnosis ras, col obs per pearson		// Diagnose an illness
capture noisily svy,subpop(if level2 == 103): tab cservice2_diagnosis ras, col obs per pearson		// Diagnose an illness

capture noisily svy,subpop(if level2 == 101): tab cservice2_test ras, col obs per pearson			// Malaria test
capture noisily svy,subpop(if level2 == 102): tab cservice2_test ras, col obs per pearson			// Malaria test
capture noisily svy,subpop(if level2 == 103): tab cservice2_test ras, col obs per pearson			// Malaria test

capture noisily svy,subpop(if level2 == 101): tab cservice2_treat_child ras, col obs per pearson	 	// Treatment of child
capture noisily svy,subpop(if level2 == 102): tab cservice2_treat_child ras, col obs per pearson	 	// Treatment of child
capture noisily svy,subpop(if level2 == 103): tab cservice2_treat_child ras, col obs per pearson	 	// Treatment of child

capture noisily svy,subpop(if level2 == 101): tab cservice2_treat_adult ras, col obs per pearson	 	// Treatment of adult
capture noisily svy,subpop(if level2 == 102): tab cservice2_treat_adult ras, col obs per pearson	 	// Treatment of adult
capture noisily svy,subpop(if level2 == 103): tab cservice2_treat_adult ras, col obs per pearson	 	// Treatment of adult

capture noisily svy,subpop(if level2 == 101): tab cservice2_refer ras, col obs per pearson			// Referral to a health facility
capture noisily svy,subpop(if level2 == 102): tab cservice2_refer ras, col obs per pearson			// Referral to a health facility
capture noisily svy,subpop(if level2 == 103): tab cservice2_refer ras, col obs per pearson			// Referral to a health facility

capture noisily svy,subpop(if level2 == 101): tab cservice2_medicine ras, col obs per pearson	 	// Provision of medicine
capture noisily svy,subpop(if level2 == 102): tab cservice2_medicine ras, col obs per pearson	 	// Provision of medicine
capture noisily svy,subpop(if level2 == 103): tab cservice2_medicine ras, col obs per pearson	 	// Provision of medicine

capture noisily svy,subpop(if level2 == 101): tab cservice2_net ras, col obs per pearson	 			// Provision of mosquito net
capture noisily svy,subpop(if level2 == 102): tab cservice2_net ras, col obs per pearson	 			// Provision of mosquito net
capture noisily svy,subpop(if level2 == 103): tab cservice2_net ras, col obs per pearson	 			// Provision of mosquito net

capture noisily svy,subpop(if level2 == 101): tab cservice2_other ras, col obs per pearson			// Other
capture noisily svy,subpop(if level2 == 102): tab cservice2_other ras, col obs per pearson			// Other
capture noisily svy,subpop(if level2 == 103): tab cservice2_other ras, col obs per pearson			// Other

capture noisily svy,subpop(if level2 == 101): tab cservice2_dk ras, col obs per pearson	 			// Don't know
capture noisily svy,subpop(if level2 == 102): tab cservice2_dk ras, col obs per pearson	 			// Don't know
capture noisily svy,subpop(if level2 == 103): tab cservice2_dk ras, col obs per pearson	 			// Don't know

tab q182oth	ras	// Please check if any other response fits into one of the categories above

* Which services offered by CHW are useful
capture noisily svy,subpop(if level2 == 101): tab cservice3_none ras, col obs per pearson			// None / no service
capture noisily svy,subpop(if level2 == 102): tab cservice3_none ras, col obs per pearson			// None / no service
capture noisily svy,subpop(if level2 == 103): tab cservice3_none ras, col obs per pearson			// None / no service

capture noisily svy,subpop(if level2 == 101): tab cservice3_advice ras, col obs per pearson			// Advice / counselling
capture noisily svy,subpop(if level2 == 102): tab cservice3_advice ras, col obs per pearson			// Advice / counselling
capture noisily svy,subpop(if level2 == 103): tab cservice3_advice ras, col obs per pearson			// Advice / counselling

capture noisily svy,subpop(if level2 == 101): tab cservice3_diagnosis ras, col obs per pearson	 	// Diagnose an illness
capture noisily svy,subpop(if level2 == 102): tab cservice3_diagnosis ras, col obs per pearson	 	// Diagnose an illness
capture noisily svy,subpop(if level2 == 103): tab cservice3_diagnosis ras, col obs per pearson	 	// Diagnose an illness

capture noisily svy,subpop(if level2 == 101): tab cservice3_test ras, col obs per pearson	 		// Malaria test
capture noisily svy,subpop(if level2 == 102): tab cservice3_test ras, col obs per pearson	 		// Malaria test
capture noisily svy,subpop(if level2 == 103): tab cservice3_test ras, col obs per pearson	 		// Malaria test

capture noisily svy,subpop(if level2 == 101): tab cservice3_treat_child ras, col obs per pearson	 	// Treatment of child
capture noisily svy,subpop(if level2 == 102): tab cservice3_treat_child ras, col obs per pearson	 	// Treatment of child
capture noisily svy,subpop(if level2 == 103): tab cservice3_treat_child ras, col obs per pearson	 	// Treatment of child

capture noisily svy,subpop(if level2 == 101): tab cservice3_treat_adult ras, col obs per pearson	 	// Treatment of adult
capture noisily svy,subpop(if level2 == 102): tab cservice3_treat_adult ras, col obs per pearson	 	// Treatment of adult
capture noisily svy,subpop(if level2 == 103): tab cservice3_treat_adult ras, col obs per pearson	 	// Treatment of adult

capture noisily svy,subpop(if level2 == 101): tab cservice3_refer ras, col obs per pearson	 		// Referral to a health facility
capture noisily svy,subpop(if level2 == 102): tab cservice3_refer ras, col obs per pearson	 		// Referral to a health facility
capture noisily svy,subpop(if level2 == 103): tab cservice3_refer ras, col obs per pearson	 		// Referral to a health facility

capture noisily svy,subpop(if level2 == 101): tab cservice3_medicine ras, col obs per pearson	 	// Provision of medicine
capture noisily svy,subpop(if level2 == 102): tab cservice3_medicine ras, col obs per pearson	 	// Provision of medicine
capture noisily svy,subpop(if level2 == 103): tab cservice3_medicine ras, col obs per pearson	 	// Provision of medicine

capture noisily svy,subpop(if level2 == 101): tab cservice3_net ras, col obs per pearson	 			// Provision of mosquito net
capture noisily svy,subpop(if level2 == 102): tab cservice3_net ras, col obs per pearson	 			// Provision of mosquito net
capture noisily svy,subpop(if level2 == 103): tab cservice3_net ras, col obs per pearson	 			// Provision of mosquito net

capture noisily svy,subpop(if level2 == 101): tab cservice3_other ras, col obs per pearson	 		// Other
capture noisily svy,subpop(if level2 == 102): tab cservice3_other ras, col obs per pearson	 		// Other
capture noisily svy,subpop(if level2 == 103): tab cservice3_other ras, col obs per pearson	 		// Other

capture noisily svy,subpop(if level2 == 101): tab cservice3_dk ras, col obs per pearson	 			// Don't know
capture noisily svy,subpop(if level2 == 102): tab cservice3_dk ras, col obs per pearson	 			// Don't know
capture noisily svy,subpop(if level2 == 103): tab cservice3_dk ras, col obs per pearson	 			// Don't know

tab q183oth	ras	// Please check if any other response fits into one of the categories above

* Which services offered by CHW are NOT useful
capture noisily svy,subpop(if level2 == 101): tab cservice4_none ras, col obs per pearson	 		// None / no service
capture noisily svy,subpop(if level2 == 102): tab cservice4_none ras, col obs per pearson	 		// None / no service
capture noisily svy,subpop(if level2 == 103): tab cservice4_none ras, col obs per pearson	 		// None / no service

capture noisily svy,subpop(if level2 == 101): tab cservice4_advice ras, col obs per pearson	 		// Advice / counselling
capture noisily svy,subpop(if level2 == 102): tab cservice4_advice ras, col obs per pearson	 		// Advice / counselling
capture noisily svy,subpop(if level2 == 103): tab cservice4_advice ras, col obs per pearson	 		// Advice / counselling

capture noisily svy,subpop(if level2 == 101): tab cservice4_diagnosis ras, col obs per pearson	 	// Diagnose an illness
capture noisily svy,subpop(if level2 == 102): tab cservice4_diagnosis ras, col obs per pearson	 	// Diagnose an illness
capture noisily svy,subpop(if level2 == 103): tab cservice4_diagnosis ras, col obs per pearson	 	// Diagnose an illness

capture noisily svy,subpop(if level2 == 101): tab cservice4_test ras, col obs per pearson			// Malaria test
capture noisily svy,subpop(if level2 == 102): tab cservice4_test ras, col obs per pearson			// Malaria test
capture noisily svy,subpop(if level2 == 103): tab cservice4_test ras, col obs per pearson			// Malaria test

capture noisily svy,subpop(if level2 == 101): tab cservice4_treat_child ras, col obs per pearson	 	// Treatment of child
capture noisily svy,subpop(if level2 == 102): tab cservice4_treat_child ras, col obs per pearson	 	// Treatment of child
capture noisily svy,subpop(if level2 == 103): tab cservice4_treat_child ras, col obs per pearson	 	// Treatment of child

capture noisily svy,subpop(if level2 == 101): tab cservice4_treat_adult ras, col obs per pearson	 	// Treatment of adult
capture noisily svy,subpop(if level2 == 102): tab cservice4_treat_adult ras, col obs per pearson	 	// Treatment of adult
capture noisily svy,subpop(if level2 == 103): tab cservice4_treat_adult ras, col obs per pearson	 	// Treatment of adult

capture noisily svy,subpop(if level2 == 101): tab cservice4_refer ras, col obs per pearson	 		// Referral to a health facility
capture noisily svy,subpop(if level2 == 102): tab cservice4_refer ras, col obs per pearson	 		// Referral to a health facility
capture noisily svy,subpop(if level2 == 103): tab cservice4_refer ras, col obs per pearson	 		// Referral to a health facility

capture noisily svy,subpop(if level2 == 101): tab cservice4_medicine ras, col obs per pearson		// Provision of medicine
capture noisily svy,subpop(if level2 == 102): tab cservice4_medicine ras, col obs per pearson		// Provision of medicine
capture noisily svy,subpop(if level2 == 103): tab cservice4_medicine ras, col obs per pearson		// Provision of medicine

capture noisily svy,subpop(if level2 == 101): tab cservice4_net ras, col obs per pearson			// Provision of mosquito net
capture noisily svy,subpop(if level2 == 102): tab cservice4_net ras, col obs per pearson			// Provision of mosquito net
capture noisily svy,subpop(if level2 == 103): tab cservice4_net ras, col obs per pearson			// Provision of mosquito net

capture noisily svy,subpop(if level2 == 101): tab cservice4_other ras, col obs per pearson			// Other
capture noisily svy,subpop(if level2 == 102): tab cservice4_other ras, col obs per pearson			// Other
capture noisily svy,subpop(if level2 == 103): tab cservice4_other ras, col obs per pearson			// Other

capture noisily svy,subpop(if level2 == 101): tab cservice4_dk ras, col obs per pearson	 			// Don't know
capture noisily svy,subpop(if level2 == 102): tab cservice4_dk ras, col obs per pearson	 			// Don't know
capture noisily svy,subpop(if level2 == 103): tab cservice4_dk ras, col obs per pearson	 			// Don't know

tab q185oth	ras	// Please check if any other response fits into one of the categories above

capture noisily svy,subpop(if level2 == 101): tab q188 ras, col obs per pearson			// Has problems to access CHW
capture noisily svy,subpop(if level2 == 102): tab q188 ras, col obs per pearson			// Has problems to access CHW
capture noisily svy,subpop(if level2 == 103): tab q188 ras, col obs per pearson			// Has problems to access CHW


*Specific problems to access CHW
capture noisily svy,subpop(if level2 == 101): tab access_nochw ras, col obs per pearson	 			// There is no CHW nearby
capture noisily svy,subpop(if level2 == 102): tab access_nochw ras, col obs per pearson	 			// There is no CHW nearby
capture noisily svy,subpop(if level2 == 103): tab access_nochw ras, col obs per pearson	 			// There is no CHW nearby

capture noisily svy,subpop(if level2 == 101): tab access_notavailable ras, col obs per pearson	 	// The CHW is not readily available / is not at work
capture noisily svy,subpop(if level2 == 102): tab access_notavailable ras, col obs per pearson	 	// The CHW is not readily available / is not at work
capture noisily svy,subpop(if level2 == 103): tab access_notavailable ras, col obs per pearson	 	// The CHW is not readily available / is not at work

capture noisily svy,subpop(if level2 == 101): tab access_nofind ras, col obs per pearson	 			// I don't know where / how to find the CHW
capture noisily svy,subpop(if level2 == 102): tab access_nofind ras, col obs per pearson	 			// I don't know where / how to find the CHW
capture noisily svy,subpop(if level2 == 103): tab access_nofind ras, col obs per pearson	 			// I don't know where / how to find the CHW

capture noisily svy,subpop(if level2 == 101): tab access_knowledge ras, col obs per pearson	 		// The CHW is not knowledgeable
capture noisily svy,subpop(if level2 == 102): tab access_knowledge ras, col obs per pearson	 		// The CHW is not knowledgeable
capture noisily svy,subpop(if level2 == 103): tab access_knowledge ras, col obs per pearson	 		// The CHW is not knowledgeable

capture noisily svy,subpop(if level2 == 101): tab access_cost ras, col obs per pearson	 			// The CHW charges money
capture noisily svy,subpop(if level2 == 102): tab access_cost ras, col obs per pearson	 			// The CHW charges money
capture noisily svy,subpop(if level2 == 103): tab access_cost ras, col obs per pearson	 			// The CHW charges money

capture noisily svy,subpop(if level2 == 101): tab access_other ras, col obs per pearson	 			// Other
capture noisily svy,subpop(if level2 == 102): tab access_other ras, col obs per pearson	 			// Other
capture noisily svy,subpop(if level2 == 103): tab access_other ras, col obs per pearson	 			// Other

capture noisily svy,subpop(if level2 == 101): tab access_dk ras, col obs per pearson					// Don't know
capture noisily svy,subpop(if level2 == 102): tab access_dk ras, col obs per pearson					// Don't know
capture noisily svy,subpop(if level2 == 103): tab access_dk ras, col obs per pearson					// Don't know

tab q189oth	ras	// Please check if any other response fits into one of the categories above

capture noisily svy,subpop(if level2 == 101): tab q191 ras, col obs per pearson			// Thinks CHW are well trained
capture noisily svy,subpop(if level2 == 102): tab q191 ras, col obs per pearson			// Thinks CHW are well trained
capture noisily svy,subpop(if level2 == 103): tab q191 ras, col obs per pearson			// Thinks CHW are well trained

capture noisily svy,subpop(if level2 == 101): tab q193 ras, col obs per pearson			// Thinks CHW are well respected in community
capture noisily svy,subpop(if level2 == 102): tab q193 ras, col obs per pearson			// Thinks CHW are well respected in community
capture noisily svy,subpop(if level2 == 103): tab q193 ras, col obs per pearson			// Thinks CHW are well respected in community


** Other indicators: KAP RAS & iCCM
capture noisily svy,subpop(if level2 == 101): tab q186 ras, col obs per pearson						// Why are these services not useful
capture noisily svy,subpop(if level2 == 102): tab q186 ras, col obs per pearson						// Why are these services not useful
capture noisily svy,subpop(if level2 == 103): tab q186 ras, col obs per pearson						// Why are these services not useful


*** Media ***
** Table: Exposure to media **
capture noisily svy,subpop(if level2 == 101): tab q198 ras, col obs per pearson						// Exposure frequency to newspaper of Ipamu
capture noisily svy,subpop(if level2 == 102): tab q198 ras, col obs per pearson						// Exposure frequency to newspaper of Kenge
capture noisily svy,subpop(if level2 == 103): tab q198 ras, col obs per pearson						// Exposure frequency to newspaper of Kingandu

capture noisily svy,subpop(if level2 == 101): tab q199 ras, col obs per pearson						// Exposure frequency to radio of Ipamu
capture noisily svy,subpop(if level2 == 102): tab q199 ras, col obs per pearson						// Exposure frequency to radio of Kenge
capture noisily svy,subpop(if level2 == 103): tab q199 ras, col obs per pearson						// Exposure frequency to radio Kingandu

capture noisily svy,subpop(if level2 == 101): tab q200 ras, col obs per pearson						// Exposure frequency to TV of Ipamu
capture noisily svy,subpop(if level2 == 102): tab q200 ras, col obs per pearson						// Exposure frequency to TV of Kenge
capture noisily svy,subpop(if level2 == 103): tab q200 ras, col obs per pearson						// Exposure frequency to TV of Kingandu

capture noisily svy,subpop(if level2 == 101): tab q201 ras, col obs per pearson						// Exposure frequency to religious gatherings of Ipamu
capture noisily svy,subpop(if level2 == 102): tab q201 ras, col obs per pearson						// Exposure frequency to religious gatherings of Kenge
capture noisily svy,subpop(if level2 == 103): tab q201 ras, col obs per pearson						// Exposure frequency to religious gatherings of Kingandu

capture noisily svy,subpop(if level2 == 101): tab q202 ras, col obs per pearson						// Exposure frequency to community gatherings of Ipamu
capture noisily svy,subpop(if level2 == 102): tab q202 ras, col obs per pearson						// Exposure frequency to community gatherings of Kenge
capture noisily svy,subpop(if level2 == 103): tab q202 ras, col obs per pearson						// Exposure frequency to community gatherings of Kingandu




