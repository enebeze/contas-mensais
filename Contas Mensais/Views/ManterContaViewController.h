//
//  ManterContaViewController
//  Contas Mensais
//
//  Created by Ebenezer Souza on 23/09/13.
//  Copyright (c) 2013 Ebenezer Souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "Contas.h"

@protocol ManterContaViewControllerDelegate <NSObject>

@required
-(void)carregaContas;

@end

@interface ManterContaViewController : UITableViewController<UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate>

- (IBAction)cancelar:(id)sender;
- (void)selecionaConta:(NSString*)conta;
- (IBAction)salvarConta:(id)sender;
- (IBAction)excluirConta:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblConta;
@property (nonatomic, assign) id<ManterContaViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *lblDiaVencimento;
@property (strong, nonatomic) IBOutlet UILabel *lblDataFinal;
@property (strong, nonatomic) IBOutlet UITextField *diaVencimento;
@property (strong, nonatomic) IBOutlet UILabel *lblLembreme;
@property (strong, nonatomic) Contas *contas;
@property (strong, nonatomic) NSArray *tiposLembretes;
@property (strong, nonatomic) NSDictionary *lembreMeList;
@property (assign, nonatomic) NSInteger linhaLembre;

@end
