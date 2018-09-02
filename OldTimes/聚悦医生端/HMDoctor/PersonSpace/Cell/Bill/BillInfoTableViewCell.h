//
//  BillInfoTableViewCell.h
//  HMDoctor
//
//  Created by lkl on 16/6/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillInfo.h"

@interface TotalBillTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *iconBtn;

- (void)setBillSum:(NSString *)billSum;
- (void)setTime:(NSString *)time;

@end

@interface BillInfoTableViewCell : UITableViewCell

- (void) setBillInfoValue:(BillInfo *)billinfo;
@end

@interface BillConfirmTableViewCell : UITableViewCell

@end