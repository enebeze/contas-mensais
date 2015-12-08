//
//  ManterContaViewController
//  Contas Mensais
//
//  Created by Ebenezer Souza on 23/09/13.
//  Copyright (c) 2013 Ebenezer Souza. All rights reserved.
//

#import "ManterContaViewController.h"
#import "ContasPadraoViewController.h"
#import "ContasViewController.h"
#import "AppDelegate.h"
#import "Contas.h"
#import "Util/Util.h"

@interface ManterContaViewController ()

@end

@implementation ManterContaViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value: @"Manter Screen"];
    
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:tgr];
    
    // Carrega a lista de lembremes
    [self carregaLembreMeList];
    
    _linhaLembre = 1;
    
    if (_contas) {
        self.title = NSLocalizedString(@"Alterar Conta", @"Titulo Alterar");
        [self selecionaConta:_contas.conta];
        [self setDateWithDate:_contas.diaVencimento withIndex:1];
        [self setDateWithDate:_contas.dataFim withIndex:2];
        _linhaLembre = [_contas.lembreme integerValue];
        _lblConta.enabled = NO;
    }
    
    // Carrega os tipos de lembretes
    //_lblLembreme.text = @"No Dia (Mensal)";
    //[_lembreMeList objectForKey:[NSString stringWithFormat:@"%ld", (long)row]];
    NSString *text = [_lembreMeList objectForKey:[NSString stringWithFormat:@"%ld", (long)_linhaLembre]];
    _lblLembreme.text = NSLocalizedString(text, @"Lembretes em Dias");
    
}

-(void)carregaLembreMeList
{
    // Caminho da aplicação
    NSString *path = [[NSBundle mainBundle] bundlePath];
    // String com o nome do arquivo
	NSString *dataPath = [path stringByAppendingPathComponent:@"LembreMeList.plist"];
	// Recebe os dados da lista
	_lembreMeList = [[NSDictionary alloc] initWithContentsOfFile:dataPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_contas) {
        return 2;
    }
    else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (_contas) {
            return NSLocalizedString(@"Alterar Conta", @"Titulo Alterar");
        }
        else {
            return NSLocalizedString(@"Adicionar uma nova conta", @"Titulo Nova Conta");
        }
        
    }
    else {
        return @"";
    }
    
}

- (void)dismissKeyboard
{
    [self.view endEditing:TRUE];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        //NSDate *dateNow = [NSDate date];
        //[self setDateWithDate:dateNow withIndex:1];
        [self displayViewDataFinal];
    }
    else if (indexPath.row == 3){
        [self displayViewDataFinal];
    }
    else if (indexPath.row == 2) {
        [self displayViewLembreme];
    }
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)displayViewLembreme
{
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-266-44, 320, 44);
    CGRect pickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-266, 320, 216);
    
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 20;
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPicker:)];
    [tgr setCancelsTouchesInView:NO];
    [darkView addGestureRecognizer:tgr];
    
    [self.view addSubview:darkView];
    
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
    picker.tag = 21;
    picker.backgroundColor = [UIColor whiteColor];
    picker.alpha = 1;
    picker.dataSource = self;
    picker.delegate = self;
    [picker selectRow:_linhaLembre inComponent:0 animated:YES];
    //[picker selectRow:[[NSUserDefaults standardUserDefaults]integerForKey:_lblLembreme.text] inComponent:0 animated:YES];
    [self.view addSubview:picker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.tag = 22;
    [toolBar setBarTintColor:[UIColor colorWithRed:0/255.0f green:150/255.0f blue:200/255.0f alpha:1.0f]];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Fechar", @"Fechar") style:UIBarButtonItemStylePlain target:self action:@selector(dismissPicker:)];
    doneButton.tintColor = [UIColor whiteColor];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    picker.frame = pickerTargetFrame;
    darkView.alpha = 0.1;
    [UIView commitAnimations];
}


#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _lembreMeList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *text = [_lembreMeList objectForKey:[NSString stringWithFormat:@"%ld", (long)row]];
    return NSLocalizedString(text, @"Lembretes em Dias");
}

#pragma mark PickerView Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *text = [_lembreMeList objectForKey:[NSString stringWithFormat:@"%ld", (long)row]];
    _lblLembreme.text = NSLocalizedString(text, @"Lembretes em Dias");
    _linhaLembre = row;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    tView.font = [UIFont fontWithName:@"" size:19];
    tView.textAlignment = NSTextAlignmentCenter;
    NSString *text = [_lembreMeList objectForKey:[NSString stringWithFormat:@"%ld", (long)row]];
    tView.text = NSLocalizedString(text, @"Lembretes em Dias");

    return tView;
}

-(void)displayViewDataFinal
{
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-266-44, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-266, 320, 216);
    //CGRect movBtnTeste = CGRectMake(30, 200, 250, 44);
    
   /* UIButton *btnTeste = [[UIButton alloc] initWithFrame:CGRectMake(40, -44, 250, 44)];
    btnTeste.alpha = 1;
    btnTeste.backgroundColor = [UIColor greenColor];
    btnTeste.titleLabel.text = @"Meu Butão";
    btnTeste.tintColor = [UIColor blackColor];*/
    
    //[self.view addSubview:btnTeste];
    
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 9;
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)];
    [tgr setCancelsTouchesInView:NO];
    [darkView addGestureRecognizer:tgr];
    
    [self.view addSubview:darkView];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
    datePicker.tag = 10;
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.alpha = 1;
    
    if (_contas) {
        datePicker.date = _contas.diaVencimento;
    }
    
    
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.tag = 11;
    //toolBar.barStyle = UIBarStyleBlackTranslucent;
    [toolBar setBarTintColor:[UIColor colorWithRed:0/255.0f green:150/255.0f blue:200/255.0f alpha:1.0f]];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Fechar", @"Fechar") style:UIBarButtonItemStylePlain target:self action:@selector(dismissDatePicker:)];
    UIBarButtonItem *removerButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Remover", @"Remover") style:UIBarButtonItemStylePlain target:self action:@selector(removeDateButton:)];
    doneButton.tintColor = [UIColor whiteColor];
    removerButton.tintColor = [UIColor whiteColor];
    [toolBar setItems:[NSArray arrayWithObjects:removerButton, spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    datePicker.frame = datePickerTargetFrame;
    darkView.alpha = 0.1;
    [UIView commitAnimations];
    
   /* [UIView animateWithDuration:0.1 animations:^{
        toolBar.frame = toolbarTargetFrame;
        datePicker.frame = datePickerTargetFrame;
        darkView.alpha = 0.2;
    }];*/

}

- (void)removeDateButton:(id)sender
{
    if (self.tableView.indexPathForSelectedRow.row == 1) {
        _lblDiaVencimento.text = NSLocalizedString(@"Selecione", @"Selecione");
    }
    else if (self.tableView.indexPathForSelectedRow.row == 2) {
        _lblDataFinal.text = NSLocalizedString(@"Não Informado", @"Não Informado");
    }
    
    [self removeDataPicker];
}

-(void)dismissPicker:(id)sender
{
    [self removePicker];
}

- (void)dismissDatePicker:(id)sender
{
    [self removeDataPicker];
}

- (void)removePicker
{
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:20].alpha = 0;
    [self.view viewWithTag:21].frame = datePickerTargetFrame;
    [self.view viewWithTag:22].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViewsLembreme:)];
    [UIView commitAnimations];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

-(void)removeDataPicker
{
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)changeDate:(UIDatePicker *)sender
{
    [self setDateWithDate:sender.date withIndex:self.tableView.indexPathForSelectedRow.row];
}

- (void)setDateWithDate:(NSDate *)data withIndex:(NSInteger)index
{
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    [formatDate setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    if (index == 1) {
        
        _lblDiaVencimento.text = [formatDate stringFromDate:data];
    }
    else if (index == 2) {
        if (!data) {
            _lblDataFinal.text = NSLocalizedString(@"Não Informado", @"Não Informado");
        }
        else {
            _lblDataFinal.text = [formatDate stringFromDate:data];
        }
    }
}

- (void)removeViews:(id)object
{
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}

-(void)removeViewsLembreme:(id)object
{
    [[self.view viewWithTag:20] removeFromSuperview];
    [[self.view viewWithTag:21] removeFromSuperview];
    [[self.view viewWithTag:22] removeFromSuperview];
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Verifica o Push selecionado
    if ([segue.identifier isEqualToString:@"Seleciona Conta"])
	{
        ContasPadraoViewController *contasPadraoViewController = segue.destinationViewController;
        contasPadraoViewController.delegate = self;
    }
}

- (IBAction)cancelar:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)selecionaConta:(NSString *)conta
{
    self.lblConta.text = conta;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)salvarConta:(id)sender
{
    // Valida os campos
    NSString *msg = [self validaCampos];
    
    // Verifica se validou
    if (![msg isEqualToString:@""]) {
        [Util AlertWithMsg:msg title:NSLocalizedString(@"Atenção", @"Atenção")];
        return;
    }
    
    // Sempre cancela a notificação
    [self cancelLocalNotification:_contas.conta];
    
    // Cria o contexto
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    if (!_contas) {
        
        // Cria uma nova conta
        _contas = [NSEntityDescription insertNewObjectForEntityForName:@"Contas" inManagedObjectContext:context];
        // Adiciona data de cadastro que não poderá ser alterada
        _contas.dataCadastro = [NSDate date];
    }
    
    // Preenche a conta
    _contas = [self preencheConta:_contas];
    
    // Variável de erro
    NSError *error;
    
    // Salva a conta
    if ([context save:&error]) {
        
        // Verifica se é diferente de Desativado
        if (![_contas.lembreme isEqualToNumber:[NSNumber numberWithInteger:6]]) {
            // Cria a notificação
            [self addLocalNotification];
        }
        
        // Recarrega as contas na tela inicial
        [self.delegate carregaContas];
        // Volta pra view anterior
        [self dismissViewControllerAnimated:YES completion:Nil];
    }
    else {
        // Cria um alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Erro", @"Erro") message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
    }
}

// Valida os campos
- (NSString*)validaCampos
{
    // Mensagem de retorno
    NSString *msg = @"" ;
    
    // Verifica se preencheu o nome da conta
    if ([_lblConta.text isEqualToString:NSLocalizedString(@"Conta", @"Conta")])
    {
        msg = NSLocalizedString(@"- Informe o nome da Conta \n", @"Valida Conta");
        //msg = [msg stringByAppendingString:@"Preecha o campo Conta"];
    }
    
    // Verifica se preencheu o dia de vencimento
    if ([_lblDiaVencimento.text isEqualToString:NSLocalizedString(@"Selecione", @"Selecione")])
    {
        msg = [msg stringByAppendingString:NSLocalizedString(@"- Informe o Dia de Vencimento", @"Valida Dia Vencimento")];
    }
    
    // Verifica se é atualizacão
    if (_contas) {
        // Verifica se o nome da conta foi alterado
        if (![_contas.conta isEqualToString:_lblConta.text]) {
            // Verifica se existe uma conta com o novo nome
            if ([self isContaExiste:_lblConta.text]) {
                msg = [msg stringByAppendingString:NSLocalizedString(@"- Nome da conta já existe", @"Valida Conta Existente")];
            }
        }
    }
    else
    {
        // Verifica se existe uma conta com o novo nome
        if ([self isContaExiste:_lblConta.text]) {
            msg = [msg stringByAppendingString:NSLocalizedString(@"- Nome da conta já existe", @"Valida Conta Existente")];
        }
    }
    
   
    
    return msg;
}

- (BOOL)isContaExiste:(NSString*)nomeConta
{
    // Cria o contexto
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Entidade a ser pesquisada
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contas" inManagedObjectContext:context];
    
    // Adiciona a entidade a variáveis de persistência
    [fetchRequest setEntity:entity];
    
    // Filtro
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"conta = %@", nomeConta];
    [fetchRequest setPredicate:predicate];
    
    // Variável de erro
    NSError *error;
    
    NSArray *consulta = [context executeFetchRequest:fetchRequest error:&error];
    
    // Verifica se encontrou
    if ([consulta count]) {
        return YES;
    }
    else {
        return NO;
    }
    
    
}

// Método que preenche a conta com os dados da tela
- (Contas *) preencheConta:(Contas*)conta
{
    // Cria o formato da data
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    [formatDate setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    // Preenche a nova conta
    conta.conta = _lblConta.text;
    conta.diaVencimento = [formatDate dateFromString:_lblDiaVencimento.text];
    
    if (![_lblDataFinal.text isEqualToString:NSLocalizedString(@"Não Informado", @"Não Informado")]) {
        conta.dataFim = [formatDate dateFromString:_lblDataFinal.text];
    }
    conta.lembreme = [NSNumber numberWithInteger:_linhaLembre];
    
    // Retorna a conta
    return conta;

}

// Método responsável por adicionar uma notificação para uma conta
-(void) addLocalNotification
{
    NSDate *fireDate = [self getFireDateWithDate];
    
    // Cria uma Local notificação
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"Conta %@ está perto do seu vencimento", @"Texto da Notificação"), _lblConta.text];
    localNotification.timeZone = [NSTimeZone defaultTimeZone]; //[NSTimeZone timeZoneWithName:@"UTC"];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    localNotification.repeatInterval = NSMonthCalendarUnit;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    // Cria informação da conta
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:_lblConta.text forKey:@"Conta"];
    // Salva informação da conta
    localNotification.userInfo = dictionary;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}

// Método que cancela a notificação de uma conta
-(void) cancelLocalNotification:(NSString*)conta
{
    // Recebe todas as notificações
    NSArray * allNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    // Percorre todas as notificações
    for (UILocalNotification *not in allNotifications)
    {
        if ([[not.userInfo objectForKey:@"Conta"] isEqualToString:conta]) {
            // Cancela a notificação
            [[UIApplication sharedApplication] cancelLocalNotification:not];
        }
    }
}

-(NSDate*)getFireDateWithDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *dataAtual = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:_contas.diaVencimento];
    
    // Altera o valor do dia
    [dataAtual setDay:[dataAtual day] - _linhaLembre];
    
    // Retorna a data de notificação
    return [calendar dateFromComponents:dataAtual];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self excluiConta];
    }
}

- (IBAction)excluirConta:(id)sender {
    
    
    NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"Deseja realmente excluir a conta %@? ", @"Confirm Exclusao"), _contas.conta];
    
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:msg
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Não", @"Não")
                                         destructiveButtonTitle:NSLocalizedString(@"Sim", @"Sim")
                                              otherButtonTitles:nil];
    
    [sheet showInView:[self view]];
    
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            if ([button.titleLabel.text isEqualToString:NSLocalizedString(@"Sim", @"Sim")]) {
                button.titleLabel.textColor = [UIColor colorWithRed:0/255.0f green:150/255.0f blue:200/255.0f alpha:1.0f];
            }
            else {
                button.titleLabel.textColor = [UIColor redColor];
            }
            
        }
    }
}

- (void)excluiConta
{
    // Cria o contexto
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    if (_contas) {
        [context deleteObject:_contas];
    }
    
    // Variável de erro
    NSError *error;
    
    // Armazena o nome da conta a ser excluída
    NSString *nomeConta = _contas.conta;
    
    // Exclui a igreja
    if ([context save:&error])
    {
        // Sempre cancela a notificação
        [self cancelLocalNotification:nomeConta];
        // Reload a table view da View Igrejas
        [self.delegate carregaContas];
        // Volta pra view anterior
        [self dismissViewControllerAnimated:YES completion:Nil];
    }
    else {
        // Cria um alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Erro", @"Erro") message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
    }

}

@end
