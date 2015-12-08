//
//  CellConta.h
//  Contas Mensais
//
//  Created by Ebenezer Souza on 11/10/13.
//  Copyright (c) 2013 Ebenezer Souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICheckboxButton.h"
#import "Contas.h"

@protocol CellContaDelegate <NSObject>

- (void) pagarConta:(Contas*)conta;

@required

-(void) willEditConta:(UITableViewCell *)tbCell;
-(void) willDeleteConta:(Contas *)conta tableViewCell:(UITableViewCell *)tbCell;

@end

@interface CellConta : UITableViewCell <UICheckboxButtonDelegate, UIActionSheetDelegate> {
    
    BOOL inEditing;
    
    IBOutlet UIView *viewContent;
    IBOutlet UIView *viewEdit;
    
    IBOutlet UILabel *lblConta;
    IBOutlet UILabel *lblDiaVencimento;
    IBOutlet UILabel *lblLembreme;
    
    UICheckboxButton *chk;
    Contas *contaCell;
    
    CGRect vCpositionOrigin;
    CGRect vEpositionOrigin;
    
}

@property (nonatomic, assign) id<CellContaDelegate> delegate;

- (void) setCellWithConta:(Contas *)conta;
- (void) setStateInEdit:(BOOL)editing;

- (IBAction)delContaButton:(id)sender;


@end
