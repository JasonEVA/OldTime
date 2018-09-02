//
//  PrescribeSearchDrugViewController.h
//  HMDoctor
//
//  Created by lkl on 16/6/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMBasePageViewController.h"

@class DrugInfo;

@protocol PrescribeSearchDrugViewControllerDelegate <NSObject>

- (void)PrescribeSearchDrugViewControllerDelegateCallBack_cellClick:(DrugInfo *)model;

@end

@interface PrescribeSearchDrugViewController : HMBasePageViewController
@property (nonatomic, weak) id<PrescribeSearchDrugViewControllerDelegate> delegate;

@end

@protocol PrescribeSearchDrugTableViewControllerDelegate <NSObject>

- (void)PrescribeSearchDrugTableViewControllerDelegateCallBack_cellClick:(DrugInfo *)model;

@end
@interface PrescribeSearchDrugTableViewController : UITableViewController
@property (nonatomic, weak) id<PrescribeSearchDrugTableViewControllerDelegate> delegate;
@end