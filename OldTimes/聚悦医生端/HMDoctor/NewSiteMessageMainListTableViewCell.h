//
//  NewSiteMessageMainListTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2016/10/31.
//  Copyright © 2016年 YinQ. All rights reserved.
//  第二版站内信主页面cell

#import <UIKit/UIKit.h>
@class SiteMessageSecondEditionMainListModel;


@interface NewSiteMessageMainListTableViewCell : UITableViewCell
//站内信主页数据源方法
- (void)fillDataWithModel:(SiteMessageSecondEditionMainListModel *)model;
@end
