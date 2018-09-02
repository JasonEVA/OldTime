//
//  PEFResultValueTableViewCell.h
//  HMClient
//
//  Created by lkl on 2017/6/9.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEFResultModel.h"

@interface PEFResultValueTableViewCell : UITableViewCell

- (void)setDataList:(PEFResultdataListModel *)model;

@end

@interface PEFResultHistoryTableViewCell : UITableViewCell

- (void)setPEFResult:(PEFResultModel *)model;

@end
