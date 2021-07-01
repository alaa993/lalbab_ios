#import <UIKit/UIKit.h>
#import "BaseVC.h"
@interface RegisterVC : BaseVC
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtEmailId;


@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;

@property (weak, nonatomic) IBOutlet UILabel *lb_code;

@property (weak, nonatomic) IBOutlet UILabel *lb_name;

@property (weak, nonatomic) IBOutlet UILabel *lb_phone;

@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *mobile;
@property (nonatomic, retain) NSString *token;

- (IBAction)CodeBT:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *textCodeR;



@end
