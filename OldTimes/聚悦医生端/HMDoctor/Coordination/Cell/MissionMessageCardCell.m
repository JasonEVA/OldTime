//
//  MissionMessageCardCell.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionMessageCardCell.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "NSDate+String.h"
#import "AvatarUtil.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import <UIImageView+WebCache.h>
#import "LeftTriangle.h"

@interface MissionMessageCardCell()
@property (strong, nonatomic) UIView *cardView;      //整个卡片View
@property (nonatomic, strong) UIView *headView;     //头部标题View
@property (nonatomic, strong) UILabel *typeTitel;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *rightLb;
@property (nonatomic, strong) UIImageView *deadLinetimeImage;
@property (nonatomic, strong) UILabel *deadLinetimeLb;
@property (nonatomic, strong) UIImageView *memberImage;
@property (nonatomic, strong) UILabel *memberLb;
@property (nonatomic, strong) UILabel *patientLb;
@property (nonatomic, strong) UILabel *refuseReson;
//@property (nonatomic, strong) UIImageView *stateImageView;
//@property (nonatomic, strong) UILabel *stateLb;
//@property (nonatomic, strong) UIView *priorityView;
//@property (nonatomic, strong) UILabel *priorityLb;
@property (nonatomic, strong) UIButton *acceptBtn;
@property (nonatomic, strong) UIButton *refustBtn;
//@property (nonatomic, strong) UILabel *sendFromLb;
@property (nonatomic, strong) UILabel *receiveTimeLb;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIView *line3;
@property (nonatomic, strong) UIImageView *acceptOrRefuseImageView;
@property (nonatomic, strong)  UIImageView  *avatar; // 头像
@property (nonatomic, strong)  UILabel  *name; // 姓名
@property (nonatomic, strong) LeftTriangle *leftTri; // 尖角

@property (nonatomic) BOOL isHandled;
@property (nonatomic, copy) MissionMessageCardCellBlock clickBlock;
@property (nonatomic, strong) MissionDetailModel *detailModel;
@end

@implementation MissionMessageCardCell
+ (NSString *)identifier { return NSStringFromClass([self class]);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.isHandled = arc4random() % 2;
        [self configElements];
    }
    return self;
}

#pragma mark -private method
- (void)configElements {
    [self.contentView addSubview:self.avatar];
    [self.contentView addSubview:self.name];
    [self.contentView addSubview:self.cardView];
//    [self.contentView addSubview:self.sendFromLb];
    [self.contentView addSubview:self.receiveTimeLb];
    [self.contentView addSubview:self.leftTri];
    [self.cardView addSubview:self.acceptOrRefuseImageView];
    [self.headView addSubview:self.typeTitel];
    [self.headView addSubview:self.rightLb];
    
    [self.cardView addSubview:self.titelLb];
    [self.cardView addSubview:self.headView];
    [self.cardView addSubview:self.deadLinetimeImage];
    [self.cardView addSubview:self.deadLinetimeLb];
    [self.cardView addSubview:self.memberImage];
    [self.cardView addSubview:self.memberLb];
    [self.cardView addSubview:self.patientLb];
//    [self.cardView addSubview:self.stateImageView];
//    [self.cardView addSubview:self.stateLb];
//    [self.cardView addSubview:self.priorityView];
//    [self.cardView addSubview:self.priorityLb];
    [self.cardView addSubview:self.line1];

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
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

    [self.cardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom);
        make.left.equalTo(self.name);
        make.right.equalTo(self.contentView).offset(-12);
        CGFloat hei = 0;
        if (self.isHandled) {
            if (self.detailModel.taskStatus == TaskStatusTypeDisabled) {
                hei = 166;
            }
            else {
            hei = 175 - 35;
            }
        }
        else {
                hei = 180;
        }
        make.height.equalTo(@(hei));
    }];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.cardView);
        make.height.equalTo(@30);
    }];
    [self.leftTri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView);
        make.right.equalTo(self.headView.mas_left).offset(1);
        make.width.equalTo(@8);
        make.height.equalTo(@30);
    }];

    [self.typeTitel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardView).offset(15);
        make.centerY.equalTo(self.headView);
        make.right.lessThanOrEqualTo(self.rightLb.mas_left);
    }];
    
    [self.rightLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cardView).offset(-9);
        make.centerY.equalTo(self.headView);
    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.cardView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.headView);
    }];
    
    [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).offset(10);
        make.left.equalTo(self.cardView).offset(15);
        make.right.lessThanOrEqualTo(self.cardView).offset(-5);
    }];
    
    [self.deadLinetimeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardView).offset(15);
        make.top.equalTo(self.titelLb.mas_bottom).offset(10);
        make.width.height.equalTo(@13);
    }];
    
    [self.deadLinetimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.deadLinetimeImage);
        make.left.equalTo(self.deadLinetimeImage.mas_right).offset(3);
    }];
    
    [self.memberImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deadLinetimeImage);
        make.top.equalTo(self.deadLinetimeImage.mas_bottom).offset(10);
        make.width.height.equalTo(@13);
    }];
    
    [self.memberLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deadLinetimeLb);
        make.centerY.equalTo(self.memberImage);
        make.right.lessThanOrEqualTo(self.cardView).offset(-9);
    }];
    
    [self.patientLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deadLinetimeImage);
        make.top.equalTo(self.memberLb.mas_bottom).offset(10);
        make.right.lessThanOrEqualTo(self.cardView).offset(-9);
    }];
    
//    [self.stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.deadLinetimeImage);
//        make.top.equalTo(self.memberLb.mas_bottom).offset(9);
//    }];
//    [self.stateLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.stateImageView);
//        make.left.equalTo(self.stateImageView.mas_right).offset(9);
//    }];
    
//    [self.priorityView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.stateLb.mas_right).offset(25);
//        make.centerY.equalTo(self.stateLb);
//        make.width.height.equalTo(@10);
//    }];
//    
//    [self.priorityLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.priorityView);
//        make.left.equalTo(self.priorityView.mas_right).offset(9);
//        make.right.lessThanOrEqualTo(self.cardView);
//    }];
    
    if (self.isHandled) { //已处理
        
        
        [self.acceptBtn removeFromSuperview];
        [self.refustBtn removeFromSuperview];
        [self.line3 removeFromSuperview];
        [self.line2 removeFromSuperview];
        
        
        [self.acceptOrRefuseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.cardView);
        }];
    } else { //未处理
        [self.cardView addSubview:self.acceptBtn];
        [self.cardView addSubview:self.refustBtn];
        [self.cardView addSubview:self.line3];
        [self.cardView addSubview:self.line2];
        [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.cardView);
            make.height.equalTo(@0.5);
            make.bottom.equalTo(self.cardView).offset(-35);
        }];
        [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0.5);
            make.top.equalTo(self.line2);
            make.bottom.centerX.equalTo(self.cardView);
        }];
        [self.acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.cardView);
            make.top.equalTo(self.line2.mas_bottom);
            make.right.equalTo(self.line3.mas_left);
        }];
        
        [self.refustBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.cardView);
            make.top.equalTo(self.line2.mas_bottom);
            make.left.equalTo(self.line3.mas_right);
        }];
        
    }
//    [self.sendFromLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.cardView.mas_bottom).offset(5);
//        make.height.mas_equalTo(20);
//        make.right.equalTo(self.cardView);
//    }];

    [super updateConstraints];
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
        avatarUid = model.senderId;
        name = model.senderName;
    }
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [self.avatar sd_setImageWithURL:avatarURL(avatarType_80,avatarUid) placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    self.name.text = name;
    
    [self.titelLb setText:model.taskTitle];
//    [self setPriority:model.taskPriority];
    [self.deadLinetimeLb setText:model.endTime];
    // 默认隐藏
    self.acceptOrRefuseImageView.hidden = YES;
    [self.memberLb setAttributedText:[NSAttributedString getAttributWithChangePart:model.participatorName UnChangePart:@"执行者:" UnChangeColor:[UIColor commonBlackTextColor_333333] UnChangeFont:nil]];
    [self.patientLb setAttributedText:[NSAttributedString getAttributWithChangePart:[self handlePatientNameWithStr:model.pShowName] UnChangePart:@"服务群:" UnChangeColor:[UIColor commonLightGrayColor_999999] UnChangeFont:nil]];
//    [self.sendFromLb setAttributedText:[NSAttributedString getAttributWithChangePart:model.createUserName UnChangePart:@"来自 " UnChangeColor:[UIColor commonLightGrayColor_999999] UnChangeFont:nil]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.createTime longLongValue]]]]];
//    self.sendFromLb.hidden = model.isSendFromMe;
    
    [self.refuseReson removeFromSuperview];
    if (model.taskStatus == TaskStatusTypeDisabled)
    {
        [self.refuseReson setText:[NSString stringWithFormat:@"拒绝理由:%@",model.reason]];
        [self.cardView addSubview:self.refuseReson];
        [self.refuseReson mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.patientLb.mas_bottom).offset(10);
            make.left.equalTo(self.patientLb);
            make.right.lessThanOrEqualTo(self.cardView).offset(-5);
        }];
    }

//    if(model.taskStatus == TaskStatusTypeDone) {
//        [self.stateLb setText:@"已完成"];
//        [self.stateImageView setImage:[UIImage imageNamed:@"Mission_Mark"]];
//        self.deadLinetimeLb.textColor = [UIColor commonGrayTextColor];
//        self.deadLinetimeImage.image = [UIImage imageNamed:@"Mission_grayclock"];
//    }else if(model.taskStatus == TaskStatusTypeExpired)
//    {
//        [self.stateLb setText:@"待执行"];
//        [self.stateImageView setImage:[UIImage imageNamed:@"Mission_UNMark"]];
//        self.deadLinetimeLb.textColor = [UIColor commonRedColor];
//        self.deadLinetimeImage.image = [UIImage imageNamed:@"Mission_redClock"];
//    }else if (model.taskStatus == TaskStatusTypeDisabled)
//    {
//        self.stateLb.text = @"已拒绝";
//        [self.stateImageView setImage:[UIImage imageNamed:@"Mission_RefuseAlrelday"]];
//        self.deadLinetimeLb.textColor = [UIColor commonGrayTextColor];
//        self.deadLinetimeImage.image = [UIImage imageNamed:@"Mission_grayclock"];
//    }
//    else
//    {
//        [self.stateLb setText:@"待执行"];
//        [self.stateImageView setImage:[UIImage imageNamed:@"Mission_UNMark"]];
//        self.deadLinetimeLb.textColor = [UIColor commonRedColor];
//        self.deadLinetimeImage.image = [UIImage imageNamed:@"Mission_redClock"];
//    }
    
    self.rightLb.hidden = YES;
    UserInfo *info = [UserInfoHelper defaultHelper].currentUserInfo;
    
    //非事件的参与者，右上角会出现提示
    if (![[NSString stringWithFormat:@"%ld",info.userId] isEqualToString:model.participatorID])
    {
        self.rightLb.hidden = NO;
        //会有已接收和已拒绝两种状态,其他状态不显示
        if (model.taskStatus == TaskStatusTypeActivated)
        {
            self.rightLb.text = @"已接受";
            self.rightLb.textColor = [UIColor commonGreenColor];
        }else if(model.taskStatus == TaskStatusTypeDisabled)
        {
            self.rightLb.text = @"已拒绝";
            self.rightLb.textColor = [UIColor colorWithHexString:@"ff3366"];
        }else if(model.taskStatus == TaskStatusTypeExpired)
        {
            self.rightLb.text = @"已过期";
            self.rightLb.textColor = [UIColor commonGrayTextColor];
        }else if(model.taskStatus == TaskStatusTypeDone)
        {
            self.rightLb.text = @"已完成";
            self.rightLb.textColor = [UIColor colorWithHexString:@"0099ff"];
        }

        else
        {
            self.rightLb.hidden = YES;
        }
        self.acceptOrRefuseImageView.hidden = YES;
    }else
    {
        //消息不是我发出的，并且我是参与者的情况下，且状态已经是接受或者拒绝的时候，显示印章
        if (!model.isSendFromMe)
        {
            self.rightLb.hidden = YES;
            self.acceptOrRefuseImageView.hidden = YES;

            if ([[NSString stringWithFormat:@"%ld",info.userId] isEqualToString:model.participatorID])
            {
                self.rightLb.hidden = YES;
                self.acceptOrRefuseImageView.hidden = NO;
                if (model.taskStatus == TaskStatusTypeActivated){
                    self.acceptOrRefuseImageView.image = [UIImage imageNamed:@"Mission_accept"];
                }else if(model.taskStatus == TaskStatusTypeDisabled){
                    self.acceptOrRefuseImageView.image = [UIImage imageNamed:@"Mission_refuse-1"];
                }else if(model.taskStatus == TaskStatusTypeExpired){
                    self.acceptOrRefuseImageView.image = [UIImage imageNamed:@"Mission_passe"];
                }else if(model.taskStatus == TaskStatusTypeDone){
                    self.acceptOrRefuseImageView.image = [UIImage imageNamed:@"Mission_done"];
                }else{
                    self.acceptOrRefuseImageView.hidden = YES;
                }
            }
            
        }
    }
    
    self.deadLinetimeLb.text = [self timeHandleWithStartTime:model.startTime EndTime:model.endTime];
    self.isHandled = model.taskStatus;
    self.detailModel = model;

    [self setNeedsUpdateConstraints];
    [self updateConstraints];
}

- (NSString *)handlePatientNameWithStr:(NSString *)patientName
{
    NSArray *nameArray = [patientName componentsSeparatedByString:@"|"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *name in nameArray)
    {
        if (![name isEqualToString:@""])
        {
            [tempArray addObject:name];
        }
    }
    return [tempArray componentsJoinedByString:@","];
}

- (NSString *)timeHandleWithStartTime:(NSString *)startTime EndTime:(NSString *)endTime
{
    NSString *separate = startTime.length > 0 && endTime.length > 0 ? @"~" : @"";
    return [NSString stringWithFormat:@"%@%@%@",[self transformTimeWithTimestr:startTime],separate,[self transformTimeWithTimestr:endTime]];
}

- (NSString *)transformTimeWithTimestr:(NSString *)time
{
    if (time.length == 0) {
        return @"";
    }
    time = [time stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSArray *timeCompnentArray = [time componentsSeparatedByString:@" "];

    if (timeCompnentArray.count == 2) // 有时间的状态下
    {
        NSString *cutYearStr = [time substringFromIndex:4];
        NSMutableString *cutTialStr = [[cutYearStr substringToIndex:[cutYearStr length] -3] mutableCopy];
        [cutTialStr insertString:@"月" atIndex:2];
        [cutTialStr insertString:@"日" atIndex:5];
        return cutTialStr;
    }
    //没有时间的状态下
    
    time = [time substringFromIndex:4];
    NSMutableString *tempStr = [time mutableCopy];
    [tempStr insertString:@"月" atIndex:2];
    [tempStr insertString:@"日" atIndex:5];
    return tempStr;
}


//- (void)setPriority:(MissionTaskPriority)priority {
//    NSString *priorityString = @"";
//    UIColor *color;
//    switch (priority) {
//        case MissionTaskPriorityLow:
//            color = [UIColor colorWithHexString:@"ccccccc"];
//            priorityString = @"低";
//            break;
//        case MissionTaskPriorityMid:
//            color = [UIColor commonYellewColor_ffac4f];
//            priorityString = @"中";
//            break;
//        case MissionTaskPriorityHigh:
//            color = [UIColor commonRedColor];
//            priorityString = @"高";
//            break;
//        case MissionTaskPriorityNone:
//            color = [UIColor clearColor];
//            priorityString = @"";
//            break;
//    }
//    self.priorityLb.text = priorityString;
//    self.priorityView.backgroundColor = color;
//    self.priorityLb.textColor = color;
//}


#pragma mark - event Response
- (void)btnClick:(UIButton *)btn
{
    if (self.clickBlock) {
        self.clickBlock(btn.tag);
    }
}
#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
- (void)clickBtnBlock:(MissionMessageCardCellBlock)clickBlock
{
    self.clickBlock = clickBlock;
}

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

- (UILabel *)typeTitel
{
    if (!_typeTitel) {
        _typeTitel = [self getLebalWithTitel:@"任务" font:[UIFont systemFontOfSize:15] textColor:[UIColor commonBlackTextColor_333333]];
    }
    return _typeTitel;
}
- (UILabel *)titelLb
{
    if (!_titelLb) {
        _titelLb = [self getLebalWithTitel:@"随访" font:[UIFont systemFontOfSize:15] textColor:[UIColor commonBlackTextColor_333333]];
    }
    return _titelLb;
}

- (UILabel *)rightLb
{
    if (!_rightLb) {
        _rightLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:13] textColor:[UIColor commonDarkGrayColor_666666]];
    }
    return _rightLb;
}
- (UIImageView *)deadLinetimeImage
{
    if (!_deadLinetimeImage) {
        _deadLinetimeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time"]];
    }
    return _deadLinetimeImage;
}
- (UILabel *)deadLinetimeLb
{
    if (!_deadLinetimeLb) {
        _deadLinetimeLb = [self getLebalWithTitel:@"12.8" font:[UIFont systemFontOfSize:13] textColor:[UIColor commonBlackTextColor_333333]];
    }
    return _deadLinetimeLb;
}
- (UIImageView *)memberImage
{
    if (!_memberImage) {
        _memberImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"for"]];
    }
    return _memberImage;
}
- (UILabel *)memberLb
{
    if (!_memberLb) {
        _memberLb = [self getLebalWithTitel:@"参与者：李明" font:[UIFont systemFontOfSize:13] textColor:[UIColor commonBlackTextColor_333333]];
    }
    return _memberLb;
}

- (UILabel *)patientLb
{
    if (!_patientLb) {
        _patientLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:13] textColor:[UIColor commonLightGrayColor_999999]];
    }
    return _patientLb;
}
- (UILabel *)refuseReson
{
    if (!_refuseReson) {
        _refuseReson = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:13] textColor:[UIColor commonLightGrayColor_999999]];
    }
    return _refuseReson;
}
//- (UIImageView *)stateImageView
//{
//    if (!_stateImageView) {
//        _stateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mission_UNMark"]];
//    }
//    return _stateImageView;
//}
//
//- (UILabel *)stateLb
//{
//    if (!_stateLb) {
//        _stateLb = [self getLebalWithTitel:@"待执行" font:[UIFont systemFontOfSize:13] textColor:[UIColor commonBlackTextColor_333333]];
//    }
//    return _stateLb;
//}
//- (UIView *)priorityView
//{
//    if (!_priorityView) {
//        _priorityView = [UIView new];
//        [_priorityView setBackgroundColor:[UIColor redColor]];
//    }
//    return _priorityView;
//}
//
//- (UILabel *)priorityLb
//{
//    if (!_priorityLb) {
//        _priorityLb = [self getLebalWithTitel:@"高" font:[UIFont systemFontOfSize:14] textColor:[UIColor redColor]];
//    }
//    return _priorityLb;
//}

- (UIButton *)acceptBtn
{
    if (!_acceptBtn) {
        _acceptBtn = [UIButton new];
        [_acceptBtn setTitle:@"接受" forState:UIControlStateNormal];
        [_acceptBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_acceptBtn setTitleColor:[UIColor colorWithHexString:@"66c2ff"] forState:UIControlStateNormal];
        [_acceptBtn setTag:1];
        [_acceptBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];


    }
    return _acceptBtn;
}

- (UIButton *)refustBtn
{
    if (!_refustBtn) {
        _refustBtn = [UIButton new];
        [_refustBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [_refustBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_refustBtn setTitleColor:[UIColor colorWithHexString:@"ff3366"] forState:UIControlStateNormal];
        [_refustBtn setTag:0];
        [_refustBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refustBtn;
}

//- (UILabel *)sendFromLb
//{
//    if (!_sendFromLb) {
//        _sendFromLb = [self getLebalWithTitel:@"来自 Jason" font:[UIFont systemFontOfSize:14] textColor:[UIColor mainThemeColor]];
//    }
//    return _sendFromLb;
//}

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
- (UIView *)line2
{
    if (!_line2) {
        _line2 = [UIView new];
        [_line2 setBackgroundColor:[UIColor colorWithHexString:@"dfdfdf"]];
    }
    return _line2;
}
- (UIView *)line3
{
    if (!_line3) {
        _line3 = [UIView new];
        [_line3 setBackgroundColor:[UIColor colorWithHexString:@"dfdfdf"]];
    }
    return _line3;
}

- (UIImageView *)acceptOrRefuseImageView
{
    if (!_acceptOrRefuseImageView) {
        _acceptOrRefuseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mission_refuse-1"] highlightedImage:[UIImage imageNamed:@"Mission_accept"]];
    }
    return _acceptOrRefuseImageView;
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
