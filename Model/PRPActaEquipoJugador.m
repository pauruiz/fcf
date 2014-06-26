//
//  PRPActaJugador.m
//  CF
//
//  Created by pau on 18/02/14.
//  Copyright (c) 2014 Pau Ruiz Perez. All rights reserved.
//

#import "PRPActaEquipoJugador.h"

@implementation PRPActaEquipoJugador
- (BOOL) portero{
    return [self.porteroString isEqualToString:@"Si"];
}
- (BOOL) capitan{
    return [self.capitanString isEqualToString:@"Si"];
}
@end
