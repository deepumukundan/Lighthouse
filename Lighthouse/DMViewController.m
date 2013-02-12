//
//  DMViewController.m
//  Lighthouse
//
//  Created by Deepu Mukundan on 2/11/13.
//
//

#import "DMViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "SoundEffect.h"

@interface DMViewController()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation DMViewController {
    int vibrateCount;
    BOOL torchOn;
    SoundEffect *soundEffect;
    MBProgressHUD *hud;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    vibrateCount = [self.counterLabel.text integerValue];
    torchOn = NO;
    soundEffect = [[SoundEffect alloc] initWithSoundNamed:@"laser.wav"];
    self.fireInterval.text = [NSString stringWithFormat:@"%0.1f s",self.firingIntervalStepper.value];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.timer = nil;
}

#pragma mark - Utility methods
- (void)showStartupHud{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Starting up...";
    hud.delegate = self;
    [hud showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}

- (void)myProgressTask {
    // This just increases the progress indicator in a loop
	float progress = 0.0f;
	while (progress < 1.0f) {
		progress += 0.01f;
		hud.progress = progress;
		usleep(14000);
	}
    
    // After the hud is dissolved, start the lighthouse
    if (hud.progress >= 1.0f) {
        dispatch_async(dispatch_get_main_queue(), ^{[self startFiringFlashes];});
    }
}

- (void)startFiringFlashes {
    // A timer is created which will start the looping
    double interval = self.firingIntervalStepper.value;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                  target:self
                                                selector:@selector(processLoop)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)processLoop{
    if (vibrateCount > 0) {
        // Make a noise
        if (self.soundToggle.on) 
            [soundEffect play];
        
        // Vibrate once
        if (self.motionToggle.on)
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        // Flash on/off
        if (self.lightsToggle.on)
            [self toggleTorch];
        
        // Decrement the label showing remaining loops
        self.counterLabel.text = [NSString stringWithFormat:@"%d",--vibrateCount];
    } else {
        [self resetProcessing];
    }
}

- (void)toggleTorch {
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn])
    {
        BOOL success = [flashLight lockForConfiguration:nil];
        if(success)
        {
            if (!torchOn) {
                [flashLight setTorchMode:AVCaptureTorchModeOn];
                torchOn = YES;
            } else {
                [flashLight setTorchMode:AVCaptureTorchModeOff];
                torchOn = NO;
            }
            [flashLight unlockForConfiguration];
        }
    }
}

- (void)resetProcessing{
    // Reset the timer
    [self.timer invalidate];
    self.timer = nil;
    // Reset the flash is already on
    if (torchOn) {
        [self toggleTorch];
    }
    // Reset the label
    self.counterLabel.text = @"0";
    // Reset the iVar tracking the counts
    vibrateCount = 0;
}

#pragma mark - UIGestureRecognizer delegate methods
- (IBAction)reportVerticalSwipe:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        vibrateCount = ++vibrateCount;
    } else if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        if (vibrateCount > 0)
            vibrateCount = --vibrateCount;
    }
    self.counterLabel.text = [NSString stringWithFormat:@"%d",vibrateCount];
}

- (IBAction)reportHorizontalSwipe:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self resetProcessing];
    }
}

#pragma mark - User methods
- (IBAction)touchDetected:(UITapGestureRecognizer *)sender {
    [self showStartupHud];
}

- (IBAction)stepperPressed:(UIStepper *)sender {
    self.fireInterval.text = [NSString stringWithFormat:@"%0.1f s",sender.value];
}

@end
