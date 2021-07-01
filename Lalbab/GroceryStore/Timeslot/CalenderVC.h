//
//  CalenderVC.h
//  cbkmobiletest
//
//  Created by subhashsanghani on 12/1/16.
//  Copyright © 2016 com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>
#import "BaseVC.h"
@interface CalenderVC : BaseVC<JTCalendarDelegate>
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (weak, nonatomic) IBOutlet UIButton *btnChooseDate;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (assign, readwrite) NSString *allow_current_date;
//@property (assign, nonatomic) NSDate *fromDate;
//@property (assign, nonatomic) NSDate *toDate;
//@property (assign, nonatomic) NSString *source;
@end
