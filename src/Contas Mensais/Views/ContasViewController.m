//
//  ContasViewController.m
//  Contas Mensais
//
//  Created by Ebenezer Souza on 20/09/13.
//  Copyright (c) 2013 Ebenezer Souza. All rights reserved.
//

#import "ContasViewController.h"
#import "ManterContaViewController.h"
#import "AppDelegate.h"
#import "CellConta.h"
#import "Pagamentos.h"
#import "Util.h"

@interface ContasViewController () <ManterContaViewControllerDelegate, CellContaDelegate>

@property (nonatomic, strong) NSArray *contas;

@end

@implementation ContasViewController

-(void)notificationActions
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pagarContaWithNotification:) name:@"pagarContaWithNotification" object:nil];
}

-(void)pagarContaWithNotification:(NSNotification*)notification
{
    NSDictionary *dict = [notification userInfo];
    UILocalNotification *not = (UILocalNotification*) [dict objectForKey:@"not"];
    
    // Percorre as contas
    for (Contas *conta in _contas) {
        if ([conta.conta isEqualToString:[not.userInfo objectForKey:@"Conta"]])
        {
            [self pagarConta:conta];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        
    CGRect rect = self.view.frame;
    rect.size.height = rect.size.height - 50;

    [self.tableView setFrame:rect];
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadContas];
    
    //UIColor* color = [UIColor colorWithRed:65.0/255 green:75.0/255 blue:89.0/255 alpha:1.0];
    //[self.view setBackgroundColor:color];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissCellEdit:)];
    [tgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:tgr];
    
    // Adiciona as ações para as notificações
    [self notificationActions];
    
    [self.bannerView setAdSize:kGADAdSizeSmartBannerPortrait];
    
    // Especificar o ID do bloco de anúncios.
    self.bannerView.adUnitID = @"ca-app-pub-9012198329041855/2806182324";
     
    // Permitir que o tempo de execução saiba qual UIViewController deve ser restaurado depois de levar
    // o usuário para onde quer que o anúncio vá e adicioná-lo à hierarquia de visualização.
    self.bannerView.rootViewController = self;
    
    // Iniciar uma solicitação genérica para carregá-la com um anúncio.
    [self.bannerView loadRequest:[self createRequest]];
    
    self.screenName = @"Home Screen";
    
}


- (GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
    
//#ifdef DEBUG
    request.testDevices = @[@"2c973e851f3e0009f4fde27ceff3b0ab"];
//#endif
    
    return request;
}
 

-(void)dismissCellEdit:(id)sender
{
    if (indexPathInEdit != nil) {
        CellConta * cellConta = (CellConta *)[self.tableView cellForRowAtIndexPath:indexPathInEdit];
        [cellConta setStateInEdit:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadContas
{
    // Delegate do App
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // Variáveis para conexão com banco
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Entidade a ser pesquisada
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contas" inManagedObjectContext:context];
    
    // Adiciona a entidade a variáveis de persistência
    [fetchRequest setEntity:entity];
    // Variável de erro
    NSError *error;
    
    // Executa a busca e retorna no array
    self.contas = [context executeFetchRequest:fetchRequest error:&error];
    
    [self showHiddenImgStar];
    
}

-(void) showHiddenImgStar
{
    [UIView transitionWithView: self.imgStart
                      duration: 0.5f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void)
     {
         
         if ([self.contas count] == 0) {
             
             [self.imgStart setHidden:NO];
              self.tableView.alpha = 0;
         }
         else {
             [self.imgStart setHidden:YES];
             self.tableView.alpha = 1;
         }
     }
                    completion: ^(BOOL isFinished)
     {
         
     }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.contas.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedString(@"MINHAS CONTAS", @"Header Table View");
    }
    
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	UITableViewCell * cell = nil;
    
    NSString *cellid = @"CellConta";
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (cell == nil) {
        cell = [[CellConta alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    [((CellConta *)cell) setCellWithConta:[_contas objectAtIndex:indexPath.row]];
    [((CellConta *)cell) setDelegate:self];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissCellEdit:nil];
    
    // Recebe a conta
    Contas *conta = (Contas*)[_contas objectAtIndex:indexPath.row];
    
    // Cria o controle
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"NCNovaConta"];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    ManterContaViewController *novaConta = (ManterContaViewController*)navController.visibleViewController;
    novaConta.delegate = self;
    novaConta.contas = conta;
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self presentViewController:navController animated:YES completion:Nil];
    
}

#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"novaConta"]) {

        [self dismissCellEdit:nil];
        
        UINavigationController *navController = segue.destinationViewController;
        ManterContaViewController *novaConta = (ManterContaViewController*)navController.visibleViewController;
        novaConta.delegate = self;
    }

}

-(void)carregaContas
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contas" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    
    _contas = [context executeFetchRequest:fetchRequest error:&error];
    
    [self showHiddenImgStar];
    
    [UIView transitionWithView: self.tableView
                      duration: 0.5f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void)
                                        {
                                            [self.tableView reloadData];
                                        }
                    completion: ^(BOOL isFinished)
                                {
                                    [self viewDidAppear:YES];
                                }];
    
   /* CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFromLeft;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.fillMode = kCAFillModeForwards;
    transition.duration = 0.5;
    transition.subtype = kCATransitionFromLeft;
    
    [[self.tableView layer] addAnimation:transition forKey:@"UITableViewReloadDataAnimationKey"];
    
    [self.tableView reloadData];*/
    
}

- (void) pagarConta:(Contas *)conta
{
    // Cria contexto de conexão
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSString *msg;
    
    if ([conta.status isEqualToNumber:[NSNumber numberWithInt:0]]) {
        
        Pagamentos *pg = [NSEntityDescription insertNewObjectForEntityForName:@"Pagamentos" inManagedObjectContext:context];
        pg.referencia = [NSDate date];
        [conta addPagamentoObject:pg];
        conta.status = [NSNumber numberWithInt:1];
        msg = NSLocalizedString(@"Conta paga com Sucesso!", @"Alert Pago");
        // Atualiza a data da notificação
        [self updateLocalNotification:conta foiPaga:YES];
    }
    else {
        [conta removePagamentoObject:[self getPagamentoDoMes:conta]];
        conta.status = [NSNumber numberWithInt:0];
        msg = NSLocalizedString(@"Conta cancelada com Sucesso!", @"Alert Cancelado");
        // Atualiza a data da notificação menos um mês
        [self updateLocalNotification:conta foiPaga:NO];
    }
    
    NSError *error;
    
    // Altera a conta
    if ([context save:&error])
    {
        [Util AlertDismissWithMsg:msg title:NSLocalizedString(@"Sucesso", @"Alert Sucesso")];
    }
    else {
        [Util AlertWithMsg:[error localizedDescription] title:NSLocalizedString(@"Erro", @"Erro")];
    }
    
    [self dismissCellEdit:nil];
    
    // Recarrega as tableview
    [self carregaContas];
}

-(Pagamentos*)getPagamentoDoMes:(Contas *)conta
{
    for (Pagamentos *pg in conta.pagamento)
    {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MM/yyyy"];
        
        if ([[format stringFromDate:pg.referencia] isEqualToString:[format stringFromDate:[NSDate date]]]) {
            return pg;
        }
    }
    
    return nil;

}

-(void)willEditConta:(UITableViewCell *)tbCell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tbCell]; //[tblMails indexPathForCell:ic];
    
    if (( indexPathInEdit != nil ) && ( ![indexPathInEdit isEqual:indexPath] )){
        CellConta * cellConta = (CellConta *)[self.tableView cellForRowAtIndexPath:indexPathInEdit];
        
        [cellConta setStateInEdit:NO];
    }
    
    indexPathInEdit = indexPath;

}

- (void)willDeleteConta:(Contas *)conta tableViewCell:(UITableViewCell *)tbCell
{
    // Salva a conta
    contaEdit = conta;
    cellContaEdit = (CellConta*)tbCell;
    
    NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"Deseja realmente excluir a conta %@? ", @"Confirm Exclusao"), conta.conta];
    
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:msg
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Não", @"Não")
                                         destructiveButtonTitle:NSLocalizedString(@"Sim", @"Sim")
                                              otherButtonTitles:nil];
    
    [sheet showInView:[self view]];
}

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self viewDidAppear:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissCellEdit:nil];
    
    if (buttonIndex == 0) {
        [self excluiConta];
    }
    
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
        [context deleteObject:contaEdit];
    }
    
    // Variável de erro
    NSError *error;
    
    // Armazena o nome da conta a ser excluída
    NSString *nomeConta = contaEdit.conta;
    
    // Exclui a igreja
    if ([context save:&error])
    {
        [cellContaEdit setStateInEdit:NO];
        cellContaEdit = nil;
        contaEdit = nil;
        
        // Sempre cancela a notificação
        [self cancelLocalNotification:nomeConta];
        
        // Reload a table view da View Igrejas
        [self carregaContas];
        
    }
    else {
        // Cria um alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Erro", @"Erro") message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
    }
    
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

// Atualiza a data da notificação
-(void) updateLocalNotification:(Contas*)conta foiPaga:(BOOL)foiPaga
{
    // Recebe todas as notificações
    NSArray *allNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    // Percorre as notificações
    for (UILocalNotification *not in allNotifications) {
        
        if ([[not.userInfo objectForKey:@"Conta"] isEqualToString:conta.conta]) {
            
            // Cancela a notificação antiga
            [[UIApplication sharedApplication] cancelLocalNotification:not];
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            
            // Recebe a data
            NSDateComponents *dataAtual = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:conta.diaVencimento];
            
            
            if (foiPaga) {
                // Altera pro próximo mês
                [dataAtual setMonth:dataAtual.month + 1];
                
                // Altera o vencimento da conta
                conta.diaVencimento = [calendar dateFromComponents:dataAtual];
            }
            else {
                // Altera pro mês anterior
                [dataAtual setMonth:dataAtual.month - 1];
                // Altera o vencimento da conta
                conta.diaVencimento = [calendar dateFromComponents:dataAtual];
            }
            
            // Altera o valor do dia
            [dataAtual setDay:[dataAtual day] - [conta.lembreme integerValue]];
            
            // Altera a data da nova notification
            not.fireDate = [calendar dateFromComponents:dataAtual];
            
            // Adiciona a nova notificação
            [[UIApplication sharedApplication] scheduleLocalNotification:not];
            
            // Sai do método
            return;
        }
    }
}


- (IBAction)viewMenu:(id)sender {
    
   // UIStoryboard *storyB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //UIViewController *viewMenu = [storyB instantiateViewControllerWithIdentifier:@"ViewMenu"];
    
   // [self.view addSubview:viewMenu.view];
    
}
@end
