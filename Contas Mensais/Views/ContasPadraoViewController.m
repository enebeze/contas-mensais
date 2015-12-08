//
//  ContasPadraoViewController.m
//  Contas Mensais
//
//  Created by Ebenezer Souza on 24/09/13.
//  Copyright (c) 2013 Ebenezer Souza. All rights reserved.
//

#import "ContasPadraoViewController.h"
#import "ManterContaViewController.h"

@interface ContasPadraoViewController ()

@property (nonatomic, strong) NSArray *contasPadroes;
@property (nonatomic, strong) NSArray *imagesContas;


@end

@implementation ContasPadraoViewController

@synthesize delegate = _delegate;

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
    
    [tracker set:kGAIScreenName value: @"Contas Padrao Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Inicializa as contas padrões
    _contasPadroes = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Água", @"Água"), NSLocalizedString(@"Energia", @"Energia"), NSLocalizedString(@"Telefone", @"Telefone"), NSLocalizedString(@"Celular", @"Celular"), NSLocalizedString(@"Condomínio", @"Condomínio"), NSLocalizedString(@"TV por Assinatura", @"Tv por Assinatura"), NSLocalizedString(@"Aluguel", @"Aluguel"), NSLocalizedString(@"Cartão de Crédito", @"Cartão de Crédito"), NSLocalizedString(@"Gás", @"Gás"), nil];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:tgr];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return NSLocalizedString(@"Outros", @"Outros");
    }
    else {
        return NSLocalizedString(@"Contas Padrões", @"Contas Padrões");
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }
    else {
        return [_contasPadroes count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellOutros" forIndexPath:indexPath];
        
        // Retorna a célula
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellPadrao" forIndexPath:indexPath];
        
        // Adiciona a imagem
        //UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        //imgView.image = [UIImage imageNamed:[_imagesContas objectAtIndex:indexPath.row]];
        //cell.imageView.image = imgView.image;
        // Adiciona a descrição
        cell.textLabel.text = [_contasPadroes objectAtIndex:indexPath.row];
        
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *contaSelecionada;
    
    if (indexPath.section == 0) {
        contaSelecionada = [_contasPadroes objectAtIndex:indexPath.row];
        [(ManterContaViewController*)_delegate selecionaConta:contaSelecionada];
    }
    
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Text Fild Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Chama o método que seleciona a conta passando o texto digitado
    [(ManterContaViewController*)_delegate selecionaConta:textField.text];
    return  YES;
}


@end
