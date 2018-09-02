//
//  HMHistoryCollectVoiceTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2017/1/4.
//  Copyright © 2017年 yinquan. All rights reserved.
//  历史记录收藏语音cell

#import "HMHistoryCollectBaseTableViewCell.h"
@class MessageBaseModel;

@interface HMHistoryCollectVoiceTableViewCell : HMHistoryCollectBaseTableViewCell
- (void)setDataWithModel:(MessageBaseModel *)model;
- (void)startPlayVoiceWithTime:(CGFloat)lenght;
- (void)stopPlayVoice;
@end
