clear
mkdir C:\Users\ldb92\Desktop\Stata
cd C:\Users\ldb92\Desktop\Stata
set matsize 200
version 15

local WebURL "https://sites.google.com/site/bivonastatadatasets/data-management/"
local PS3Path C:\Users\ldb92\Desktop\Stata


/*
         .----------------------------------------------------------.
         |                 "Eat the other White Meat"                |
         |                __ __  ___  _____ _____ _  _               |
         |                ||=|| ||=|| ||_// ||_// \\//               |
         |                || || || || ||    ||     //                |
         |____ __ __  ___  __ __ __ __ __ ___  __ __ __ __ __ __ ___ |
         | ||  ||=|| ||=|| ||\|| ||<< (( (( __ || \\ // || ||\||(( __|
         | ||  || || || || || \| || \\_)) \\|| ||  \V/  || || \| \\|||
         |                                                           |
         '._________________________________________________________.'
            ,      \            .-""-._  | |
            |'.    |\   ;.     /   _ .-\ | |
      _     |  '.  | \  | '    |  ( o_O || |
      \'-._ ;    \ |  ; '  \   \  `-/ `\/| |
       \   'f     '|  '\|   ; /.`.__'  L | |
        \    `\    ;    Y   |/ |  / | />)| |
   _     ;     l   '     ;  |  | / /|/(< | |
  `\'`'-._\     \   ;    |  ' .'/ |    )|| |
    \     '-\    \   \  '__'_.-'  L   (_/| |
     `.      `.   `._.-'"'``       '.   _| |
,.-'"-.'.      `. ,"`                \"` |/`\
 '.      `'-._   7             "-._   \  |\_ |
   `'-.__     '-'    ;             `-..|_|_|~
   __,-'"'--.._'      \                     \
._'           /        \                , _.`
   '"'--;-''"<          `|\             _\ |
   _.-'`   _;|             `"-.,___\--'' | |
  `'-.,__..'  \                          | |
        .'   .'.                         | |
       /..-'`   \                      _/| |
          /    .'7_                 _,'  | |
         ;   ./   ;`'-,,_    ___.,-'"`mx | |
         |_.';   /  |  \ \  | |  |       | |
             |.-';  ;  '  ~~   ~~        | |
                  \' \/   ||   ||        | |
                          ||  _||__      | |
                      _.-" '`"--.._'-._  | |
                     r"-.,-''""---.\"-.\ |_| 




Rather than use my farm data this week, I'm using data from an internship
I have with the Center for Environmental Transformation here in Camden.
The nonprofit just completed post-surveys of its youth from the program. Someone else
input the pre-surveys back at the beginning of the summer, and I copied their formatting
for the post surveys. I plan to merge the pre and post surveys for analysis.			 
*/





///////////////////////////////////////////////////////////
/*-------- Step 1: Formatting Data for Merges ---------- */
///////////////////////////////////////////////////////////

//File number 1: Basic Survey Pre-test

import excel `WebURL'CFET%20Basic%20Survey%202017%20-%20Pre.xlsx, first clear
browse
drop if length(Name)<1

/* used these to be able to install renvars
sysdir set PERSONAL C:\Users\ldb92\Desktop\Stata\Personal
sysdir set PLUS C:\Users\ldb92\Desktop\Stata\Plus

help renvars 
//- then installed it
*/

renvars Name-Nutrition \ name cook garden plantid vegid talkcust money dealissues pubspeak ///
newpeople oppress racism stereo fact foodsys indag farm urbfarm organic chemfree ///
enviro jobaccess desert foodaccess foodjust envirojust socialjust camdenhist privilege carbon conflict ///
istate nutrition

/* also installed "missings" commands
help dropmiss

missings dropvars drops any variables for which ALL obs are missing. Option force is required.
*/

missings dropvars, force

sort name

gen id= _n
order id, first

foreach v of varlist *{
	rename `v' PRE`v'
	}

renvars name-nutrition \ PREname PREcook PREgarden PREplantid PREvegid PREtalkcust PREmoney PREdealissues PREpubspeak ///
PREnewpeople PREoppress PREracism PREstereo PREfact PREfoodsys PREindag PREfarm PREurbfarm PREorganic PREchemfree ///
PREenviro PREjobaccess PREdesert PREfoodaccess PREfoodjust PREenvirojust PREsocialjust PREcamdenhist PREprivilege PREcarbon PREconflict ///
PREistate PREnutrition
// changed mind on naming vars, want to make sure difference remain after merge

save BasicSurv2017_PRE.dta, replace

//---------------------------------------------------------------------------
//File number 2: Basic Survey Post-test

import excel `WebURL'CFET%20Basic%20Survey%202017%20-%20Post.xlsx, first clear
browse
missings dropvars, force
missings dropobs, force

foreach v of varlist *{
	rename `v' POST`v'
	}
sort POSTname
gen id = _n
order id, first

save BasicSurv2017_POST.dta, replace

//-----------------------------------------------------------------------------
//File number 3: Food Corps Survey Pre-test

import excel `WebURL'CFET%20Food%20Corps%20Survey%202017%20-%20Pre.xlsx, first clear
missings dropvars, force
missings dropobs, force

foreach v of varlist *{
	rename `v' PRE`v'
	}

sort PREname
gen id = _n
order id, first

destring PREtom-PREcollar, replace ignore("?")

save FoodCorpsSurv2017_PRE.dta, replace

//-----------------------------------------------------------------------------
//File number 4: Food Corps Survey Post-test

import excel `WebURL'CFET%20Food%20Corps%20Survey%202017%20-%20Post.xlsx,first clear 
missings dropvars, force
missings dropobs, force

foreach v of varlist *{
	rename `v' POST`v'
	}

sort POSTname
gen id = _n
order id, first

destring POSTlett-POSTcollard, replace

save FoodCorpsSurv2017_POST.dta, replace

//-----------------------------------------------------------------------------
//File number 5: Food Bank Survey Pre-test
import excel `WebURL'Food%20Bank%20Survey%202017%20-%20Pre.xlsx,first clear
missings dropvars, force

renvars Name- Iknowhowtouseaunitpricet \ PREname PREmyplate PREfoodgroup PREgrain ///
PREnutlabel PRErecipe PREextrafood PREunitprice

sort PREname
gen id = _n
order id, first

save FoodBankSurv2017_PRE.dta, replace

//-----------------------------------------------------------------------------
//File number 6: Food Bank Survey Post-test

import excel `WebURL'Food%20Bank%20Survey%202017%20-%20Post.xlsx,first clear
missings dropvars, force
missings dropobs, force

renvars Name- Iknowhowtouseaunitpricet \ POSTname POSTmyplate POSTfoodgroup POSTgrain ///
POSTnutlabel POSTrecipe POSTextrafood POSTunitprice

sort POSTname
gen id = _n
order id, first

save FoodBankSurv2017_POST.dta, replace

//------------------------------------------------------------------------------
//File number 7: 2017 Market Sales Data
local WebURL "https://sites.google.com/site/bivonastatadatasets/data-management/"
import excel `WebURL'CFET%20Summer%202017%20Market%20Sales.xlsx,first clear

renvars Date-ProductsLeftover \ date team sales donation prodsold leftovers

gen teamid =.
foreach id in team{
	if team=="Rickea's Team"{
		replace teamid=1
		}
	else if team=="Dimitrius's Team"{
		replace teamid=2
		}
	else{
		replace teamid=3
		}
}
//For some reason, this keeps producing the result that the only value of 
//"team" var is "Rickea's Team". Why???

replace teamid=1 if team=="Rickea's Team"
replace teamid=2 if team=="Dimitrius's Team"
replace teamid=3 if team=="Cheyanne's Team"

order teamid team, before(date)
sort teamid

save MarketSales2017.dta, replace






///////////////////////////////////////////////////////////
/*----------------- Step 2: Merges --------------------- */
///////////////////////////////////////////////////////////

/* The individual data files should now be ready to merge. Because the data sets
are quite small (we only have 12 youth interns) managing the merges should be
relatively easy*/


///////////////////////////////////////////////////////////////////////////////
//Performing the simple 1:1 merges

use BasicSurv2017_PRE, clear
merge 1:1 id using BasicSurv2017_POST.dta
save MergedBasicSurvey2017.dta, replace

use FoodCorpsSurv2017_PRE, clear
merge 1:1 id using FoodCorpsSurv2017_POST.dta
save MergedFoodCorpsSurvey2017.dta, replace

use FoodBankSurv2017_PRE, clear
merge 1:1 id using FoodBankSurv2017_POST.dta
save MergedFoodBankSurvey2017.dta, replace


///////////////////////////////////////////////////////////////////////////////
//Matching together the simple merged data sets

use MergedBasicSurvey2017, clear
merge 1:1 id using MergedFoodCorpsSurvey2017, gen(FC_Basic_Merge)
save FoodCorps_Basic_Merged2017, replace

use FoodCorps_Basic_Merged2017, clear
merge 1:1 id using MergedFoodBankSurvey2017, gen(FB_FC_Basic_Merge)
save FB_FC_Basic_Merged2017, replace


///////////////////////////////////////////////////////////////////////////////
// Performing the m:1 merge and Reshaping//////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

use MarketSales2017.dta, clear
reshape wide sales donation prodsold leftovers, i(teamid) j(date)
save MarketSales2017_RESHAPED.dta, replace

use FB_FC_Basic_Merged2017, clear
gen teamid=.
order teamid, first

replace teamid=1 if id==1|id==6|id==8|id==11
replace teamid=2 if id==2|id==3|id==5|id==10
replace teamid=3 if missing(teamid)
/*The team members aren't picked in any logical order, so I couldn't think of a
more clever way of doing this... let me know if I missed something I could've done.*/

merge m:1 teamid using MarketSales2017_RESHAPED, gen(Markets_Merge)

save MasterMerge_CFETData2017.dta, replace






