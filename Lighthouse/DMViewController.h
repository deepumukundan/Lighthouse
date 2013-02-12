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

// Properties
@property (weak, nonatomic) IBOutlet UIStepper *firingIntervalStepper;
@property (weak, nonatomic) IBOutlet UILabel *fireInterval;
@property (weak, nonatomic) IBOutlet UISwitch *soundToggle;
@property (weak, nonatomic) IBOutlet UISwitch *lightsToggle;
@property (weak, nonatomic) IBOutlet UISwitch *motionToggle;

@property (weak, nonatomic) IBOutlet UILabel *counterLabel;

// Methods
- (IBAction)touchDetected:(UITapGestureRecognizer *)sender;
- (IBAction)reportVerticalSwipe:(UISwipeGestureRecognizer *)sender;
- (IBAction)reportHorizontalSwipe:(UISwipeGestureRecognizer *)sender;
- (IBAction)stepperPressed:(UIStepper *)sender;

@end
