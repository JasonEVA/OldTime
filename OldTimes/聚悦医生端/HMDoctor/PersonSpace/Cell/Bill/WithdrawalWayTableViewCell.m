//
//  WithdrawalWayTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "WithdrawalWayTableViewCell.h"

@interface WithdrawalWayTableViewCell ()
{
    UIView      *bankTypeView;
    UIImageView *ivLogo;
    UILabel     *lbBankCardNum;
}
@end

@implementation WithdrawalWayTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor commonBackgroundColor]];
        
        bankTypeView = [[UIView alloc] init];
        [self addSubview:bankTypeView];
        [bankTypeView setBackgroundColor:[UIColor whiteColor]];
        [bankTypeView.layer setCornerRadius:5.0f];
        [bankTypeView.layer setMasksToBounds:YES];
        
        ivLogo = [[UIImageView alloc] init];
        [bankTypeView addSubview:ivLogo];
        
        _lbBankType = [[UILabel alloc] init];
        [bankTypeView addSubview:_lbBankType];
        [_lbBankType setTextColor:[UIColor commonTextColor]];
        [_lbBankType setFont:[UIFont systemFontOfSize:14]];
        
        lbBankCardNum = [[UILabel alloc] init];
        [bankTypeView addSubview:lbBankCardNum];
        [lbBankCardNum setTextColor:[UIColor commonTextColor]];
        [lbBankCardNum setFont:[UIFont systemFontOfSize:14]];
        
        [self subViewsLayout];
    }
    
    return self;
}

- (void)subViewsLayout
{
    [bankTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.right.equalTo(self).with.offset(-12.5);
        make.top.equalTo(self).with.offset(15);
        make.height.mas_equalTo(@70);
    }];
    
    [ivLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankTypeView).with.offset(12.5);
        make.centerY.equalTo(bankTypeView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [_lbBankType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivLogo.mas_right).with.offset(10);
        make.top.equalTo(bankTypeView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    [lbBankCardNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivLogo.mas_right).with.offset(10);
        make.top.equalTo(_lbBankType.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(240, 20));
    }];
}

- (void)setBankCardInfo:(BankCardInfo *)bankCard
{
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [ivLogo sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"img_default"]];
    
    [_lbBankType setText:bankCard.bankName];
    [lbBankCardNum setText:[NSString stringWithFormat:@"%@",bankCard.cardNo]];
}

@end
