//
//  HMDoctorConcernMainTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2016/12/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//  医生关怀卡片cell

#import <UIKit/UIKit.h>
@class HMConcernModel;



typedef void(^ConcernClickBlock)(NSInteger resendTag,BOOL palyVoiceClick);

typedef void(^ConcernImageClickBlock)(NSIndexPath *concernIndexPath);

typedef void(^ConcernEditionClickBlock)(NSString *classId);


@interface HMDoctorConcernMainTableViewCell : UITableViewCell
@property (nonatomic, retain) UIImageView* ivVoice;
//语音图片

- (void)fillDataWithModel:(HMConcernModel *)model;
- (void)concernBlock:(ConcernClickBlock)block;
- (void)imageClick:(ConcernImageClickBlock)block;
- (void)editionClick:(ConcernEditionClickBlock)block;
@end
