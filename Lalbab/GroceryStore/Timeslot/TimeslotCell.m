//
//  TimeslotCell.m
//  Rabbit
//
//  Created by subhashsanghani on 2/4/17.
//  Copyright © 2017 Rabbit. All rights reserved.
//

#import "TimeslotCell.h"

@implementation TimeslotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _lblTime.layer.shadowOffset = CGSizeMake(0.0,-1.0);
    _lblTime.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    _lblTime.layer.shadowRadius = 4.0f;
    _lblTime.layer.cornerRadius = 4.0f;
    _lblTime.layer.masksToBounds = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
