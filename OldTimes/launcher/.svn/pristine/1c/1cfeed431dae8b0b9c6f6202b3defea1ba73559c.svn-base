//
//  ChatRightTextTableViewCell.m
//  Titans
//
//  Created by Andrew Shen on 14-9-22.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "ChatRightTextTableViewCell.h"
#import "Slacker.h"
#import "MyDefine.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>
#import "UIColor+Hex.h"

#define MARGE 30              // 头像距边界的距离
#define MARGE_TOP 8           // 头像距顶部边界的距离

#define INTERVAL 7          // 头像与气泡间隔
#define INTERVAL_LOADING 20    // 气泡与旋转框距离
#define W_HEADICON 42       // 头像宽度，与气泡高度一样
#define H_BUBBLE 42         // 气泡默认高度
#define W_SENDFAIL 22       // 失败图标宽度
#define MAX_W (185 + [Slacker getXMarginFrom320ToNowScreen] * 2)           // 文本最大宽度

#define CHAT_BUBBLE @"chat_right_bubble" // 气泡
#define CHAT_SENDFAIL @"chat_sendFail" // 发送失败
@implementation ChatRightTextTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier HeadIcon:(NSString *)imgUrl Target:(id)target Action:(SEL)action ActionFail:(SEL)actionFail ActionHead:(SEL)actionHead
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        // 头像
        _imgViewHeadIcon = [[UIImageView alloc] initWithFrame:CGRectMake(IOS_SCREEN_WIDTH - MARGE - W_HEADICON, MARGE_TOP, W_HEADICON, W_HEADICON)];
        [_imgViewHeadIcon sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:IMG_PLACEHOLDER_HEAD];
        //        [_imgViewHeadIcon.layer setCornerRadius:W_HEADICON / 2];
        [_imgViewHeadIcon.layer setMasksToBounds:YES];
        [_imgViewHeadIcon setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:actionHead];
        [_imgViewHeadIcon addGestureRecognizer:tapGesture];
        [self addSubview:_imgViewHeadIcon];
        [_imgViewHeadIcon setHidden:YES];
        
        // 气泡
        _imgViewBubble = [[UIImageView alloc] init];
        [_imgViewBubble setUserInteractionEnabled:YES];
        [self addSubview:_imgViewBubble];
        // 给气泡添加长按手势
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:action];
        [_imgViewBubble addGestureRecognizer:longGesture];
        
        // 文字
        _lbText = [[UILabel alloc] init];
        [_lbText setFont:[UIFont systemFontOfSize:17]];
        [_lbText setNumberOfLines:0];
        [_lbText setTextColor:[UIColor blackColor]];
        [_lbText setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_lbText];
        
        // 旋转图标
        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_loadingIndicator setHidesWhenStopped:YES];
        [self addSubview:_loadingIndicator];
        
        // 失败图案
        _imgViewFailed = [[UIImageView alloc] init];
        [_imgViewFailed setImage:[UIImage imageNamed:CHAT_SENDFAIL]];
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:target action:actionFail];
        [_imgViewFailed setUserInteractionEnabled:YES];
        [_imgViewFailed addGestureRecognizer:gest];
        [self addSubview:_imgViewFailed];
        
        // 时间图案
        _lbTime = [UILabel new];
        [_lbTime setFont:[UIFont systemFontOfSize:13]];
        [_lbTime setTextColor:[UIColor grayColor]];
        [self addSubview:_lbTime];
        
        // 已读未读
        _imgViewReaded = [UIImageView new];
        [self addSubview:_imgViewReaded];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - OverWrite
- (void)setTag:(NSInteger)tag
{
    [_imgViewBubble setTag:tag];
    [_imgViewFailed setTag:tag];
    [_imgViewHeadIcon setTag:tag];
}

#pragma mark -- Interface Method
- (void)showTextMessage:(NSString *)message
{
    // 得到输入文字内容长度
    UIFont *font = [UIFont systemFontOfSize:17];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize size = [message boundingRectWithSize:CGSizeMake(MAX_W, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    // 设置label长度
    //    [_lbText setFrame:CGRectMake(IOS_SCREEN_WIDTH - MARGE, MARGE_TOP + 5, size.width + 10, size.height + 10)];
    [_lbText mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-35);
        make.centerY.equalTo(self);
        //        make.width.lessThanOrEqualTo(@(MAX_W));
        make.width.equalTo(@(size.width + 10));
    }];
    [_lbText setLineBreakMode:NSLineBreakByWordWrapping];
    [_lbText setText:message];
    
    // 气泡图片
    UIImage *img = [UIImage imageNamed:CHAT_BUBBLE];
    img = [img stretchableImageWithLeftCapWidth:img.size.width / 2 topCapHeight:img.size.height * 0.8];
    //    [_imgViewBubble setFrame:CGRectMake(_lbText.frame.origin.x - 5, MARGE_TOP, width, MAX(_lbText.frame.size.height + 5, 42))];
    [_imgViewBubble mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_lbText).offset(15);
        make.centerY.equalTo(self);
        make.left.equalTo(_lbText).offset(-10);
        make.height.equalTo(_lbText).offset(5);
    }];
    [_imgViewBubble setImage:img];
}

// 显示时间
- (void)showDate:(NSString *)time
{
    [_lbTime setText:time];
    [_lbTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_imgViewBubble.mas_left).offset(-13);
        make.bottom.equalTo(_imgViewBubble);
    }];
}

// 设置状态
- (void)showStatus:(Msg_status)status
{
    switch (status)
    {
        case status_send_success:
            [self showSendSuccess];
            break;
            
        case status_sending:
            [self showSending];
            break;
            
        case status_send_failed:
            [self showSendFail];
            break;
            
        default:
            break;
    }
}

// 显示已读未读标记
- (void)isReaded:(NSInteger)readed
{
    [_imgViewReaded mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_lbTime.mas_top);
        make.right.equalTo(_lbTime).offset(-2);
    }];
    
    if (readed)
    {
        [_imgViewReaded setImage:[UIImage imageNamed:@"message_check"]];
    }
    else
    {
        [_imgViewReaded setImage:[UIImage imageNamed:@"message_uncheck"]];
    }
    
}

#pragma mark - Private Method
// 发送loading
- (void)showSending
{
    [_imgViewFailed setHidden:YES];
    //    [_loadingIndicator setFrame:CGRectMake(_imgViewBubble.frame.origin.x - INTERVAL_LOADING - (_loadingIndicator.frame.size.width), (_imgViewBubble.frame.size.height - _loadingIndicator.frame.size.height) / 2 + MARGE_TOP, _loadingIndicator.frame.size.width, _loadingIndicator.frame.size.height)];
    [_loadingIndicator mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_imgViewBubble.mas_left).offset(-INTERVAL_LOADING);
        make.top.equalTo(_imgViewBubble);
    }];
    [_loadingIndicator startAnimating];
}

// 发送成功，停止转动
- (void)showSendSuccess
{
    [_imgViewFailed setHidden:YES];
    [_loadingIndicator stopAnimating];
}

// 发送失败
- (void)showSendFail
{
    [_loadingIndicator stopAnimating];
    [_imgViewFailed setHidden:NO];
    //    [_imgViewFailed setFrame:CGRectMake(_imgViewBubble.frame.origin.x - INTERVAL_LOADING - W_SENDFAIL, (_imgViewBubble.frame.size.height - W_SENDFAIL) / 2 + MARGE_TOP, W_SENDFAIL, W_SENDFAIL)];
    [_imgViewFailed mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_imgViewBubble.mas_left).offset(-INTERVAL_LOADING);
        make.top.equalTo(_imgViewBubble);
    }];
}

@end
