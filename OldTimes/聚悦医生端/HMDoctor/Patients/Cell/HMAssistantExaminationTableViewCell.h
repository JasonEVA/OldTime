//
//  HMAssistantExaminationTableViewCell.h
//  HMDoctor
//
//  Created by lkl on 2017/3/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMGetCheckImgListModel.h"

@interface HMAssistantExaminationTableViewCell : UITableViewCell

@property (nonatomic, weak) UIViewController *ownerViewController;

- (void)setCheckImgList:(HMGetCheckImgListModel *)model;

@end
