//
//  MainStartUesrAlertTableViewCell.m
//  HMDoctor
//
//  Created by yinqaun on 16/6/3.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MainStartUesrAlertTableViewCell.h"

//预警
@interface MainStartUserAlertView ()
{
    UIImageView* ivPartrait;
    UILabel* lbPatientName;
    UILabel* lbPatientInfo;
    UILabel* lbDetectValue;
    UILabel* uploadTimeLable;    //监测数据上传时间
    UILabel* lbDetectTime;      //测量时间
}
@end

@implementation MainStartUserAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        ivPartrait = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_default_user"]];
        [self addSubview:ivPartrait];
        ivPartrait.layer.cornerRadius = 2.5;
        ivPartrait.layer.masksToBounds = YES;
        
        [ivPartrait mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.equalTo(self).with.offset(13);
        }];
        
        lbPatientName = [[UILabel alloc]init];
        [self addSubview:lbPatientName];
        [lbPatientName setFont:[UIFont systemFontOfSize:15]];
        [lbPatientName setTextColor:[UIColor commonTextColor]];
        [lbPatientName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ivPartrait.mas_right).with.offset(6);
            make.top.equalTo(ivPartrait);
        }];
        
        _archiveButton = [[UIButton alloc] init];
        [self addSubview:_archiveButton];
        [_archiveButton setTitle:@"档案详情 >" forState:UIControlStateNormal];
        [_archiveButton setTitleColor:[UIColor commonLightGrayTextColor] forState:UIControlStateNormal];
        [_archiveButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_archiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-8);
            make.top.equalTo(lbPatientName).offset(-5);;
            make.width.mas_greaterThanOrEqualTo(@80);
        }];
        
        lbPatientInfo = [[UILabel alloc]init];
        [self addSubview:lbPatientInfo];
        [lbPatientInfo setFont:[UIFont systemFontOfSize:12]];
        [lbPatientInfo setTextColor:[UIColor commonTextColor]];
        
        [lbPatientInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lbPatientName).with.offset(1);
            make.left.equalTo(lbPatientName.mas_right).with.offset(2);
            make.right.lessThanOrEqualTo(_archiveButton.mas_left);
        }];
        
        lbDetectValue = [[UILabel alloc]init];
        [self addSubview:lbDetectValue];
        [lbDetectValue setFont:[UIFont systemFontOfSize:13]];
        [lbDetectValue setTextColor:[UIColor commonGrayTextColor]];
        
        [lbDetectValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbPatientName);
            make.bottom.equalTo(ivPartrait);
        }];
        
        lbDetectTime = [[UILabel alloc]init];
        [self addSubview:lbDetectTime];
        [lbDetectTime setFont:[UIFont systemFontOfSize:13]];
        [lbDetectTime setTextColor:[UIColor commonGrayTextColor]];
        
        [lbDetectTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbPatientName);
            make.right.lessThanOrEqualTo(self.mas_right).with.offset(-5);
            make.top.equalTo(lbDetectValue.mas_bottom).with.offset(7);
        }];
        
        uploadTimeLable = [[UILabel alloc]init];
        [self addSubview:uploadTimeLable];
        [uploadTimeLable setFont:[UIFont systemFontOfSize:13]];
        [uploadTimeLable setTextColor:[UIColor commonGrayTextColor]];
        
        [uploadTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbPatientName);
            make.right.lessThanOrEqualTo(self.mas_right).with.offset(-5);
            make.top.equalTo(lbDetectTime.mas_bottom).with.offset(7);
        }];
    }
    return self;
}

- (void) setUserAlert:(UserAlertInfo*) alert
{
    // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [ivPartrait sd_setImageWithURL:[NSURL URLWithString:alert.imgUrl] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
    
    [lbPatientName setText:alert.userName];
    
    if (kStringIsEmpty(alert.mainIll)) {
        [lbPatientInfo setText:[NSString stringWithFormat:@"(%@|%ld)", alert.sex, alert.age]];
    }
    else{
        [lbPatientInfo setText:[NSString stringWithFormat:@"(%@|%ld %@)", alert.sex, alert.age,alert.mainIll]];
    }
    
    [lbDetectValue setText:alert.dataDets.testValue];
    
    //监测时间
    if ([self isEmpty:alert.testTime])
    {
        NSDate* date = [NSDate dateWithString:alert.testTime formatString:@"yyyy-MM-dd HH:mm:ss"];
        
        //体重和尿量不显示时分
        if ([alert.kpiCode isEqualToString:@"NL"] || [alert.kpiCode isEqualToString:@"TZ"]) {
            [lbDetectTime setText:[NSString stringWithFormat:@"测量时间:%@",[date formattedDateWithFormat:@"yyyy-MM-dd"]]];
        }
        else{
            [lbDetectTime setText:[NSString stringWithFormat:@"测量时间:%@",[date formattedDateWithFormat:@"yyyy-MM-dd HH:mm"]]];
        }
        
    }
    else
    {
        [lbDetectTime setText:[NSString stringWithFormat:@"测量时间:%@",alert.testTime]];
    }
    
    //监测数据上传时间
    if ([self isEmpty:alert.uploadTime]) {
        
        NSDate* date = [NSDate dateWithString:alert.uploadTime formatString:@"yyyy-MM-dd HH:mm:ss"];
        [uploadTimeLable setText:[NSString stringWithFormat:@"预警时间:%@", [date formattedDateWithFormat:@"yyyy-MM-dd HH:mm"]]];
    }
    else{
        [uploadTimeLable setText:[NSString stringWithFormat:@"预警时间:%@", alert.uploadTime]];
    }
}

-(BOOL)isEmpty:(NSString *) str {
    NSRange range = [str rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES; //yes代表包含空格
    }else {
        return NO; //反之
    }
}


@end


//待处理
@interface MainStartUesrAlertUndealView ()

@property (nonatomic, strong) UILabel *statusLabel;

- (void) setUserAlert:(UserAlertInfo*) alert;

@end

@implementation MainStartUesrAlertUndealView

- (id)init{
    self = [super init];
    if (self) {
        
        [self addSubview:self.statusLabel];
        [self addSubview:self.statusbutton];
        [self addSubview:self.contactBtn];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(8);
            make.centerY.equalTo(self);
        }];
        
        [_statusbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-8);
            make.centerY.equalTo(self);
        }];
        
        [_contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_statusbutton.mas_left).offset(-15);
            make.centerY.equalTo(self);
        }];
        
    }
    return self;
}

- (void) setUserAlert:(UserAlertInfo*) alert
{
    [_statusLabel setText:alert.doStatusName];
    
    [_statusbutton setEnabled:(alert.doStatus == 0)];
    //判断是否有处理权限
    BOOL processPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeWarmMode Status:alert.doStatus OperateCode:kPrivilegeProcessOperate];
    [_statusbutton setHidden:!processPrivilege];
}

#pragma mark -- init
- (UIButton *)statusbutton{

    if (!_statusbutton) {
        _statusbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statusbutton setBackgroundImage:[UIImage rectImage:CGSizeMake(55, 24) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [_statusbutton setBackgroundImage:[UIImage rectImage:CGSizeMake(55, 24) Color:[UIColor commonBackgroundColor]] forState:UIControlStateDisabled];
        [_statusbutton setTitle:@"处理" forState:UIControlStateNormal];
        [_statusbutton setTitle:@"已处理" forState:UIControlStateDisabled];
        [_statusbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_statusbutton setTitleColor:[UIColor commonLightGrayTextColor] forState:UIControlStateDisabled];
        [_statusbutton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        _statusbutton.layer.cornerRadius = 2.5;
        _statusbutton.layer.masksToBounds = YES;
    }
    return _statusbutton;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        [_statusLabel setText:@"待处理"];
        [_statusLabel setTextColor:[UIColor commonGrayTextColor]];
        [_statusLabel setFont:[UIFont font_28]];
    }
    return _statusLabel;

}

- (UIButton *)contactBtn{
    if (!_contactBtn) {
        _contactBtn = [[UIButton alloc] init];
        [_contactBtn setTitle:@"联系患者" forState:UIControlStateNormal];
        [_contactBtn setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [_contactBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    }
    return _contactBtn;
}

@end


// 全部
@interface MainStartUesrAlertAllStatusView ()
{
    UILabel* lbDoStaff; //处理者
    UILabel* lbDoTime;
    UILabel* lbDoTitle;
    UILabel* lbDoWay;   //处理方式
    
    UIView *otherWayView;
}
- (void) setUserAlert:(UserAlertInfo*) alert;

@end

@implementation MainStartUesrAlertAllStatusView

- (id)init{
    self = [super init];
    if (self) {
    
        lbDoStaff = [[UILabel alloc]init];
        [self addSubview:lbDoStaff];
        [lbDoStaff setTextColor:[UIColor commonTextColor]];
        [lbDoStaff setFont:[UIFont systemFontOfSize:12]];
        [lbDoStaff mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.centerY.equalTo(self);
        }];
        
        lbDoTime = [[UILabel alloc]init];
        [self addSubview:lbDoTime];
        [lbDoTime setTextColor:[UIColor commonGrayTextColor]];
        [lbDoTime setFont:[UIFont systemFontOfSize:12]];
        
        lbDoTitle = [[UILabel alloc]init];
        [lbDoTitle setText:@"处理方式:"];
        [self addSubview:lbDoTitle];
        [lbDoTitle setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbDoTitle setFont:[UIFont systemFontOfSize:12]];
        
        lbDoWay = [[UILabel alloc]init];
        [self addSubview:lbDoWay];
        [lbDoWay setText:@"继续监测"];
        [lbDoWay setTextColor:[UIColor commonGrayTextColor]];
        [lbDoWay setFont:[UIFont systemFontOfSize:12]];
        
        [lbDoTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbDoStaff.mas_right).with.offset(3);
            make.right.lessThanOrEqualTo(@-135);
            make.centerY.equalTo(self);
        }];
        
        [lbDoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lbDoWay.mas_left);
            make.centerY.equalTo(self);
        }];

        [lbDoWay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-12.5);
            make.centerY.equalTo(self);
        }];

    }
    return self;
}

- (void) setUserAlert:(UserAlertInfo*) alert
{
    [lbDoStaff setText:alert.staffName];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    if (alert.staffId == staff.staffId)
    {
        [lbDoStaff setText:@"我"];
    }
    
    if (alert.doTime)
    {
        NSDate* date = [NSDate dateWithString:alert.doTime formatString:@"yyyy-MM-dd HH:mm:ss"];
        
        [lbDoTime setText:[date formattedDateWithFormat:@"yyyy-MM-dd HH:mm"]];
    }
    else
    {
        [lbDoTime setText:@""];
    }
    [lbDoWay setText:alert.doWay];
}

@end


//cell
@interface MainStartUesrAlertTableViewCell ()
{
    UIView *alertView;
    MainStartUesrAlertAllStatusView *allStatusView;  //全部
    
    UIView *otherWayView;
    UILabel *opinionLb;
}

@end

@implementation MainStartUesrAlertTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor commonBackgroundColor]];
        
        alertView = [[UIView alloc] init];
        [self.contentView addSubview:alertView];
        [alertView setBackgroundColor:[UIColor whiteColor]];
        alertView.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        alertView.layer.borderWidth = 0.5;
        alertView.layer.cornerRadius = 4;
        alertView.layer.masksToBounds = YES;
        [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(10, 12, 0, 12));
        }];
        
        _userAlertView = [[MainStartUserAlertView alloc] init];
        [alertView addSubview:_userAlertView];
        [_userAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(alertView);
            make.height.mas_equalTo(@110);
        }];
        
        allStatusView = [[MainStartUesrAlertAllStatusView alloc]init];
        [alertView addSubview:allStatusView];
        [allStatusView showTopLine];
        [allStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(alertView);
            make.top.equalTo(_userAlertView.mas_bottom);
            make.height.mas_equalTo(@40);
        }];
        
        otherWayView = [UIView new];
        [alertView addSubview:otherWayView];
        [otherWayView showTopLine];
        [otherWayView setBackgroundColor:[UIColor whiteColor]];
        [otherWayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(alertView);
            make.top.equalTo(allStatusView.mas_bottom);
            make.height.mas_equalTo(@40);
        }];
        
        opinionLb = [UILabel new];
        [otherWayView addSubview:opinionLb];
        [opinionLb setFont:[UIFont font_26]];
        [opinionLb setTextColor:[UIColor commonLightGrayTextColor]];
        [opinionLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(otherWayView).offset(12.5);
            make.right.equalTo(otherWayView.mas_right).offset(-12.5);
            make.centerY.equalTo(otherWayView);
        }];
        
    }
    return self;
}

//
- (void) setUserAlert:(UserAlertInfo*) alert{
    
    [_userAlertView setUserAlert:alert];
    [allStatusView setUserAlert:alert];
    
    if ([alert.doWay isEqualToString:@"其他方式"]) {
        [otherWayView setHidden:NO];
        [opinionLb setText:alert.opinion];
    }
    else{
        [otherWayView setHidden:YES];
        [opinionLb setText:@""];
    }
}

@end


@interface MainStartUesrAlertUndealTableViewCell ()
{
    UIView *alertView;
}
@end

@implementation MainStartUesrAlertUndealTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor commonBackgroundColor]];
        
        alertView = [[UIView alloc] init];
        [self.contentView addSubview:alertView];
        [alertView setBackgroundColor:[UIColor whiteColor]];
        alertView.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        alertView.layer.borderWidth = 0.5;
        alertView.layer.cornerRadius = 4;
        alertView.layer.masksToBounds = YES;
        [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(9, 12, 2, 12));
        }];
        
        _userAlertView = [[MainStartUserAlertView alloc] init];
        [alertView addSubview:_userAlertView];
        [_userAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(alertView);
            make.height.mas_equalTo(@120);
        }];
        
        _undealView = [[MainStartUesrAlertUndealView alloc]init];
        [alertView addSubview:_undealView];
        [_undealView showTopLine];
        [_undealView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(alertView);
            make.height.mas_equalTo(@40);
        }];
        
    }
    return  self;
}

//
- (void) setUserAlert:(UserAlertInfo*) alert{

    [_userAlertView setUserAlert:alert];
    [_undealView setUserAlert:alert];
}

@end
