//
//  MissionRightMessageTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 16/8/2.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionRightMessageTableViewCell.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "NSDate+String.h"
#import "AvatarUtil.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import <UIImageView+WebCache.h>
#import "RightTriangle.h"
#import "MissionDetailModel.h"

@interface MissionRightMessageTableViewCell()
@property (strong, nonatomic) UIView *cardView;      //整个卡片View
@property (nonatomic, strong) UIView *headView;     //头部标题View
@property (nonatomic, strong) UILabel *typeTitel;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UIImageView *deadLinetimeImage;
@property (nonatomic, strong) UILabel *deadLinetimeLb;
@property (nonatomic, strong) UIImageView *memberImage;
@property (nonatomic, strong) UILabel *memberLb;
@property (nonatomic, strong) UILabel *patientLb;
@property (nonatomic, strong) UILabel *receiveTimeLb;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong)  UIImageView  *avatar; // 头像
@property (nonatomic, strong)  UILabel  *name; // 姓名
@property (nonatomic, strong) RightTriangle *leftTri; // 尖角

//@property (nonatomic, copy) MissionMessageCardCellBlock clickBlock;
@end

@implementation MissionRightMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
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
    [self.cardView addSubview:self.deadLinetimeImage];
    [self.cardView addSubview:self.deadLinetimeLb];
    [self.cardView addSubview:self.memberImage];
    [self.cardView addSubview:self.memberLb];
    [self.cardView addSubview:self.patientLb];
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
        make.right.equalTo(self.contentView).offset(-12.5);
        make.top.equalTo(self.receiveTimeLb.mas_bottom).offset(2.5);
        make.width.height.equalTo(@40);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.avatar.mas_left).offset(-12);
        make.top.equalTo(self.avatar);
        make.height.equalTo(@20);
    }];
    
    [self.cardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom);
        make.right.equalTo(self.name);
        make.left.equalTo(self.contentView).offset(12);
        make.height.equalTo(@(140));
    }];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.cardView);
        make.height.equalTo(@30);
    }];
    [self.leftTri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView);
        make.left.equalTo(self.headView.mas_right).offset(-1);
        make.width.equalTo(@8);
        make.height.equalTo(@30);
    }];
    
    [self.typeTitel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardView).offset(15);
        make.centerY.equalTo(self.headView);
        make.right.lessThanOrEqualTo(self.headView).offset(-5);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.cardView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.headView);
    }];
    
    [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).offset(11);
        make.left.equalTo(self.typeTitel);
        make.right.lessThanOrEqualTo(self.cardView).offset(-5);
    }];
    
    [self.deadLinetimeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeTitel);
        make.top.equalTo(self.titelLb.mas_bottom).offset(11);
        make.width.height.equalTo(@13);
    }];
    
    [self.deadLinetimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.deadLinetimeImage);
        make.left.equalTo(self.deadLinetimeImage.mas_right).offset(3);
    }];
    
    [self.memberImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeTitel);
        make.top.equalTo(self.deadLinetimeImage.mas_bottom).offset(9);
        make.width.height.equalTo(@13);
    }];
    
    [self.memberLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deadLinetimeLb);
        make.top.equalTo(self.deadLinetimeImage.mas_bottom).offset(9);
        make.right.lessThanOrEqualTo(self.cardView).offset(-9);
    }];
    
    [self.patientLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeTitel);
        make.top.equalTo(self.memberLb.mas_bottom).offset(9);
        make.right.lessThanOrEqualTo(self.cardView).offset(-9);
    }];
    
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
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [self.avatar sd_setImageWithURL:avatarURL(avatarType_80,model.createUserID) placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    self.name.text = model.createUserName;
    
    [self.titelLb setText:model.taskTitle];
    //    [self setPriority:model.taskPriority];
    [self.deadLinetimeLb setText:model.endTime];
    [self.memberLb setAttributedText:[NSAttributedString getAttributWithChangePart:model.participatorName UnChangePart:@"执行者:" UnChangeColor:[UIColor commonBlackTextColor_333333] UnChangeFont:nil]];
    [self.patientLb setAttributedText:[NSAttributedString getAttributWithChangePart:[self handlePatientNameWithStr:model.pShowName] UnChangePart:@"服务群:" UnChangeColor:[UIColor commonLightGrayColor_999999] UnChangeFont:nil]];
    //    [self.sendFromLb setAttributedText:[NSAttributedString getAttributWithChangePart:model.createUserName UnChangePart:@"来自 " UnChangeColor:[UIColor commonLightGrayColor_999999] UnChangeFont:nil]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.createTime longLongValue]]]]];
    
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

#pragma mark - event Response
- (void)btnClick:(UIButton *)btn
{
//    if (self.clickBlock) {
//        self.clickBlock(btn.tag);
//    }
}
#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
//- (void)clickBtnBlock:(MissionMessageCardCellBlock)clickBlock
//{
//    self.clickBlock = clickBlock;
//}

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
        [_headView setBackgroundColor:[UIColor colorWithHex:0x66c2ff]];
    }
    return _headView;
}

- (UILabel *)typeTitel
{
    if (!_typeTitel) {
        _typeTitel = [self getLebalWithTitel:@"任务" font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor]];
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
        _patientLb = [self getLebalWithTitel:@"用户：李明" font:[UIFont systemFontOfSize:13] textColor:[UIColor commonLightGrayColor_999999]];
    }
    return _patientLb;
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

- (RightTriangle *)leftTri
{
    if (!_leftTri)
    {
        _leftTri = [[RightTriangle alloc] initWithFrame:CGRectZero WithColor:[UIColor colorWithHex:0x66c2ff] colorBorderColor:[UIColor colorWithHex:0xdfdfdf]];
    }
    return _leftTri;
}
@end
