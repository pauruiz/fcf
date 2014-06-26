//
//  PRPAPIRequest.h
//  OhNight
//
//  Created by pau on 28/04/13.
//  Copyright (c) 2013 Ingens Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PRPActa, PRPCompeticion;

#if !defined(__PRPAPIRequest__)
#define __PRPAPIRequest__
typedef NS_ENUM(NSUInteger, PRPAPIRequestType) {
    PRPAPIRequestTypeNone,
    PRPAPIRequestTypeActa,
    PRPAPIRequestTypeClasificacion,
    PRPAPIRequestTypeResultados
};
#endif

#if !defined(__PRPAPIRequestError__)
#define __PRPAPIRequestError__
typedef NS_ENUM(NSUInteger, PRPAPIRequestError) {
    PRPAPIRequestErrorConnection,
    PRPAPIRequestErrorDownloadFailed,
    PRPAPIRequestErrorParse
    //    PRPAPIRequestError
};
#endif

// Required only if calling Acta
@protocol PRPAPIRequestActaDelegate
- (void) apiSetActa:(PRPActa *)acta;
@end

// Required only if calling Resultados
@protocol PRPAPIRequestResultsDelegate
- (void) apiSetResultados:(NSArray *)resultados;
@end

// Required only if calling Clasificacion
@protocol PRPAPIRequestClasificacionDelegate
- (void) apiSetCompeticion:(PRPCompeticion *)competicion; // Solo si se llama a requestClasificacion
@end

@protocol PRPAPIRequestDelegate
- (void) apiRequestError:(PRPAPIRequestError)error forAction:(PRPAPIRequestType)action;
@optional
- (void) apiSetActa:(PRPActa *)acta;
- (void) apiSetCompeticion:(PRPCompeticion *)competicion; // Solo si se llama a requestClasificacion
- (void) apiSetResultados:(NSArray *)resultados;
@end

@interface PRPAPIRequest : NSObject
@property (atomic) BOOL apiRequestPending;

- (void) requestActaWithDelegate:(id<PRPAPIRequestDelegate>)delegate codigoActa:(NSUInteger)acta;
- (void) requestClasificacionWithDelegate:(id<PRPAPIRequestDelegate>)delegate grupo:(NSUInteger)grupo;
- (void) requestResultadosWithDelegate:(id<PRPAPIRequestDelegate>)delegate grupo:(NSUInteger)grupo;
- (void) requestResultadosWithDelegate:(id<PRPAPIRequestDelegate>)delegate grupo:(NSUInteger)grupo jornada:(NSUInteger)jornada;

@end
