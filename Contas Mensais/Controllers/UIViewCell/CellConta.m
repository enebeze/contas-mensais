//
//  CellConta.m
//  Contas Mensais
//
//  Created by Ebenezer Souza on 11/10/13.
//  Copyright (c) 2013 Ebenezer Souza. All rights reserved.
//

#import "CellConta.h"
#import "Pagamentos.h"

@implementation CellConta

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCellWithConta:(Contas *)conta
{
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    [formatDate setDateFormat:@"HH:mm"];
    
    contaCell = conta;
    
    NSString *lembreme;
    
    switch ([conta.lembreme integerValue])
    {
        case 0:
            lembreme = [NSString stringWithFormat:NSLocalizedString(@"Lembrar No dia ás %@", @"Lembrar no Dia"), [formatDate stringFromDate:conta.diaVencimento]];
            break;
        case 1:
            lembreme = [NSString stringWithFormat:NSLocalizedString(@"Lembrar %@ dia antes ás %@", @"Lembrar outros dia"), [conta.lembreme stringValue], [formatDate stringFromDate:conta.diaVencimento]];
            break;
        case 2:
        case 3:
        case 4:
        case 5:
            lembreme = [NSString stringWithFormat:NSLocalizedString(@"Lembrar %@ dias antes ás %@", @"Lembrar outros dias"), [conta.lembreme stringValue], [formatDate stringFromDate:conta.diaVencimento]];
            break;
        case 6:
            lembreme = NSLocalizedString(@"Lembrar Desativado", @"Lembrar Desativado");
            
    }

    [formatDate setDateFormat:@"dd/MM/yyyy"];
    
    [lblConta setText:conta.conta];
    [lblDiaVencimento setText:[NSString stringWithFormat:NSLocalizedString(@"Vence em %@", @"Vence em"), [formatDate stringFromDate:conta.diaVencimento]]];
    [lblLembreme setText:lembreme];
    
    chk = (UICheckboxButton*)[self viewWithTag:100];
    
    if (chk == nil) {
        
        // Cria e adiciona o check box
        chk = [[UICheckboxButton alloc] initWithFrame:CGRectMake(270, 23, 70, 29)];
        chk.tag = 100;
        chk.delegate = self;
        [viewContent addSubview:chk];
    }
    
    
    //[chk setChecked:[conta.status isEqualToNumber:[NSNumber numberWithInt:1]]];
    [chk setChecked:[self verificaSeFoiPaga]];
    
    // Add gestos
    [self addGestureRecognizers];
}

-(NSDate*)getDataExibicao
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *vencimentoConta = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:contaCell.diaVencimento];
    
    NSDateComponents *dataAtual = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];

    
    if ([vencimentoConta month] > [dataAtual month]) {
        return [calendar dateFromComponents:vencimentoConta];
    }
    else {
        [vencimentoConta setMonth:[dataAtual month]];
        return [calendar dateFromComponents:vencimentoConta];
    }

}

- (void) setStateInEdit:(BOOL)editing
{
    inEditing = editing;
    
    [self showState];
}

- (IBAction)delContaButton:(id)sender {
    [self.delegate willDeleteConta:contaCell tableViewCell:self];
}


-(BOOL)verificaSeFoiPaga
{
    for (Pagamentos *pg in contaCell.pagamento)
    {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MM/yyyy"];
        
        if ([[format stringFromDate:pg.referencia] isEqualToString:[format stringFromDate:[NSDate date]]]) {
            contaCell.status = [NSNumber numberWithInt:1];
            return YES;
        }
    }
    
    contaCell.status = [NSNumber numberWithInt:0];
    return NO;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [chk setChecked:!chk.isChecked];
    }
    else if (buttonIndex == 0) {
        [self.delegate pagarConta:contaCell];
    }
}

- (void) didClickCheckbox:(UICheckboxButton *)chkBox
{
    NSString *msg;
    
    if ([contaCell.status isEqualToNumber:[NSNumber numberWithInt:1]]) {
        msg = NSLocalizedString(@"Deseja cancelar o pagamento desta Conta?", @"Confirm cancelar pagamento");
    }
    else {
        msg = NSLocalizedString(@"A conta realmente foi paga?", @"Confirm pagamento");
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:msg
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Não", @"Não")
                                         destructiveButtonTitle:NSLocalizedString(@"Sim", @"Sim")
                                              otherButtonTitles:nil];

    [sheet showInView:self];
}


- (void) addGestureRecognizers
{
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    recognizer.minimumPressDuration = 0.4f;
    [self addGestureRecognizer:recognizer];

}

- (void) handleLongPress:(UILongPressGestureRecognizer *)recognizer  {
    
    if ( recognizer.state == UIGestureRecognizerStateBegan )
    {
        inEditing = !inEditing;
        
        [self showState];
        
        if (inEditing) {
            if (self.delegate) {
                [self.delegate willEditConta:self];
            }
        }
    }
}


- (void) showState
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    
    if (inEditing) {
        if (CGRectIsEmpty(vCpositionOrigin)) {
            vCpositionOrigin = viewContent.frame;
        }
        
        if (CGRectIsEmpty(vEpositionOrigin)) {
            vEpositionOrigin = viewEdit.frame;
        }
        
        CGRect f = viewContent.frame;
        f.origin.x = f.origin.x - 75;
        viewContent.frame = f;
        
        CGRect f1 = viewEdit.frame;
        f1.origin.x = f1.origin.x - 75;
        viewEdit.frame = f1;
        
        
        //viewContent.transform = CGAffineTransformMakeTranslation(-150, 0);
        //viewEdit.transform = CGAffineTransformMakeTranslation( -150, 0 );
    }
    else {
        viewContent.frame = vCpositionOrigin;
        viewEdit.frame = vEpositionOrigin;
        
        //CGRect f1 = viewEdit.frame;
        //f1.origin.x = 20;
        //viewEdit.frame = f1;
        
        //viewContent.transform = CGAffineTransformIdentity;
        //viewEdit.transform = CGAffineTransformIdentity;
    }
    
    [UIView commitAnimations];
}

@end
