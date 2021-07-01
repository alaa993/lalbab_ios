//
//  CalenderVC.m
//  cbkmobiletest
//
//  Created by subhashsanghani on 12/1/16.
//  Copyright © 2016 com. All rights reserved.
//

#import "CalenderVC.h"
#import "Languge.h"
#import "Common.h"


@interface CalenderVC ()
{
   
    NSDate *current_date;
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    
    NSDate *_dateSelected;
}
@end

@implementation CalenderVC
@synthesize allow_current_date;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedStrings(@"Choose Date", nil);
    [self setActionbarLogo];
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    current_date = [NSDate date];
    if ([allow_current_date isEqualToString:@"false"]) {
        current_date = [current_date dateByAddingTimeInterval:(24*3600)];
    }
    [_calendarManager setDate:current_date];
    
    // Generate random events sort by date using a dateformatter for the demonstration
    
    
    // Create a min and max date for limit the calendar, optional
    [self createMinAndMaxDate];
    [_calendarManager reload];
    _dateSelected = current_date;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons callback

- (IBAction)didGoTodayTouch
{
    [[NSUserDefaults standardUserDefaults] setObject:_dateSelected forKey:@"selected_date"];
    [self.navigationController popViewControllerAnimated:true];
    [_calendarManager setDate:_todayDate];
    //[self getTimeSlot];
}
-(IBAction)chooseDateConfirm:(id)sender{
    [[NSUserDefaults standardUserDefaults] setObject:_dateSelected forKey:@"selected_date"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"selected_time"];
    [self.navigationController popViewControllerAnimated:true];
    //[self getTimeSlot];
}
-(NSString*)getStringDateFormate:(NSDate*)date{
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
   
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
     [format setLocale:usLocale];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString* finalDateString = [format stringFromDate:date];
    
    
    return finalDateString;
}
/*-(void)getTimeSlot{
    //NSLog(@"date : %@",self.selected_date);
    NSDictionary *dictParams = @{
                                 @"date": [self getStringDateFormate:_dateSelected]
                                 };
    [self postResponseFromURL:[self getStringURLForAPI:URL_API_TIMESLOT] withParams:[[NSMutableDictionary alloc] initWithDictionary:dictParams] progrss:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, bool isSuccess) {
        if ([[responseObject objectForKey:PARAM_RESPONSE] intValue] == 1) {
            NSMutableArray *timeSlotArray = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"times"]];
            if(timeSlotArray != nil && [timeSlotArray count] > 0){
                [[NSUserDefaults standardUserDefaults] setObject:_dateSelected forKey:@"selected_date"];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"selected_time"];
                [self.navigationController popViewControllerAnimated:true];
            }else{
                [self showAlertForTitle:@"Error!" withMessage:@"No Timeslot Available for this date"];
            }
            
        }
        else{
            [self showAlertForTitle:@"Failed" withMessage:[responseObject objectForKey:PARAM_ERROR]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    } showLoader:YES hideLoader:YES];
}
 */
- (IBAction)didChangeModeTouch
{
    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
    [_calendarManager reload];
    
    CGFloat newHeight = 300;
    if(_calendarManager.settings.weekModeEnabled){
        newHeight = 85.;
    }
    
    
    [self.view layoutIfNeeded];
}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    if([_calendarManager.dateHelper date:current_date isEqualOrBefore:dayView.date]){
        dayView.textLabel.textColor = [UIColor grayColor];
    }
    
    // Today
    if([_calendarManager.dateHelper date:current_date isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor lightGrayColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = PRIMARY_COLOR;
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    /*if([_source isEqualToString:@"from_date"]){
        if ( [_calendarManager.dateHelper date:dayView.date isTheSameDayThan:[NSDate date]]) {
            
        }else if ( [_calendarManager.dateHelper date:dayView.date isEqualOrAfter:[NSDate date]]) {
            [common setAlertView:NSLocalizedStrings(@"Date must be Current date or earlier date.", nil)];
            return ;
        }
       
    }else if([_source isEqualToString:@"to_date"]){
        if (_fromDate!=nil) {
            if ( [_calendarManager.dateHelper date:dayView.date isTheSameDayThan:_fromDate] || [_calendarManager.dateHelper date:dayView.date isTheSameDayThan:[NSDate date]]) {
                
            }else if ( [_calendarManager.dateHelper date:dayView.date isEqualOrBefore:_fromDate] ||  [_calendarManager.dateHelper date:dayView.date isEqualOrAfter:[NSDate date]]) {
                [common setAlertView:[NSString stringWithFormat:@"%@ %@. %@ %@",NSLocalizedStrings(@"Date must be between", nil),[common getStringDateFormate:_fromDate],NSLocalizedStrings(@"and", nil),[common getStringDateFormate:[NSDate date]]]];
                return ;
            }
        }else{
            [common setAlertView:NSLocalizedStrings(@"Please choose from Dater", nil)];
           
            return;
        }
    }
     */
    if (![_calendarManager.dateHelper date:dayView.date isTheSameDayThan:current_date] && [_calendarManager.dateHelper date:dayView.date isEqualOrBefore:current_date]) {
        [self showAlertForTitle:NSLocalizedStrings(@"Error!", nil) withMessage:NSLocalizedStrings(@"Date must be greater than current date", nil)];
        return ;
    }
    if([_calendarManager.dateHelper date:current_date isTheSameDayThan:dayView.date]){
        [_btnChooseDate setHidden:FALSE];
    }else{
        [_btnChooseDate setHidden:FALSE];
    }
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
    
    
    
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}

#pragma mark - Fake data

- (void)createMinAndMaxDate
{
    _todayDate = current_date;
    
    // Min date will be 2 month before today
    /*if(_fromDate!=nil)
        _minDate = _fromDate;
    else
        _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-24];
    */
    
    
    // Max date will be 2 month after today
    _minDate = _todayDate;// [_calendarManager.dateHelper addToDate:_todayDate months:2];
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:2];
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setLocale:usLocale];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}



@end
