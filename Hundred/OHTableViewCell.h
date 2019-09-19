//
//  OHTableViewCell.h
//  OneHundred
//
//  Created by Вадим on 16.07.14.
//  Copyright (c) 2014 Вадим. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OHTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellDesk;
@property (weak, nonatomic) IBOutlet UIImageView *cellCheck;
@property (weak, nonatomic) IBOutlet UILabel *cellTemer;
@property (weak, nonatomic) IBOutlet UILabel *cellRate;

@end
