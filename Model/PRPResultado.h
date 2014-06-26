//
//  PRPResult.h
//  CF
//
//  Created by pau on 14/02/14.
//  Copyright (c) 2014 Pau Ruiz Perez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRPResultado : NSObject
@property (assign, nonatomic) NSUInteger resultadoId;      // id
@property (assign, nonatomic) NSUInteger codigoGrupo;      // codigo_grupo
@property (assign, nonatomic) NSUInteger jornadaNumero;    // jornada_numero
@property (strong, nonatomic) NSDate *   jornadaFecha;     // jornada_fecha
@property (assign, nonatomic) NSUInteger codigoActa;       // codigo_acta
@property (assign, nonatomic) BOOL       actaCerrada;      // acta_cerrada
@property (strong, nonatomic) NSString * fechaPartido;     // fecha_partido  "2014-02-16"
@property (strong, nonatomic) NSString * horaPartido;      // hora_partido   "12:00:00"
@property (strong, nonatomic) NSString * campo;            //
@property (assign, nonatomic) NSUInteger estado;           // "0"
@property (assign, nonatomic) BOOL resultadoProvisional;    // resultado_provisional "0"
@property (assign, nonatomic) NSUInteger equipoLocalCodigo;       // equipo_local_codigo   "33915"
@property (strong, nonatomic) NSString * equipoLocalNombre;       // equipo_local_nombre
@property (strong, nonatomic) NSString * equipoLocalRetirado;     // equipo_local_retirado "0"
@property (assign, nonatomic) NSUInteger equipoLocalGoles;        //  equipo_local_goles   "0"
@property (assign, nonatomic) NSUInteger equipoVisitanteCodigo;  // equipo_visitante_codigo "33439"
@property (strong, nonatomic) NSString * equipoVisitanteNombre;   // equipo_visitante_nombre
@property (strong, nonatomic) NSString * equipoVisitanteRetirado; // equipo_visitante_retirado "0"
@property (assign, nonatomic) NSUInteger equipoVisitanteGoles;    // equipo_visitante_goles    "0"
@property (strong, nonatomic) NSString * arbitro;
@end
