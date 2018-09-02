//
//  HMSecondEditionPatientInfoCollectTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2016/11/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//  第二版患者信息页（免费版）collect 图片 cell

#import <UIKit/UIKit.h>

@protocol HMSecondEditionPatientInfoCollectTableViewCellDelegate <NSObject>

- (void)HMSecondEditionPatientInfoCollectTableViewCellDelegateCallBack_imageClick:(NSIndexPath *)index groupName:(NSString *)groupName;

@end

@class HMSecondEditionFreeCheckGroupModel;

@interface HMSecondEditionPatientInfoCollectTableViewCell : UITableViewCell
- (void)fillDataWithModel:(HMSecondEditionFreeCheckGroupModel *)model;
@property (nonatomic, weak) id<HMSecondEditionPatientInfoCollectTableViewCellDelegate> delegate;
@end
