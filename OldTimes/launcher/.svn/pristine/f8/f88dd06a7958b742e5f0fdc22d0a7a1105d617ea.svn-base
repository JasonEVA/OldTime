//
//  TaskWithSegmentTableViewCell.h
//  launcher
//
//  Created by 马晓波 on 15/8/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhiteBoradStatusType.h"

typedef void(^TaskWithSegmentBlock)(NSUInteger selectedIndex);

@interface TaskWithSegmentTableViewCell : UITableViewCell

+ (NSString *)identifier;

@property (nonatomic, strong) UILabel *lblTitle;

- (void)segmentDidSelect:(TaskWithSegmentBlock)selectBlock;

- (void)setCurrentSelectPriority:(MissionTaskPriority)priority;

@end
