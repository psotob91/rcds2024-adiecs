clear all

use "omicron2_mini.dta", clear

gen omicron3 = 0 if omicron2 == 0
replace omicron3 = 1 if omicron2 > 0 & omicron2 < .

gen finicial=.

replace finicial = date("08-05-2022","DMY") if omicron2 != .

format fecha_vacuna_* fecha_variante ultima_fecha_pm finicial %td

drop if edad < 18 | edad >= 100

egen edadcut = cut(edad), at(15 (5) 110)

keep uuid departamento fecha_vacuna_* omicron2 personal_salud sexo edad edadcut quintil omicron3 ultima_fecha_pm finicial infeccion_previa
 
drop if ultima_fecha_pm == . 

save "omicron2_mini2.dta", replace

stset ultima_fecha_pm, failure(omicron3) origin(time finicial)

drop if _t == .

set seed 123

sttocc, match(sexo edadcut personal_salud departamento infeccion_previa) n(5) 

gen date_match = ultima_fecha_pm if _case == 1
format date_match  %td

by _set (_case), sort: replace date_match = date_match[_n+1] if date_match >= . 
by _set (_case), sort: replace date_match = date_match[_n+1] if date_match >= . 
by _set (_case), sort: replace date_match = date_match[_n+1] if date_match >= . 
by _set (_case), sort: replace date_match = date_match[_n+1] if date_match >= . 
by _set (_case), sort: replace date_match = date_match[_n+1] if date_match >= . 

gen dosis1 = 1 if fecha_vacuna_1 < date_match & date_match < .
gen dosis2 = 2 if fecha_vacuna_2 < date_match & date_match < .
gen dosis3 = 3 if fecha_vacuna_3 < date_match & date_match < .
gen dosis4 = 4 if fecha_vacuna_4 < date_match & date_match < .
egen dosis = rowmax(dosis1 dosis2 dosis3 dosis4)
recode dosis (. = 0)
drop dosis1 dosis2 dosis3 dosis4

clogit _case i.dosis, strata(_set) or
xtset _set
xtmlogit omicron2 i.dosis, fe rrr