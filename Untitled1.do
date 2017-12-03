/*Make a new directory if needed
mkdir \ldb92\Desktop\StataFiles_NIFTI
*/
version 14
set matsize 200

//Set NIFTIdir to your directory of choice, set WebURL to the root page
//containing files you'd like to download
loc NIFTIdir "\ldb92\Desktop\StataFiles_NIFTI"
loc WebURL "https://sites.google.com/site/bivonastatadatasets/data-management/"

sysdir set PLUS `NIFTIdir'

//install renvars, if not already installed:
//findit renvars

*******************************************************************************
///////////////////////////////////////////////////////////////////////////////
///////////////////////// Part 1: Preparing Data for Append ///////////////////
///////////////////////////////////////////////////////////////////////////////
*******************************************************************************

//2014/////////////////////////////////////////////////////////////////////////
loc WebURL "https://sites.google.com/site/bivonastatadatasets/data-management/"
import delimited `WebURL'2014%20NIFTI%20Annual%20Survey.csv, bindq(strict) clear 

drop submitteddate firstname lastname phonenumber emailaddress formname ///
creationdate modifieddate completiontime responsehtml responsetext response ///
responseurl resumeemail filelist unprotectedfilelist responseid referrer ipaddress v71


renvars nameoffarmincubator-howwereyoureferredtothissurveyli \ name operate ///
locatn yearsop numacres numplots acrelgplot acresmplot fte pte vols priorexp ///
specpop popserv popservdetails numfarmers numpartic yrlimit maxyears ///
youngestp oldestp female male prodtype incservs otherservs edservs ///
trainservs trainservsdesc barrservs barrservsdesc tracksparts trackhow ///
stillfarm primfarm employfarm fundfed fundfound fundfees fundprods ///
fundindraise fundstateloc funduniv fundother fundotherdesc launchdate ///
challenge niftihelp niftiused rescother referred

drop referred niftihelp 

sort name

egen num_missing = rowmiss(*)
gen perc_missing = round(num_missing/c(k)*100, 0.1)  //awesome idea!
li name perc_missing if perc_missing > 33
order num_missing perc_missing, first
sort perc_missing
/* ultimately, deciding what is an acceptable amount of data missing from an 
observation to still be included in our study is a subjective assessment. In the
2014 data we're working with here, there is a clear gap between those missing
a relative high number of responses (30-40%) and those nearly all responses (80%
or more). It is odd that, of the eight observations missing more than 40% of their
responses, 7 of them are missing exactly 82.4% and the other is missing 84.3%, all
of which answered (or missed) the same questions. There may have been user error,
like some accidental deletion. I've reached out to original data source to see if
there is some possible correction. For now, I drop these upper eight outliers, as the
little data they do retain does not include the variables in which we are most interested,
and because they lack nearly all basic identifying information aside from project name.
*/
drop if perc_missing > 40 //fine but you already flagged it so may keep it
//but doesnt matter--you have the code so can always go back and retain more

sort name
gen id=_n
order id, first

gen year=2014
label var year "Year NIFTI survey was conducted"
order year, first


save 2014NIFTI.dta, replace

//2015///////////////////////////////////////////////////////////////////////
//normally I wouldn't keep pasting the loc WebURL text, but do-files
//annoyingly won't remember local macros
//then do global macros!

loc WebURL "https://sites.google.com/site/bivonastatadatasets/data-management/"
import delimited `WebURL'2015%20NIFTI%20Annual%20Survey.csv, rowr(4:) varn(2) bindq(strict) clear

drop startdate-distributionchann
drop v19-v23

desc using 2014NIFTI.dta, simple

renvars pleasecompletethefollowinginform- isthereanythingelseyouwouldliket \ ///
name org state zipcode yearsop launchdate numacres ownlease acresown /// 
acreslease lessor lessor_other numplots acrelgplot acresmplot numfarmbiz /// 
fte pte vols numpartic priorexp popUSborn poprefugee popimmigrant poplowinc /// 
popcollege popdetails numfarmers yrlimit maxyears youngestp oldestp female /// 
male prodtype prodtype_other  incservs incservs_other trainservs /// 
trainservs_other barrservs barrservs_other tracksparts stillfarm primfarm /// 
employfarm trackhow fundfed fundfound fundfees fundprods fundindraise /// 
fundstateloc funduniv fundearnedrev fundother fundotherdesc topchall_1 /// 
topchall_2 topchall_3 topchall_other challresources region partners leaderrole ///
 techassist techhours techprovider niftiused niftiused_other nifticomm_list /// 
 nifticomm_forum nifticomm_fb nifticomm_call nifticomm_regevent /// 
 nifticomm_natevent nifticomm_webmeet rescother anyelse
//this is dense! could just rename one by one in separate row
//would be easier to read and debug

 drop techprovider nifticomm* 
 
//can put 'TODO' and then just search you file for "TODO"
//other favorite tags are "MAYBE" "LATER" "BUG"
 
 //Make sure to look into this in future files!!!!
 notes: numpartic ask for number of participants from 2014, but for numfarmers /// 
 and numfarmbiz, it asks for numbers in 2015
 
egen num_missing = rowmiss(*)
gen perc_missing = round(num_missing/c(k)*100, 0.1)
li name perc_missing if perc_missing > 33
order num_missing perc_missing, first
sort perc_missing
/* Again, the decision of where to draw the line for legitimate vs. junk observations
is not as clear as I would like. Our cutoff above was observations missing greater than
40% of their values. In our 2015 data, there are 20 such observations. The two with
the lowest percentage missing are at 45.2% and 58.9% respectively. Both observations
contain nearly all basic information and farmer demographic information. Althought
later data may be missing either because entrants decides to stop the survey, or 
perhaps due to data entry error, these should be retained for the basic information they
do provide. Two less complete observations are missing 78.1% each, yet also contain
basic information about their incubators and should be retained. All others are missing
almost all data or, when there is data, it is nonsensical (e.g. strings of 0s across
large numbers of values). These are dropped for our analysis. 
*/
drop if perc_missing > 60 & missing(name)
drop if perc_missing > 78.1 //To remove obs 49, which includes only "Fondy Farm" as org name
 
sort name
gen id=_n
order id, first

gen year=2015
label var year "Year NIFTI survey was conducted"
order year, first
 
save 2015NIFTI.dta, replace
 
 
 //2016///////////////////////////////////////////////////////////////////////
loc WebURL "https://sites.google.com/site/bivonastatadatasets/data-management/"
import delimited `WebURL'2016%20NIFTI%20Annual%20Survey.csv, rowr(4:) varn(2) bindq(strict) clear

drop startdate - distributionchannel
drop v19 - v23
drop d_5_texttopics

desc using 2015NIFTI.dta, simple

renvars pleasecompletethefollowinginform-mayniftipubliclylistthatyourorga \ name org state /// 
zipcode yearsop launchdate numacres ownlease acresown acreslease lessor /// 
lessor_other organic organic_other covercrop numplots acrelgplot acresmplot /// 
numfarmbiz numfarmers  yrlimit maxyears fte pte fundfed fundfound fundfees fundprods /// 
fundindraise fundstateloc funduniv fundearnedrev fundother fundotherdesc /// 
donatedum donatelbs feedself sharebartsold numpartic priorexp popUSborn /// 
poprefugee popimmigrant poplowinc popcollege popother popdetails langdum /// 
langdetail youngestp oldestp female male prodtype prodtype_other incservs /// 
incservs_other1 incservs_other2 trainservs trainservs_other barrservs /// 
barrservs_other tracksparts stillfarm primfarm employfarm trackhow bestrescdum /// 
bestresc_1 bestresc_2 bestresc_3 bestresc_1kind bestresc_1other bestresc_1web /// 
bestresc_2kind bestresc_2other bestresc_2web bestresc_3kind bestresc_3other /// 
bestresc_3web partner_1 partner_2 partner_3 partner_4 partner_5 partner_1type /// 
partner_1other partner_2type partner_2other partner_3type partner_3other /// 
partner_4type partner_4other partner_5type partner_5other relatpartner_1 /// 
relatpartner_2 relatpartner_3 relatpartner_4 relatpartner_5 partnerhours /// 
techassist techhours partnerfund topchall_1 topchall_2 topchall_3 /// 
topchall_other challresources niftiused niftiused_other assistpartners /// 
anyelse publiclisting

drop bestresc* publiclisting 

egen num_missing = rowmiss(*)
gen perc_missing = round(num_missing/c(k)*100, 0.1)
li name perc_missing if perc_missing > 33
order num_missing perc_missing, first //you repeat this again--why not make it into a program, ado?
sort perc_missing
/* As above, the boundary between usable and junk observations is unclear. Considerably
more observations (25) have over 40% of values missing. This may be due to the higher
number of "other" boxes in this year's survey, in which organizations may not add 
information because they do not need to. Organizations missing up to 83% of values
still provided basic information that should be retained in the data, but values with
higher perc_missing answered only a few of the most basic questions (if they even 
included an organization or name) and were therefore dropped.*/
drop if perc_missing > 83

sort name
gen id=_n
order id, first

gen year=2016
label var year "Year NIFTI survey was conducted"
order year, first

save 2016NIFTI.dta, replace

//2017////////////////////////////////////////////////////////////////////////
loc WebURL "https://sites.google.com/site/bivonastatadatasets/data-management/"
import delimited `WebURL'2017%20NIFTI%20Annual%20Survey.csv, rowr(4) varn(2) bindq(strict) clear

drop startdate-distributionchannel
drop v19-v23

desc using 2016NIFTI.dta, simple

renvars pleasecompletethefollowinginform- mayniftipubliclylistthatyourorga \ /// 
name org state zipcode yearsop launchdate numacres ownlease acresown acreslease /// 
lessor lessor_other organic organic_other covercrop numplots acrelgplot /// 
acresmplot numfarmbiz numfarmers yrlimit maxyears fte pte fundfed fundfound /// 
fundfees fundprods fundindraise fundstateloc funduniv fundearnedrev fundother /// 
fundotherdesc donatedum donatelbs feedself sharebartsold numpartic priorexp /// 
popUSborn poprefugee popimmigrant poplowinc popcollege pop2ndcar popveteran /// 
popother popdetails langdum langdetail youngestp oldestp female male prodtype /// 
prodtype_other incservs incservs_other1 incservs_other2 trainservs /// 
trainservs_other barrservs barrservs_other tracksparts stillfarm primfarm /// 
employfarm FSMpilot FSMwilluse trackhow partner_1 partner_2 partner_3 partner_4 /// 
partner_5 partner_1type partner_1other partner_2type partner_2other /// 
partner_3type partner_3other partner_4type partner_4other partner_5type /// 
partner_5other relatpartner_1 relatpartner_2 relatpartner_3 relatpartner_4 /// 
relatpartner_5 partnerhours techassist techhours partnerfund topchall_1 /// 
topchall_2 topchall_3 topchall_other challresources niftiused niftiused_other /// 
listserv niftifee assistpartners anyelse publiclisting

drop listserv publiclisting FSMpilot FSMwilluse niftifee

egen num_missing = rowmiss(*)
gen perc_missing = round(num_missing/c(k)*100, 0.1)
li name perc_missing if perc_missing > 33
order num_missing perc_missing, first
sort perc_missing
/* Similar to the case of the 2016 data, a few observations with up to 84% of values
missing still contained basic incubator information that I believe should be retained
in the data. A couple of values with slightly lower perc_missing values (78.1 and 81.9) were made up
entirely of nonsensical values and were dropped. All obs with greater than 84% values
missing were dropped, as they contained an absolute minimum of information (in 12 cases, they
contained no information at all)
*/
drop if perc_missing > 72 & missing(name)
drop if perc_missing > 84

sort name
gen id=_n
order id, first

gen year=2017
label var year "Year NIFTI survey was conducted"
order year, first

save 2017NIFTI.dta, replace



///////////////////////////////////////////////////////////////////////////////
///////////////////////////APPENDING //////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

//in this chunk looks like lots of repetition. this is ripe for ado!

use 2014NIFTI.dta, clear

forval i=5/7{
	append using 201`i'NIFTI.dta
}

//Getting things organized:
gen BASIC_INFO= "***************************"
lab var BASIC_INFO "**********************************************************"
order BASIC_INFO id name org operate launchdate yearsop locatn state zipcode region /// 
fte pte vols, after(year)

gen LAND_INFO= "***************************"
lab var LAND_INFO "**********************************************************"
order LAND_INFO numacres numplots acrelgplot acresmplot ownlease acresown /// 
acreslease lessor lessor_other, after(vols)

gen INCUBATOR_PRACTICES= "***************************"
lab var INCUBATOR_PRACTICES "**********************************************************"
order INCUBATOR_PRACTICES yrlimit maxyears tracksparts trackhow, after(lessor_other)

gen INCUBATOR_OUTCOMES= "***************************"
lab var INCUBATOR_OUTCOMES "**********************************************************"
order INCUBATOR_OUTCOMES stillfarm primfarm employfarm donatedum donatelbs ///
feedself sharebartsold, after(trackhow)

gen DEMOGRAPHICS = "********************"
lab var DEMOGRAPHICS "**********************************************************"
order DEMOGRAPHICS numfarmbiz numfarmers numpartic priorexp male female specpop /// 
popserv popservdetails oldestp youngestp popUSborn poprefugee popimmigrant /// 
poplowinc popcollege pop2ndcar popveteran popother popdetails, after(sharebartsold)

gen PRODUCTION_PRACTICES = "********************"
lab var PRODUCTION_PRACTICES "**********************************************************"
order PRODUCTION_PRACTICES prodtype prodtype_other organic organic_other /// 
covercrop, after(popdetails)

gen INCUBATOR_SERVICES = "********************"
lab var INCUBATOR_SERVICES "**********************************************************"
order INCUBATOR_SERVICES incservs incservs_other incservs_other1 incservs_other2 /// 
otherservs edservs trainservs trainservsdesc trainservs_other barrservs /// 
barrservsdesc barrservs_other langdum langdetail, after(covercrop)

gen FUNDING = "********************"
lab var FUNDING "**********************************************************"
order FUNDING fundfed fundfound fundfees fundprods fundindraise fundstateloc /// 
funduniv fundearnedrev fundother fundotherdesc, after(langdetail)

gen PARTNERSHIPS = "********************"
lab var PARTNERSHIPS "**********************************************************"
order PARTNERSHIPS partners partner_1 partner_2 partner_3 partner_4 partner_5 /// 
partner_1type partner_1other partner_2type partner_2other partner_3type /// 
partner_3other partner_4type partner_4other partner_5type partner_5other /// 
relatpartner_1 relatpartner_2 relatpartner_3 relatpartner_4 relatpartner_5 /// 
leaderrole techassist techhours partnerhours partnerfund assistpartners, /// 
after(fundotherdesc)

gen CHALLENGES = "********************"
lab var CHALLENGES "**********************************************************"
order CHALLENGES challenge topchall_1 topchall_2 topchall_3 topchall_other /// 
challresources, after(assistpartners)

gen RESOURCES_USED = "********************"
lab var RESOURCES_USED "**********************************************************"
order RESOURCES_USED niftiused niftiused_other rescother anyelse, after(challresources)

rename id yearid
sort year name
gen masterid = _n
order masterid, before(year)

/*
What needs to be fixed:

BASIC_INFO
name: make them match between years, 
check for and resolve duplicates
org: fill in org names for 2014 based on other years
X operate: droppy (only in 2014 and redundant given yearsop)
X launchdate: droppy (is about expected launchdate, and also redundant given yearsop)
X yearsop: make ordinal
locatn: pull out states and add them to 'state', rename town, fill in other years with zip info
state: simplify into two letter codes
zipcode: fix so that all are 5-digit zips, have to merge in some data to make zips match as towns
X region: droppy (only recorded for 2015, and could easily be improved through grouping state var later)
fte: destring
pte: destring
X vols: droppy (only recorded for 2014-5, and counts inconsistent between 
*/

drop operate launchdate region vols


replace yearsop = "0-1 years" if yearsop == "0 - 1 years"
replace yearsop = "2-3 years" if yearsop == "2 - 3 years"
replace yearsop = "3-4 years" if yearsop == "3 - 4 years"  //there are string functions 
//that would trim it automatically!
replace yearsop = "*Pre-Launch" if yearsop == "Pre-Launch"
encode yearsop, generate(yearsop_ord)
drop yearsop
rename yearsop_ord yearsop
order yearsop, after(org)

replace state = regexs(0) if (regexm(locatn, ", [a-zA-Z]+")) //not pulling what I want it to

sort fte

sort pte

//findit statastates, then install statastates



/*
LAND_INFO
numacres: destring
numplots: destring
acrelgplot: destring
acresmplot: destring
ownlease: make dummies for own, lease, and both
acresown: droppy (almost no responses)
acreslease: droppy (almost no responses)
lessor: droppy (not of interest)
lessor_other: droppy
*/

sort numacres

/*
INCUBATOR_PRACTICES
yrlimit: dummy
maxyears: destring
tracksparts: dummy
trackhow: keep

INCUBATOR_OUTCOMES
stillfarm: destring
primfarm: destring
employfarm: destring
donatedum: dummy
donatelbs: destring
feedself: destring/keep
sharebartsold: destring/keep

DEMOGRAPHICS
numfarmbiz: destring
numfarmers: destring
numpartic: destring
priorexp: dummies for yes, no, and mixed
male and female: destring
specpop: droppy (only 2014, and unnecessary given other populations
popserv: divide up along other "pop" fields
popservdetails: fold into 'popdetails', then droppy
oldestp: destring
youngestp: destring
pop*: destring
popdetails: see 'popservdetails'

PRODUCTION_PRACTICES
prodtype: extract out unique values, make dummies for each
prodtype_other: keep
organic: make dummies for yes, no, and other
organic_other: keep
covercrop: destring

INCUBATOR_SERVICES
incservs: figure out unique identities and make dummies for each
incservs_other: copy incservs_other1 and 2, and otherservs, into this, then drop other ones
edservs: droppy (collected for 2014 only, and redundant given trainservs)
trainservs: identity unique values, make dummies for each
trainservsdesc: fold into trainservs_other
trainservs_other: keep
barrservs: figure out unique identities and make dummies for each
barrservsdesc: fold into barrservs_other
barrservs_other: keep
langdum: dummies for yes, no, unsure
langdetail: keep
*/

local i = 1
while `i' < 500{ 
replace barrservs = regexr(barrservs, "etc.", "etc")
loc i=`i'+1
}

local i = 1
while `i' < 4{ 
replace barrservs = regexr(barrservs, ", [A-Z]", ",O")
loc i=`i'+1
}
// This block of code addresses an annoying inconsistency in "Other services" value
// within barrservs. Has to be done before the following loop
local i = 1
while `i' < 7{ 
replace barrservs = regexr(barrservs, ", ", "|")
loc i=`i'+1
}
// This block of code removes commas internal to responses, making it possible
// to split the variable on commas as we'd like


preserve
keep masterid-name barrservs
split barrservs, p(",") 
drop barrservs
reshape long barrservs, i(masterid) string
levelsof barrservs, local(barrlevs)
restore
// this block reshapes all the new barrservs* vars into one long variable, so we can
// pull out the unique values and form variables from them

`"Helping participants to learn how to find their own farmland"' 
`"Ongoing Marketing Support"' 
`"Ongoing Technical Assistance"' `"Other"' 
> `"Other services"' `"Participating in programs that link new farmers
>  with farmland"' `"Providing access to equipment (tractors|tools|etc
> .)"' `"Providing access to infrastructure (irrigation|greenhouses|et
> c)"' `"Providing access to infrastructure (irrigation|greenhouses|et
> c.)"' `"Providing start-up loans to participants"' `"Support to acce
> ss to capital including grants|loans and other financing"'


foreach bar in `barrlevs'{
	loc i = `i' + 1
	gen byte barr_`i' = strpos(barrservs, "`bar'") > 0
	rename barr_`i' 
}
/*
FUNDING
fund*: destring, make dummies for each that are yes/no, and then another set of dummies for majorityfunding

PARTNERSHIPS
partners: if enough time, CODE by org types, put into dummies, then drop
partner_#: drop, the particular relationships aren't of much interest
partner_#type: turn into dummies for different org types
partner_#other: droppy (not helpful)
leaderrole: droppy (only for 2015, and not helpful)
techassist: dummy
techhours: destring
partnerhours: destring
partnerfund: dummies for yes, no, unsure
assistpartners: too diverse of suggestion, not much for quantiative comparison

CHALLENGES
challenge: needs to be CODED
topchall_*: need to be CODED
challresources: needs to be CODED

RESOURCES_USED
niftiused: need to sort out unique values, make dummies for each

*/



//awesome, this is what i am talking aboout!
////////////TRYING TO WORK ON AN ADO FILE HERE////////////////////////////////
cap program drop grouptheme
program define grouptheme, rclass
version 14
syntax newvar varlist, varname
gen `newvar' = "********************"
lab var `newvar' "******************************"
order `newvar' `varlist', after(varname)
end


