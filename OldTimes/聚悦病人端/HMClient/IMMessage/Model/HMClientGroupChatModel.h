//
//  HMClientGroupChatModel.h
//  HMClient
//
//  Created by jasonwang on 16/9/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//  病人端聊天界面所需数据model

#import <Foundation/Foundation.h>
@interface HMClientGroupChatModel : NSObject

@property (nonatomic, retain) NSString* teamName;
@property (nonatomic) NSInteger teamStaffId;
@property (nonatomic, retain) NSNumber* numTeamId;
@property (nonatomic, retain) NSArray* staffs;
@property (nonatomic, strong) NSString *grouptargetId;
@end
