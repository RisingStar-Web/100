//
//  OHViewController.m
//  OneHundred
//
//  Created by Вадим on 12.07.14.
//  Copyright (c) 2014 Вадим. All rights reserved.
//

#import "OHViewController.h"


@interface OHViewController ()

@end


@implementation OHViewController

@synthesize resours;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setResours:[[OHResouces alloc] init]];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setOpaque:NO];
    CGRect _tmpRect = self.navigationController.navigationBar.frame;
    _tmpRect.origin.y = 20.0f;
    [self.navigationController.navigationBar setFrame:_tmpRect];
}

@end
