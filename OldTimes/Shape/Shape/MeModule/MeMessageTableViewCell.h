//
//  MeMessageTableViewCell.h
//  Shape
//
//  Created by jasonwang on 15/10/21.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeGetUserInfoModel.h"

@interface MeMessageTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *myImageView;
- (void)setMyData:(MeGetUserInfoModel *)model;

@end
