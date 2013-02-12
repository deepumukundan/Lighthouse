//
//  DMViewController.h
//  Lighthouse
//
//  Created by Deepu Mukundan on 2/11/13.
//
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface DMViewController : UIViewController <MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UILabel *counterLabel;
@property (weak, nonatomic) IBOutlet UISwitch *soundToggle;
@property (weak, nonatomic) IBOutlet UILabel *fireInterval;

- (IBAction)touchDetected:(UITapGestureRecognizer *)sender;
- (IBAction)reportVerticalSwipe:(UISwipeGestureRecognizer *)sender;
- (IBAction)reportHorizontalSwipe:(UISwipeGestureRecognizer *)sender;
- (IBAction)stepperPressed:(UIStepper *)sender;

@end
