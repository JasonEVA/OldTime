//
//  ChatRightAttachmentTableViewCell.m
//  Titans
//
//  Created by Andrew Shen on 14-9-24.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "ChatRightAttachmentTableViewCell.h"
#import "Slacker.h"
#import <UIImageView+WebCache.h>
#import "MyDefine.h"

#define MARGE 12            // 头像距边界的距离
#define MARGE_TOP 8           // 头像距顶部边界的距离

#define INTERVAL 7          // 头像与气泡间隔
#define INTERVAL_LOADING 20    // 气泡与旋转框距离
#define INTERVAL_ICON 8     // 附件图标与边界距离间隔
#define INTERVAL_LABEL 10    // 气泡与时间label距离

#define W_HEADICON 42       // 头像宽度，与气泡高度一样
#define H_BUBBLE 42         // 气泡默认高度
#define W_SENDFAIL 22       // 失败图标宽度
#define W_TITLE (120 + [Slacker getXMarginFrom320ToNowScreen] * 2)         // 标题宽度
#define W_MAX (185 + [Slacker getXMarginFrom320ToNowScreen] * 2)           // 最大宽度
#define W_ATTACHMENT 32     // 附件图标宽度
#define W_SIZE 50           // 时间宽度

#define CHAT_BUBBLE @"chat_right_bubble" // 气泡
#define CHAT_SENDFAIL @"chat_sendFail" // 发送失败
#define FILE_XLS    @"file_icon_xls"

@implementation ChatRightAttachmentTableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier HeadIcon:(NSString *)imgUrl Target:(id)target ActionTap:(SEL)actionTap ActionLong:(SEL)actionLong ActionFail:(SEL)actionFail ActionHead:(SEL)actionHead
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];

        // 头像
        _imgViewHeadIcon = [[UIImageView alloc] initWithFrame:CGRectMake(IOS_SCREEN_WIDTH - MARGE - W_HEADICON, MARGE_TOP, W_HEADICON, W_HEADICON)];
        NSURL *urlHead = [NSURL URLWithString:imgUrl];
        [_imgViewHeadIcon sd_setImageWithURL:urlHead placeholderImage:IMG_DEFAULT_HEAD];
        [_imgViewHeadIcon.layer setCornerRadius:W_HEADICON / 2];
        [_imgViewHeadIcon.layer setMasksToBounds:YES];
        [_imgViewHeadIcon setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:actionHead];
        [_imgViewHeadIcon addGestureRecognizer:tapGesture];
        [self addSubview:_imgViewHeadIcon];
        
        // 气泡
        _imgViewBubble = [[UIImageView alloc] initWithFrame:CGRectMake(_imgViewHeadIcon.frame.origin.x - INTERVAL - W_MAX, MARGE_TOP, W_MAX, H_BUBBLE)];
        [self addSubview:_imgViewBubble];
        // 为图片添加手势
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:actionTap];
        [_imgViewBubble setUserInteractionEnabled:YES];
        [_imgViewBubble addGestureRecognizer:tapGesture];
        
        // 附件类型图标
        _imgViewAttachment = [[UIImageView alloc] initWithFrame:CGRectMake(INTERVAL_ICON, (H_BUBBLE - W_ATTACHMENT) / 2, W_ATTACHMENT, W_ATTACHMENT)];
        [_imgViewBubble addSubview:_imgViewAttachment];
        
        // 给气泡添加长按手势
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:actionLong];
        [_imgViewBubble addGestureRecognizer:longGesture];
        
        // 附件名
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(_imgViewHeadIcon.frame.origin.x - 20 - W_TITLE, MARGE_TOP, W_TITLE, H_BUBBLE)];
        [_lbTitle setFont:[UIFont systemFontOfSize:17]];
        [_lbTitle setBackgroundColor:[UIColor clearColor]];
        [_lbTitle setTextAlignment:NSTextAlignmentCenter];
        [_lbTitle setLineBreakMode:NSLineBreakByTruncatingMiddle];
        [self addSubview:_lbTitle];
        
        // 附件大小
        _lbSize = [[UILabel alloc] initWithFrame:CGRectMake(_imgViewBubble.frame.origin.x - INTERVAL_LABEL - W_SIZE, MARGE_TOP, W_SIZE, H_BUBBLE)];
        [_lbSize setFont:[UIFont systemFontOfSize:15]];
        [_lbSize setTextColor:[UIColor grayColor]];
        [_lbSize setBackgroundColor:[UIColor clearColor]];
        [_lbSize setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_lbSize];
        
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
#pragma mark - Private Method

// 发送loading
- (void)showSending
{
    [_imgViewFailed setHidden:YES];
    [_lbSize setHidden:YES];
    [_loadingIndicator setFrame:CGRectMake(_imgViewBubble.frame.origin.x - INTERVAL_LOADING - (_loadingIndicator.frame.size.width), (_imgViewBubble.frame.size.height - _loadingIndicator.frame.size.height) / 2 + MARGE_TOP, _loadingIndicator.frame.size.width, _loadingIndicator.frame.size.height)];
    [_loadingIndicator startAnimating];
}

// 发送成功，停止转动
- (void)showSendSuccess
{
    [_imgViewFailed setHidden:YES];
    [_lbSize setHidden:NO];
    [_loadingIndicator stopAnimating];
}

// 发送失败
- (void)showSendFail
{
    [_loadingIndicator stopAnimating];
    [_imgViewFailed setHidden:NO];
    [_lbSize setHidden:YES];
    [_imgViewFailed setFrame:CGRectMake(_imgViewBubble.frame.origin.x - INTERVAL_LOADING - W_SENDFAIL, (_imgViewBubble.frame.size.height - W_SENDFAIL) / 2 + MARGE_TOP, W_SENDFAIL, H_BUBBLE)];
}

#pragma mark - OverWrite
- (void)setTag:(NSInteger)tag
{
    [_imgViewBubble setTag:tag];
    [_imgViewFailed setTag:tag];
    [_imgViewHeadIcon setTag:tag];
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
            [self showSending];
            break;
            
        case status_send_failed:
            [self showSendFail];
            break;
            
        default:
            break;
    }
}

- (void)showAttachmentType:(UIImage *)image Title:(NSString *)title Size:(NSString *)attachmentSize Tag:(NSInteger)tag
{
    
    // 气泡图片
    UIImage *img = [UIImage imageNamed:CHAT_BUBBLE];
    img = [img stretchableImageWithLeftCapWidth:img.size.width / 2 topCapHeight:img.size.height * 0.8];
    [_imgViewBubble setImage:img];
    [_imgViewBubble setTag:tag];
    
    // 附件显示
    [_imgViewAttachment setImage:image];
    
    // 附件大小
    [_lbSize setText:attachmentSize];
    
    // 附件title显示
    [_lbTitle setText:title];
    
}

@end
