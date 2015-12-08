//
//  ContasViewController.h
//  Contas Mensais
//
//  Created by Ebenezer Souza on 20/09/13.
//  Copyright (c) 2013 Ebenezer Souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "Contas.h"
#import "CellConta.h"
#import "GADBannerView.h"
#import "GADRequest.h"

@class GADBannerView, GADRequest;

@interface ContasViewController : UIViewController<UIActionSheetDelegate, GADBannerViewDelegate> {
    NSIndexPath * indexPathInEdit;
    Contas *contaEdit;
    CellConta *cellContaEdit;

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imgStart;

- (IBAction)viewMenu:(id)sender;

// Declarar um como uma variável da instância
@property(strong, nonatomic) GADBannerView *adBanner;

- (GADRequest *)createRequest;

@end
