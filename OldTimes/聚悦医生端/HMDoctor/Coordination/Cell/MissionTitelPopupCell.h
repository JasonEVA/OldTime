//
//  MissionTitelPopupCell.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//  任务标题类型弹出cell

#import <UIKit/UIKit.h>

@interface MissionTitelPopupCell : UITableViewCell
+ (NSString *)identifier;

@property (nonatomic, strong) UILabel *lblTitle;
@end
