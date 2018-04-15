//
//  UIGroupCheckboxView.h
//  RunSport
//
//  Created by Tapha Media Ltd on 3/8/13.
//  Copyright (c) 2013 Tapha Media Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UICheckboxButton.h"

@protocol UIGroupCheckboxViewDelegate;

@interface UIGroupCheckboxView : UIView<UICheckboxButtonDelegate> {
    BOOL multiSelectable;
    
    int currentIndex;
    
    NSMutableArray *arrChkBox;
}
@property (nonatomic) BOOL multiSelectable;

@property (nonatomic, assign) id<UIGroupCheckboxViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles chkbox:(BOOL)chkbox;

- (void) performClickOnCheckboxFrom:(int)index;


@end


@protocol UIGroupCheckboxViewDelegate

@optional

- (void) didClickCheckboxItem:(UIGroupCheckboxView *)gcv chkIndex:(int)index value:(BOOL)value;

@end