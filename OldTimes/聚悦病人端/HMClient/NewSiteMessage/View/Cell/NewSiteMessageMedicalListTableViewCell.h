//
//  NewSiteMessageMedicalListTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2016/11/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//  站内信用药详情列表cell

#import <UIKit/UIKit.h>
#import "NewSiteMessageDrugModel.h"

@interface NewSiteMessageMedicalListTableViewCell : UITableViewCell
- (void)fillDataWithModel:(NewSiteMessageDrugModel *)model;
@end
