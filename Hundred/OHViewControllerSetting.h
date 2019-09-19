//
//  OHViewControllerSetting.h
//  OneHundred
//
//  Created by Вадим on 13.07.14.
//  Copyright (c) 2014 Вадим. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHViewController.h"


@interface OHViewControllerSetting : OHViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutletCollection(UIToolbar) NSArray *toolBars;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *labelAudio;
@property (weak, nonatomic) IBOutlet UILabel *label6d;
@property (weak, nonatomic) IBOutlet UILabel *label3d;

@property (weak, nonatomic) IBOutlet UILabel *labelDesk6d;
@property (weak, nonatomic) IBOutlet UILabel *labelDesk3d;
@property (weak, nonatomic) IBOutlet UILabel *labelDeskFunction;

@property (weak, nonatomic) IBOutlet UISwitch *switchAudio;
@property (weak, nonatomic) IBOutlet UISwitch *switch6d;
@property (weak, nonatomic) IBOutlet UISwitch *switch3d;

@property (weak, nonatomic) IBOutlet UINavigationBar *iAdNavbar;
@property (weak, nonatomic) IBOutlet UIToolbar *iAdToolBarPursh;
@property (weak, nonatomic) IBOutlet UIToolbar *iAdToolBarOff;
@property (weak, nonatomic) IBOutlet UIView *iAdViewLoader;
@property (weak, nonatomic) IBOutlet UISwitch *iAdSwitch;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *iAdTitle;
- (IBAction)iAdPurshOn:(id)sender;
- (IBAction)iAdSwitchOff:(id)sender;


- (IBAction)switchActionAudio:(id)sender;
- (IBAction)switchAction6d:(id)sender;
- (IBAction)switchAction3d:(id)sender;

@end
