//
//  ApplyCCSendTableViewCell.m
//  launcher
//
//  Created by Kyle He on 15/8/13.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplySendTableViewCell.h"
#import <Masonry/Masonry.h>
#import "RoundCountView.h"
#import "UIView+Util.h"
#import "MyDefine.h"
#import "Category.h"

typedef enum
{
    UNACCEPT = 0,       // 不被接受
    ACCEPT,             // 接受
    CANCLED,            // 驳回
    DEALING,            // 进行中
    ACCEPTADNTRANSFER   // 待审批
} APPLYEVENTSTATE;       // 请求事件状态

@interface ApplySendTableViewCell ()
/**
 *  标题
 */
@property(nonatomic, strong) UILabel  *titleLb;
/**
 *  时间
 */
@property(nonatomic, strong) UILabel  *timeLb;
/**
 *  事件状态
 */
@property (nonatomic , strong)  UIButton *stateBtn;
/**
 *  评论图标
 */
@property(nonatomic, strong) UIImageView  *commentIcon;

/**
 *  附件图标
 */
@property (nonatomic , strong) UIImageView  *CCIcon;

/**
 *  左侧红色角标
 */
@property(nonatomic, strong) UILabel  *cornerTag;
/**
 *   评论图标角标
 */
@property(nonatomic, strong) UIImageView  *commentTag;

@property (nonatomic, strong) UIImageView *imgviewPass;

@end

@implementation ApplySendTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier ])
    {
        [self createFrame];
        self.cornerTag.hidden = YES;
    }
    return self;
}

#pragma mark - interaface method 

- (void)setTagHide
{
    self.cornerTag.hidden = YES;
    self.commentTag.hidden = YES;
}

- (void)setCellWithModel:(ApplyGetSendListModel *)model
{
    self.titleLb.text = model.title;
    NSDate *date = model.createTime;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd"];
    NSString *timeStr = [format stringFromDate:date];
    self.timeLb.text = timeStr;
    [self setStateTitle:model.status];
    if (model.Unreadmsg)
    {
        self.cornerTag.hidden = NO;
    }
    else
    {
        self.cornerTag.hidden = YES;
    }
    if (model.UnreadComment)
    {
        self.commentTag.hidden = NO;
    }
    else
    {
        self.commentTag.hidden = YES;
    }
    self.CCIcon.hidden = !model.IS_HAVEFILE;
    self.commentIcon.hidden = !model.IS_HAVECOMMENT;
    self.imgviewPass.hidden = !(model.A_APPROVE_PATH.length > 0);
}

- (void)setCCCellWithModel:(ApplyGetReceiveListModel *)model
{
    
    self.titleLb.text = model.A_TITLE;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.CREATE_TIME/1000];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd"];
    NSString *timeStr = [format stringFromDate:date];
    self.timeLb.text = timeStr;
    [self setStateTitle:model.A_STATUS];
    if (model.Unreadmsg)
    {
        self.cornerTag.hidden = NO;
    }
    else
    {
        self.cornerTag.hidden = YES;
    }
    if (model.UnreadComment)
    {
        self.commentTag.hidden = NO;
    }
    else
    {
        self.commentTag.hidden = YES;
    }
    self.CCIcon.hidden = !model.IS_HAVEFILE;
    self.imgviewPass.hidden = !(model.A_APPROVE_PATH.length > 0);
}


- (void)OnlyUsedInSearch_setCellWithModel:(ApplyGetReceiveListModel *)model
{
    self.titleLb.text = model.A_TITLE;
    if (model.isInSearchView)
    {
        if ([[model.A_TITLE lowercaseString] rangeOfString:[model.searchKey lowercaseString]].location != NSNotFound)
        {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:model.A_TITLE];
            [str addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:[[model.A_TITLE lowercaseString] rangeOfString:[model.searchKey lowercaseString]]];
            self.titleLb.attributedText = str;
        }
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.CREATE_TIME/1000];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd"];
    NSString *timeStr = [format stringFromDate:date];
    self.timeLb.text = timeStr;
    [self setStateTitle:model.A_STATUS];
    self.imgviewPass.hidden = !(model.A_APPROVE_PATH.length > 0);
}

- (void)setStateTitle:(NSString *)statusTitle
{
    //根据statu动态改变颜色
    if ([statusTitle isEqualToString:@"APPROVE"])
    {
        [self changeStatement:ACCEPT];
    }
    if ([statusTitle isEqualToString:@"WAITING"])
    {
        [self changeStatement:ACCEPTADNTRANSFER];
    }
    if ([statusTitle isEqualToString:@"IN_PROGRESS"])
    {
        [self changeStatement:DEALING];
    }
    if ([statusTitle isEqualToString:@"DENY"])
    {
        [self changeStatement:UNACCEPT];
    }
    if ([statusTitle isEqualToString:@"CALL_BACK"])
    {
        [self changeStatement:CANCLED];
    }
}

#pragma mark - Pravite Method
- (void)changeStatement:(APPLYEVENTSTATE)state
{
    switch (state) {
        case UNACCEPT:
        {
            [self.stateBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor themeRed]] forState:UIControlStateNormal];
            [self.stateBtn setTitle:LOCAL(APPLY_SENDER_UNACCEPT_TITLE) forState:UIControlStateNormal];
            break;
        }
        case ACCEPT:
        {
            [self.stateBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor mtc_colorWithHex:0x22c064]] forState:UIControlStateNormal];
            [self.stateBtn setTitle:LOCAL(APPLY_SENDER_ACCEPT_TITLE) forState:UIControlStateNormal];
            break;
        }
        case CANCLED:
        {
            [self.stateBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor mtc_colorWithHex:0xff8447]] forState:UIControlStateNormal];
            [self.stateBtn setTitle:LOCAL(APPLY_SENDER_BACKWARD_TITLE) forState:UIControlStateNormal];
            break;
        }
        case DEALING:
        {
            [self.stateBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor mtc_colorWithHex:0x0099ff]] forState:UIControlStateNormal];
            [self.stateBtn setTitle:LOCAL(APPLY_SENDER_DEALING_TITLE) forState:UIControlStateNormal];
            break;
        }
        case ACCEPTADNTRANSFER:
        {
            [self.stateBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor mtc_colorWithHex:0x0099ff]] forState:UIControlStateNormal];
            [self.stateBtn setTitle:LOCAL(APPLY_SENDER_WAITDEAL_TITLE) forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}

#pragma mark - createFrame

- (void)createFrame
{
    [self.contentView addSubview:self.cornerTag];
    [self.cornerTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(5);
        make.top.equalTo(self.contentView).offset(10);
        make.width.equalTo(@(6));
        make.height.equalTo(@(6));
    }];
    [self.contentView addSubview:self.stateBtn];
    [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-13);
        make.top.equalTo(self.contentView).offset(10);
        make.height.equalTo(@19);
        make.width.lessThanOrEqualTo(@60);
    }];
    [self.contentView addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(13);
        make.top.equalTo(self.contentView).offset(10);
        make.right.lessThanOrEqualTo(self.stateBtn.mas_left);
    }];
    
    [self.contentView addSubview:self.timeLb];
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.contentView addSubview:self.cornerTag];
    [self.cornerTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.top.equalTo(self).offset(10);
    }];
    
    [self.contentView addSubview:self.commentIcon];
    [self.commentIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.stateBtn);
        make.bottom.equalTo(self).offset(-12);
    }];
    
    [self addSubview:self.commentTag];
    [self.commentTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.commentIcon).offset(2);
        make.top.equalTo(self.commentIcon).offset(-2);
        make.width.equalTo(@(4));
        make.height.equalTo(@(4));
    }];
    
    [self addSubview:self.CCIcon];
    [self.CCIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentIcon);
        make.right.equalTo(self.commentIcon.mas_left).offset(-15);
        make.width.equalTo(@(13));
        make.height.equalTo(@(13));
    }];
    
    [self addSubview:self.imgviewPass];
    [self.imgviewPass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentIcon);
        make.right.equalTo(self.CCIcon.mas_left).offset(-15);
        make.width.equalTo(@(13));
        make.height.equalTo(@(13));
    }];
}

#pragma mark - Initializer
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont mtc_font_30];
    }
    return _titleLb;
}

- (UILabel *)timeLb
{
    if (!_timeLb)
    {
        _timeLb = [[UILabel alloc]init];
        _timeLb.textColor = [UIColor mediumFontColor];
        _timeLb.font = [UIFont mtc_font_26];
    }
    return _timeLb;
}

- (UIButton *)stateBtn
{
    if (!_stateBtn)
    {
        _stateBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _stateBtn.expandSize = CGSizeMake(35, 0);
        _stateBtn.layer.cornerRadius = self.frame.size.height * 0.20;
        _stateBtn.layer.masksToBounds = YES;
        [_stateBtn setTintColor:[UIColor whiteColor]];
        _stateBtn.titleLabel.font = [UIFont mtc_font_24];
        _stateBtn.userInteractionEnabled = NO;
        
    }
    return _stateBtn;
}

- (UIImageView *)commentIcon
{
    if (!_commentIcon)
    {
        _commentIcon = [[UIImageView alloc]init];
        _commentIcon.image = [UIImage imageNamed:@"comment"];
    }
    return _commentIcon;
}

- (UILabel *)cornerTag
{
    if (!_cornerTag)
    {
        _cornerTag = [[UILabel alloc]init];
        _cornerTag.frame = CGRectMake(0, 0, 6, 6);
        _cornerTag.layer.cornerRadius = 3.0f;
        _cornerTag.clipsToBounds = YES;
        _cornerTag.backgroundColor = [UIColor redColor];
    }
    return _cornerTag;
}

- (UIImageView *)commentTag
{
    if (!_commentTag) {
        _commentTag = [[UIImageView alloc]init];
        _commentTag.layer.cornerRadius = 1.5;
        _commentTag.layer.masksToBounds = YES;
        _commentTag.hidden = YES;
        [_commentTag setImage:[UIImage mtc_imageColor:[UIColor themeRed] size:CGSizeMake(3, 3)]];
    }
    return _commentTag;
}

- (UIImageView *)CCIcon
{
    if (!_CCIcon)
    {
        _CCIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _CCIcon.image = [UIImage imageNamed:@"paper-clip"];
        _CCIcon.hidden = YES;
        [self.contentView addSubview:_CCIcon];
    }
    return _CCIcon;
}

- (UIImageView *)imgviewPass
{
    if (!_imgviewPass)
    {
        _imgviewPass = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowright"]];
    }
    return _imgviewPass;
}
@end
