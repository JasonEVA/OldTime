//
//  MessageBaseModel+missionModelTranslate.h
//  HMDoctor
//
//  Created by kylehe on 16/6/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//  解析数据聊天任务数据  只解析最内层的content

#import <MintcodeIMKit/MintcodeIMKit.h>
@class MissionDetailModel;
@class MessageBaseModel;
@interface MessageBaseModel (missionModelTranslate)

+ (MissionDetailModel *)getDetailModelWithContent:(MessageBaseModel *)content;

@end
