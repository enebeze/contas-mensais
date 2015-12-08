//
//  UICheckboxButton.h
//  RunSport
//
//  Created by Tapha Media Ltd on 3/8/13.
//  Copyright (c) 2013 Tapha Media Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UICheckboxButtonDelegate;

@interface UICheckboxButton : UIButton {
    BOOL isChecked;
	
	UIImageView * checkIcon;
    
    UILabel * lblTitle;
    
    float normalR, normalG, normalB;
    float activeR, activeG, activeB;
    
    BOOL checkboxType;
}
@property (nonatomic) BOOL isChecked;
@property (nonatomic, assign) id<UICheckboxButtonDelegate> delegate;
@property (nonatomic) BOOL checkboxType;

- (void) setText:(NSString *)text;

- (void) showCurrentState;

- (void) setChecked:(BOOL)checked;

- (void) setCheckBoxRightType;
- (void) setCheckBoxLeftType;

- (void) setNormalTextColorWith:(float)r g:(float)g b:(float)b;
- (void) setCheckedTextColorWith:(float)r g:(float)g b:(float)b;
- (void) setFontWith:(NSString *)fontName size:(float)size;

@end


@protocol UICheckboxButtonDelegate

@optional

- (void) didClickCheckbox:(UICheckboxButton *)chkBox;

@end