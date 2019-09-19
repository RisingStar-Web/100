//
//  OHViewControllerSetting.m
//  OneHundred
//
//  Created by Вадим on 13.07.14.
//  Copyright (c) 2014 Вадим. All rights reserved.
//

#import "OHViewControllerSetting.h"
#import "OHTableViewCell.h"
#import "OHUtils.h"
#import "SoundManager.h"
#import "RageProductPurchased.h"

@interface OHViewControllerSetting ()
{
    NSMutableDictionary *_dataSett;
    NSArray *_calcSumbol;
    NSArray *_products;
}

@end


@implementation OHViewControllerSetting

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([OHUtils getVersion] < 7.0) {
        for (UIToolbar *toolBar in self.toolBars) {
            [toolBar.layer setMasksToBounds:YES];
            [toolBar.layer setShadowOpacity:0.0f];
        }
    }

    [self.navigationItem setTitle:NSLocalizedString(@"TopSetting", nil)];
    [self.navigationController.navigationBar.topItem setTitle:NSLocalizedString(@"BackGame", nil)];
    
    [self.labelAudio setText:NSLocalizedString(@"SetAudio", nil)];
    [self.label6d setText:NSLocalizedString(@"6digits", nil)];
    [self.label3d setText:NSLocalizedString(@"3digits", nil)];
    
    [self.labelDesk6d setText:NSLocalizedString(@"6digitsDesck", nil)];
    [self.labelDesk3d setText:NSLocalizedString(@"3digitsDesck", nil)];
    [self.labelDeskFunction setText:NSLocalizedString(@"Function", nil)];

    _calcSumbol = [[NSArray alloc] initWithObjects:@"+", @"–", @"×", @"÷", @"^", nil];
    _dataSett = [OHUtils getSetting];
    [self.switchAudio setOn:[[_dataSett objectForKey:@"audio_param"] boolValue]];
    [self.switch6d setOn:[[_dataSett objectForKey:@"six_or_three_digits"] boolValue]];
    [self.switch3d setOn:![[_dataSett objectForKey:@"six_or_three_digits"] boolValue]];

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0f, 0.0f, _contentView.frame.size.height, 0.0f);
    [_scrollView setContentInset:contentInsets];
    
    [self.iAdViewLoader setHidden:YES];
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPad"] || [deviceType isEqualToString:@"iPad Simulator"]){
    } else {
        if ([[_dataSett objectForKey:@"iAd"] boolValue] == YES){
            [[RageProductPurchased sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
                if (success) {
                    _products = products;
                    SKProduct *product = [_products objectAtIndex:0];
                    [self.iAdTitle setTitle:[[NSString alloc] initWithFormat:@"%@ %0.2f", NSLocalizedString(@"iAd", nil), product.price.floatValue]];
                    [self.iAdNavbar setHidden:NO];
                    [self.iAdToolBarOff setHidden:NO];
                    [self.iAdToolBarPursh setHidden:NO];
                } else {
                    [self.iAdNavbar setHidden:YES];
                    [self.iAdToolBarOff setHidden:YES];
                    [self.iAdToolBarPursh setHidden:YES];
                    [self.iAdViewLoader setHidden:YES];
                }
            }];
        }
        [[RageProductPurchased sharedInstance] setLoaderView:self.iAdViewLoader];
        [[RageProductPurchased sharedInstance] setIdSettinSwitch:self.iAdSwitch];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[_dataSett objectForKey:@"iAd"] boolValue] == YES) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellFun"];
    cell.cellDesk.text = [_calcSumbol objectAtIndex:[indexPath row]];
    [cell.cellCheck setHidden:![[[_dataSett objectForKey:@"functions"] objectAtIndex:[indexPath row]] boolValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OHTableViewCell *cell = (OHTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    BOOL _st_ = [[[_dataSett objectForKey:@"functions"] objectAtIndex:[indexPath row]] boolValue];
    [cell.cellCheck setHidden:_st_];
    
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray:[_dataSett objectForKey:@"functions"]];
    [tmp replaceObjectAtIndex:[indexPath row] withObject:[NSNumber numberWithBool:!_st_]];
    [OHUtils writeSettingName:@"functions" value: [[NSArray alloc] initWithArray:tmp]];
    [_dataSett setObject:[[NSArray alloc] initWithArray:tmp] forKey:@"functions"];
}

- (IBAction)switchActionAudio:(id)sender {
    BOOL _st_ = [(UISwitch*)sender isOn];
    [OHUtils writeSettingName:@"audio_param" value:[NSNumber numberWithBool:_st_]];
    if (_st_) {
        [SoundManager sharedManager].musicVolume = 0.9f;
        [SoundManager sharedManager].soundVolume = 1.0f;
    } else {
        [SoundManager sharedManager].musicVolume = 0.0f;
        [SoundManager sharedManager].soundVolume = 0.0f;
    }
}

- (IBAction)switchAction6d:(id)sender {
    if ([(UISwitch*)sender isOn]) {
        [self.switch3d setOn:NO animated:YES];
    } else {
        [self.switch3d setOn:YES animated:YES];
    }
    [OHUtils writeSettingName:@"six_or_three_digits" value:[NSNumber numberWithBool:[(UISwitch*)sender isOn]]];
}

- (IBAction)switchAction3d:(id)sender {
    if ([(UISwitch*)sender isOn]) {
        [self.switch6d setOn:NO animated:YES];
    } else {
        [self.switch6d setOn:YES animated:YES];
    }
    [OHUtils writeSettingName:@"six_or_three_digits" value:[NSNumber numberWithBool:![(UISwitch*)sender isOn]]];
}

/* iAd */
- (IBAction)iAdPurshOn:(id)sender {
    [self.iAdViewLoader setHidden: NO];
    [[RageProductPurchased sharedInstance] restoreCompletedTransactions];
}
- (IBAction)iAdSwitchOff:(id)sender {
    if ([(UISwitch*)sender isOn] == NO && _products != nil) {
        [self.iAdViewLoader setHidden: NO];
        SKProduct *product = [_products objectAtIndex:0];
        [[RageProductPurchased sharedInstance] buyProduct:product];
    }
}
- (void)productPurchased:(NSNotification *)notification {
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            [self.iAdViewLoader setHidden:YES];
            [self.iAdNavbar setHidden:YES];
            [self.iAdToolBarOff setHidden:YES];
            [self.iAdToolBarPursh setHidden:YES];
            [OHUtils writeSettingName:@"iAd" value:[NSNumber numberWithBool:NO]];
            *stop = YES;
        }
    }];
}
/* =========== */

@end
