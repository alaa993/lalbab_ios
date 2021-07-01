//
//  LocalizeLabel.m
//  Localization
//
//  Created by Dharmesh on 9/1/16.
//  Copyright © 2016 Sky Infoway. All rights reserved.
//

#import "LocalizeLabel.h"

@implementation LocalizeLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib {
    self.text = AMLocalizedString(self.text, @"");
    self.adjustsFontSizeToFitWidth = YES;
    //self.font = [UIFont fontWithName:@"CoconNextArabic-Light" size:18];
   
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.text = AMLocalizedString(self.text, @"");
        self.adjustsFontSizeToFitWidth = YES;
        //self.font = [UIFont fontWithName:@"CoconNextArabic-Light" size:18];
    }
    return self;
}

@end
