//
//  BillDetailTableViewCell.h
//  HMDoctor
//
//  Created by lkl on 16/6/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillInfo.h"

@interface BillMoneyTableViewCell : UITableViewCell

- (void)setBillDetailInfo:(BillInfo *)billinfo;

@end

@interface BillServiceNameTableViewCell : UITableViewCell

- (void)setBillDetailInfo:(BillInfo *)billinfo;

@end

@interface BillDetailTableViewCell : UITableViewCell

- (void)setBillDetailInfo:(BillInfo *)billinfo;

@end


