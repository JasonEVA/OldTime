//
//  ChatRightVoiceTableViewCell.m
//  Titans
//
//  Created by Andrew Shen on 14-9-23.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "ChatRightVoiceTableViewCell.h"
#import "Slacker.h"
#import "MyDefine.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

#define MARGE 20            // 头像距边界的距离
#define MARGE_TOP 8           // 头像距顶部边界的距离

#define INTERVAL 7          // 头像与气泡间隔
#define INTERVAL_VOICE 14   // 声音图片距气泡距离
#define INTERVAL_LABEL 15    // 气泡与时间label距离
#define INTERVAL_LOADING 20    // 气泡与旋转框距离

#define W_HEADICON 42       // 头像宽度，与气泡高度一样
#define H_BUBBLE 42         // 气泡默认高度
#define W_SENDFAIL 22       // 失败图标宽度
#define MAX_W (185 + [Slacker getXMarginFrom320ToNowScreen] * 2)            // 文本最大宽度
#define W_VOICE 18          // 声音图片宽度
#define W_TIME 50           // 时间宽度

#define CHAT_BUBBLE @"chat_right_bubble" // 气泡
#define CHAT_SENDFAIL @"chat_sendFail" // 发送失败

#define CHAT_VOICE_PLAYING0 @"chat_voice0"              // 播放0
#define CHAT_VOICE_PLAYING1 @"chat_right_voice1"         // 播放1
#define CHAT_VOICE_PLAYING2 @"chat_right_voice2"         // 播放2
#define CHAT_VOICE_PLAYING3 @"chat_right_voice3"         // 播放3

@implementation ChatRightVoiceTableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier HeadIcon:(NSString *)imgUrl Target:(id)target ActionTap:(SEL)actionTap ActionLong:(SEL)actionLong ActionFail:(SEL)actionFail ActionHead:(SEL)actionHead
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
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
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:actionLong];
        [_imgViewBubble addGestureRecognizer:longGesture];
        
        // 为图片添加手势
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:actionTap];
        [_imgViewBubble addGestureRecognizer:tapGesture];
        
        // 声音波图片
        _imgViewVoice = [[UIImageView alloc] init];
        [_imgViewVoice setImage:[UIImage imageNamed:CHAT_VOICE_PLAYING3]];
        [_imgViewVoice setContentMode:UIViewContentModeCenter];
        [_imgViewBubble addSubview:_imgViewVoice];
        
        // 文字
        _lbTime = [[UILabel alloc] init];
        [_lbTime setFont:[UIFont systemFontOfSize:17]];
        [_lbTime setTextAlignment:NSTextAlignmentRight];
        [_lbTime setTextColor:[UIColor blackColor]];
        [_lbTime setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_lbTime];
        
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
        
        // 存放语音播放时的图片
        _arrayVoicePlaying = [NSMutableArray arrayWithObjects:[UIImage imageNamed:CHAT_VOICE_PLAYING0],[UIImage imageNamed:CHAT_VOICE_PLAYING1], [UIImage imageNamed:CHAT_VOICE_PLAYING2], [UIImage imageNamed:CHAT_VOICE_PLAYING3], nil];
        
        // 时间图案
        _lbMessageTime = [UILabel new];
        [_lbMessageTime setFont:[UIFont systemFontOfSize:13]];
        [_lbMessageTime setTextColor:[UIColor grayColor]];
        [self addSubview:_lbMessageTime];
        
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

#pragma mark -- Interface Method
// 设置状态
- (void)showStatus:(Msg_status)status
{
    switch (status)
    {
        case status_send_success:
            [self showSendSuccess];
            break;
            
        case status_sending:
        case status_send_waiting:
            [self showSending];
            break;
            
        case status_send_failed:
            [self showSendFail];
            break;
            
        default:
            break;
    }
}

#pragma mark - OverWrite
- (void)setTag:(NSInteger)tag
{
    [_imgViewBubble setTag:tag];
    [_imgViewFailed setTag:tag];
    [_imgViewHeadIcon setTag:tag];
}

#pragma mark -- Private Method

- (void)showVoiceMessageTime:(NSInteger)length Tag:(NSInteger)tag
{
    NSInteger bubbleWidth = length * 5 + H_BUBBLE + 30;
    // 气泡图片
    UIImage *img = [UIImage imageNamed:CHAT_BUBBLE];
    img = [img stretchableImageWithLeftCapWidth:img.size.width / 2 topCapHeight:img.size.height * 0.8];
    
    CGFloat maxWidth = MAX_W;
    [_imgViewBubble setFrame:CGRectMake(IOS_SCREEN_WIDTH - MARGE - MIN(bubbleWidth, maxWidth), MARGE_TOP, MIN(bubbleWidth, maxWidth), H_BUBBLE)];
    [_imgViewBubble setImage:img];
    [_imgViewBubble setTag:tag];
    
    // 设置声音播放图片位置
    [_imgViewVoice setFrame:CGRectMake(_imgViewBubble.frame.size.width - INTERVAL_VOICE - W_VOICE, (H_BUBBLE - W_VOICE) / 2, W_VOICE, W_VOICE)];
    
    [_imgViewVoice mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_imgViewBubble).offset(-INTERVAL_VOICE);
        make.centerY.equalTo(_imgViewBubble);
    }];
    
    // 时间显示
    //    [_lbTime setFrame:CGRectMake(_imgViewBubble.frame.origin.x + INTERVAL_LABEL + W_TIME, MARGE_TOP, W_TIME, H_BUBBLE)];
    [_lbTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgViewBubble).offset(14);
        make.centerY.equalTo(_imgViewBubble);
    }];
    [_lbTime setText:[NSString stringWithFormat:@"%ld''",(long)length]];
}

// 显示时间
- (void)showDate:(NSString *)time
{
    [_lbMessageTime setText:time];
    [_lbMessageTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_imgViewBubble.mas_left).offset(-13);
        make.bottom.equalTo(_imgViewBubble);
    }];
}

// 显示已读未读标记
- (void)isReaded:(NSInteger)readed
{
    [_imgViewReaded mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_lbMessageTime.mas_top);
        make.right.equalTo(_lbMessageTime).offset(-2);
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

// 发送loading
- (void)showSending
{
    [_imgViewFailed setHidden:YES];
    //    [_loadingIndicator setFrame:CGRectMake(_imgViewBubble.frame.origin.x - INTERVAL_LOADING * 2 - (_loadingIndicator.frame.size.width), (_imgViewBubble.frame.size.height - _loadingIndicator.frame.size.height) / 2 + MARGE_TOP, _loadingIndicator.frame.size.width, _loadingIndicator.frame.size.height)];
    [_loadingIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
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
    //    [_imgViewFailed setFrame:CGRectMake(_imgViewBubble.frame.origin.x - INTERVAL_LOADING * 2 - W_SENDFAIL, (_imgViewBubble.frame.size.height - W_SENDFAIL) / 2 + MARGE_TOP, W_SENDFAIL, W_SENDFAIL)];
    [_imgViewFailed mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_imgViewBubble.mas_left).offset(-INTERVAL_LOADING);
        make.top.equalTo(_imgViewBubble);
    }];
}

// 播放声音的动画
- (void)startPlayVoiceWithTime:(CGFloat)lenght
{
    _imgViewVoice.animationImages = _arrayVoicePlaying;
    _imgViewVoice.animationRepeatCount = lenght * 2;
    _imgViewVoice.animationDuration = 0.5;
    [_imgViewVoice startAnimating];
    
}

// 停止播放声音的动画
- (void)stopPlayVoice
{
    // 如果正在播放，就停止
    if (_imgViewVoice.isAnimating)
    {
        [_imgViewVoice stopAnimating];
    }
}

@end
