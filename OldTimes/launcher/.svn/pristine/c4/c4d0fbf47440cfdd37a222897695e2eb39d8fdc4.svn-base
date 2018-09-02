//
//  MissionDetailToolTableViewCell.h
//  launcher
//
//  Created by Kyle He on 15/8/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MissionDetailModel;

@interface MissionDetailToolTableViewCell : UITableViewCell

+ (NSString *)identifier;

+ (CGFloat)heightFromDetail:(MissionDetailModel *)detailModel;

- (void)clickButtonAtIndex:(void (^)(NSUInteger clickedIndex)) clickIndexBlock;
- (void)setMissionDetail:(MissionDetailModel *)detailModel;

@end
