//
//  PRPClasificacion.h
//  CF
//
//  Created by pau on 13/02/14.
//  Copyright (c) 2014 Pau Ruiz Perez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRPClasificacion : NSObject
@property (strong, nonatomic) NSString * urlImg;        // url_img
@property (strong, nonatomic) NSString * posicion;      // Posicion
@property (assign, nonatomic) NSUInteger codEquipo;    // CodEquipo
@property (strong, nonatomic) NSString * nombre;        // Nombre
@property (assign, nonatomic) NSUInteger jugados;      // Jugados
@property (assign, nonatomic) NSUInteger ganados;      // Ganados
@property (assign, nonatomic) NSUInteger perdidos;     // Perdidos
@property (assign, nonatomic) NSUInteger empatados;    // Empatados
@property (assign, nonatomic) NSUInteger golesAFavor;  // GolesAFavor
@property (assign, nonatomic) NSUInteger golesEnContra;// GolesEnContra
@property (assign, nonatomic) NSUInteger puntos;       // Puntos
@property (assign, nonatomic) NSUInteger puntosSancion;// PuntosSaction
@end
