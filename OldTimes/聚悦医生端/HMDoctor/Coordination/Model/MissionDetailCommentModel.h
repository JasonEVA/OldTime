//
//  MissionDetailCommentModel.h
//  HMDoctor
//
//  Created by kylehe on 16/6/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//  任务评论Model－－暂时无用

#import <Foundation/Foundation.h>

@interface MissionDetailCommentModel : NSObject

@property(nonatomic, copy) NSString  *taskTitle;

@property(nonatomic, copy) NSString  *taskShowId;

@property(nonatomic, copy) NSString  *content;

@property(nonatomic, copy) NSString  *createUser;

@property(nonatomic, copy) NSString  *createUserName;


@end
