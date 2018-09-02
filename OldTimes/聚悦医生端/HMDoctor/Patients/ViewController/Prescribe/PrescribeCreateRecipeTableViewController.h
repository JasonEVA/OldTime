//
//  PrescribeCreateRecipeTableViewController.h
//  HMDoctor
//
//  Created by lkl on 16/6/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientInfo.h"

@class DrugInfo;
typedef void(^deleteClick)();

@interface PrescribeCreateRecipeTableViewController : UITableViewController

@property (nonatomic, copy) NSString *userRecipeId;
@property (nonatomic, strong) PatientInfo *patientinfo;
@property (nonatomic, copy) NSString *testResulId;
@property (nonatomic, strong) NSMutableArray *prescribeDetailList;
// 保存处方
- (void)saveButtonClick;
// 保存为模板通知事件
- (void)saveToTemplateBtnClicked;
//添加药品
- (void)addDrug:(DrugInfo *)drug;
//选择模板
- (void)selectDrugTemplate:(NSString *)modelID;

// 删除回调
- (void)deleteCallBack:(deleteClick)block;
@end
