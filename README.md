fcf
===

REST API to connect to Catalan Footbal Federation

Working at 2014-01.

Requirements
===
RestKit
AFNetworking


How to use
===
requestActaWithDelegate:codigoActa:
Asks the federation for the resume of a match. The delegate must conform to the PRPAPIRequestDelegate and PRPAPIRequestActaDelegate protocols

requestClasificacionWithDelegate:grupo:
Asks the federation WSs for the team classification of a known group. The delegate must conform to the PRPAPIRequestDelegate and PRPAPIRequestClasificationDelegate protocols

requestResultadosWithDelegate:grupo:
requestResultadosWithDelegate:grupo:jornada:
Asks the federation WSs for the results of a week of a known group. The delegate must conform to the PRPAPIRequestDelegate and PRPAPIRequestResultadosDelegate protocols