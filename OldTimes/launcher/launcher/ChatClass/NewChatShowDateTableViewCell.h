//
//  NewChatShowDateTableViewCell.h
//  launcher
//
//  Created by 马晓波 on 16/3/14.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  warining:仅给应用类使用

#import <UIKit/UIKit.h>
#import <MintcodeIM/MintcodeIM.h>

@interface NewChatShowDateTableViewCell : UITableViewCell
{
    UILabel *_lbText;
}

+ (NSString *)identifier;
+ (CGFloat)cellHeightWithDateString:(NSString *)date;

/**
 * 更新显示的文字，会自动计算更新高度和位置，时间和时间的间隔不同
 */
- (void)showDateAndEvent:(MessageBaseModel *)baseModel ifEvent:(BOOL)ifEvent;
//提醒
- (void)showDateAndEvent:(MessageBaseModel *)baseModel;
@end
