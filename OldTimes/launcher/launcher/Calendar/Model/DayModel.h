//
//  DayModel.h
//  Titans
//
//  Created by Andrew Shen on 15/3/20.
//  Copyright (c) 2015年 Remon Lv. All rights reserved.
//  每一天的model

#import <Foundation/Foundation.h>

@interface DayModel : NSObject

@property (nonatomic) NSInteger _dayNumber;         // 日
@property (nonatomic) NSMutableArray *arrayEventList;

@end
