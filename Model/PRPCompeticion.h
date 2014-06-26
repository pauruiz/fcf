//
//  PRPCompeticion.h
//  CF
//
//  Created by pau on 13/02/14.
//  Copyright (c) 2014 Pau Ruiz Perez. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PRPGrupo;

@interface PRPCompeticion : NSObject
@property (strong, nonatomic) NSString *nombre;
@property (strong, nonatomic) NSString *codigo;
@property (strong, nonatomic) PRPGrupo *grupo;
@end
