//
//  HMNewDoctorCareAlterImageTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2017/6/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//  首页医生关怀弹窗图片cell

#import <UIKit/UIKit.h>
typedef void(^ConcernImageClickBlock)(NSIndexPath *concernIndexPath);

@interface HMNewDoctorCareAlterImageTableViewCell : UITableViewCell
- (void)fillDataWithImageDataList:(NSArray *)imageList;
- (void)imageClick:(ConcernImageClickBlock)block;

@end
