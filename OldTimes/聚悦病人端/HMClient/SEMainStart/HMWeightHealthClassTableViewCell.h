//
//  HMWeightHealthClassTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2017/8/9.
//  Copyright © 2017年 YinQ. All rights reserved.
//  体重相关阅读cell

#import <UIKit/UIKit.h>

@class HealthEducationItem;

typedef void(^ClickBlock)(NSInteger index);

@interface HMWeightHealthClassTableViewCell : UITableViewCell
- (void)fillDataWithArray:(NSArray<HealthEducationItem *> *)array;

- (void)dealWithClick:(ClickBlock)block;
@end
