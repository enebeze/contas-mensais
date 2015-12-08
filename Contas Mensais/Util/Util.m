//
//  Util.m
//  Contas Mensais
//
//  Created by Ebenezer Silva on 13/05/14.
//  Copyright (c) 2014 Ebenezer Souza. All rights reserved.
//

#import "Util.h"

@implementation Util

+(void)AlertDismissWithMsg:(NSString *)msg title:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
    
    [alert show];
}

+(void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

+(void)AlertWithMsg:(NSString *)msg title:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    [alert show];
}



@end
