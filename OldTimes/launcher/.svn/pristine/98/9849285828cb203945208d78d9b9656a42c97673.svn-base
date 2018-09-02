//
//  MeetingJoinPersonModel.h
//  launcher
//
//  Created by Andrew Shen on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  参会人员状态model

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PersonJoinState) {
    join_no,
    join_yew,
    join_unSure
};
@interface MeetingJoinPersonModel : NSObject

@property (nonatomic, copy  ) NSString *name;
/** 账号名 */
@property (nonatomic, copy  ) NSString *NANE;
@property (nonatomic, assign) PersonJoinState ISJOIN;// 参与状态

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
