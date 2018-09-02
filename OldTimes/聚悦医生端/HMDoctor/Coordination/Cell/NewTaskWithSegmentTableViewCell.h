//
//  NewTaskWithSegmentTableViewCell.h
//  launcher
//
//  Created by jasonwang on 16/2/17.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  优先度选择Cell

#import <UIKit/UIKit.h>

typedef void(^NewTaskWithSegmentBlock)(NSUInteger selectedIndex);

@interface NewTaskWithSegmentTableViewCell : UITableViewCell

+ (NSString *)identifier;

@property (nonatomic, strong) UILabel *lblTitle;

- (void)segmentDidSelect:(NewTaskWithSegmentBlock)selectBlock;

- (void)setCurrentSelectPriority:(MissionTaskPriority)priority;

@end

