//
//  NewSiteMessageTwoSelectedIconTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2016/12/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewSiteMessageTwoSelectedIconTableViewCell.h"
#import "NewSiteMessageDoctorCareModel.h"

@interface  NewSiteMessageTwoSelectedIconTableViewCell ()
@property (nonatomic, strong) UILabel *contentLb;
@property (nonatomic, strong) UIButton *yesBtn;
@property (nonatomic, strong) UIButton *noBtn;
@property (nonatomic, copy) ButtonClick buttonClick;

@end
@implementation NewSiteMessageTwoSelectedIconTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.cardView addSubview:self.contentLb];
        [self.cardView addSubview:self.yesBtn];
        [self.cardView addSubview:self.noBtn];
        
        [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.cardView).offset(15);
            make.right.equalTo(self.cardView).offset(-15);
        }];
        
        [self.yesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentLb).offset(10);
            make.height.equalTo(@25);
            make.top.equalTo(self.contentLb.mas_bottom).offset(10);
            make.bottom.equalTo(self.cardView).offset(-15);
        }];
        [self.noBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.yesBtn);
            make.left.equalTo(self.yesBtn).offset(60);
            make.height.equalTo(@25);
        }];

    }
    return self;
}

#pragma mark -private method
- (void)configElements {
}
#pragma mark - event Response
- (void)buttonClick:(UIButton *)btn {
    if (self.buttonClick) {
        self.buttonClick(btn.tag);
    }
}
#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
- (void)btnClick:(ButtonClick)block {
    self.buttonClick = block;
}

- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model {
    NewSiteMessageDoctorCareModel *tempModel  = [NewSiteMessageDoctorCareModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
    [self.contentLb setText:tempModel.msg];
    NSString *strDate = [NSDate im_dateFormaterWithTimeInterval:model.createTimestamp appendMinute:NO];
    [self.receiveTimeLb setText:[NSString stringWithFormat:@" %@ ",strDate]];
}
#pragma mark - init UI

- (UILabel *)contentLb
{
    if (!_contentLb) {
        _contentLb = [self getLebalWithTitel:@"" font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"333333"]];
        [_contentLb setNumberOfLines:0];
        _contentLb.preferredMaxLayoutWidth = W_MAX;
        
    }
    return _contentLb;
}

- (UIButton *)yesBtn {
    if (!_yesBtn) {
        _yesBtn = [UIButton new];
        [_yesBtn setImage:[UIImage imageNamed:@"im_choose"] forState:UIControlStateNormal];
        [_yesBtn setImage:[UIImage imageNamed:@"im_choosed"] forState:UIControlStateSelected];
        [_yesBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [_yesBtn setTag:1];
        [_yesBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lb = [UILabel new];
        [lb setText:@"有"];
        [_yesBtn addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_yesBtn.imageView.mas_right).offset(5);
            make.centerY.equalTo(_yesBtn.imageView);
        }];
    }
    return _yesBtn;
}

- (UIButton *)noBtn {
    if (!_noBtn) {
        _noBtn = [UIButton new];
        [_noBtn setImage:[UIImage imageNamed:@"im_choose"] forState:UIControlStateNormal];
        [_noBtn setImage:[UIImage imageNamed:@"im_choosed"] forState:UIControlStateSelected];
        [_noBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [_noBtn setTag:0];
        [_noBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lb = [UILabel new];
        [lb setText:@"没有"];
        [_noBtn addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_noBtn.imageView.mas_right).offset(5);
            make.centerY.equalTo(_noBtn.imageView);
        }];
    }
    return _noBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
