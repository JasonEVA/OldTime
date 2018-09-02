//
//  MissionDetailButtonCell.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/18.
//  Copyright © 2016年 yinquan. All rights reserved.
//  任务详情是否参加按钮cell

#import <UIKit/UIKit.h>
typedef void (^MissionDetailButtonCellBlock)(BOOL isAccept);

@interface MissionDetailButtonCell : UITableViewCell
+ (NSString *)identifier;
- (void)clickMyBtnBlock:(MissionDetailButtonCellBlock)block;
@end
