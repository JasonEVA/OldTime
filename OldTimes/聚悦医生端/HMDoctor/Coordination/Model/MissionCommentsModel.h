//
//  MissionCommentsModel.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//  任务评价model

#import <Foundation/Foundation.h>

@interface MissionCommentsModel : NSObject

@property (nonatomic, assign)  NSInteger  cIsDelete;
@property (nonatomic, copy)  NSString  *createTime;
@property (nonatomic, assign)  NSInteger  createUser;
@property (nonatomic, copy)  NSString  *createUserName;
@property (nonatomic, assign)  NSInteger  iD;
@property (nonatomic, copy)  NSString  *imgUrl;
@property (nonatomic, copy)  NSString  *showId;
@property (nonatomic, copy)  NSString  *tContent;
@property (nonatomic, assign)  NSInteger  tMessageType;
@property (nonatomic, copy)  NSString  *tShowId; // 任务ID

@end


@interface MissionCommentListModel : NSObject

@property (nonatomic, assign)  NSInteger  count; // <##>
@property (nonatomic, copy)  NSArray<MissionCommentsModel *>  *list; // <##>
@end