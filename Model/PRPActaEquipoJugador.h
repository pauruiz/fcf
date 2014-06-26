//
//  PRPActaEquipoJugador.h
//  CF
//
//  Created by pau on 18/02/14.
//  Copyright (c) 2014 Pau Ruiz Perez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRPActaEquipoJugador : NSObject
@property (strong, nonatomic) NSString *dorsal;
@property (strong, nonatomic) NSString *nombre;
@property (assign, nonatomic, readonly) BOOL portero;
@property (assign, nonatomic, readonly) BOOL capitan;
@property (strong, nonatomic) NSString *porteroString;
@property (strong, nonatomic) NSString *capitanString;
@end
