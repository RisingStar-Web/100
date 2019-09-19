//
//  OHViewControllerGameView.h
//  OneHundred
//
//  Created by Вадим on 12.07.14.
//  Copyright (c) 2014 Вадим. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <GameKit/GameKit.h>
#import "OHViewController.h"
#import "OHUtils.h"
#import "SoundManager.h"

@interface OHViewControllerGameView : OHViewController <ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UILabel *labelResult;
@property (weak, nonatomic) IBOutlet UILabel *labelTick;
@property (weak, nonatomic) IBOutlet UILabel *labelGameStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelEndScet;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelsDisplay;
@property (weak, nonatomic) IBOutlet UIImageView *lineSeparator;
@property (weak, nonatomic) IBOutlet UILabel *labelResultLeft;
@property (weak, nonatomic) IBOutlet UILabel *labelResultRight;
@property (weak, nonatomic) IBOutlet UILabel *labelColLeft;
@property (weak, nonatomic) IBOutlet UILabel *labelColRight;
@property (weak, nonatomic) IBOutlet UILabel *labelSeparatorEqually;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timerConstain;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *actionCalculators;

- (IBAction)refreshAction:(id)sender;
- (IBAction)topAction:(id)sender;

@end
