//
//  PersonInfoTableViewCell.m
//  HMClient
//
//  Created by lkl on 16/4/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonInfoTableViewCell.h"

@interface PersonInfoTableViewCell ()
{
    UILabel *lbTitle;
    UILabel *lbTextContent;
}

- (void)subViewLayout;
@end

@implementation PersonInfoTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        lbTitle = [[UILabel alloc]init];
        [lbTitle setBackgroundColor:[UIColor clearColor]];
        [lbTitle setTextColor:[UIColor commonTextColor]];
        [lbTitle setFont:[UIFont font_32]];
        [self.contentView addSubview:lbTitle];
        
        lbTextContent = [[UILabel alloc]init];
        [lbTextContent setBackgroundColor:[UIColor clearColor]];
        [lbTextContent setTextColor:[UIColor commonGrayTextColor]];
        [lbTextContent setFont:[UIFont font_32]];
    
        [self.contentView addSubview:lbTextContent];
        
        [self subViewLayout];
    }
    return self;
}

- (void)subViewLayout
{
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.equalTo(self.contentView);
    }];
    
    [lbTextContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTitle.mas_right).with.offset(4);
        make.centerY.equalTo(self.contentView);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12);
    }];
} 

- (void)setlbTitle:(NSString*)aTitle
{
    [lbTitle setText:aTitle];
}

- (void) setUserInfo:(NSString*)userInfo
{
    [lbTextContent setText:userInfo];
}

@end

@interface PersonInfoEidtTableViewCell ()

@property (nonatomic, strong) UIImageView *iconArrows;

@end

@implementation PersonInfoEidtTableViewCell


- (void)subViewLayout
{
    [super subViewLayout];
    [self.iconArrows mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).with.offset(-13.5);
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
    
}

- (UIImageView*) iconArrows
{
    if (!_iconArrows) {
        _iconArrows = [[UIImageView alloc] init];
        [_iconArrows setImage:[UIImage imageNamed:@"icon_x_arrows"]];
        [self.contentView addSubview:_iconArrows];
    }
    return _iconArrows;
}

@end

@interface PersonHeaderInfoTableViewCell ()
{
    UIImageView *headerImgView;
    UILabel *lbContent;
    UIImageView *iconArrows;
}

@end
@implementation PersonHeaderInfoTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        headerImgView = [[UIImageView alloc] init];
        [headerImgView.layer setCornerRadius:22];
        [headerImgView.layer setMasksToBounds:YES];
        [self.contentView addSubview:headerImgView];
        
        lbContent = [[UILabel alloc] init];
        [lbContent setText:@"编辑头像"];
        [lbContent setFont:[UIFont font_26]];
        [lbContent setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self.contentView addSubview:lbContent];
        
        iconArrows = [[UIImageView alloc] init];
        [iconArrows setImage:[UIImage imageNamed:@"icon_x_arrows"]];
        [self.contentView addSubview:iconArrows];

        [self subViewLayout];
    }
    return self;
}

- (void)subViewLayout
{
    [headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.equalTo(self.contentView);
        make.width.and.height.mas_equalTo(44);
        
    }];
    
    [lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(iconArrows.mas_left).with.offset(-5);
        make.centerY.equalTo(self.contentView);
    }];
    
    [iconArrows mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).with.offset(-13.5);
        make.size.mas_equalTo(CGSizeMake(8, 15));
    }];
}

- (void) updateUserInfo
{
    UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    testActivityIndicator.center = CGPointMake(22.0f, 22.0f);
    [headerImgView addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor orangeColor];
    [testActivityIndicator startAnimating];
    [testActivityIndicator setHidesWhenStopped:YES];
    
    UserInfo *user = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    if (user.imgUrl)
    {
        //用户头像
        [headerImgView sd_setImageWithURL:[NSURL URLWithString:user.imgUrl] placeholderImage:[UIImage imageNamed:@"img_default_photo"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [testActivityIndicator stopAnimating];
        }];
    }
}

@end
