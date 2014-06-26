//
//  PRPAPIRequest.m
//  OhNight
//
//  Created by pau on 28/04/13.
//  Copyright (c) 2013 Ingens Networks. All rights reserved.
//

#import "PRPAPIRequest.h"
#import <RestKit/RestKit.h>

#import "PRPActa.h"
#import "PRPActaArbitro.h"
#import "PRPActaEquipoAmonestacion.h"
#import "PRPActaEquipoGol.h"
#import "PRPActaEquipoJugador.h"
#import "PRPActaEquipoSustitucion.h"
#import "PRPActaResultado.h"
#import "PRPClasificacion.h"
#import "PRPCompeticion.h"
#import "PRPGrupo.h"
#import "PRPJornada.h"
#import "PRPResultado.h"
#import "PRPResultados.h"
#import "RKObjectMappingOperationDataSource.h"

// No existe cola de peticiones, y el delegado cambia con cada llamada

@interface PRPAPIRequest() <NSURLConnectionDelegate>
@property (nonatomic, strong) NSMutableData   *buffer;
@property (nonatomic, strong) NSURLConnection *connection;
@property (strong, nonatomic) id<PRPAPIRequestDelegate> delegate;
@property (assign, nonatomic) PRPAPIRequestType currentAction;
@end


@implementation PRPAPIRequest
static NSString *const kURLBase = @"http://m.fcf.cat/";
static NSString *const kURLPath = @"data/";

- (id)init{
    if (self = [super init]) {
        _buffer = nil;
        _connection = nil;
        _currentAction = PRPAPIRequestTypeNone;
    }
    return self;
}

#pragma mark - Mappings
+ (RKObjectMapping *) mappingForClass:(NSString *)class{
    RKObjectMapping *returnVal = nil;
    
    /*if([class isEqualToString:@"PRPAPIRequestError"]){
        RKObjectMapping *requestErrorMapping = [RKObjectMapping mappingForClass:[PRPAPIRequestError class]];
        [requestErrorMapping addAttributeMappingsFromDictionary:@{@"error":@"errorNumber", @"error_description":@"errorDescription"}];
        returnVal = requestErrorMapping;
    }else*/
    if([class isEqualToString:@"PRPActa"]){
        RKObjectMapping *requestActaArbitroMapping = [[self class] mappingForClass:@"PRPActaArbitro"];
        RKObjectMapping *requestActaEquipoMapping = [[self class] mappingForClass:@"PRPActaEquipo"];
        RKObjectMapping *requestActaResultadoMapping = [[self class] mappingForClass:@"PRPActaResultado"];
        RKObjectMapping *requestActaMapping = [RKObjectMapping mappingForClass:[PRPActa class]];
        [requestActaMapping addAttributeMappingsFromDictionary:@{ @"NombreCompeticion":@"nombreCompeticion", @"CodigoCompeticion":@"codigoCompeticion", @"NombreGrupo": @"nombreGrupo", @"CodigoGrupo":@"codigoGrupo", @"Ciudad":@"ciudad", @"Jornada": @"jornada", @"Fecha":@"fecha", @"Hora":@"hora", @"Desfibrilador":@"desfibrilador", @"Campo_juego":@"campoJuego", @"Puntos":@"puntos", @"PuntosSancion":@"puntosSancion"}];
        [requestActaMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Arbitros.Arbitro" toKeyPath:@"arbitros" withMapping:requestActaArbitroMapping]];
        [requestActaMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"EquipoLocal" toKeyPath:@"equipoLocal" withMapping:requestActaEquipoMapping]];
        [requestActaMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"EquipoVisitante" toKeyPath:@"equipoVisitante" withMapping:requestActaEquipoMapping]];
        [requestActaMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Resultado" toKeyPath:@"resultado" withMapping:requestActaResultadoMapping]];
        returnVal = requestActaMapping;
    }else if([class isEqualToString:@"PRPActaArbitro"]){
        RKObjectMapping *requestActaArbitroMapping = [RKObjectMapping mappingForClass:[PRPActaArbitro class]];
        [requestActaArbitroMapping addAttributeMappingsFromDictionary:@{@"Nombre":@"nombre", @"Tipo":@"tipo"}];
        returnVal = requestActaArbitroMapping;
    }else if([class isEqualToString:@"PRPActaEquipo"]){
        RKObjectMapping *requestActaEquipoAmonestacionMapping = [[self class] mappingForClass:@"PRPActaEquipoAmonestacion"];
        RKObjectMapping *requestActaEquipoGolMapping = [[self class] mappingForClass:@"PRPActaEquipoGol"];
        RKObjectMapping *requestActaEquipoJugadorMapping = [[self class] mappingForClass:@"PRPActaEquipoJugador"];
        RKObjectMapping *requestActaEquipoSustitucionMapping = [[self class] mappingForClass:@"PRPActaEquipoSustitucion"];
        RKObjectMapping *requestActaEquipoMapping = [RKObjectMapping mappingForClass:[PRPActaEquipo class]];
        [requestActaEquipoMapping addAttributeMappingsFromDictionary:@{@"CodEquipo":@"codEquipo", @"url_img_local":@"urlImgLocal", @"url_img_visitante":@"urlImgVisitante", @"Equipo": @"equipo", @"PoblacionClub":@"poblacionClub", @"Entrenador.Nombre":@"entrenador"}];
        [requestActaEquipoMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Amonestaciones.Amonestacion" toKeyPath:@"amonestaciones" withMapping:requestActaEquipoAmonestacionMapping]];
        [requestActaEquipoMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Goles.Gol" toKeyPath:@"goles" withMapping:requestActaEquipoGolMapping]];
        [requestActaEquipoMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Titulares.Titular" toKeyPath:@"titulares" withMapping:requestActaEquipoJugadorMapping]];
        [requestActaEquipoMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Suplentes.Suplente" toKeyPath:@"suplentes" withMapping:requestActaEquipoJugadorMapping]];
        [requestActaEquipoMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Sustituciones.Sustitucion" toKeyPath:@"sustituciones" withMapping:requestActaEquipoSustitucionMapping]];
        returnVal = requestActaEquipoMapping;
    }else if([class isEqualToString:@"PRPActaEquipoAmonestacion"]){
        RKObjectMapping *requestActaEquipoAmonestacionMapping = [RKObjectMapping mappingForClass:[PRPActaEquipoAmonestacion class]];
        [requestActaEquipoAmonestacionMapping addAttributeMappingsFromDictionary:@{@"Dorsal":@"dorsal", @"Minuto":@"minuto", @"Nombre":@"nombre",@"Tipo":@"tipo"}];
        returnVal = requestActaEquipoAmonestacionMapping;
    }else if([class isEqualToString:@"PRPActaEquipoSustitucion"]){
        RKObjectMapping *requestActaEquipoAmonestacionMapping = [RKObjectMapping mappingForClass:[PRPActaEquipoSustitucion class]];
        [requestActaEquipoAmonestacionMapping addAttributeMappingsFromDictionary:@{@"EntraDorsal":@"entraDorsal", @"EntraNombre":@"entraNombre", @"minuto":@"minuto", @"SaleDorsal":@"saleDorsal",@"SaleNombre":@"saleNombre"}];
        returnVal = requestActaEquipoAmonestacionMapping;
    }else if([class isEqualToString:@"PRPActaEquipoGol"]){
        RKObjectMapping *requestActaGolMapping = [RKObjectMapping mappingForClass:[PRPActaEquipoGol class]];
        [requestActaGolMapping addAttributeMappingsFromDictionary:@{@"Dorsal":@"dorsal", @"Minuto":@"minuto", @"Nombre":@"nombre",@"Tipo":@"tipo"}];
        returnVal = requestActaGolMapping;
    }else if([class isEqualToString:@"PRPActaEquipoJugador"]){
        RKObjectMapping *requestActaEquipoJugador = [RKObjectMapping mappingForClass:[PRPActaEquipoJugador class]];
        [requestActaEquipoJugador addAttributeMappingsFromDictionary:@{@"Dorsal":@"dorsal", @"Nombre":@"nombre", @"Portero":@"porteroString", @"Capitan":@"capitanString"}];
        returnVal = requestActaEquipoJugador;
    }else if([class isEqualToString:@"PRPActaResultado"]){
        RKObjectMapping *requestActaEquipoJugador = [RKObjectMapping mappingForClass:[PRPActaResultado class]];
        [requestActaEquipoJugador addAttributeMappingsFromDictionary:@{@"GolesLocal":@"golesLocal", @"GolesVisitante":@"golesVisitante"}];
        returnVal = requestActaEquipoJugador;
    }else if([class isEqualToString:@"PRPClasificacion"]){
        RKObjectMapping *requestClasificacionMapping = [RKObjectMapping mappingForClass:[PRPClasificacion class]];
        [requestClasificacionMapping addAttributeMappingsFromDictionary:@{@"url_img":@"urlImg", @"Posicion":@"posicion", @"CodEquipo":@"codEquipo", @"Nombre":@"nombre", @"Jugados":@"jugados", @"Ganados": @"ganados", @"Perdidos":@"perdidos", @"Empatados":@"empatados", @"GolesAFavor":@"golesAFavor", @"GolesEnContra":@"golesEnContra", @"Puntos":@"puntos", @"PuntosSancion":@"puntosSancion"}];
        returnVal = requestClasificacionMapping;
    }else if([class isEqualToString:@"PRPCompeticion"]){
        RKObjectMapping *requestGrupoMapping = [self mappingForClass:@"PRPGrupo"];
        RKObjectMapping *requestCompeticionMapping = [RKObjectMapping mappingForClass:[PRPCompeticion class]];
        [requestCompeticionMapping addAttributeMappingsFromDictionary:@{@"Competicion.Nombre":@"nombre", @"Competicion.Codigo":@"codigo"}];
        [requestCompeticionMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Competicion.Grupos.Grupo" toKeyPath:@"grupo" withMapping:requestGrupoMapping]];
        returnVal = requestCompeticionMapping;
    }else if([class isEqualToString:@"PRPGrupo"]){
        RKObjectMapping *requestJornadaMapping = [self mappingForClass:@"PRPJornada"];
        RKObjectMapping *requestGrupoMapping = [RKObjectMapping mappingForClass:[PRPGrupo class]];
        [requestGrupoMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Jornadas.Jornada" toKeyPath:@"jornada" withMapping:requestJornadaMapping]];
        [requestGrupoMapping addAttributeMappingsFromDictionary:@{@"Nombre": @"nombre", @"Codigo":@"codigo"}];
        returnVal = requestGrupoMapping;
    }else if([class isEqualToString:@"PRPResultado"]){
        RKObjectMapping *requestResultadoMapping = [RKObjectMapping mappingForClass:[PRPResultado class]];
        [requestResultadoMapping addAttributeMappingsFromDictionary:@{ @"id":@"resultadoId", @"codigo_grupo": @"codigoGrupo", @"jornada_numero": @"jornadaNumero", @"jornada_fecha":@"jornadaFecha", @"codigo_acta":@"codigoActa", @"acta_cerrada":@"actaCerrada", @"fecha_partido":@"fechaPartido", @"hora_partido":@"horaPartido", @"campo":@"campo", @"estado":@"estado", @"resultado_provisional":@"resultadoProvisional", @"equipo_local_codigo":@"equipoLocalCodigo", @"equipo_local_nombre":@"equipoLocalNombre", @"equipo_local_retirado":@"equipoLocalRetirado", @"equipo_local_goles":@"equipoLocalGoles", @"equipo_visitante_codigo":@"equipoVisitanteCodigo", @"equipo_visitante_nombre":@"equipoVisitanteNombre", @"equipo_visitante_retirado":@"equipoVisitanteRetirado", @"equipo_visitante_goles":@"equipoVisitanteGoles", @"arbitro":@"arbitro"}];
        returnVal = requestResultadoMapping;
    }else if([class isEqualToString:@"PRPResultados"]){
        RKObjectMapping *requestResultadosMapping = [RKObjectMapping mappingForClass:[PRPResultados class]];
        RKObjectMapping *requestResultadoMapping = [self mappingForClass:@"PRPResultado"];
        [requestResultadosMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"resultados" withMapping:requestResultadoMapping]];
        returnVal = requestResultadosMapping;
    }else if([class isEqualToString:@"PRPJornada"]){
        RKObjectMapping *requestClasificacionMapping = [self mappingForClass:@"PRPClasificacion"];
        RKObjectMapping *requestJornadaMapping = [RKObjectMapping mappingForClass:[PRPJornada class]];
        [requestJornadaMapping addAttributeMappingsFromDictionary:@{@"Numero": @"numero"}];
        [requestJornadaMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Clasificacion.Equipo" toKeyPath:@"clasificaciones" withMapping:requestClasificacionMapping]];
        returnVal = requestJornadaMapping;
    }else{
        NSLog(@"Error en PRPApiRequest::mappingForClass: '%@'", class);
    }
    return returnVal;
}

#pragma mark - Request Functions
- (void) requestActaWithDelegate:(id<PRPAPIRequestDelegate>)delegate codigoActa:(NSUInteger)acta{
    self.delegate = delegate;
    self.currentAction = PRPAPIRequestTypeActa;
    
    // create the request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", kURLBase, kURLPath, @"json_acta.php"]]];

    NSData *postData;
    postData = [self encodeDictionary:@{@"codacta":[NSNumber numberWithUnsignedInteger:acta] }];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%ld", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // create the connection
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    // ensure the connection was created
    if (self.connection){
        // initialize the buffer
        self.buffer = [NSMutableData data];
        
        // start the request
        [self.connection start];
    }else{
        [delegate apiRequestError:PRPAPIRequestErrorConnection forAction:PRPAPIRequestTypeActa];
    }
}

- (void) requestClasificacionWithDelegate:(id<PRPAPIRequestDelegate>)delegate grupo:(NSUInteger)grupo{
    self.delegate = delegate;
    self.currentAction = PRPAPIRequestTypeClasificacion;

    // create the request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", kURLBase, kURLPath, @"json_clasificaciones.php"]]];
    
    NSData *postData;
    postData = [self encodeDictionary:@{@"id_grupo":[NSNumber numberWithUnsignedInteger:grupo] }];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%ld", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    // create the connection
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    // ensure the connection was created
    if (self.connection){
        // initialize the buffer
        self.buffer = [NSMutableData data];
        
        // start the request
        [self.connection start];
    }else{
        [delegate apiRequestError:PRPAPIRequestErrorConnection forAction:PRPAPIRequestTypeResultados];
    }
}

- (void) requestResultadosWithDelegate:(id<PRPAPIRequestDelegate>)delegate grupo:(NSUInteger)grupo{
    [self requestResultadosWithDelegate:delegate grupo:grupo jornada:0];
}

- (void) requestResultadosWithDelegate:(id<PRPAPIRequestDelegate>)delegate grupo:(NSUInteger)grupo jornada:(NSUInteger)jornada{
    self.delegate = delegate;
    self.currentAction = PRPAPIRequestTypeResultados;
    // create the request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", kURLBase, kURLPath, @"json_resultados.php"]]];
    
    NSData *postData;
    if (jornada!=0) {
        postData = [self encodeDictionary:@{@"id_grupo":[NSNumber numberWithUnsignedInteger:grupo], @"jornada":[NSNumber numberWithUnsignedInteger:jornada]}];
    }else{
        postData = [self encodeDictionary:@{@"id_grupo":[NSNumber numberWithUnsignedInteger:grupo] }];
    }
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%ld", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // create the connection
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    // ensure the connection was created
    if (self.connection){
        // initialize the buffer
        self.buffer = [NSMutableData data];
        
        // start the request
        [self.connection start];
    }else{
        [delegate apiRequestError:PRPAPIRequestErrorConnection forAction:PRPAPIRequestTypeResultados];
    }
}

/*- (void) requestKittenWithDelegate:(id<PRPAPIRequestDelegate>)delegate andURL:(NSString *)url{
    // https://dl.dropboxusercontent.com/s/epwb8f207uy5w9n/kittenz-example.in
    
    // create the request
    self.delegate = delegate;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // create the connection
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    // ensure the connection was created
    if (self.connection){
        // initialize the buffer
        self.buffer = [NSMutableData data];
        
        // start the request
        [self.connection start];
    }else{
        [delegate requestError:@"Conection failed"];
    }
}*/

- (NSData*)encodeDictionary:(NSDictionary*)dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSString *value = [NSString stringWithFormat:@"%@", [dictionary objectForKey:key]];
        NSString *encodedValue = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self.delegate apiRequestError:PRPAPIRequestErrorDownloadFailed forAction:self.currentAction];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    /* reset the buffer length each time this is called */
    [self.buffer setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    /* Append data to the buffer */
    [self.buffer appendData:data];
}

- (void) checkParsedObject:(id)object forArrayName:(NSString *)array withField:(NSString *)field{
    if ([[object valueForKey:array] count] == 1 && ([[[object valueForKey:array] objectAtIndex:0] valueForKey:field]==nil)) {
        [object setValue:@[] forKey:array];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    /* dispatch off the main queue for json processing */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString* MIMEType = @"application/json";
        NSError* parseError;
        
        //NSString *comentar = [[NSString alloc] initWithData:self.buffer encoding:NSUTF8StringEncoding];
        
        id parsedData = [RKMIMETypeSerialization objectFromData:self.buffer MIMEType:MIMEType error:&parseError];
        if (parsedData == nil && parseError) {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               // Some code
                               [self.delegate apiRequestError:PRPAPIRequestErrorParse forAction:self.currentAction];
                           });
            NSLog(@"Cannot parse data: %@", parseError);
        }else{
            switch (self.currentAction) {
                case PRPAPIRequestTypeActa:
                {
                    RKObjectMapping *inputMapping = [[self class] mappingForClass:@"PRPActa"];
                    PRPActa *acta = [PRPActa new];
                    RKMappingOperation* mapper = [[RKMappingOperation alloc] initWithSourceObject:parsedData destinationObject:acta mapping:inputMapping];
                    RKObjectMappingOperationDataSource *mappingDS = [RKObjectMappingOperationDataSource new];
                    /*if ([acta.equipoLocal.amonestaciones count] == 1 && (((PRPActaEquipoAmonestacion *)[acta.equipoLocal.amonestaciones objectAtIndex:0]).dorsal == nil)) {
                     acta.eqquipoLocal.amonestaciones
                     }*/
                    mapper.dataSource = mappingDS;
                    [mapper performMapping:&parseError];
                    if(parseError == nil){
                        dispatch_async(dispatch_get_main_queue(),
                                       ^{
                                           // Some code
                                           [self checkParsedObject:acta.equipoLocal forArrayName:@"amonestaciones" withField:@"dorsal"];
                                           [self checkParsedObject:acta.equipoVisitante forArrayName:@"amonestaciones" withField:@"dorsal"];
                                           [self checkParsedObject:acta.equipoLocal forArrayName:@"goles" withField:@"dorsal"];
                                           [self checkParsedObject:acta.equipoVisitante forArrayName:@"goles" withField:@"dorsal"];
                                           [self.delegate apiSetActa:acta];
                                       });
                    }else{
                        NSLog(@"Parse error: %@", parseError);
                    }
                    break;
                }
                case PRPAPIRequestTypeClasificacion:
                {
                    RKObjectMapping *mappingCompeticion = [[self class] mappingForClass:@"PRPCompeticion"];
                    PRPCompeticion *competicion = [PRPCompeticion new];
                    RKMappingOperation *mapper = [[RKMappingOperation alloc] initWithSourceObject:parsedData destinationObject:competicion mapping:mappingCompeticion];
                    
                    RKObjectMappingOperationDataSource *mappingDS = [RKObjectMappingOperationDataSource new];
                    mapper.dataSource = mappingDS;
                    [mapper performMapping:&parseError];
                    if (parseError == nil) {
                        dispatch_async(dispatch_get_main_queue(),
                                       ^{
                                           // Some code
                                           [self.delegate apiSetCompeticion:competicion];
                                       });
                    }else{
                        NSLog(@"Parse error: %@", parseError);
                    }
                    //competicion.grupo.jornada.numero = [parsedJornada valueForKey:@"Nombre"];
                    //competicion.grupo.jornada.clasificaciones
                    
                    
                    //RKMappingOperation* mapper = [[RKMappingOperation alloc] initWithSourceObject:[parsedData objectForKey:@""] destinationObject:input mapping:inputMapping];
                    /*RKMappingOperation* mapper = [[RKMappingOperation alloc] initWithSourceObject:parsedData destinationObject:competicion mapping:inputMapping];
                     RKObjectMappingOperationDataSource *mappingDS = [RKObjectMappingOperationDataSource new];
                     mapper.dataSource = mappingDS;
                     [mapper performMapping:&parseError];
                     if(parseError == nil){
                     [self.delegate apiSetCompeticion:competicion];
                     }else{
                     NSLog(@"Parse error: %@", parseError);
                     }*/
                    
                    break;
                }
                case PRPAPIRequestTypeResultados:
                {
                    RKObjectMapping *inputMapping = [[self class] mappingForClass:@"PRPResultados"];
                    
                    //PRPResultado *resultado = [PRPResultado new];
                    PRPResultados *resultados = [PRPResultados new];
                    //RKMappingOperation* mapper = [[RKMappingOperation alloc] initWithSourceObject:[parsedData objectForKey:@""] destinationObject:input mapping:inputMapping];
                    RKMappingOperation* mapper = [[RKMappingOperation alloc] initWithSourceObject:parsedData destinationObject:resultados mapping:inputMapping];
                    RKObjectMappingOperationDataSource *mappingDS = [RKObjectMappingOperationDataSource new];
                    mapper.dataSource = mappingDS;
                    [mapper performMapping:&parseError];
                    if(parseError == nil){
                        dispatch_async(dispatch_get_main_queue(),
                                       ^{
                                           // Some code
                                           [self.delegate apiSetResultados:resultados.resultados];
                                       });
                    }else{
                        NSLog(@"Parse error: %@", parseError);
                    }
                    break;
                }
                case PRPAPIRequestTypeNone:
                {
                    break;
                }
            }
        }
        
    });
}

@end
