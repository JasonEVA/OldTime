//
//  CreateDocumentMessionTableViewCell.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/23.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CreateDocumentMessionTableViewCell.h"

@interface CreateDocumentMessionTableViewCell ()
{
    
}

@property (nonatomic, strong) UIView* messionView;

@property (nonatomic, strong) UILabel* userNameLable;
@property (nonatomic, strong) UILabel* userInfoLable;
@property (nonatomic, strong) UILabel* orderTimeTitleLable;
@property (nonatomic, strong) UILabel* orderTimeLable;

@property (nonatomic, strong) UIView* statusView;
@property (nonatomic, strong) UILabel* statusLable;

@end

@implementation CreateDocumentMessionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor commonBackgroundColor]];
        self.messionView;
        
        self.userNameLable;
        self.userInfoLable;
        self.orderTimeTitleLable;
        self.orderTimeLable;
        
        self.statusView;
        self.statusLable;
        self.viewButton;       //查看按钮
    }
    return self;
}

#pragma mark - Initialize
- (UIView*) messionView
{
    if (!_messionView)
    {
        _messionView = [[UIView alloc]init];
        [self.contentView addSubview:_messionView];
        [_messionView setBackgroundColor:[UIColor whiteColor]];
        
        _messionView.layer.borderWidth = 0.5;
        _messionView.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        _messionView.layer.cornerRadius = 5;
        _messionView.layer.masksToBounds = YES;
        
        [_messionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.right.equalTo(self.contentView).with.offset(-12.5);
            make.top.equalTo(self.contentView).with.offset(7.5);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return _messionView;
}

- (UILabel*) userNameLable
{
    if (!_userNameLable)
    {
        _userNameLable = [[UILabel alloc]init];
        [self.messionView addSubview:_userNameLable];
        [_userNameLable setFont:[UIFont systemFontOfSize:15]];
        [_userNameLable setTextColor:[UIColor commonTextColor]];
        
        [_userNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.messionView).with.offset(9);
            make.top.equalTo(self.messionView).with.offset(12);
        }];
    }
    return _userNameLable;
}

- (UILabel*) userInfoLable
{
    if (!_userInfoLable)
    {
        _userInfoLable = [[UILabel alloc]init];
        [self.messionView addSubview:_userInfoLable];
        [_userInfoLable setFont:[UIFont systemFontOfSize:15]];
        [_userInfoLable setTextColor:[UIColor commonTextColor]];
        
        [_userInfoLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userNameLable.mas_right).with.offset(1.5);
            make.bottom.equalTo(self.userNameLable);
        }];
    }
    return _userInfoLable;
}

- (UILabel*) orderTimeTitleLable
{
    if (!_orderTimeTitleLable)
    {
        _orderTimeTitleLable = [[UILabel alloc]init];
        [self.messionView addSubview:_orderTimeTitleLable];
        [_orderTimeTitleLable setFont:[UIFont systemFontOfSize:13]];
        [_orderTimeTitleLable setTextColor:[UIColor commonGrayTextColor]];
        [_orderTimeTitleLable setText:@"服务订购时间："];
        [_orderTimeTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userNameLable);
            make.top.equalTo(self.userNameLable.mas_bottom).with.offset(15);
        }];
    }
    return _orderTimeTitleLable;
}

- (UILabel*) orderTimeLable
{
    if (!_orderTimeLable)
    {
        _orderTimeLable = [[UILabel alloc]init];
        [self.messionView addSubview:_orderTimeLable];
        [_orderTimeLable setFont:[UIFont systemFontOfSize:13]];
        [_orderTimeLable setTextColor:[UIColor commonGrayTextColor]];
        
        [_orderTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderTimeTitleLable.mas_right).with.offset(1.5);
            make.top.equalTo(self.orderTimeTitleLable);
        }];
    }
    return _orderTimeLable;
}

- (UIView*) statusView
{
    if (!_statusView) {
        _statusView = [[UIView alloc]init];
        [self.messionView addSubview:_statusView];
        [_statusView setBackgroundColor:[UIColor whiteColor]];
        [_statusView showTopLine];
        
        [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.equalTo(self.messionView);
            make.height.mas_equalTo(@40);
        }];
    }
    return _statusView;
}

- (UILabel*) statusLable
{
    if (!_statusLable)
    {
        _statusLable = [[UILabel alloc]init];
        [self.statusView addSubview:_statusLable];
        [_statusLable setFont:[UIFont systemFontOfSize:13]];
        [_statusLable setTextColor:[UIColor commonGrayTextColor]];
        
        [_statusLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.statusView).with.offset(9);
            make.centerY.equalTo(self.statusView);
        }];
    }
    return _statusLable;
}

- (UIButton*) viewButton
{
    if (!_viewButton)
    {
        _viewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_viewButton setBackgroundImage:[UIImage rectImage:CGSizeMake(80, 32) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [self.statusView addSubview:_viewButton];
        [_viewButton setTitle:@"查看" forState:UIControlStateNormal];
        [_viewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_viewButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        _viewButton.layer.cornerRadius = 2.5;
        _viewButton.layer.masksToBounds = YES;
        
        [_viewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.statusView);
            make.right.equalTo(self.statusView).with.offset(-9);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
    }
    return _viewButton;
}

- (void) setCreateDocumentMession:(CreateDocumetnMessionInfo*)mession
{
    [self.userNameLable setText:@""];
    [self.userInfoLable setText:@""];
    [self.orderTimeLable setText:@""];
    
    [self.statusLable setText:@""];
    
    if (!mession)
    {
        return;
    }
    
    [self.userNameLable setText:mession.userName];
    NSString* userInfoString = [NSString stringWithFormat:@"(%@|%ld)", mession.sex, mession.age];
    [self.userInfoLable setText:userInfoString];
    
    [self.orderTimeLable setText:mession.serviceBeginTime];
    
    //任务状态
    [self.statusLable setText:mession.statusName];
    
    BOOL viewPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateDocumentMode Status:mession.status OperateCode:kPrivilegeViewOperate];
    [self.viewButton setHidden:!viewPrivilege];
}
@end
