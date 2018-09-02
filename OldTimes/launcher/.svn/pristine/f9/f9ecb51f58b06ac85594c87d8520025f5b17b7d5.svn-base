//
//  ChatShowDateTableViewCell.h
//  Titans
//
//  Created by Andrew Shen on 14-9-24.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  聊天日期显示

#import <UIKit/UIKit.h>
#import <MintcodeIM/MintcodeIM.h>

@interface ChatShowDateTableViewCell : UITableViewCell
{
    UILabel *_lbText;
}

+ (NSString *)identifier;
+ (CGFloat)cellHeightWithDateString:(NSString *)date;
/**
 * 更新显示的文字，会自动计算更新高度和位置，时间和时间的间隔不同
 */
- (void)showDateAndEvent:(MessageBaseModel *)baseModel ifEvent:(BOOL)ifEvent;

@end
