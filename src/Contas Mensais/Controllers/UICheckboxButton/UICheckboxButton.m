//
//  UICheckboxButton.m
//  RunSport
//
//  Created by Tapha Media Ltd on 3/8/13.
//  Copyright (c) 2013 Tapha Media Ltd. All rights reserved.
//

#import "UICheckboxButton.h"

@implementation UICheckboxButton
@synthesize isChecked;
@synthesize checkboxType;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake( frame.origin.x, frame.origin.y, frame.size.width, 29 )]) {
        // Initialization code
		
		//self.frame =frame;
		self.contentVerticalAlignment  = UIControlContentVerticalAlignmentCenter;
		
        activeR = 0.0f;
        activeG = 0.0f;
        activeB = 0.0f;
        
        normalR = 179.0f;
        normalG = 179.0f;
        normalB = 179.0f;
        
        checkboxType = true;
        
        checkIcon = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, 29, 29 )];
		[self addSubview:checkIcon];
        
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake( 33, 0, frame.size.width - 33, frame.size.height )];
        [lblTitle setTextColor:[UIColor colorWithRed:normalR/255.0f green:normalG/255.0f blue:normalB/255.0f alpha:1.0f]];
		[lblTitle setTextAlignment:NSTextAlignmentLeft];
        [lblTitle setLineBreakMode:NSLineBreakByCharWrapping];
        [lblTitle setNumberOfLines:1];
        [lblTitle setBackgroundColor:[UIColor clearColor]];
        [lblTitle setText:@""];
        [lblTitle setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
        [self addSubview:lblTitle];
		
        [self setCheckBoxLeftType];
        
        
		[self addTarget:self action:@selector(checkBoxClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(checkboxUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(checkBoxDown) forControlEvents:UIControlEventTouchDown];
	}
    return self;
}

- (void) checkBoxDown
{
    [lblTitle setTextColor:[UIColor colorWithRed:7/255.0f green:7/255.0f blue:7/255.0f alpha:1.0f]];
}

- (void) checkboxUpOutside
{
    [self showCurrentState];
}

-(void) checkBoxClicked
{
    
    if(self.isChecked == NO) {
		self.isChecked = YES;
	} else {
		self.isChecked = NO;
	}
    
    [self showCurrentState];
    
    if (self.delegate) {
        [self.delegate didClickCheckbox:self];
    }
}

- (void) setText:(NSString *)text
{
    [lblTitle setText:text];
}

- (void) setNormalTextColorWith:(float)r g:(float)g b:(float)b
{
    normalR = r;
    normalB = g;
    normalG = g;
}

- (void) setCheckedTextColorWith:(float)r g:(float)g b:(float)b
{
    activeR = r;
    activeG = g;
    activeB = b;
}


- (void) setFontWith:(NSString *)fontName size:(float)size
{
    [lblTitle setFont:[UIFont fontWithName:fontName size:size]];
    
    [self showCurrentState];
}


- (void) setChecked:(BOOL)checked
{
    isChecked = checked;
    [self showCurrentState];
}

- (void) showCurrentState
{
    if(self.isChecked == YES){
		[checkIcon setImage:[UIImage imageNamed:checkboxType ? @"checkbox-checked.png" : @"option-selected.png"]];
		[lblTitle setTextColor:[UIColor colorWithRed:activeR/255.0f green:activeG/255.0f blue:activeB/255.0f alpha:1.0f]];
	} else {
		[checkIcon setImage:[UIImage imageNamed:checkboxType ? @"checkbox-normal.png" : @"option-normal.png"]];
        [lblTitle setTextColor:[UIColor colorWithRed:normalR/255.0f green:normalG/255.0f blue:normalB/255.0f alpha:1.0f]];
	}
}

- (void) setCheckBoxRightType
{
	[self showCurrentState];
	[checkIcon setFrame:CGRectMake( self.frame.size.width - 29, 0, 29, 29 )];
}

- (void) setCheckBoxLeftType
{
	[self showCurrentState];
	[checkIcon setFrame:CGRectMake( 0, 0, 29, 29 )];
	
}



@end
