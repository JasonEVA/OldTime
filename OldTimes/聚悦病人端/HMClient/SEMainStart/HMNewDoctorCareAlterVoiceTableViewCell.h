//
//  HMNewDoctorCareAlterVoiceTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2017/6/14.
//  Copyright © 2017年 YinQ. All rights reserved.
//  首页医生关怀弹窗语音cell

#import <UIKit/UIKit.h>
typedef void(^playVoice)();

@interface HMNewDoctorCareAlterVoiceTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *voiceImages;          //语音图标
- (void)playVoiceClickBlock:(playVoice)block;
- (void)fillDataWithVoiceLenth:(NSString *)lenth;
@end
