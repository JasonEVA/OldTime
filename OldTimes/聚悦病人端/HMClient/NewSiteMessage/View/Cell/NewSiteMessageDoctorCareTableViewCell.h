//
//  NewSiteMessageDoctorCareTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2017/2/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//  站内信 医生关怀cell

#import "NewSiteMessageBubbleBaseTableViewCell.h"
#import "SiteMessageLastMsgModel.h"

typedef void(^playVoice)();
typedef void(^ConcernImageClickBlock)(NSArray *imagesArr,NSIndexPath *concernIndexPath);

@interface NewSiteMessageDoctorCareTableViewCell : NewSiteMessageBubbleBaseTableViewCell
@property (nonatomic, strong) UIImageView *voiceImages;          //语音图标

- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model;
- (void)playVoiceClickBlock:(playVoice)block;
- (void)imageClick:(ConcernImageClickBlock)block;

@end
