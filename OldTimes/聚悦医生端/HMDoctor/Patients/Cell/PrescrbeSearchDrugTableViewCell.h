//
//  PrescrbeSearchDrugTableViewCell.h
//  HMDoctor
//
//  Created by lkl on 16/6/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrugInfo.h"

@interface PrescrbeSearchDrugTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *addBtn;

- (void)setDrugInfo:(DrugInfo *)info;

@end
