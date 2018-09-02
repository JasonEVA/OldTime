//
//  MissionSendFromMeMessageCardCell.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/20.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionSendFromMeMessageCardCell.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "LeftTriangle.h"

@interface MissionSendFromMeMessageCardCell ()
@property (strong, nonatomic) UIView *cardView;      //整个卡片View
@property (nonatomic, strong) UIView *headView;     //头部标题View
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *typeTitel;

@property(nonatomic, strong) UILabel  *rightLb;
@property(nonatomic, strong) UILabel  *memberLb;

@property (nonatomic, strong) UILabel *receiveTimeLb;
@property (nonatomic, strong) UIView *line1;

@property(nonatomic, strong) UILabel  *commenterLabel; //评论人的姓名
@property(nonatomic, strong) UILabel  *commentDetailLabel;  //评论了该条任务

@property (nonatomic, strong)  UIImageView  *avatar; // 头像
@property (nonatomic, strong)  UILabel  *name; // 姓名
@property (nonatomic, strong) LeftTriangle *leftTri; // 尖角

@end

@implementation MissionSendFromMeMessageCardCell
+ (NSString *)identifier { return NSStringFromClass([self class]);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self configElements];
    }
    return self;
}
#pragma mark -private method
- (void)configElements {
    [self.contentView addSubview:self.avatar];
    [self.contentView addSubview:self.name];
    [self.contentView addSubview:self.cardView];
    [self.contentView addSubview:self.receiveTimeLb];
    [self.contentView addSubview:self.leftTri];

    [self.headView addSubview:self.typeTitel];
    
    [self.cardView addSubview:self.titelLb];
    [self.cardView addSubview:self.headView];
    [self.cardView addSubview:self.line1];
    [self.cardView addSubview:self.commenterLabel];
    [self.cardView addSubview:self.commentDetailLabel];

    [self.receiveTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(20);
        make.height.equalTo(@20);
    }];
    
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12.5);
        make.top.equalTo(self.receiveTimeLb.mas_bottom).offset(2.5);
        make.width.height.equalTo(@40);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar.mas_right).offset(12);
        make.top.equalTo(self.avatar);
        make.height.equalTo(@20);
    }];

    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom);
        make.left.equalTo(self.name);
        make.right.equalTo(self.contentView).offset(-12);
        make.height.equalTo(@90);
    }];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.cardView);
        make.height.equalTo(@30);
    }];
    [self.leftTri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView);
        make.right.equalTo(self.headView.mas_left).offset(1);
        make.width.equalTo(@8);
        make.height.equalTo(@300);
    }];

    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.cardView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.headView);
    }];

    [self.typeTitel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardView).offset(15);
        make.centerY.equalTo(self.headView);
    }];
    
    
//    [self.commenterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titelLb);
//        make.top.equalTo(self.line1.mas_bottom).offset(9);
//    }];
    
//    [self.commenterLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.commentDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeTitel);
        make.top.equalTo(self.line1.mas_bottom).offset(9);
        make.right.lessThanOrEqualTo(self.cardView).offset(-5);
    }];
    
    [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentDetailLabel.mas_bottom).offset(9);
        make.left.equalTo(self.commentDetailLabel);
        make.right.lessThanOrEqualTo(self.cardView).offset(-5);
    }];
    [self.cardView addSubview:self.rightLb];
    [self.rightLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cardView.mas_right).offset(-5);
        make.bottom.equalTo(self.titelLb);
    }];
    
}

- (UILabel *)getLebalWithTitel:(NSString *)titel font:(UIFont *)font textColor:(UIColor *)textColor
{
    UILabel *lb = [UILabel new];
    [lb setText:titel];
    [lb setTextColor:textColor];
    [lb setFont:font];
    return lb;
}

- (void)setCellDataWithModel:(MissionDetailModel *)model
{
    NSString *avatarUid;
    NSString *name;
    if (!model.senderId && !model.senderName) {
        if (model.eventType == k_comment) {
            // 评论
            if (model.isSendFromMe) {
                // 我发出的任务，显示参与者
                avatarUid = model.participatorID;
                name = model.participatorName;
            }
            else {
                // 不是我发出的任务，显示创建者
                avatarUid = model.createUserID;
                name = model.createUserName;
            }
        }
        else {
            // 系统消息
            avatarUid = @"";
            name = @"系统消息";
        }
    }
    else {
        avatarUid = model.senderId;
        name = model.senderName;
    }
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [self.avatar sd_setImageWithURL:avatarURL(avatarType_80,avatarUid) placeholderImage:[UIImage imageNamed:(model.eventType == k_comment) ? @"img_default_staff" : @"mission_icon_sysMsg"]];
    self.name.text = name;
    
    [self.titelLb setText:[NSString stringWithFormat:@"任务:%@",model.taskTitle]];

    if (model.eventType == k_comment)
    {
        self.commenterLabel.hidden = NO;
         self.commenterLabel.text = @"评论：";
        self.commentDetailLabel.text = model.commentContent;
    }
//    else if (model.eventType == k_Remind) {
//        self.commenterLabel.hidden = YES;
//        self.commenterLabel.text = @"";
//        self.commentDetailLabel.text = model.msgInfo;
//    }
//    else
//    {
//        [self.rightLb setText:model.taskStatus ==TaskStatusTypeDisabled?@"已拒绝":@"已接受"];
//        [self.rightLb setTextColor:model.taskStatus ==TaskStatusTypeDisabled?[UIColor commonRedColor]:[UIColor commonGreenColor]];
//        [self.memberLb setAttributedText:[NSAttributedString getAttributWithChangePart:model.createUserName UnChangePart:@"参与者:" UnChangeColor:[UIColor commonDarkGrayColor_666666] UnChangeFont:nil]];
//    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.createTime longLongValue]]]]];
}

#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface

#pragma mark - init UI

- (UIView *)cardView
{
    if (!_cardView) {
        _cardView = [UIView new];
        [_cardView setBackgroundColor:[UIColor whiteColor]];
        [_cardView.layer setCornerRadius:5];
        [_cardView.layer setBorderWidth:0.5];
        [_cardView.layer setBorderColor:[UIColor colorWithHex:0xdfdfdf].CGColor];
        [_cardView setClipsToBounds:YES];
    }
    return _cardView;
}

- (UIView *)headView
{
    if (!_headView) {
        _headView = [UIView new];
        [_headView setBackgroundColor:[UIColor colorWithHex:0xdfdfdf]];
    }
    return _headView;
}

- (UILabel *)titelLb
{
    if (!_titelLb) {
        _titelLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:13] textColor:[UIColor commonLightGrayColor_999999]];
    }
    return _titelLb;
}
- (UILabel *)typeTitel
{
    if (!_typeTitel) {
        _typeTitel = [self getLebalWithTitel:@"评论" font:[UIFont systemFontOfSize:15] textColor:[UIColor commonBlackTextColor_333333]];
    }
    return _typeTitel;
}
- (UILabel *)rightLb
{
    if (!_rightLb)
    {
        _rightLb = [[UILabel alloc] init];
    }
    return _rightLb;
}

- (UILabel *)memberLb
{
    if (!_memberLb)
    {
        _memberLb = [[UILabel alloc] init];
    }
    return _memberLb;
}

- (UILabel *)receiveTimeLb
{
    if (!_receiveTimeLb) {
        _receiveTimeLb = [self getLebalWithTitel:@" 12-12 18:13 " font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithHexString:@"FFFFFF"]];
        [_receiveTimeLb.layer setCornerRadius:3];
        [_receiveTimeLb setBackgroundColor:[UIColor colorWithHexString:@"cecece"]];
        [_receiveTimeLb setClipsToBounds:YES];
        
    }
    return _receiveTimeLb;
}

- (UIView *)line1
{
    if (!_line1) {
        _line1 = [UIView new];
        [_line1 setBackgroundColor:[UIColor colorWithHexString:@"dfdfdf"]];
    }
    return _line1;
}

- (UILabel *)commenterLabel
{
    if (!_commenterLabel)
    {
        _commenterLabel = [UILabel new];
        _commenterLabel.font = [UIFont systemFontOfSize:13];
        _commenterLabel.textColor = [UIColor commonGrayTextColor];
        _commenterLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _commenterLabel;
}

- (UILabel *)commentDetailLabel
{
    if (!_commentDetailLabel)
    {
        _commentDetailLabel = [UILabel new];
        _commentDetailLabel.textColor = [UIColor commonBlackTextColor_333333];
        _commentDetailLabel.font = [UIFont systemFontOfSize:15];
        _commentDetailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _commentDetailLabel;
}

- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [UIImageView new];
        _avatar.layer.cornerRadius = 2;
        _avatar.clipsToBounds = YES;
    }
    return _avatar;
}

- (UILabel *)name {
    if (!_name) {
        _name = [UILabel new];
        _name.text = @"我是姓名";
        [_name setTextAlignment:NSTextAlignmentCenter];
        [_name setFont:[UIFont font_26]];
        [_name setTextColor:[UIColor commonTextColor]];
    }
    return _name;
}

- (LeftTriangle *)leftTri
{
    if (!_leftTri)
    {
        _leftTri = [[LeftTriangle alloc] initWithFrame:CGRectZero WithColor:[UIColor colorWithHex:0xdfdfdf] colorBorderColor:[UIColor colorWithHex:0xdfdfdf]];
    }
    return _leftTri;
}

@end
