//
//  UIGroupCheckboxView.m
//  RunSport
//
//  Created by Tapha Media Ltd on 3/8/13.
//  Copyright (c) 2013 Tapha Media Ltd. All rights reserved.
//

#import "UIGroupCheckboxView.h"

@implementation UIGroupCheckboxView

@synthesize multiSelectable;

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles chkbox:(BOOL)chkbox
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        multiSelectable = chkbox;
        
        arrChkBox = [[NSMutableArray alloc] init];
        
        currentIndex = 0;
        int y = 0;
        if (titles != nil) {
            for (int i = 0; i < [titles count]; i++) {
                NSString * title = [titles objectAtIndex:i];
                
                UICheckboxButton * chk = [[UICheckboxButton alloc] initWithFrame:CGRectMake( 0, y, frame.size.width, 29 )];
                [chk setText:title];
                [chk setCheckboxType:chkbox];
                [chk setChecked:(i == 0)];
                [chk showCurrentState];
                chk.delegate = self;
                [arrChkBox addObject:chk];
                [self addSubview:chk];
                
                y += 35;
            }
            
            frame.size.height = y;
            [self setFrame:frame];
        }
        
    }
    return self;
}



- (void) didClickCheckbox:(UICheckboxButton *)chkBox
{
    NSInteger index = [arrChkBox indexOfObject:chkBox];
    
//    if (index == NSNotFound) {
//        return;
//    }
    

    if (!multiSelectable) {
        
        if ((currentIndex == index) && !chkBox.isChecked && ([arrChkBox count] > 1)) {
            [chkBox setIsChecked:YES];
            [chkBox showCurrentState];
        }
        else {
            for ( int i = 0; i < [arrChkBox count]; i++) {
                if (i == index) {
                    continue;
                }
                
                UICheckboxButton * chk = [arrChkBox objectAtIndex:i];
                [chk setIsChecked:!chkBox.isChecked];
                [chk showCurrentState];
            }
        }
    }
    
    currentIndex = (int)index;
    
    if (self.delegate) {
        [self.delegate didClickCheckboxItem:self chkIndex:(int)index value:chkBox.isChecked];
    }
}

- (void) performClickOnCheckboxFrom:(int)index
{
    if (arrChkBox == nil) {
        return;
    }
    
    if (index < 0) {
        return;
    }
    
    if (index >= [arrChkBox count]) {
        return;
    }
    
    UICheckboxButton * chk = [arrChkBox objectAtIndex:index];
    
    [self didClickCheckbox:chk];
}


@end
