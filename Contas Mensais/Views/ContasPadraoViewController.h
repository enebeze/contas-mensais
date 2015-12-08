//
//  ContasPadraoViewController.h
//  Contas Mensais
//
//  Created by Ebenezer Souza on 24/09/13.
//  Copyright (c) 2013 Ebenezer Souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface ContasPadraoViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, weak) id delegate;

@end
