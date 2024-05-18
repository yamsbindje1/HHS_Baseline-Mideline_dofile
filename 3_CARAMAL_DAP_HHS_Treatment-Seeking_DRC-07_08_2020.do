***************************
**                       **
**   CARAMAL Project     **
**                       **
***************************
**   Household Survey    **
***************************

* Analysis of baseline  and midline Household Survey 2020 - DRC

** Open main dataset (Enter your own file path)
use "D:\NEXT SURVEY ANALYSIS 20_07_2020\COMPARAISON MENAGE\HHS_Treatment-Seeking_DRC_Baseline.dta"
rename *, lower
gen ras=1
tempfile Baseline
save Baseline

use "D:\NEXT SURVEY ANALYSIS 20_07_2020\COMPARAISON MENAGE\HHS_Treatment-Seeking_DRC_Post_RAS.dta"
rename *, lower
gen ras=2

append using Baseline, force

label define ras 1 "baseline" 2 "post-ras", replace
label value ras ras


rename hh_member_name child_name	// unique child name
rename hh_age child_age				// unique child age
rename hh_gender child_gender		// unique child sex


rename cg_name hh_member_name		// unique caregiver name
rename hh_age cg_age				// unique caregiver age
rename hh_gender cg_gender			// unique caregiver sex
rename hh_relationship cg_relationship // unique caregiver relationship to household head

** rename "other" variables (to reference other variable with _*)
rename *_oth* *oth*

*------------------------------------------------------------------------------*
** Overview of interviewed households

* Derived variable: 
** Interview completed, based on availability of a competent responent 
** and provision of informed consent / agreement to TS questionnaire
gen xcomplete = 0
replace xcomplete = 1 if consent == 1 & agree_ts == 1
replace xcomplete = 1 if confirm_con1 == 1 & consent == 1 & agree_ts == 1

tab consent, m  		// total hh that provided consent
tab xcomplete, m  		// total hh that provided consent and were interviewed 
tab child_age				// age of children 	
tab sick_nosick			// number of TS interviews (1) and Vignettes (0)

drop if xcomplete != 1 		// drop incomplete hh interviews
drop if child_age > 4		// drop interviews for children > 4 years
drop if sick_nosick == 0	// drop vignettes

*tab q1a					// NA: Question does not exist in DRC...
tab q3						// Fever in the last 2 weeks
tab q2						// Is the child still sick today?

drop if q3 == 0 | q2 == 1	// Children without fever or still sick are excluded

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

svyset cluster [pw=finalwt], strata(superstra) fpc(fpc1) vce(linearized) singleunit(scaled) ///
	|| uniqueid , fpc(fpc2)
svydescribe

*------------------------------------------------------------------------------*	
* Tabulation of indicators

*** Sample *** (no table)
ttest child_age if level2 == 101, by(ras) unpaired         // Mean Age of child IPAMU
ttest child_age if level2 == 102, by(ras) unpaired         // Mean Age of child KENGE
ttest child_age if level2 == 103, by(ras) unpaired         // Mean Age of child KINGANDU

capture noisily svy, subpop(if level2 == 101): tab cg_gender ras, col obs count per pearson		// Sex of child IPAMU
capture noisily svy, subpop(if level2 == 102): tab cg_gender ras, col obs count per pearson		// Sex of child IPAMU
capture noisily svy, subpop(if level2 == 103): tab cg_gender ras, col obs count per pearson		// Sex of child IPAMU


*** Symptoms *** (no table)
* Derived variables: 
* Other symptoms
egen other_symptom = concat(q17_* q17), punct(" ")
replace other_symptom = " " + other_symptom + " "
gen symptom_none = cond(regexm(other_symptom,"77")==1,1,0)
gen symptom_headache = cond(regexm(other_symptom," 1 ")==1,1,0)
gen symptom_dizzy = cond(regexm(other_symptom," 2 ")==1,1,0)
gen symptom_cough = cond(regexm(other_symptom," 3 ")==1,1,0)
gen symptom_sputum = cond(regexm(other_symptom," 4 ")==1,1,0)
gen symptom_breathing = cond(regexm(other_symptom," 5 ")==1,1,0)
gen symptom_nausea = cond(regexm(other_symptom," 6 ")==1,1,0)
gen symptom_vomit = cond(regexm(other_symptom," 7 ")==1,1,0)
gen symptom_diarrhea = cond(regexm(other_symptom," 8 ")==1,1,0)
gen symptom_watery_diarrhea = cond(regexm(other_symptom," 9 ")==1,1,0)
gen symptom_stomach = cond(regexm(other_symptom," 10 ")==1,1,0)
gen symptom_skin = cond(regexm(other_symptom," 11 ")==1,1,0)
gen symptom_convulsion = cond(regexm(other_symptom," 12 ")==1,1,0)
gen symptom_shiver = cond(regexm(other_symptom," 13 ")==1,1,0)
gen symptom_bpain = cond(regexm(other_symptom," 14 ")==1,1,0)
gen symptom_jpain = cond(regexm(other_symptom," 15 ")==1,1,0)
gen symptom_sleepy = cond(regexm(other_symptom," 16 ")==1,1,0)
gen symptom_bloody_diarrhea = cond(regexm(other_symptom," 17 ")==1,1,0)
gen symptom_fever = cond(regexm(other_symptom," 18 ")==1,1,0)
gen symptom_nodrink = cond(regexm(other_symptom," 19 ")==1,1,0)
gen symptom_swelling = cond(regexm(other_symptom," 20 ")==1,1,0)
gen symptom_nosit = cond(regexm(other_symptom," 21 ")==1,1,0)
gen symptom_stiffneck = cond(regexm(other_symptom," 22 ")==1,1,0)
gen symptom_other = cond(regexm(other_symptom,"96")==1,1,0)
gen symptom_dk = cond(regexm(other_symptom,"98")==1,1,0)
label values symptom_* yesno

* Variable changes (mainly to adjust denominator)
clonevar bstool = q7
replace bstool = 0 if q7 == .

* Fever
ttest q4 if level2 == 101, by(ras) unpaired      // Duration of fever IPAMU
ttest q4 if level2 == 103, by(ras) unpaired      // Duration of fever KENGE
ttest q4 if level2 == 103, by(ras) unpaired      // Duration of fever KINGANDU

ttest q8 if level2 == 101, by(ras) unpaired      //  Duration of diarrhea IPAMU
ttest q8 if level2 == 102, by(ras) unpaired      //  Duration of diarrhea KENGE
ttest q8 if level2 == 103, by(ras) unpaired      //  Duration of diarrhea KINGANDU

* Danger signs:
capture noisily svy, subpop(if level2 == 101): tab q3 ras, col obs count per pearson		// fever IPAMU
capture noisily svy, subpop(if level2 == 102): tab q3 ras, col obs count per pearson		// fever KENGE
capture noisily svy, subpop(if level2 == 103): tab q3 ras, col obs count per pearson		// fever KINGANDU
capture noisily svy, subpop(if level2 == 101): tab q6 ras, col obs count per pearson		// Diarrhea IPAMU
capture noisily svy, subpop(if level2 == 102): tab q6 ras, col obs count per pearson		// Diarrhea KENGE
capture noisily svy, subpop(if level2 == 103): tab q6 ras, col obs count per pearson		// Diarrhea KINGANDU
capture noisily svy, subpop(if level2 == 101): tab bstool ras, col obs count per pearson    // Blood in stool IPAMU
capture noisily svy, subpop(if level2 == 102): tab bstool ras, col obs count per pearson	// Blood in stool KENGE
capture noisily svy, subpop(if level2 == 103): tab bstool ras, col obs count per pearson	// Blood in stool KINGANDU

capture noisily svy, subpop(if level2 == 101): tab q10 ras, col obs count per pearson		// Cough IPAMU
capture noisily svy, subpop(if level2 == 102): tab q10 ras, col obs count per pearson		// Cough KENGE
capture noisily svy, subpop(if level2 == 103): tab q10 ras, col obs count per pearson		// Cough KINGANDU

ttest q11 if level2 == 101, by(ras) unpaired      //  Duration of cough IPAMU
ttest q11 if level2 == 102, by(ras) unpaired      //  Duration of cough KENGE
ttest q11 if level2 == 103, by(ras) unpaired      //  Duration of cough KINGANDU


*Other symptoms
capture noisily svy, subpop(if level2 == 101): tab symptom_none ras, col obs count per pearson		        // None IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_none ras, col obs count per pearson		        // None KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_none ras, col obs count per pearson		        // None KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_headache ras, col obs count per pearson		    // Headache IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_headache ras, col obs count per pearson		    // Headache KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_headache ras , col obs count per pearson		    // Headache KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_dizzy ras, col obs count per pearson		        // Dizziness IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_dizzy ras, col obs count per pearson		        // Dizziness KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_dizzy ras , col obs count per pearson		    // Dizziness KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_cough ras, col obs count per pearson		        // Cough IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_cough ras, col obs count per pearson		        // Cough KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_cough ras , col obs count per pearson		    // Cough KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_sputum ras, col obs count per pearson		    // Cough with sputum IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_sputum ras, col obs count per pearson		    // Cough with sputum KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_sputum ras , col obs count per pearson		    // Cough with sputum KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_breathing ras, col obs count per pearson		    // Fast or difficulty in breathing IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_breathing ras, col obs count per pearson		    // Fast or difficulty in breathing KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_breathing ras , col obs count per pearson	    // Fast or difficulty in breathing KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_nausea ras, col obs count per pearson		    // Nausea IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_nausea ras, col obs count per pearson		    // Nausea KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_nausea ras , col obs count per pearson	        // Nausea KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_vomit ras, col obs count per pearson		        // Vomiting IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_vomit ras, col obs count per pearson		        // Vomiting KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_vomit ras , col obs count per pearson	        // Vomiting KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_diarrhea ras, col obs count per pearson		    // Diarrhea IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_diarrhea ras, col obs count per pearson		    // Diarrheag KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_diarrhea ras , col obs count per pearson	        // Diarrhea KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_watery_diarrhea ras, col obs count per pearson	// Watery diarrhea IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_watery_diarrhea ras, col obs count per pearson	// Watery diarrhea KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_watery_diarrhea ras , col obs count per pearson	// Watery diarrhea KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_stomach ras, col obs count per pearson		    // Stomach ache IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_stomach ras, col obs count per pearson		    // Stomach achea KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_stomach ras , col obs count per pearson	        // Stomach ache KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_skin ras, col obs count per pearson		        // Skin rash IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_skin ras, col obs count per pearson		        // Skin rash KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_skin ras , col obs count per pearson	            // Skin rash KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_convulsion ras, col obs count per pearson		// Convulsions IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_convulsion ras, col obs count per pearson		// Convulsions KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_convulsion ras , col obs count per pearson	    // Convulsions KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_shiver ras, col obs count per pearson		    // Shivering IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_shiver ras, col obs count per pearson		    // Shivering KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_shiver ras , col obs count per pearson	        // Shivering KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_bpain ras, col obs count per pearson		        // Body pain IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_bpain ras, col obs count per pearson		        // Body pain KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_bpain ras , col obs count per pearson	        // Body pain KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_jpain ras, col obs count per pearson		        // Joint pain IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_jpain ras, col obs count per pearson		        // Joint pain KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_jpain ras , col obs count per pearson	        // Joint pain KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_sleepy ras, col obs count per pearson		    // Unusually sleepy or unconsciou IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_sleepy ras, col obs count per pearson		    // Unusually sleepy or unconsciou KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_sleepy ras , col obs count per pearson	        // Unusually sleepy or unconsciou KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_bloody_diarrhea ras, col obs count per pearson	// Diarrhea with bloodIPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_bloody_diarrhea ras, col obs count per pearson	// Diarrhea with blood KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_bloody_diarrhea ras , col obs count per pearson	// Diarrhea with bloodu KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_fever ras, col obs count per pearson	            // Fever IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_fever ras, col obs count per pearson	            // Fever KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_fever ras , col obs count per pearson	        // Fever KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_nodrink  ras, col obs count per pearson	        // Unable to drink or eat IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_nodrink  ras, col obs count per pearson	        // Unable to drink or eat KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_nodrink  ras , col obs count per pearson	        // Unable to drink or eat KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_swelling  ras, col obs count per pearson	        // Swelling of both feet IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_swelling  ras, col obs count per pearson	        // Swelling of both feett KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_swelling  ras , col obs count per pearson        // Swelling of both feet KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_nosit  ras, col obs count per pearson	        // Unable to sit or stand up IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_nosit  ras, col obs count per pearson	        // Unable to sit or stand up KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_nosit  ras , col obs count per pearson           // Unable to sit or stand up KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_stiffneck  ras, col obs count per pearson	    // Stiff neck IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_stiffneck  ras, col obs count per pearson	    // Stiff neck KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_stiffneck  ras , col obs count per pearson       // Stiff neck KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_other  ras, col obs count per pearson	        // Other IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_other  ras, col obs count per pearson	        // Other KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_other  ras , col obs count per pearson           // Other KINGANDU
capture noisily svy, subpop(if level2 == 101): tab symptom_dk  ras, col obs count per pearson	            // Don't Know IPAMU
capture noisily svy, subpop(if level2 == 102): tab symptom_dk  ras, col obs count per pearson	            // Don't Know KENGE
capture noisily svy, subpop(if level2 == 103): tab symptom_dk  ras , col obs count per pearson              // Don't Know KINGANDU

tab q17oth		// Please check if any other response fits into one of the categories above
	
*** Table: Treatment seeking ***
* Derived variables: 
* Danger signs according to WHO definition
gen danger_sign = cond((q10==1 & (q11>21 & q11!=.)) | (q6==1 & (q8>14 & q8!=.)) ///
	| q7 == 1 | (q3==1 & (q4>7 & q4!=.)) | symptom_convulsion==1 | symptom_nodrink==1 ///
	| symptom_vomit==1 | symptom_sleepy==1 | symptom_swelling==1,1,0)
label values danger_sign yesno
* Took antimalarials at home
egen antimalarial = concat(q29_* q30_* q29 q30), punct(" ")
replace antimalarial = " " + antimalarial + " "
gen am_alu = cond(regexm(antimalarial," 8 "),1,0)
gen am_aq = cond(regexm(antimalarial," 9 "),1,0)
gen am_as = cond(regexm(antimalarial," 10 "),1,0)
gen am_ras = cond(regexm(antimalarial," 21 "),1,0)
gen am_am = cond(regexm(antimalarial," 11 "),1,0)
gen am_asaq = cond(regexm(antimalarial," 12 "),1,0)
gen am_chloro = cond(regexm(antimalarial," 13 "),1,0)
gen am_quin = cond(regexm(antimalarial," 14 "),1,0)
gen am_sp = cond(regexm(antimalarial," 15 "),1,0)
label values antimalarial yesno
* Took medicine at home
clonevar med_home = q27
replace med_home = 0 if med_home == .
* Outside sources of treatment and care
egen out_source = concat(q39_* q39), punct(" ")
replace out_source = " " + out_source + " "
gen source_chw = cond(regexm(out_source," 1 "),1,0)
gen source_p_shf = cond(regexm(out_source," 2 ")|regexm(out_source," 3 "),1,0)
gen source_rhf = cond(regexm(out_source," 4 "),1,0)
gen source_pharm = cond(regexm(out_source," 5 "),1,0)
gen source_religion = cond(regexm(out_source," 7 ")|regexm(out_source," 8 "),1,0)
gen source_spirit = cond(regexm(out_source," 9 ")|regexm(out_source," 10 "),1,0)
gen source_other = cond(regexm(out_source,"96"),1,0)
* Type of outside provider visited first
egen first_provider = rowtotal(q39_1 q39)
recode first_provider 1=1 2=2 3=3 4=4 5=5 6=6 7/8=7 9/10=8 -96=-96 .=0
label define first_provider 1 "CHW" 2 "Referral facility" 3 "Secondary / primary facility" 4 "Clinic" 5 "Chemist/pharmacy" 6 "Drug shop"  7/8 "Church/mosque/shrine" 9/10 "Traditional healer, spiritualist" -96 "Other" 0 "No provider seen", replace
label values first_provider provider
* Time taken to reach first provider
egen time_first = rowtotal(q43_1 q43)
label define ttime_first  0 "Did not see any provider outside home" 1 "Less than 30  minutes" 2 "Less than one hour" 3 "Less than one day" 4 "More than one day" -98 "Don't know"
label values time_first time_toprovider
* Admitted for more than 12 hours
clonevar admitted = q25
replace admitted = 0 if admitted == .
* Had blood test done outside home
egen b_test = rowtotal(q46)		// Blood test done at any provider
recode b_test 0=0 1/100=1
* Result of blood test
quietly summarize count_p
global pmax = `r(max)'
forvalues i= 1/$pmax {						// Remove "Other" & "Don't know"
	gen test_`i' = q48				// New variable: test_*
	replace test_`i' = . if test_`i' < 0
	recode test_`i' 1=0 2=1
	}	
egen testresult_prov = rowtotal(q48_1  q48_2 q48_3 q48), missing
egen test_result = rowtotal(test_*), missing	// Positive if any test was positive
recode test_result 0=0 1/100=1
replace test_result = -96 if (q48_1==-96 | q48_2==-96 | q48_3==-96 | q48==-96) & test_result == .
replace test_result = -96 if (q48_1==-98 | q48_2==-98 | q48_3==-98 | q48==-98) & test_result == .
replace test_result = -77 if test_result == .
label define result 1 "Positive for malaria" 0 "Negative for malaria" -96 "Other" -98 "Don't know" -77 "No test done"
label values test_result result
* Received medicine outside home
egen out_medicine = rowtotal(q52_* q52)
recode out_medicine 0=0 1/100=1
* Received antimalarial outside home
egen receive_antimalarial = anymatch (q54_* q55_*) , values(8 9 10 21 11 12 13 14 15)
egen out_antimalaria = rowtotal(q53_* q53)
egen antimalarial2 = concat(q54_* q55_* q54 q55), punct(" ")
replace antimalarial2 = " " + antimalarial2 + " "
gen am_alu2 = cond(regexm(antimalarial2," 8 "),1,0)
gen am_aq2 = cond(regexm(antimalarial2," 9 "),1,0)
gen am_as2 = cond(regexm(antimalarial2," 10 "),1,0)
gen am_ras2 = cond(regexm(antimalarial2," 21 "),1,0)
gen am_am2 = cond(regexm(antimalarial2," 11 "),1,0)
gen am_asaq2 = cond(regexm(antimalarial2," 12 "),1,0)
gen am_chloro2 = cond(regexm(antimalarial2," 13 "),1,0)
gen am_quin2 = cond(regexm(antimalarial2," 14 "),1,0)
gen am_sp2 = cond(regexm(antimalarial2," 15 "),1,0)
label values antimalarial2 yesno
* Received antibiotic from outside home
egen receive_antibiotic = concat(q54_* q55_* q54 q55)
* Referred to another facility
egen referred = rowtotal(q66_* q66)	 
recode referred 0=0 1/100=1
* Followed referral advise
egen ref_adhere = rowtotal(q69_* q66), missing	 
recode ref_adhere 0=0 1/100=1 .=.
* Reasons for not following referral advise
egen not_adhere = concat(q72_* q72), punct(" ")
replace not_adhere = " " + not_adhere + " "
gen noadhere_money = cond(referred==1,cond(regexm(not_adhere," 1 "),1,0),.)
gen noadhere_distance = cond(referred==1,cond(regexm(not_adhere," 2 "),1,0),.)
gen noadhere_transport = cond(referred==1,cond(regexm(not_adhere," 3 "),1,0),.)
gen noadhere_duties = cond(referred==1,cond(regexm(not_adhere," 4 "),1,0),.)
gen noadhere_notsevere = cond(referred==1,cond(regexm(not_adhere," 5 "),1,0),.)
gen noadhere_improving = cond(referred==1,cond(regexm(not_adhere," 6 "),1,0),.)
gen noadhere_noagree = cond(referred==1,cond(regexm(not_adhere," 7 "),1,0),.)
gen noadhere_notrust = cond(referred==1,cond(regexm(not_adhere," 8 "),1,0),.)
gen noadhere_nohelp = cond(referred==1,cond(regexm(not_adhere," 9 "),1,0),.)
gen noadhere_other = cond(referred==1,cond(regexm(not_adhere,"96"),1,0),.)
label values source_* b_test out_medicine receive_* am_* referred ref_adhere noadhere_* yesno

*------------------------------------------------------------------------------*
*** Treatment seeking: Results ***
** Did something at home **
capture noisily svy, subpop(if danger_sign==0): tab q20 ras, col obs count per pearson	        // Did something at home BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab q20 ras, col obs count per pearson	        // Did something at home POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab med_home ras, col obs count per pearson	    // Took medicine at home BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab med_home ras, col obs count per pearson	    // Took medicine at home POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab q28 ras, col obs count per pearson	        // Took antimalarials at home BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab q28 ras, col obs count per pearson	        // Took antimalarials at home POST-RAS


* Type of antimalarial taken at home
capture noisily svy, subpop(if danger_sign==0): tab am_alu ras, col obs count per pearson	     // Artemether-Lumefantrine danger_sign
capture noisily svy, subpop(if danger_sign!=0): tab am_alu ras, col obs count per pearson	     // Artemether-Lumefantrine POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab am_aq ras , col obs count per pearson	     // Amodiaquine BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab am_aq ras, col obs count per pearson	     // Amodiaquine POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab am_as ras, col obs count per pearson	     // Artesunate BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab am_as ras, col obs count per pearson	     // Artesunate POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab am_ras ras, col obs count per pearson        // Rectal artesunate (suppository) BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab am_ras ras, col obs count per pearson	     // Rectal artesunate (suppository) POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab am_am ras, col obs count per pearson	     // Artemether BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab am_am ras, col obs count per pearson	     // Artemether POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab am_asaq ras, col obs count per pearson	     // Artesunate-Amodiaquine BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab am_asaq ras, col obs count per pearson	     // Artesunate-Amodiaquine POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab am_chloro ras, col obs count per pearson	 // Chloroquine BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab am_chloro ras, col obs count per pearson	 // Chloroquine POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab am_quin ras, col obs count per pearson	     // Quinine BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab am_quin ras, col obs count per pearson	     // Quinine POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab am_sp ras, col obs count per pearson	     // Sulphadoxine-pyrimethamine (SP) / Fansidar BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab am_sp ras, col obs count per pearson	     // Sulphadoxine-pyrimethamine (SP) / Fansidar POST-RAS
tab q29oth		// Please check if any other response fits into one of the categories above

** Sought treatment outside home **
capture noisily svy, subpop(if danger_sign==0): tab q21  ras, col obs count per pearson	                   // Sought treatment outside home BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab q21  ras, col obs count per pearson	                   // Sought treatment outside home BASELINE
* Outside sources of treatment & care
capture noisily svy, subpop(if danger_sign==0): tab source_chw, ras col obs count per pearson	           // CHW BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab source_chw ras, col obs count per pearson	           // CHW POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab source_rhf ras, col obs count per pearson	           // Referral facility BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab source_rhf ras, col obs count per pearson	           // Referral facility POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab source_p_shf ras, col obs count per pearson	           // Secondary / primary facility BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab source_p_shf ras, col obs count per pearson	           // Secondary / primary facility POST-RAS
		// Clinic: not applicable
capture noisily svy, subpop(if danger_sign==0): tab source_pharm ras, col obs count per pearson	       	   // Chemist / Pharmacy BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab source_pharm ras, col obs count per pearson	           // Chemist / Pharmacy POST-RAS
        // Drug shop: not applicable
capture noisily svy, subpop(if danger_sign==0): tab source_religion ras, col obs count per pearson	       // Church, mosque, shrine BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab source_religion ras, col obs count per pearson	       // Church, mosque, shrine POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab source_spirit ras, col obs count per pearson	       // Traditional healer, spiritualist BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab source_spirit ras, col obs count per pearson	       // Traditional healer, spiritualist POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab source_other ras, col obs count per pearson	           // Other BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab source_other ras, col obs count per pearson	           // Other POST-RAS
tab q39oth1		// Please check if any other response fits into one of the categories above
tab q39oth2		// Please check if any other response fits into one of the categories above
tab q39oth3		// Please check if any other response fits into one of the categories above

capture noisily svy, subpop(if danger_sign==0): tab first_provider ras, col obs count per pearson		   // Type of outside provider visited first BASELINE 
capture noisily svy, subpop(if danger_sign!=0): tab first_provider ras, col obs count per pearson	       // Type of outside provider visited first POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab time_first ras, col obs count per pearson	           // Time taken to reach first outside provider BASELINE 
capture noisily svy, subpop(if danger_sign!=0): tab time_first ras, col obs count per pearson	           // Time taken to reach first outside provider POST-

replace q4=. if q4==-98
ttest q4 if danger_sign ==0, by(ras) unpaired      // Time between start of illness and visiting first outside provider: Mean(sd) days  non danger_sign
ttest q4 if danger_sign !=0, by(ras) unpaired      // Time between start of illness and visiting first outside provider: Mean(sd) days  danger_sign

capture noisily svy, subpop(if danger_sign==0): tab admitted ras, col obs count per pearson	               // Admitted for more than 12 hours non danger_sign
capture noisily svy, subpop(if danger_sign!=0): tab admitted ras, col obs count per pearson	               // Admitted for more than 12 hours danger_sign
capture noisily svy, subpop(if danger_sign==0): tab b_test ras, col obs count per pearson	               // Had blood test done outside home non danger_sign 
capture noisily svy, subpop(if danger_sign!=0): tab b_test ras, col obs count per pearson	               // Had blood test done outside home danger_sign
capture noisily svy, subpop(if danger_sign==0): tab test_result ras, col obs count per pearson	           // Result of blood test (Positive if any test positive, negative if any test negative (except if one was positive))non danger_sign 
capture noisily svy, subpop(if danger_sign!=0): tab test_result ras, col obs count per pearson	           // Result of blood test (Positive if any test positive, negative if any test negative (except if one was positive)) danger_sign
tab q48oth1		// Please check if any other response fits into one of the categories above
tab q48oth2		// Please check if any other response fits into one of the categories above
tab q48oth3		// Please check if any other response fits into one of the categories above

capture noisily svy, subpop(if danger_sign==0): tab out_medicine ras, col obs count per pearson	          	// Received medicine outside home non danger_sign 
capture noisily svy, subpop(if danger_sign!=0): tab out_medicine ras, col obs count per pearson	          	// Received medicine outside home danger_sign
capture noisily svy, subpop(if danger_sign==0): tab receive_antimalarial ras, col obs count per pearson	    // Received antimalarial outside home non danger_sign 
capture noisily svy, subpop(if danger_sign!=0): tab receive_antimalarial ras, col obs count per pearson	    // Received antimalarial outside home danger_sign

* Type of antimalarial from outside home

* Type of antimalarial from outside home
capture noisily svy: tab am_alu danger_sign, col per 	// Artemether-Lumefantrine
capture noisily svy: tab am_aq danger_sign, col per 		// Amodiaquine
capture noisily svy: tab am_as danger_sign, col per 		// Artesunate
capture noisily svy: tab am_ras danger_sign, col per 	// Rectal artesunate (suppository)
capture noisily svy: tab am_am danger_sign, col per 		// Artemether
capture noisily svy: tab am_asaq danger_sign, col per 	// Artesunate-Amodiaquine
capture noisily svy: tab am_chloro danger_sign, col per 	// Chloroquine
capture noisily svy: tab am_quin danger_sign, col per 	// Quinine
capture noisily svy: tab am_sp danger_sign, col per 		// Sulphadoxine-pyrimethamine (SP) / Fansidar
tab q29oth		// Please check if any other response fits into one of the categories above

capture noisily svy, subpop(if danger_sign==0): tab am_alu2 ras, col obs count per pearson	     // Artemether-Lumefantrine non danger_sign
capture noisily svy, subpop(if danger_sign==1): tab am_alu2 ras, col obs count per pearson	     // Artemether-Lumefantrine danger_sign
capture noisily svy, subpop(if danger_sign==0): tab am_aq2 ras, col obs count per pearson	     // Amodiaquine non danger_sign 
capture noisily svy, subpop(if danger_sign!=0): tab am_aq2 ras, col obs count per pearson	     // Amodiaquine danger_sign
capture noisily svy, subpop(if danger_sign==0): tab am_as2 ras, col obs count per pearson	     // Artesunate BASELINE 
capture noisily svy, subpop(if danger_sign!=0): tab am_as2 ras, col obs count per pearson	     // Artesunate POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab am_ras2 ras, col obs count per pearson	     // Rectal artesunate (suppository) BASELINE 
capture noisily svy, subpop(if danger_sign!=0): tab am_ras2 ras, col obs count per pearson	     // Rectal artesunate (suppository)POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab am_am2 ras, col obs count per pearson	     // Artemether BASELINE 
capture noisily svy, subpop(if danger_sign!=0): tab am_am2 ras, col obs count per pearson	     // Artemether POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab am_asaq2 ras, col obs count per pearson	     // Artesunate-Amodiaquine BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab am_asaq2 ras, col obs count per pearson	     // Artesunate-Amodiaquine POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab am_chloro2 ras, col obs count per pearson	 // Chloroquine BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab am_chloro2 ras, col obs count per pearson	 // Chloroquine POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab am_quin2 ras, col obs count per pearson	     // Quinine BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab am_quin2 ras, col obs count per pearson	     // Quinine POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab am_sp2 ras, col obs count per pearson	     // Sulphadoxine-pyrimethamine (SP) / Fansidar BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab am_sp2 ras, col obs count per pearson	     // Sulphadoxine-pyrimethamine (SP) / Fansidar POST-RAS
tab q29oth		// Please check if any other response fits into one of the categories above

capture noisily svy, subpop(if danger_sign==0): tab receive_antibiotic ras, col obs count per pearson	  // Received antibiotic outside home BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab receive_antibiotic ras, col obs count per pearson	  // Received antibiotic outside home POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab referred  ras, col obs count per pearson	          // Referred to another facility BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab referred  ras, col obs count per pearson	          // Referred to another facility POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab ref_adhere ras, col obs count per pearson	          // Followed referral advice (if referred to other facility BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab ref_adhere  ras, col obs count per pearson	          // Followed referral advice (if referred to other facility POST-RAS

* Reasons for not following referral advice (if referred to another facility)
capture noisily svy, subpop(if danger_sign==0): tab  noadhere_money ras, col obs count per pearson	       // No money BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab  noadhere_money  ras, col obs count per pearson	       // No money POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab  noadhere_distance ras, col obs count per pearson	   // Too far away BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab  noadhere_distance ras, col obs count per pearson	   // Too far away POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab  noadhere_transport ras, col obs count per pearson	   // No available transport BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab  noadhere_transport ras, col obs count per pearson	   // No available transport POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab  noadhere_duties ras, col obs count per pearson	       // Domestic duties BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab  noadhere_duties ras, col obs count per pearson	       // Domestic duties POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab  noadhere_notsevere ras, col obs count per pearson	   // Child's condition was not severe/no priority BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab  noadhere_notsevere ras, col obs count per pearson	   // Child's condition was not severe/no priority POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab  noadhere_improving  ras, col obs count per pearson	   // Child's condition was improving/no follow-up treatment needed BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab  noadhere_improving  ras, col obs count per pearson    // Child's condition was improving/no follow-up treatment needed POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab  noadhere_noagree  ras, col obs count per pearson	   // I did not agree with advice BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab  noadhere_noagree  ras, col obs count per pearson      // I did not agree with advice POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab  noadhere_notrust ras, col obs count per pearson	   // I did not trust the provider who gave the advice BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab  noadhere_notrust ras, col obs count per pearson       // I did not trust the provider who gave the advice POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab  noadhere_nohelp ras, col obs count per pearson	       // Suggested provider will not be able to help my child BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab  noadhere_nohelp ras, col obs count per pearson        // Suggested provider will not be able to help my child POST-RAS
capture noisily svy, subpop(if danger_sign==0): tab  noadhere_other ras, col obs count per pearson	       // Ohter BASELINE
capture noisily svy, subpop(if danger_sign!=0): tab  noadhere_other ras, col obs count per pearson         // Ohter POST-RAS

tab q72oth1		// Please check if any other response fits into one of the categories above
tab q72oth2		// Please check if any other response fits into one of the categories above
tab q72oth3		// Please check if any other response fits into one of the categories above


** Additional indicators: Treatment seeking
// q67*, q68*, q71*
*log close
