//
//  LocalizeButton.m
//  Localization
//
//  Created by Dharmesh on 9/1/16.
//  Copyright © 2016 Sky Infoway. All rights reserved.
//

#import "LocalizeButton.h"

@implementation LocalizeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//added custum properities to button

-(void)awakeFromNib {
    [self setTitle:AMLocalizedString(self.titleLabel.text, @"") forState:UIControlStateNormal];
    //[self.titleLabel setText:AMLocalizedString(self.titleLabel.text, @"")];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    //[self.layer setCornerRadius:self.frame.size.height / 2];
    //self.titleLabel.font = [UIFont fontWithName:@"CoconNextArabic-Light" size:18];
}

@end
