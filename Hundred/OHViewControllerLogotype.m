//
//  OHViewControllerLogotype.m
//  OneHundred
//
//  Created by Вадим on 03.08.14.
//  Copyright (c) 2014 Вадим. All rights reserved.
//

#import "OHViewControllerLogotype.h"
#import "OHUtils.h"


@interface OHViewControllerLogotype ()
{
    NSTimer *_timer;
    int _iii;
}

@end


@implementation OHViewControllerLogotype

- (void)viewDidLoad
{
    [super viewDidLoad];
    _iii = 1;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.03f target:self selector:@selector(onStart) userInfo:nil repeats:YES];
}

- (void)onStart
{
    if (_iii < 100) {
        [self.labelTick setText:[NSString stringWithFormat:@"%d", _iii]];
    } else if (_iii >= 120) {
        [_timer invalidate];
        _timer = nil;
        UINavigationController* rootNav = [self.storyboard instantiateViewControllerWithIdentifier:@"rootNav"];

        /*  */
        NSDictionary *_setting = [OHUtils getSetting];
        NSInteger run = [[_setting objectForKey:@"run"] integerValue];
        if (run != -1) {
            if (run != 0){
                if ((unsigned long int)([[NSDate date] timeIntervalSince1970]) - run >= 1296000) {
                    [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(viewAlertS) userInfo:nil repeats:NO];
                }
            } else {
                [OHUtils writeSettingName:@"run" value:[NSNumber numberWithInteger:1]];
            }
        }
        /*  */

        
        [self presentViewController:rootNav animated:YES completion:nil];
    }
    _iii += 1;
}

- (void)viewAlertS
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"pleas", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"later", nil) otherButtonTitles:NSLocalizedString(@"like", nil), NSLocalizedString(@"nolike", nil), nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [NSTimer scheduledTimerWithTimeInterval:3600.0f target:self selector:@selector(viewAlertS) userInfo:nil repeats:NO];
    } else if(buttonIndex == 1) {
        [OHUtils writeSettingName:@"run" value:[NSNumber numberWithInteger:-1]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id911664850"]];
    } else {
        [OHUtils writeSettingName:@"run" value:[NSNumber numberWithInteger:(unsigned long int)([[NSDate date] timeIntervalSince1970])]];
    }
}

@end

