//
//  ChatLeftBaseTableViewController.m
//  launcher
//
//  Created by Lars Chen on 15/9/28.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatLeftBaseTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+MsgManager.h"
#import <Masonry/Masonry.h>
#import "AvatarUtil.h"
//#import "Category.h"
#import "MyDefine.h"
#import "Slacker.h"
#import "ClientHelper.h"
#import "MessageBaseModel+CellSize.h"

#define CHAT_BUBBLE @"chat_left_bubble" // 气泡

#define MARGE      18// 头像距边界的距离
#define MARGE_TOP  8 // 头像距顶部边界的距离
#define W_HEADICON 40// 头像宽度，与气泡高度一样

#define MAX_W (225 + [Slacker getXMarginFrom320ToNowScreen] * 2)           // 文本最大宽度

@interface ChatLeftBaseTableViewCell ()

@property (nonatomic, strong) UIImageView *imgViewHeadIcon;         // 头像
@property (nonatomic, strong) UILabel *lbName;                      // 名字
/// 重点
@property (nonatomic, strong) UIImageView *imgEmphasis;

@end

@implementation ChatLeftBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self initComponent];
		[self initConstraints];
		
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHead:)];
        [self.imgViewHeadIcon addGestureRecognizer:tapGesture];
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHead:)];
        [self.imgViewHeadIcon addGestureRecognizer:longGesture];
    }
    
    return self;
}

- (UIEdgeInsets)wz_leftSelectButtonInsets {
    return UIEdgeInsetsMake(MARGE_TOP + 10, 12, 0, 0);
}

- (void)initComponent
{
    [self.wz_contentView addSubview:self.imgViewHeadIcon];
    [self.wz_contentView addSubview:self.imgViewBubble];
#if CHAT_SHOWTIME
    [self.wz_contentView addSubview:self.lbTime];
#endif
    [self.wz_contentView addSubview:self.lbName];
    [self.wz_contentView addSubview:self.imgEmphasis];

}

- (void)initConstraints {
    [self.imgViewHeadIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wz_contentView).offset(MARGE_TOP);
        make.left.equalTo(self.wz_contentView).offset(MARGE);
        make.width.height.equalTo(@W_HEADICON);
    }];
    
    [self.lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgViewHeadIcon.mas_right).offset(17);
        make.top.equalTo(self.imgViewHeadIcon);
    }];
    
    [self.imgViewBubble mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgViewHeadIcon.mas_right).offset(5);
        make.top.equalTo(self.lbName.mas_bottom).offset(2);
        make.bottom.equalTo(self.wz_contentView).offset(-10);
    }];
    
#if CHAT_SHOWTIME
    [self.lbTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imgViewBubble).offset(-10).priorityLow();
        make.left.greaterThanOrEqualTo(self.imgViewBubble).offset(15).priorityHigh();
        make.top.equalTo(self.imgViewBubble.mas_bottom).offset(5);
    }];
#endif
    [self.imgEmphasis mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@14);
        make.left.equalTo(self.imgViewBubble.mas_right).offset(10);
        make.centerY.equalTo(self.imgViewBubble);
    }];
}

- (void)setData:(MessageBaseModel *)model
{
#if CHAT_SHOWTIME
    NSString *time = [NSDate im_dateFormaterWithTimeInterval:model._createDate appendMinute:YES];
    [self.lbTime setText:time];
#endif
    self.imgViewBubble.showMenu = WZImageShowMenuCancelEmphasis;

    WZImageShowMenu showMenu = 0;
    //禁止转发=-=Jason
//    showMenu |= WZImageShowMenuForward;
    
    if (model._type == msg_personal_text) {
        
        showMenu |= WZImageShowMenuCopy;
    }
    
    if (model._type == msg_personal_event) {
        
        NSDictionary* dicContent = [NSDictionary JSONValue:model._content];
        MessageBaseModelContent *contentModel = [MessageBaseModelContent mj_objectWithKeyValues:dicContent];
        if ([contentModel.type isEqualToString:@"receiptMsg"]) {
            showMenu |= WZImageShowMenuCopy;
        }
    }
    
	self.isSelectedImportant = model._markImportant;
    self.imgViewBubble.showMenu = showMenu;
    
}

// 设置头像
- (void)setHeadIconWithUid:(NSString *)uid;
{
    //头像
    NSURL *urlHead = avatarURL(avatarType_80, uid);
    [_imgViewHeadIcon sd_setImageWithURL:urlHead placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
}

// 设置姓名
- (void)setRealName:(NSString *)name hidden:(BOOL)hidden
{
    if (!hidden) {
        if (![self.lbName.text isEqualToString:name])
        {
            [self.lbName setText:name];
        }
    }
    else {
        [self.lbName setText:@""];
    }
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

- (void)tapHead:(UIGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(chatBaseTableViewCell:pressHeadAtIndexPath:)]) {
        [self.delegate chatBaseTableViewCell:self pressHeadAtIndexPath:[self getIndexPath]];
    }
}

- (void)longPressHead:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(chatBaseTableViewCell:longPressHeadAtIndexPath:)]) {
            [self.delegate chatBaseTableViewCell:self longPressHeadAtIndexPath:[self getIndexPath]];
        }
    }
}

#pragma mark - Init UI
@synthesize imgViewBubble = _imgViewBubble;
- (MenuImageView *)imgViewBubble
{
    if (!_imgViewBubble)
    {
        _imgViewBubble = [MenuImageView new];
        UIImage *img = [UIImage imageNamed:CHAT_BUBBLE];
        img = [img stretchableImageWithLeftCapWidth:img.size.width / 2 topCapHeight:img.size.height * 0.8];
        [_imgViewBubble setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        
        _imgViewBubble.tintColor = ChatBubbleLeftConfigShare.textBackgroundColor;
        
        _imgViewBubble.delegate = self;
    }
    
    return _imgViewBubble;
}

- (UILabel *)lbTime
{
    if (!_lbTime)
    {
        _lbTime = [UILabel new];
        [_lbTime setFont:[UIFont font_24]];
        [_lbTime setTextColor:ChatBubbleLeftConfigShare.timeColor];
    }
    
    return _lbTime;
}

- (UILabel *)lbName
{
    if (!_lbName)
    {
        _lbName = [UILabel new];
        [_lbName setFont:[UIFont font_24]];
        [_lbName setTextColor:[UIColor blackColor]];
        [_lbName setBackgroundColor:[UIColor clearColor]];
        [_lbName setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    
    return _lbName;
}

- (UIImageView *)imgViewHeadIcon
{
    if (!_imgViewHeadIcon)
    {
        _imgViewHeadIcon = [UIImageView new];
        [_imgViewHeadIcon setUserInteractionEnabled:YES];
        _imgViewHeadIcon.layer.cornerRadius = 2.5;
        _imgViewHeadIcon.clipsToBounds = YES;
//        _imgViewHeadIcon.layer.shouldRasterize = YES;
//        _imgViewHeadIcon.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    
    return _imgViewHeadIcon;
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
