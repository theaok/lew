clear
mkdir C:\Users\ldb92\Desktop\Stata
cd C:\Users\ldb92\Desktop\Stata
set matsize 200
version 15

/* 			 Happy Halloween!
      ^^         |         ^^
          ::         |         ::
   ^^     ::         |         ::     ^^
   ::     ::         |         ::     ::
    ::     ::        |        ::     ::
      ::    ::       |       ::    ::
        ::    ::   _/~\_   ::    ::
          ::   :::/     \:::   ::
            :::::(       ):::::
                  \ ___ /
             :::::/`   `\:::::
           ::    ::\o o/::    ::
         ::     ::  :":  ::     ::
       ::      ::   ` `   ::      ::
      ::      ::           ::      ::	Ascii Art Credit:
     ::      ::             ::      ::  R. Nykvist (Chuckles)
     ^^      ::             ::      ^^  From: http://www.chris.com/ascii/index.php?art=animals/spiders
             ::             ::
             ^^             ^^

Rather than use my farm data this week, I'm using data from an internship
I have with the Center for Environmental Transformation here in Camden.
The nonprofit just completed post-surveys of its youth from the program. Someone else
input the pre-surveys back at the beginning of the summer, and I copied their formatting
for the post surveys. I plan to merge the pre and post surveys for analysis.			 
*/
//awesome




///////////////////////////////////////////////////////////
/*-------- Step 1: Formatting Data for Merges ---------- */
///////////////////////////////////////////////////////////

//File number 1: Basic Survey Pre-test

import excel https://sites.google.com/site/bivonastatadatasets/data-management/CFET%20Basic%20Survey%202017%20-%20Pre.xlsx, first clear
//browse
drop if length(Name)<1 //awesome! this is bullet proof! like it much better than in range

/* used these to be able to install renvars
sysdir set PERSONAL C:\Users\ldb92\Desktop\Stata\Personal
sysdir set PLUS C:\Users\ldb92\Desktop\Stata\Plus

help renvars 
//- then installed it //good! can install with a command 
//help net, but this is absolutely fine
*/

renvars Name-Nutrition \ name cook garden plantid vegid talkcust money dealissues pubspeak ///
newpeople oppress racism stereo fact foodsys indag farm urbfarm organic chemfree ///
enviro jobaccess desert foodaccess foodjust envirojust socialjust camdenhist privilege carbon conflict ///
istate nutrition
//cool--note stata's smart--the above command may be ndangerous--it may be easy to
//make a mistake and rename wrongly; but once you did it; it actually saves
//old names as labels so all you have to do is simply to describe
//and then qucikly scan and see if your corrent names correspond to old ones
//(now as labels):
d


/* also installed "missings" commands
help dropmiss

missings dropvars drops any variables for which ALL obs are missing. Option force is required.
*/

missings dropvars, force //cool!

sort name

gen id= _n
order id, first

//now if you see sth like this, you know right away that this is bad bad bad!
//use loop!!!!! 
/*renvars name-nutrition \ PREname PREcook PREgarden PREplantid PREvegid PREtalkcust PREmoney PREdealissues PREpubspeak ///
PREnewpeople PREoppress PREracism PREstereo PREfact PREfoodsys PREindag PREfarm PREurbfarm PREorganic PREchemfree ///
PREenviro PREjobaccess PREdesert PREfoodaccess PREfoodjust PREenvirojust PREsocialjust PREcamdenhist PREprivilege PREcarbon PREconflict ///
PREistate PREnutrition
*/
// changed mind on naming vars, want to make sure difference remain after merge

//or:
ren * PRE*

save BasicSurv2017_PRE.dta, replace //i like your descriptive name! biut always add replace
//otherwhise it breaks on send run!!!

//---------------------------------------------------------------------------
//File number 2: Basic Survey Post-test

import excel https://sites.google.com/site/bivonastatadatasets/data-management/CFET%20Basic%20Survey%202017%20-%20Post.xlsx, first clear
browse
missings dropvars, force
missings dropobs, force

renvars Name-Nutrition \ POSTname POSTcook POSTgarden POSTplantid POSTvegid POSTtalkcust ///
POSTmoney POSTdealissues POSTpubspeak POSTnewpeople POSToppress POSTracism POSTstereo ///
POSTfact POSTfoodsys POSTindag POSTfarm POSTurbfarm POSTorganic POSTchemfree ///
POSTenviro POSTjobaccess POSTdesert POSTfoodaccess POSTfoodjust POSTenvirojust ///
POSTsocialjust POSTcamdenhist POSTprivilege POSTcarbon POSTconflict POSTistate POSTnutrition

sort POSTname
gen id = _n
order id, first

save BasicSurv2017_POST.dta

//-----------------------------------------------------------------------------
//File number 3: Food Corps Survey Pre-test

import excel https://sites.google.com/site/bivonastatadatasets/data-management/CFET%20Food%20Corps%20Survey%202017%20-%20Pre.xlsx, first clear
missings dropvars, force
missings dropobs, force

renvars Name-CollardGreens \ PREname PRElett PREcarrot PREzucch PREspinach PREradish ///
PREcauli PREpeas PREbellpep PREtom PREgrbean PREkale PREbeet PREbok PREswpot PREbroc ///
PREcuke PREchard PREcollard

sort PREname
gen id = _n
order id, first

destring PREtom-PREcollar, replace ignore("?")

save FoodCorpsSurv2017_PRE.dta, replace

//-----------------------------------------------------------------------------
//File number 4: Food Corps Survey Post-test

import excel https://sites.google.com/site/bivonastatadatasets/data-management/CFET%20Food%20Corps%20Survey%202017%20-%20Post.xlsx,first clear 
missings dropvars, force
missings dropobs, force

renvars Name-CollardGreens \ POSTname POSTlett POSTcarrot POSTzucch POSTspinach POSTradish ///
POSTcauli POSTpeas POSTbellpep POSTtom POSTgrbean POSTkale POSTbeet POSTbok POSTswpot POSTbroc ///
POSTcuke POSTchard POSTcollard

sort POSTname
gen id = _n
order id, first

destring POSTlett-POSTcollard, replace

save FoodCorpsSurv2017_POST.dta, replace

//-----------------------------------------------------------------------------
//File number 5: Food Bank Survey Pre-test
import excel https://sites.google.com/site/bivonastatadatasets/data-management/Food%20Bank%20Survey%202017%20-%20Pre.xlsx,first clear
missings dropvars, force

renvars Name- Iknowhowtouseaunitpricet \ PREname PREmyplate PREfoodgroup PREgrain ///
PREnutlabel PRErecipe PREextrafood PREunitprice

sort PREname
gen id = _n
order id, first

save FoodBankSurv2017_PRE.dta

//-----------------------------------------------------------------------------
//File number 6: Food Bank Survey Post-test

//also note: you have a ton of files!
//maybe better download them as zipped file once, unzip it and then load?
//would be easier and faster :)
// https://blog.stata.com/2010/12/01/automating-web-downloads-and-file-unzipping/ 

import excel https://sites.google.com/site/bivonastatadatasets/data-management/Food%20Bank%20Survey%202017%20-%20Post.xlsx,first clear
missings dropvars, force
missings dropobs, force

renvars Name- Iknowhowtouseaunitpricet \ POSTname POSTmyplate POSTfoodgroup POSTgrain ///
POSTnutlabel POSTrecipe POSTextrafood POSTunitprice

sort POSTname
gen id = _n
order id, first

save FoodBankSurv2017_POST.dta

//------------------------------------------------------------------------------
//File number 7: 2017 Market Sales Data

import excel https://sites.google.com/site/bivonastatadatasets/data-management/CFET%20Summer%202017%20Market%20Sales.xlsx,first clear

renvars Date-ProductsLeftover \ date team sales donation prodsold leftovers

gen teamid =.
replace teamid=1 if team=="Rickea's Team"
replace teamid=2 if team=="Dimitrius's Team"
replace teamid=3 if team=="Cheyanne's Team"

order teamid team, before(date)
sort teamid

save MarketSales2017.dta






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
save MergedBasicSurvey2017.dta

use FoodCorpsSurv2017_PRE, clear
merge 1:1 id using FoodCorpsSurv2017_POST.dta
save MergedFoodCorpsSurvey2017.dta

use FoodBankSurv2017_PRE, clear
merge 1:1 id using FoodBankSurv2017_POST.dta
save MergedFoodBankSurvey2017.dta


///////////////////////////////////////////////////////////////////////////////
//Matching together the simple merged data sets

use MergedBasicSurvey2017, clear
merge 1:1 id using MergedFoodCorpsSurvey2017, gen(FC_Basic_Merge)
save FoodCorps_Basic_Merged2017

use FoodCorps_Basic_Merged2017, clear
merge 1:1 id using MergedFoodBankSurvey2017, gen(FB_FC_Basic_Merge)
save FB_FC_Basic_Merged2017


///////////////////////////////////////////////////////////////////////////////
// Performing the m:1 merge and Reshaping//////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

use MarketSales2017.dta, clear
reshape wide sales donation prodsold leftovers, i(teamid) j(date)
save MarketSales2017_RESHAPED.dta

use FB_FC_Basic_Merged2017, clear
gen teamid=.
order teamid, first

//easier to get confused with number than names so maybe better sth like this, plus
//using inlist is more compact
//gen team=""
//replace team="Rickea's Team" if inlist(name,"Joe","Bob", "Amy")


replace teamid=1 if id==1|id==6|id==8|id==11
replace teamid=2 if id==2|id==3|id==5|id==10
replace teamid=3 if missing(teamid)
/*The team members aren't picked in any logical order, so I couldn't think of a
more clever way of doing this... let me know if I missed something I could've done.*/

merge m:1 teamid using MarketSales2017_RESHAPED, gen(Markets_Merge)

save MasterMerge_CFETData2017.dta



//and then looping!
//maybe some graphs, desctiptive stats etc etc


