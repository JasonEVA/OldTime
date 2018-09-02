//
//  AccountManageTableViewCell.m
//  HMDoctor
//
//  Created by yinquan on 17/3/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "AccountManageTableViewCell.h"

@interface AccountManageTableViewCell ()
{
    UIView* accountView;
}


@property (nonatomic, readonly) UIImageView* portraitImageView;
@property (nonatomic, readonly) UIImageView* loginedImageView;

@property (nonatomic, readonly) UILabel* userNameLable;
@property (nonatomic, readonly) UILabel* accountLable;
@property (nonatomic, readonly) UILabel* loginedLable;

@end

@implementation AccountManageTableViewCell

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
        _portraitImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.portraitImageView];
        [self.portraitImageView setImage:[UIImage imageNamed:@"img_default_staff"]];
        
        self.portraitImageView.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        self.portraitImageView.layer.borderWidth = 0.5;
        self.portraitImageView.layer.cornerRadius = 20;
        self.portraitImageView.layer.masksToBounds = YES;
        
        accountView = [[UIView alloc] init];
        [self.contentView addSubview:accountView];
        
        
        _userNameLable = [[UILabel alloc] init];
        [accountView addSubview:_userNameLable];
        [self.userNameLable setFont:[UIFont systemFontOfSize:15]];
        [self.userNameLable setTextColor:[UIColor commonTextColor]];
        
        
        _accountLable = [[UILabel alloc] init];
        [accountView addSubview:self.accountLable];
        [self.accountLable setFont:[UIFont systemFontOfSize:12]];
        [self.accountLable setTextColor:[UIColor commonGrayTextColor]];
        
        _loginedImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.loginedImageView];
        [self.loginedImageView setImage:[UIImage imageNamed:@"c_contact_selected"]];
        [self.loginedImageView setHidden:YES];
        
        _loginedLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.loginedLable];
        [self.loginedLable setFont:[UIFont systemFontOfSize:15]];
        [self.loginedLable setTextColor:[UIColor mainThemeColor]];
        [self.loginedLable setText:@"当前账号"];
        [self.loginedLable setHidden:YES];
        
        [self subviewsLayout];
    }
    
    return self;
}

- (void) subviewsLayout
{
    
    [self.portraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(self.contentView).with.offset(20);
        make.centerY.equalTo(self.contentView);
    }];
    
    [accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.portraitImageView.mas_right).with.offset(15);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
        make.top.bottom.equalTo(self.portraitImageView);
    }];
    
    [self.userNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountView);
        make.right.lessThanOrEqualTo(accountView);
        make.top.equalTo(accountView);
    }];
    
    [self.accountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountView);
        make.right.lessThanOrEqualTo(accountView);
        make.bottom.equalTo(accountView);
    }];
    
    [self.loginedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountView.mas_right).with.offset(12.5);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.loginedLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginedImageView.mas_right).with.offset(7);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void) setLoginAccountModel:(LoginAccountModel*) model
{
    [self.portraitImageView setImage:[UIImage imageNamed:@"img_default_staff"]];
    if (model.userPortrait && model.userPortrait.length > 0) {
         // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
        // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
        [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:model.userPortrait] placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    }
    
    [self.userNameLable setText:model.staffName];
    [self.accountLable setText:model.loginAccount];
}

- (void) showAccountLogined:(BOOL) logined
{
    [self.loginedImageView setHidden:!logined];
    [self.loginedLable setHidden:!logined];
}
@end

@interface AccountManageAppendTableViewCell ()

@property (nonatomic, readonly) UIImageView* appendImageView;
@property (nonatomic, readonly) UILabel* titleLable;

@end

@implementation AccountManageAppendTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _appendImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_set_add"]];
        [self.contentView addSubview:self.appendImageView];
        
        _titleLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLable];
        [self.titleLable setFont:[UIFont systemFontOfSize:15]];
        [self.titleLable setTextColor:[UIColor mainThemeColor]];
        [self.titleLable setText:@"添加账号"];
        
        [self subviewsLayout];
    }
    return self;
}

- (void) subviewsLayout
{
    [self.appendImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.contentView).with.offset(20);
       make.size.mas_equalTo(CGSizeMake(20, 20));
       make.centerY.equalTo(self.contentView);
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.appendImageView.mas_right).with.offset(22);
        make.centerY.equalTo(self.contentView);
    }];
}
@end
