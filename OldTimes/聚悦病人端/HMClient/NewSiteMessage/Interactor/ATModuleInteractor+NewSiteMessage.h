//
//  ATModuleInteractor+NewSiteMessage.h
//  HMClient
//
//  Created by jasonwang on 2016/10/31.
//  Copyright © 2016年 YinQ. All rights reserved.
//  新站内信跳转类

#import "ATModuleInteractor.h"
#import "NewSiteMessageDrugModel.h"

@class SiteMessageSecondEditionMainListModel;
@interface ATModuleInteractor (NewSiteMessage)
//跳转站内信主页
- (void)gotoNewSiteMessageMainListVC;
//跳转各种类型消息列表
- (void)gotoTypeVCWithType:(SiteMessageSecondEditionMainListModel *)model;
//用药详情列表
- (void)gotoMedicalListVCWithDataList:(NSArray<NewSiteMessageDrugModel *> *)datalist;
//药品详情
- (void)gotoMedicalDetailVC;

@end
