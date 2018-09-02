//
//  NewSiteMessageRoundsStatusModel.h
//  HMClient
//
//  Created by jasonwang on 2017/2/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//  新版站内信查房、随访消息状态model

#import <Foundation/Foundation.h>

@interface NewSiteMessageRoundsStatusModel : NSObject
@property (nonatomic, copy) NSString *replyUrl; //
@property (nonatomic) NSInteger replyStatus;    //查房： 回复结果,状态为：0:否-无症状，1:是-正在问卷 2已删除或已过期 3未填写症状 4已填写问卷 ,只有 是 1和4 才有replyUrl

//随访：回复结果,状态为：1:已填写 2已删除 3未填写 4医生已答复
@end
