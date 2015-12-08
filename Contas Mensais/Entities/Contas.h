//
//  Contas.h
//  Contas Mensais
//
//  Created by Ebenezer Silva on 24/05/14.
//  Copyright (c) 2014 Ebenezer Souza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pagamentos;

@interface Contas : NSManagedObject

@property (nonatomic, retain) NSString * conta;
@property (nonatomic, retain) NSDate * dataCadastro;
@property (nonatomic, retain) NSDate * dataFim;
@property (nonatomic, retain) NSDate * diaVencimento;
@property (nonatomic, retain) NSNumber * lembreme;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSSet *pagamento;
@end

@interface Contas (CoreDataGeneratedAccessors)

- (void)addPagamentoObject:(Pagamentos *)value;
- (void)removePagamentoObject:(Pagamentos *)value;
- (void)addPagamento:(NSSet *)values;
- (void)removePagamento:(NSSet *)values;

@end
