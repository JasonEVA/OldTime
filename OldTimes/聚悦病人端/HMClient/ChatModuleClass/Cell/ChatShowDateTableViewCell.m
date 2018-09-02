//
//  ChatShowDateTableViewCell.m
//  Titans
//
//  Created by Andrew Shen on 14-9-24.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "ChatShowDateTableViewCell.h"
#import "MyDefine.h"
#import "Slacker.h"
#import "ImApplicationConfigure.h"

#define W_MAX_DATE (230 + [Slacker getXMarginFrom320ToNowScreen] * 2)           // 最大宽度
#define H_MARGIN_DATE_TOP 12
#define H_MARGIN_EVENT_TOP 3
#define H_MARGIN_DATE_BOTTOM 3

#define COLOR_MESSAGE_BG [UIColor colorWithRed:200.0 / 255.0 green:200.0 / 255.0 blue:200.0 / 255.0 alpha:1.0]

@implementation ChatShowDateTableViewCell

+ (NSString *)identifier { return NSStringFromClass(self);}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setClipsToBounds:YES];

        [self setBackgroundColor:[UIColor clearColor]];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        // 时间显示label
        CGRect frame = self.bounds;
        frame.size.width = IOS_SCREEN_WIDTH;
        _lbText = [[UILabel alloc] initWithFrame:self.bounds];
        [_lbText setTextAlignment:NSTextAlignmentCenter];
        [_lbText setTextColor:[UIColor whiteColor]];
        [_lbText setFont:[UIFont font_26]];
        [_lbText setNumberOfLines:0];
        [_lbText setBackgroundColor:COLOR_MESSAGE_BG];
        [_lbText.layer setCornerRadius:4];
        [_lbText.layer setMasksToBounds:YES];
        [self.contentView addSubview:_lbText];
    }
    return self;
}

#pragma mark -- Interface Method
/**
 * 更新显示的文字，会自动计算更新高度和位置，时间和时间的间隔不同
 */
- (void)showDateAndEvent:(MessageBaseModel *)baseModel ifEvent:(BOOL)ifEvent
{
//    MessageAppModel *appModel = baseModel.appModel;
    NSString *text;
//    if ([appModel isAppSystemMessage])
//    {
//        // 要显示的文字
//        text = @"自定义文字"; // [IMApplicationUtil getMsgTextWithModel:appModel];
//    }
//    else
//    {
        text = baseModel._content;
//    }
    
    // 得到输入文字内容长度
    UIFont *font = [UIFont font_26];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize size = [text boundingRectWithSize:CGSizeMake(W_MAX_DATE, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    // 设置label长度
    [_lbText setFrame:CGRectMake(0, 0, size.width + 5, size.height)];
    [_lbText setLineBreakMode:NSLineBreakByWordWrapping];
    CGPoint center = CGPointMake(IOS_SCREEN_WIDTH / 2.0, size.height / 2.0 + (ifEvent ? H_MARGIN_EVENT_TOP : H_MARGIN_DATE_TOP));
    [_lbText setCenter:center];
    [_lbText setText:text];
}
@end
