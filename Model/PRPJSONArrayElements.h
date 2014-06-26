//
//  PRPJSONArray.h
//  CF
//
//  Created by pau on 14/02/14.
//  Copyright (c) 2014 Pau Ruiz Perez. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PRPAPIRequestError;

@interface PRPJSONArrayElements : NSObject
@property (strong, nonatomic) NSArray *errors;
@property (strong, nonatomic) NSArray *resultados;
@end
