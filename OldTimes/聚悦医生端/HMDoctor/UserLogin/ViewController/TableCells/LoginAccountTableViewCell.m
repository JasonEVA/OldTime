//
//  LoginAccountTableViewCell.m
//  HMDoctor
//
//  Created by yinquan on 17/3/3.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "LoginAccountTableViewCell.h"

@interface LoginAccountTableViewCell ()
{
    
}

@property (nonatomic, readonly) UIImageView* portraitImageView;
@property (nonatomic, readonly) UIImageView* loginedImageView;

@property (nonatomic, readonly) UILabel* userNameLable;
@property (nonatomic, readonly) UILabel* accountLable;

@end

@implementation LoginAccountTableViewCell

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
        self.portraitImageView.layer.cornerRadius = 16;
        self.portraitImageView.layer.masksToBounds = YES;
        
        _userNameLable = [[UILabel alloc] init];
        [self.contentView addSubview:_userNameLable];
        [self.userNameLable setFont:[UIFont systemFontOfSize:15]];
        [self.userNameLable setTextColor:[UIColor commonTextColor]];
        
        
        _accountLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.accountLable];
        [self.accountLable setFont:[UIFont systemFontOfSize:13]];
        [self.accountLable setTextColor:[UIColor commonGrayTextColor]];
        
        _loginedImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.loginedImageView];
        [self.loginedImageView setImage:[UIImage imageNamed:@"icon_select_blue"]];
        [self.loginedImageView setHidden:YES];
        
        [self subviewsLayout];
    }
    
    return self;
}

- (void) subviewsLayout
{
    
    [self.portraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.userNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.portraitImageView.mas_right).with.offset(10);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
        make.top.equalTo(self.portraitImageView);
    }];
    
    [self.accountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.portraitImageView.mas_right).with.offset(10);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
        make.bottom.equalTo(self.portraitImageView);
    }];
    
    [self.loginedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 13));
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
}
@end
