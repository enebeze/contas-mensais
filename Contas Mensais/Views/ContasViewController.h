//
//  ContasViewController.h
//  Contas Mensais
//
//  Created by Ebenezer Souza on 20/09/13.
//  Copyright (c) 2013 Ebenezer Souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contas.h"
#import "CellConta.h"
#import "GAITrackedViewController.h"

//@class GADBannerView, GADRequest;

@import GoogleMobileAds;

@interface ContasViewController : GAITrackedViewController<UIActionSheetDelegate> {
    NSIndexPath * indexPathInEdit;
    Contas *contaEdit;
    CellConta *cellContaEdit;

}

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imgStart;

- (IBAction)viewMenu:(id)sender;
- (GADRequest *)createRequest;

@end
