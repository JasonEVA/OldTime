//
//  DealUserWarningTableViewCell.h
//  HMDoctor
//
//  Created by lkl on 16/12/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAlertInfo.h"

@interface DealUserWarningTableViewCell : UITableViewCell

- (void)setWarningRecordInfo:(UserWarningRecord *)record;
@end

@interface SelectDealUserWarningTableViewCell : UITableViewCell

- (void)setNameTitle:(NSString *)title;
@end
