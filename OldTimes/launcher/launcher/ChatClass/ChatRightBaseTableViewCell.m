//
//  ChatRightBaseTableViewCell.m
//  launcher
//
//  Created by Lars Chen on 15/9/25.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatRightBaseTableViewCell.h"
#import "NSDate+MsgManager.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"

#define CHAT_BUBBLE @"chat_right_bubble" // 气泡
#define CHAT_SENDFAIL @"chat_sendFail" // 发送失败

#define INTERVAL_LOADING 20    // 气泡与旋转框距离


@interface BecomeFirstResponderImageView : UIImageView

@property (nonatomic, copy) void (^actionBlock)();

@end

@interface ChatRightBaseTableViewCell ()

@property (nonatomic, strong) UIActivityIndicatorView       *loadingIndicator;// 旋转指示器
@property (nonatomic, strong) UILabel                       *readedLabel;// 已读
@property (nonatomic, strong) BecomeFirstResponderImageView *imgViewFailed;// 失败图标
@property (nonatomic, strong) UIImageView                   *imgEmphasis;// 重点

@end

@implementation ChatRightBaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initComponent];
    }
    return self;
}

- (UIEdgeInsets)wz_leftSelectButtonInsets {
    return UIEdgeInsetsMake(12, 12, 0, 0);
}

- (void)initComponent
{
    [self.wz_contentView addSubview:self.loadingIndicator];
    [self.wz_contentView addSubview:self.imgViewBubble];
#if CHAT_SHOWTIME
    [self.wz_contentview addSubview:self.lbTime];
#endif
    [self.wz_contentView addSubview:self.readedLabel];
    [self.wz_contentView addSubview:self.imgViewFailed];
    [self.wz_contentView addSubview:self.imgEmphasis];
    
    [self.readedLabel setHidden:YES];
    [_imgViewFailed setHidden:YES];
    
    [self initConstraints];
}

- (void)initConstraints {
    [self.imgViewBubble mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.wz_contentView).offset(-13);
        make.top.equalTo(self.wz_contentView).offset(8);
    }];
    
    [self.loadingIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgViewBubble);
        make.right.equalTo(self.imgViewBubble.mas_left).offset(-8);
    }];
    
    [self.imgViewFailed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgViewBubble);
        make.right.equalTo(self.imgViewBubble.mas_left).offset(-10);
    }];
    
    [self.readedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgViewBubble.mas_bottom).offset(5);
        make.right.equalTo(self.imgViewBubble).offset(-15);
    }];
    
    [self.imgEmphasis mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@14);
        make.right.equalTo(self.imgViewBubble.mas_left).offset(-10);
        make.centerY.equalTo(self.imgViewBubble);
    }];

}

#if CHAT_SHOWTIME
- (void)updateConstraints {
    [self.lbTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgViewBubble.mas_bottom).offset(5);
        make.left.equalTo(self.imgViewBubble).offset(10).priorityLow();
        
        if ([self.readedLabel.text length]) {
            // 显示已读
            make.right.lessThanOrEqualTo(self.readedLabel.mas_left).offset(-15).priorityHigh();
        } else {
            make.right.equalTo(self.imgViewBubble).offset(-15);
        }
        
    }];
    
    [super updateConstraints];
}
#endif

#pragma mark - Private Method
// 发送loading
- (void)showSending
{
    [_imgViewFailed setHidden:YES];
    [_readedLabel setHidden:YES];
    [_loadingIndicator startAnimating];
}

// 发送成功，停止转动
- (void)showSendSuccess
{
    [_imgViewFailed setHidden:YES];
    [_readedLabel setHidden:NO];
    [_loadingIndicator stopAnimating];
}

// 发送失败
- (void)showSendFail
{
    [_loadingIndicator stopAnimating];
    [_readedLabel setHidden:YES];
    [_imgViewFailed setHidden:NO];
}

#pragma mark - Interface Method

- (void)showImageUploadStatus:(Msg_status)status {

    [_loadingIndicator stopAnimating];
    
    BOOL failedHidden = YES;
    BOOL readedHidden = YES;
    BOOL timeHidden   = YES;

    switch (status) {
        case status_send_success:
            readedHidden = NO;
            timeHidden = NO;
            break;
        case status_send_failed:
            failedHidden = NO;
            timeHidden = NO;
            break;
        default:
            break;
    }
    
    _imgViewFailed.hidden = failedHidden;
    _readedLabel.hidden   = readedHidden;
#if CHAT_SHOWTIME
    self.lbTime.hidden        = timeHidden;
#endif
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

- (void)setData:(MessageBaseModel *)model
{
    [self setDate:model];
    [self isReaded:model._markReaded];
    
    if ([ContactDetailModel isGroupWithTarget:model._target]) {
        [self.readedLabel setText:@""];
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    WZImageShowMenu showMenu = 0;
    if (model._markStatus == status_send_success) {
        showMenu = showMenu | (model._markImportant ? WZImageShowMenuCancelEmphasis : WZImageShowMenuEmphasis) | WZImageShowMenuRecall | WZImageShowMenuMore;
    }

    if (model._type == msg_personal_text) {
        showMenu |= WZImageShowMenuCopy | WZImageShowMenuMission | WZImageShowMenuSchedule;
    }
	
	self.isSelectedImportant = model._markImportant;
	
	if (self.interactiveMode == ChatBaseCellInteractiveModeInChattingRecords) {
		showMenu = 0;
		showMenu = showMenu | (model._markImportant ? WZImageShowMenuCancelEmphasis : WZImageShowMenuEmphasis) | WZImageShowMenuMore;
		if (model._type == msg_personal_text) {
			showMenu |= WZImageShowMenuCopy;
		}
		
	}
	
    self.imgViewBubble.showMenu = showMenu;
}

- (void)setDate:(MessageBaseModel *)model
{
#if CHAT_SHOWTIME
    NSString *time = [NSDate im_dateFormaterWithTimeInterval:model._createDate appendMinute:YES];
    [self.lbTime setText:time];
#endif
}

// 显示已读未读标记
- (void)isReaded:(BOOL)readed {
    [_readedLabel setText:(readed ? LOCAL(CHAT_READED) : LOCAL(CHAT_SENDED))];
}

//设置重点标志(是否展示)
- (void)setEmphasisIsShow:(BOOL)IsShow
{
    if (IsShow) {
        _imgEmphasis.hidden = NO;
    }else {
        _imgEmphasis.hidden = YES;
    }
}

#pragma mark - Init UI
- (UIActivityIndicatorView *)loadingIndicator
{
    if (!_loadingIndicator)
    {
        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_loadingIndicator setHidesWhenStopped:YES];
    }
    
    return _loadingIndicator;
}
@synthesize imgViewBubble = _imgViewBubble;
- (MenuImageView *)imgViewBubble
{
    if (!_imgViewBubble)
    {
        _imgViewBubble = [MenuImageView new];
        UIImage *img = [UIImage imageNamed:CHAT_BUBBLE];
        img = [img stretchableImageWithLeftCapWidth:img.size.width / 2 topCapHeight:img.size.height * 0.8];
        [_imgViewBubble setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        
        _imgViewBubble.tintColor = ChatBubbleRightConfigShare.textBackgroundColor;
        
        _imgViewBubble.delegate = self;
    }
    
    return _imgViewBubble;
}

- (UILabel *)lbTime
{
    if (!_lbTime)
    {
        _lbTime = [UILabel new];
        [_lbTime setFont:[UIFont mtc_font_24]];
        [_lbTime setTextColor:ChatBubbleRightConfigShare.timeColor];
    }
    
    return _lbTime;
}

- (UILabel *)readedLabel {
    if (!_readedLabel) {
        _readedLabel = [UILabel new];
        _readedLabel.font = [UIFont mtc_font_24];
        _readedLabel.textColor = ChatBubbleRightConfigShare.readedColor;
    }
    return _readedLabel;
}

- (BecomeFirstResponderImageView *)imgViewFailed
{
    if (!_imgViewFailed)
    {
        _imgViewFailed = [[BecomeFirstResponderImageView alloc] init];
        [_imgViewFailed setUserInteractionEnabled:YES];
        [_imgViewFailed setImage:[UIImage imageNamed:CHAT_SENDFAIL]];
        
        __weak typeof(self) weakSelf = self;
        [_imgViewFailed setActionBlock:^{
            !weakSelf.sendAgain ?: weakSelf.sendAgain();
        }];
    }
    
    return _imgViewFailed;
}

- (UIImageView *)imgEmphasis
{
    if (!_imgEmphasis)
    {
        _imgEmphasis = [[UIImageView alloc] init];
        _imgEmphasis.userInteractionEnabled = YES;
        _imgEmphasis.image = [UIImage imageNamed:@"emphasis"];
        _imgEmphasis.hidden = YES;
    }
    
    return _imgEmphasis;
}

@end

@implementation BecomeFirstResponderImageView

- (BOOL)canBecomeFirstResponder { return YES;}

- (instancetype)init {
    self = [super init];
    if (self) {
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToResend)];
        [self addGestureRecognizer:gest];
    }
    return self;
}

- (void)clickToResend {
    [self becomeFirstResponder];
    
    UIMenuItem *resendItem = [[UIMenuItem alloc] initWithTitle:LOCAL(MESSAGE_SENDAGAIN) action:@selector(resendMessage)];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:nil];
    [menu setMenuItems:@[resendItem]];
    [menu setTargetRect:self.frame inView:self.superview];
    [menu setMenuVisible:YES animated:YES];
}

- (void)resendMessage {
    !self.actionBlock ?: self.actionBlock();
}

@end
