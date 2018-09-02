//
//  MissionListComponentModel.h
//  HMDoctor
//
//  Created by Dee on 16/6/9.
//  Copyright © 2016年 yinquan. All rights reserved.
//  MissionDetailModel中list字段对应的model

#import <Foundation/Foundation.h>

@interface MissionListComponentModel : NSObject

@property(nonatomic, copy) NSString  *name;

@property(nonatomic, copy) NSString  *body_show_id;

@property(nonatomic, copy) NSString  *body_t_status;

@property(nonatomic, copy) NSString  *url;

- (instancetype)initWithDict:(NSDictionary  *)dict;

@end
