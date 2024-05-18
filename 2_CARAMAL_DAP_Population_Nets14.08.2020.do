***************************
**                       **
**   CARAMAL Project     **
**                       **
***************************
**   Household Survey    **
***************************

* Analysis of baseline and midline Household Survey 2020 - DRC

** Open dataset Post-RAS(Enter your own file path)
use "C:\Users\JUNIOR KASONGA\Desktop\Etude_comparative_HHS\HHS_2\Merge_2\Nouveau_merge2\HHS_FORM_v6_DRC-2.dta",clear
rename setofg4hh_childcg_availablenet_r setofnet_repeat
rename setofg4hhroster setofhhroster

* create temporary file with HH level information
preserve
tempfile hhfile
drop if consent != 1
keep level2 cluster hhid confirm_household_head confirm_substitute consent setofhhroster
save `hhfile'
restore
** merge with HH Net usage (net_repeat)
replace setofnet_repeat = string(_n,"%5.0f") if setofnet_repeat == ""
merge 1:m setofnet_repeat using "C:\Users\JUNIOR KASONGA\Desktop\Etude_comparative_HHS\HHS_2\Merge_2\Nouveau_merge2\HHS_FORM_v6_DRC-net_repeat.dta" 
keep setofhhroster sleep_undernet hhm_sleep_undernet
rename *, lower
** merge with HH Member List (hhroster) and tempfile
merge m:m setofhhroster using "C:\Users\JUNIOR KASONGA\Desktop\Etude_comparative_HHS\HHS_2\Merge_2\Nouveau_merge2\HHS_FORM_v6_DRC-hhroster.dta"
drop if _merge==1	
drop _merge						
merge m:1 setofhhroster using `hhfile'
* Please check if the number of HH Members at this point is equal to the number of HH members of the hhroster.dta-file
rename *, lower
gen ras=2
tempfile hhs_v6_postras
save `hhs_v6_postras'
*end PostRAS

** Open dataset Baseline(Enter your own file path)
use "C:\Users\JUNIOR KASONGA\Desktop\Etude_comparative_HHS\HHS_1\Merge_1\HHS_FORM_v5_DRC_clean.dta", clear
rename SET_OF_g4_hh_child_net_repeat SETOFnet_repeat
rename SET_OF_g4_hhroster SETOFhhroster

* create temporary file with HH level information
preserve
tempfile hhfile1
drop if consent != 1
keep level2 cluster hhid confirm_household_head confirm_substitute consent SETOFhhroster
save `hhfile1'
restore

** merge with HH Net usage (net_repeat)
replace SETOFnet_repeat = string(_n,"%5.0f") if SETOFnet_repeat == ""
merge 1:m SETOFnet_repeat using "C:\Users\JUNIOR KASONGA\Desktop\Etude_comparative_HHS\HHS_1\Merge_1\HHS_FORM_v5_DRC-g4-hh_child-net_repeat.dta"
gen id = _n 								// Unique identifier of net

keep SETOFhhroster sleep_undernet hhm_sleep_undernet* id

forvalues i = 1/40 {						// drop net user variable if empty
	quietly summarize hhm_sleep_undernet`i'
	local hhm_sum = `r(sum)'
	if (`hhm_sum' == 0){
		drop hhm_sleep_undernet`i'
		}
	}
reshape long hhm_sleep_undernet, i(id) j(user_no)
collapse (sum) id, by(SETOFhhroster hhm_sleep_undernet)
gen hh_sno = hhm_sleep_undernet

** merge with HH Member List (hhroster) and tempfile
merge m:1 hh_sno SETOFhhroster using "C:\Users\JUNIOR KASONGA\Desktop\Etude_comparative_HHS\HHS_1\Merge_1\HHS_FORM_v5_DRC-g4-hhroster_clean2.dta"
drop if _merge==1	
drop _merge						
merge m:1 SETOFhhroster using `hhfile1'
* Please check if the number of HH Members at this point is equal to the number of HH members of the hhroster.dta-file
rename hhm_sleep_undernet hhm_sleep_undernetbaseline
rename *, lower
gen ras=1

**end baseline

*Append dataset
append using `hhs_v6_postras',force

label define ras 1 "baseline" 2 "post-ras", replace
label value ras ras	
drop if level2==.
label define yesno 0 "No" 1 "Yes", replace
label define yesnonk 0 "No" 1 "Yes" -98 "NK", replace
*------------------------------------------------------------------------------*

* Weighted analysis using svyset command in Stata 

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



*------------------------------------------------------------------------------*	
* Tabulation of indicators

*** Sample ***
* Derived variables:

egen agecat_all = cut(hh_age), at(0 5 10 15 20 40 200) lab
egen agecat_u5 = cut(hh_age), at(0 1 2 3 4 5 10 15 20 40 200) lab
** Table: Survey sample **
* De jure population (usually lives here)
bysort level2:tab hh_resident ras 		// by Zone de Santé/District
bysort ras:tab hh_resident agecat_all	// by age (u5 grouped together)
bysort ras:tab hh_resident agecat_u5	// by age (u5 separate by year)
bysort ras:tab hh_resident hh_gender	// by sex
bysort ras:tabstat hh_age , statistics(median p25 p75)              //Age of household members: Median (IQR)

* De facto population (all listed members)
tab level2 ras		// by Zone de Santé/District
tab agecat_all ras	// by age (u5 grouped together)
tab agecat_u5 ras	// by age (u5 separate by year)
tab hh_gender ras ,m	// by sex
bysort ras:tabstat hh_age, statistics(median p25 p75)              //Age of household members: Median (IQR)

*** Net use ***
* Derived variables:
gen sleep_net = cond(hhm_sleep_undernetbaseline!=.,1,0)	// Slept under any net last night
replace sleep_net = sleep_undernet if ras==2
egen agecat = cut(hh_age), at(0,1,5,10,15,20,200) lab
label values sleep_net yesno

** Percentage of the de facto household population who slept the night before
** the survey under a mosquito net, according to background characteristics
capture noisily svy ,subpop(if agecat== 0): tab sleep_net ras   , col obs per pearson 		// Age of sleep_net
capture noisily svy ,subpop(if agecat== 1): tab sleep_net ras   , col obs per pearson 		// Age of sleep_net
capture noisily svy ,subpop(if agecat== 2): tab sleep_net ras   , col obs per pearson 		// Age of sleep_net
capture noisily svy ,subpop(if agecat== 3): tab sleep_net ras   , col obs per pearson 		// Age of sleep_net
capture noisily svy ,subpop(if agecat== 4): tab sleep_net ras   , col obs per pearson 		// Age of sleep_net
capture noisily svy ,subpop(if agecat== 5): tab sleep_net ras   , col obs per pearson 		// Age of sleep_net

capture noisily svy ,subpop(if hh_gender == 1): tab sleep_net ras, col obs per pearson 	// Sex of sleep_net
capture noisily svy ,subpop(if hh_gender == 2): tab sleep_net ras, col obs per pearson 	// Sex of sleep_net 

capture noisily svy ,subpop(if level2 == 101): tab sleep_net ras, col obs per pearson 		// Zone de santé of sleep_net
capture noisily svy ,subpop(if level2 == 102): tab sleep_net ras, col obs per pearson 		// Zone de santé of sleep_net
capture noisily svy ,subpop(if level2 == 103): tab sleep_net ras, col obs per pearson 		// Zone de santé of sleep_net



** Note: Percentage who slept under an LLIN last night: Not applicable

***Pop_pyramid***
**Figure:  Population pyramid (WORKING TABLE ONLY)**
****Percent distribution of the de facto household population by 5-year age groups, according to sex
egen agepyramid = cut(hh_age), at(0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 200) lab

capture noisily svy ,subpop(if ras == 1): tab  agepyramid hh_gender,col  per pearson //tableau croisé des genre en fonction des groupe d'age of baseline
capture noisily svy ,subpop(if ras == 2): tab  agepyramid hh_gender,col  per pearson //tableau croisé des genre en fonction des groupe d'age of Post-RAS

/*Après la commande tab on a creer  un dataset de trois variables obtenu de tableau croisé en Excel et se de cette base des données qu'on doit 
tracer le pyramide de population*/

*------------------------------------------------------------------------------*
** Other indicators: Net used last night / Reason for not using net last night

* Net-level indicators (n = number of nets captured in the HHS)


* Open dataset post-RAS(HH dataset): Change file path!
use "C:\Users\JUNIOR KASONGA\Desktop\Etude_comparative_HHS\HHS_2\Merge_2\Nouveau_merge2\HHS_FORM_v6_DRC-2.dta",clear
rename setofg4hh_childcg_availablenet_r setofnet_repeat 
replace setofnet_repeat = string(_n,"%5.0f") if setofnet_repeat == ""

* Merge with dataset Net usage (net-repeat): Change file path!
merge 1:m setofnet_repeat using "C:\Users\JUNIOR KASONGA\Desktop\Etude_comparative_HHS\HHS_2\Merge_2\Nouveau_merge2\HHS_FORM_v6_DRC-net_repeat.dta"  
* Please make sure that all observations "from using" dataset were matched
count if _merge == 2 	// outcome should be 0

drop if _merge!=3
drop _merge
rename *, lower
gen ras=2

tempfile hhsnet_v6_PostRAS
save `hhsnet_v6_PostRAS'

* Open dataset Baseline (HH dataset): Change file path!
use "C:\Users\JUNIOR KASONGA\Desktop\Etude_comparative_HHS\HHS_1\Merge_1\HHS_FORM_v5_DRC_clean.dta", clear
rename SET_OF_g4_hh_child_net_repeat SETOFnet_repeat 
replace SETOFnet_repeat = string(_n,"%5.0f") if SETOFnet_repeat == ""

* Merge with dataset Net usage (net-repeat): Change file path!
merge 1:m SETOFnet_repeat using "C:\Users\JUNIOR KASONGA\Desktop\Etude_comparative_HHS\HHS_1\Merge_1\HHS_FORM_v5_DRC-g4-hh_child-net_repeat.dta"
* Please make sure that all observations "from using" dataset were matched
count if _merge == 2 	// outcome should be 0
drop if _merge!=3
rename *, lower
gen ras=1

*Append dataset
append using `hhsnet_v6_PostRAS', force

label define ras 1 "baseline" 2 "post-ras", replace
label value ras ras	

label define yesno 0 "No" 1 "Yes", replace
label define yesnonk 0 "No" 1 "Yes" -98 "NK", replace
*------------------------------------------------------------------------------*
* Weighted analysis using svyset command in Stata 


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

*------------------------------------------------------------------------------*
	
* Derived variables:
*rename *_oth* *oth*
egen reason_nonet = concat(no_sleep_*), punct(" ") 
replace reason_nonet = " " + reason_nonet + " "
gen nonet_mosquito = cond(regexm(reason_nonet," 1 ")==1,1,0)
gen nonet_malaria = cond(regexm(reason_nonet," 2 ")==1,1,0)
gen nonet_hot = cond(regexm(reason_nonet," 3 ")==1,1,0)
gen nonet_spare = cond(regexm(reason_nonet," 4 ")==1,1,0)
gen nonet_expired = cond(regexm(reason_nonet," 5 ")==1,1,0)
gen nonet_user = cond(regexm(reason_nonet," 6 ")==1,1,0)
gen nonet_other = cond(regexm(reason_nonet,"96")==1,1,0)
gen nonet_dk = cond(regexm(reason_nonet,"98")==1,1,0)
label values nonet_* yesno

label values sleep_undernet yesno
* Net use last night: Did anyone sleep under this net last night?
capture noisily svy  ,subpop(if level2 == 101): tab sleep_undernet ras, col obs per pearson
capture noisily svy  ,subpop(if level2 == 102): tab sleep_undernet ras, col obs per pearson
capture noisily svy  ,subpop(if level2 == 103): tab sleep_undernet ras, col obs per pearson


* Reason for not using net last night:	
capture noisily svy ,subpop(if level2 == 101): tab nonet_mosquito ras, col obs per pearson	// No mosquitoes of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab nonet_mosquito ras, col obs per pearson	// No mosquitoes of Kenge
capture noisily svy ,subpop(if level2 == 103): tab nonet_mosquito ras, col obs per pearson	// No mosquitoes of Kingandu

capture noisily svy ,subpop(if level2 == 101): tab nonet_malaria ras, col obs per pearson	// No malaria of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab nonet_malaria ras, col obs per pearson	// No malaria of Kenge
capture noisily svy ,subpop(if level2 == 103): tab nonet_malaria ras, col obs per pearson	// No malaria 


capture noisily svy ,subpop(if level2 == 101): tab nonet_hot ras, col obs per pearson	// Too hot of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab nonet_hot ras, col obs per pearson	// Too hot of Kenge
capture noisily svy ,subpop(if level2 == 103): tab nonet_hot ras, col obs per pearson	// Too hot of Kingandu


capture noisily svy ,subpop(if level2 == 101): tab nonet_spare ras, col obs per pearson	// Net spared/reserved of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab nonet_spare ras, col obs per pearson	// Net spared/reserved of Kenge
capture noisily svy ,subpop(if level2 == 103): tab nonet_spare ras, col obs per pearson	// Net spared/reserved of Kingandu


capture noisily svy ,subpop(if level2 == 101): tab nonet_expired ras, col obs per pearson	// Net expired/damaged of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab nonet_expired ras, col obs per pearson	// Net expired/damaged of Kenge
capture noisily svy ,subpop(if level2 == 103): tab nonet_expired ras, col obs per pearson	// Net expired/damaged of Kingandu


capture noisily svy ,subpop(if level2 == 101): tab nonet_user ras, col obs per pearson	// User did not sleep here of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab nonet_user ras, col obs per pearson	// User did not sleep here of Kenge
capture noisily svy ,subpop(if level2 == 103): tab nonet_user ras, col obs per pearson	// User did not sleep here of Kingandu


capture noisily svy ,subpop(if level2 == 101): tab nonet_other ras, col obs per pearson	// Other of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab nonet_other ras, col obs per pearson	// Other of Kenge
capture noisily svy ,subpop(if level2 == 103): tab nonet_other ras, col obs per pearson	// Other of Kingandu


capture noisily svy ,subpop(if level2 == 101): tab nonet_dk ras, col obs per pearson	// Don't know of Ipamu
capture noisily svy ,subpop(if level2 == 102): tab nonet_dk ras, col obs per pearson	// Don't know of Kenge
capture noisily svy ,subpop(if level2 == 103): tab nonet_dk ras, col obs per pearson	// Don't know of Kingandu

	
****BON***
