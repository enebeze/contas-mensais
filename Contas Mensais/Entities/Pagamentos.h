//
//  Pagamentos.h
//  Contas Mensais
//
//  Created by Ebenezer Souza on 06/01/14.
//  Copyright (c) 2014 Ebenezer Souza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contas;

@interface Pagamentos : NSManagedObject

@property (nonatomic, retain) NSDate * referencia;
@property (nonatomic, retain) Contas *conta;

@end
