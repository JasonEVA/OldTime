//
//  HMPopupSelectViewController.h
//  HMClient
//
//  Created by lkl on 2017/6/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BloodPressureThriceDetectModel.h"

typedef void(^PopupSelectBlock)(BloodPressureThriceDetectModel* model);

@interface HMPopupSelectViewController : UIViewController

+ (HMPopupSelectViewController *)createWithParentViewController:(UIViewController*) parentviewcontroller kpiCode:(NSString *)kpiCode dataList:(NSArray *)dataList selectblock:(PopupSelectBlock)block;

@property (nonatomic, copy) PopupSelectBlock selectblock;
@property (nonatomic, copy) NSArray *dataList;

//- (void)requestDataList:(NSString *)kpiCode;
- (void)createTableView;

@end
