//
//  RoundedTextField.m
//  Rabbit
//
//  Created by subhashsanghani on 2/2/17.
//  Copyright © 2017 Rabbit. All rights reserved.
//

#import "RoundedTextField.h"

@implementation RoundedTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 15, bounds.origin.y + 8,
                      bounds.size.width - 30, bounds.size.height - 16);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}
-(void)awakeFromNib {
    self.text = AMLocalizedString(self.text, @"");
    self.placeholder = AMLocalizedString(self.placeholder, @"");
    self.adjustsFontSizeToFitWidth = YES;
    [self.layer setBorderWidth:1.0];
    [self.layer setCornerRadius:self.frame.size.height / 2];
    [self.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    /*if ([[LocalizationSystem sharedLocalSystem] isDirectionRTL]) {
        if (self.textAlignment == NSTextAlignmentNatural || self.textAlignment == NSTextAlignmentJustified) {
            [self setTextAlignment:NSTextAlignmentRight];
        }else if(self.textAlignment == NSTextAlignmentLeft){
            [self setTextAlignment:NSTextAlignmentRight];
        }
    }
     */
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.text = AMLocalizedString(self.text, @"");
        self.placeholder = AMLocalizedString(self.placeholder, @"");
        self.adjustsFontSizeToFitWidth = YES;
        [self.layer setBorderWidth:1.0];
        [self.layer setCornerRadius:self.frame.size.height / 2];
        [self.layer setBorderColor:[[UIColor colorWithRed:96.0/255.0 green:186.0/255.0 blue:122.0/255.0 alpha:1.0] CGColor]];
        /*if ([[LocalizationSystem sharedLocalSystem] isDirectionRTL]) {
            if (self.textAlignment == NSTextAlignmentNatural || self.textAlignment == NSTextAlignmentJustified) {
                [self setTextAlignment:NSTextAlignmentRight];
            }else if(self.textAlignment == NSTextAlignmentLeft){
                [self setTextAlignment:NSTextAlignmentRight];
            }
        }
         */
    }
    return self;
}
@end
