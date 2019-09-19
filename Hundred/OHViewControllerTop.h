//
//  OHViewControllerTop.h
//  OneHundred
//
//  Created by Вадим on 02.08.14.
//  Copyright (c) 2014 Вадим. All rights reserved.
//

#import "OHViewController.h"
#import <GameKit/GameKit.h>

@interface OHViewControllerTop : OHViewController <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmented6d3;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedRep;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

- (IBAction)segmentedChangeds:(id)sender;

@end
