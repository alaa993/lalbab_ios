//
//  LocalizeButton2.m
//  Rabbit
//
//  Created by subhashsanghani on 2/3/17.
//  Copyright © 2017 Rabbit. All rights reserved.
//

#import "LocalizeButton2.h"

@implementation LocalizeButton2

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib {
    [self setTitle:AMLocalizedString(self.titleLabel.text, @"") forState:UIControlStateNormal];
    //self.titleLabel.font = [UIFont fontWithName:@"CoconNextArabic-Light" size:20];
}
@end
