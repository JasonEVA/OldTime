//
//  SurveyMessionTableViewCell.m
//  HMDoctor
//
//  Created by yinqaun on 16/6/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "SurveyMessionTableViewCell.h"

@interface SurveyMessionRecordStatusView : UIView
{
    UILabel* lbStatus;
}

@end

@implementation SurveyMessionRecordStatusView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self showTopLine];
        lbStatus = [[UILabel alloc]init];
        [self addSubview:lbStatus];
        [lbStatus setTextColor:[UIColor commonGrayTextColor]];
        [lbStatus setFont:[UIFont systemFontOfSize:13]];
        
        [lbStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(6.5);
            make.centerY.equalTo(self);
        }];

    }
    return self;
}

- (void) setSurveyStatus:(NSInteger) status
{
    switch (status)
    {
        case 0:
        {
            [lbStatus setText:@"未填写"];
        }
            break;
        case 1:
        {
            [lbStatus setText:@"已填写"];
        }
            break;
        case 2:
        {
            [lbStatus setText:@"已查看"];
        }
            break;
        case 3:
        {
            [lbStatus setText:@"已回复"];
        }
            break;
        default:
        {
            [lbStatus setText:@" "];
        }
            break;
            break;
    }
}

@end

@interface SurveyMessionRecordView : UIView
{
    UIImageView* ivPartrait;
    UILabel* lbUserName;
    UILabel* lbUserInfo;
    
    UILabel* lbCreateTiemTitle;
    UILabel* lbCreateTime;

    UILabel* lbMoudle;
    
    UILabel *lbFillTime;    //填写时间
    
    SurveyMessionRecordStatusView* statusview;
}
@property (nonatomic,strong) UIButton *archiveButton;
@property (nonatomic, readonly) UIButton* replyButton;
- (void) setSurveyRecord:(SurveyRecord*) record;
@end

@implementation SurveyMessionRecordView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        ivPartrait = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_default_user"]];
        [self addSubview:ivPartrait];
        ivPartrait.layer.cornerRadius = 2.5;
        ivPartrait.layer.masksToBounds = YES;
        
        [ivPartrait mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.equalTo(self).with.offset(13);
        }];
        
        lbUserName = [[UILabel alloc]init];
        [self addSubview:lbUserName];
        [lbUserName setTextColor:[UIColor commonTextColor]];
        [lbUserName setFont:[UIFont systemFontOfSize:15]];
        
        [lbUserName mas_makeConstraints:^(MASConstraintMaker *make) {
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
            make.top.equalTo(lbUserName).offset(-5);;
        }];
        
        lbUserInfo = [[UILabel alloc]init];
        [self addSubview:lbUserInfo];
        [lbUserInfo setTextColor:[UIColor commonTextColor]];
        [lbUserInfo setFont:[UIFont systemFontOfSize:14]];
        
        [lbUserInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbUserName.mas_right).with.offset(2);
            make.top.equalTo(lbUserName).with.offset(1);
            make.right.lessThanOrEqualTo(_archiveButton.mas_left);
        }];
        
        lbMoudle = [[UILabel alloc]init];
        [self addSubview:lbMoudle];
        [lbMoudle setTextColor:[UIColor commonGrayTextColor]];
        [lbMoudle setFont:[UIFont systemFontOfSize:13]];
        
        [lbMoudle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbUserName);
            make.top.equalTo(lbUserName.mas_bottom).with.offset(5);
        }];

        lbCreateTiemTitle = [[UILabel alloc]init];
        [self addSubview:lbCreateTiemTitle];
        [lbCreateTiemTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbCreateTiemTitle setFont:[UIFont systemFontOfSize:13]];
        [lbCreateTiemTitle setText:@"发送时间:"];
        [lbCreateTiemTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbUserName);
            make.top.equalTo(lbMoudle.mas_bottom).with.offset(5);
        }];
        
        lbCreateTime = [[UILabel alloc]init];
        [self addSubview:lbCreateTime];
        [lbCreateTime setTextColor:[UIColor commonGrayTextColor]];
        [lbCreateTime setFont:[UIFont systemFontOfSize:13]];
        
        [lbCreateTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbCreateTiemTitle.mas_right);
            make.top.equalTo(lbCreateTiemTitle);
        }];
        
        lbFillTime = [[UILabel alloc]init];
        [self addSubview:lbFillTime];
        [lbFillTime setTextColor:[UIColor commonGrayTextColor]];
        [lbFillTime setFont:[UIFont systemFontOfSize:13]];
        
        [lbFillTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbUserName);
            make.top.equalTo(lbCreateTiemTitle.mas_bottom).with.offset(5);
        }];
        
        statusview = [[SurveyMessionRecordStatusView alloc]init];
        [self addSubview:statusview];
        [statusview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(@40);
        }];
        
        _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [statusview addSubview:_replyButton];
        [_replyButton setBackgroundImage:[UIImage rectImage:CGSizeMake(60, 30) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [_replyButton setTitle:@"回复" forState:UIControlStateNormal];
        [_replyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_replyButton.titleLabel setFont:[UIFont font_26]];
        _replyButton.layer.cornerRadius = 2.5;
        _replyButton.layer.masksToBounds = YES;
        
        [_replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 30));
            make.centerY.equalTo(statusview);
            make.right.equalTo(statusview).with.offset(-7.5);
        }];
        [_replyButton setHidden:YES];
    }
    return self;
}

- (void) setSurveyRecord:(SurveyRecord*) record
{
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [ivPartrait sd_setImageWithURL:[NSURL URLWithString:record.imgUrl] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
    
    [lbUserName setText:record.userName];
    if (!record.userName || 0 == record.userName.length)
    {
        [lbUserName setText:@" "];
    }
    
    if (kStringIsEmpty(record.mainIll)) {
        [lbUserInfo setText:[NSString stringWithFormat:@"(%@|%ld)", record.sex, record.age]];
    }
    else{
        [lbUserInfo setText:[NSString stringWithFormat:@"(%@|%ld %@)", record.sex, record.age,record.mainIll]];
    }
    
    [lbMoudle setText:[NSString stringWithFormat:@"随访表:%@",record.surveyMoudleName]];
    
    NSDate* createTime = [NSDate dateWithString:record.createTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString* createTimeStr = [createTime formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
    [lbCreateTime setText:createTimeStr];
    
    if (!kStringIsEmpty(record.fillTime)) {
        NSDate *fillTime = [NSDate dateWithString:record.fillTime formatString:@"yyyy-MM-dd HH:mm:ss"];
        [lbFillTime setText:[NSString stringWithFormat:@"填写时间:%@",[fillTime formattedDateWithFormat:@"yyyy-MM-dd HH:mm"]]];
    }
    else{
        [lbFillTime setText:@""];
        [lbFillTime setHidden:YES];
    }
    
    [statusview setSurveyStatus:record.status];
    
    BOOL replyPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeSurveyMode Status:record.status OperateCode:kPrivilegeReplyOperate];
    [_replyButton setHidden:!replyPrivilege];
}

@end

@interface SurveyMessionTableViewCell ()
{
    SurveyMessionRecordView* recordview;
}
@end

@implementation SurveyMessionTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor commonBackgroundColor]];
        
        recordview = [[SurveyMessionRecordView alloc]init];
        
        [self.contentView addSubview:recordview];
        [recordview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.right.equalTo(self.contentView).with.offset(-12.5);
            make.top.equalTo(self.contentView).with.offset(10);
            make.bottom.equalTo(self.contentView);
        }];
        
        recordview.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        recordview.layer.borderWidth = 0.5;
        recordview.layer.cornerRadius = 4;
        recordview.layer.masksToBounds = YES;
        
        _replyButton = recordview.replyButton;
        _archiveButton = recordview.archiveButton;
    }
    return self;
}

- (void) setSurveyRecord:(SurveyRecord*) record
{
    [recordview setSurveyRecord:record];
}
@end
