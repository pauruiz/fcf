//
//  PRPGrupo.h
//  CF
//
//  Created by pau on 13/02/14.
//  Copyright (c) 2014 Pau Ruiz Perez. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PRPJornada.h"

@interface PRPGrupo : NSObject
@property (strong, nonatomic) NSString *nombre;
@property (assign, nonatomic) NSUInteger codigo;
@property (strong, nonatomic) PRPJornada *jornada;
@property (weak, nonatomic) NSString *jornadas; // Truco para eliminar la basura del JSON de la Federación, al ser weak, desaparecerá. No lo necesitamos para nada, ya que siempre contendrá "Jornadas"
@end
