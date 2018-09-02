//
//  NewSiteMessageItemListViewController.h
//  HMClient
//
//  Created by jasonwang on 2016/10/31.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMBasePageViewController.h"
@class SiteMessageSecondEditionMainListModel;
@interface NewSiteMessageItemListViewController : HMBasePageViewController
- (instancetype)initWithSiteType:(SiteMessageSecondEditionMainListModel *)model;
@end
