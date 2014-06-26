//
//  PRPActaEquipo.h
//  CF
//
//  Created by pau on 18/02/14.
//  Copyright (c) 2014 Pau Ruiz Perez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRPActaEquipo : NSObject
@property (strong, nonatomic) NSString *codEquipo;
@property (strong, nonatomic) NSString *urlImg;
@property (strong, nonatomic) NSString *urlImgLocal;
@property (strong, nonatomic) NSString *urlImgVisitante;
@property (strong, nonatomic) NSString *equipo;
@property (strong, nonatomic) NSString *poblacionClub;
@property (strong, nonatomic) NSArray *titulares;
@property (strong, nonatomic) NSArray *suplentes;
@property (strong, nonatomic) NSString *entrenador;
@property (strong, nonatomic) NSArray *sustituciones;
@property (strong, nonatomic) NSArray *amonestaciones;
@property (strong, nonatomic) NSArray *goles;
- (void)setUrlImgLocal:(NSString *)imgLocal;
- (void)setUrlImgVisitante:(NSString *)imgVisitante;
@end
