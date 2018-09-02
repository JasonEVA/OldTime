//
//  MissionDetailHeadTableViewCell.h
//  launcher
//
//  Created by Kyle He on 15/8/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MissionDetailModel;

@interface MissionDetailHeadTableViewCell : UITableViewCell

+ (NSString *)identifier;
+ (CGFloat)height;

- (void)setDataWithModel:(MissionDetailModel *)model;

@end
