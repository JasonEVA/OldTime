//
//  ServiceGoodsInfoTableViewCell.h
//  HMDoctor
//
//  Created by lkl on 16/11/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceInfo.h"

@interface ServiceGoodsInfoTableViewCell : UITableViewCell

@property (nonatomic, retain) UIControl *scanButton;
- (void) setServiceGoodsInfo:(ServiceInfo*) service;

@end
