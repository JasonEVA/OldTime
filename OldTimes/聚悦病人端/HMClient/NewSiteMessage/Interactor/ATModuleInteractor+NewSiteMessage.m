//
//  ATModuleInteractor+NewSiteMessage.m
//  HMClient
//
//  Created by jasonwang on 2016/10/31.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ATModuleInteractor+NewSiteMessage.h"
#import "NewSiteMessageMainListViewController.h"
#import "NewSiteMessageItemListViewController.h"
#import "NewSiteMessageMedicalUseListViewController.h"
#import "MDSDrugDetailViewController.h"
#import "SiteMessageSecondEditionMainListModel.h"

@implementation ATModuleInteractor (NewSiteMessage)
- (void)gotoNewSiteMessageMainListVC {
    NewSiteMessageMainListViewController *VC = [NewSiteMessageMainListViewController new];
    [self pushToVC:VC];
}

- (void)gotoTypeVCWithType:(SiteMessageSecondEditionMainListModel *)model {
    NewSiteMessageItemListViewController *VC = [[NewSiteMessageItemListViewController alloc] initWithSiteType:model];
    [self pushToVC:VC];
}

- (void)gotoMedicalListVCWithDataList:(NSArray<NewSiteMessageDrugModel *> *)datalist {
    NewSiteMessageMedicalUseListViewController *VC = [NewSiteMessageMedicalUseListViewController new];
    VC.dataList = datalist;
    [self pushToVC:VC];
}

- (void)gotoMedicalDetailVC {
    MDSDrugDetailViewController *VC = [MDSDrugDetailViewController new];
    [self pushToVC:VC];
}
@end
