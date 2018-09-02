//
//  HMConsultingrecordsTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2017/4/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//  我的 - 咨询记录cell

#import <UIKit/UIKit.h>
@class HMConsultingRecordsModel;
@interface HMConsultingrecordsTableViewCell : UITableViewCell
- (void)fillDataWithModel:(HMConsultingRecordsModel *)model;

@end
