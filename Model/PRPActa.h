//
//  PRPActa.h
//  CF
//
//  Created by pau on 18/02/14.
//  Copyright (c) 2014 Pau Ruiz Perez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PRPActaEquipo.h"
#import "PRPActaResultado.h"

@interface PRPActa : NSObject
@property (strong, nonatomic) NSString *nombreCompeticion;
@property (strong, nonatomic) NSString *codigoCompeticion;
@property (strong, nonatomic) NSString *nombreGrupo;
@property (strong, nonatomic) NSString *codigoGrupo;
@property (strong, nonatomic) NSString *ciudad;
@property (strong, nonatomic) NSString *jornada;
@property (strong, nonatomic) NSString *fecha;
@property (strong, nonatomic) NSString *hora;
@property (strong, nonatomic) NSString *desfibrilador;
@property (strong, nonatomic) PRPActaResultado *resultado;
@property (strong, nonatomic) NSArray *arbitros;
@property (strong, nonatomic) NSString *campoJuego;
@property (strong, nonatomic) PRPActaEquipo *equipoLocal;
@property (strong, nonatomic) PRPActaEquipo *equipoVisitante;
@end
