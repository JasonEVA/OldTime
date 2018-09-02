//
//  NewSiteMessageMonitorRemindModel.h
//  HMClient
//
//  Created by jasonwang on 2016/11/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//  站内信监测提醒model


#import <Foundation/Foundation.h>

@interface NewSiteMessageMonitorRemindModel : NSObject

@property (nonatomic, copy) NSString *msgTitle;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *kpiTitle;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *kpiCode;

@end
