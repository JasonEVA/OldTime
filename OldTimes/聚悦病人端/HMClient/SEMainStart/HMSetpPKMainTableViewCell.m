//
//  HMSetpPKMainTableViewCell.m
//  HMClient
//
//  Created by JasonWang on 2017/5/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSetpPKMainTableViewCell.h"
#import "HMExercisePKModel.h"
#import "AvatarUtil.h"
#import "UIImage+JWNameImage.h"
#import "HMLoseWeightPkModel.h"
#import "NSAttributedString+EX.h"

@interface HMSetpPKMainTableViewCell ()
@property (nonatomic, strong) UIImageView *rankingImage;
@property (nonatomic, strong) UILabel *rankingLb;
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *stepCountLb;
@property (nonatomic, strong) UILabel *praiseCountLb;
@property (nonatomic, strong) UIButton *praiseImageBtn;
@property (nonatomic, copy) HMSetpPKMainTableViewCellBlock block;
@property (nonatomic) NSInteger cellRanking;
@property (nonatomic, strong) HMExercisePKModel *cellModel;
@end

@implementation HMSetpPKMainTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self configElements];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark -private method
- (void)configElements {
    [self.contentView addSubview:self.rankingLb];
    [self.contentView addSubview:self.rankingImage];
    [self.contentView addSubview:self.headView];
    [self.contentView addSubview:self.nameLb];
    [self.contentView addSubview:self.stepCountLb];
    [self.contentView addSubview:self.praiseCountLb];
    [self.contentView addSubview:self.praiseImageBtn];
    
    [self.rankingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(11);
    }];
    
    [self.rankingLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.rankingImage);
    }];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.rankingImage.mas_right).offset(21);
        make.width.height.equalTo(@40);
    }];
    
    
    [self.praiseImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.praiseCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_centerY);
        make.centerX.equalTo(self.praiseImageBtn);
    }];
    
    [self.stepCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.praiseImageBtn.mas_left).offset(-25);
    }];
    
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.headView.mas_right).offset(12);
        make.right.lessThanOrEqualTo(self.stepCountLb.mas_left).offset(-10);
    }];

}

- (void)configRankingView:(NSInteger)ranking{
    self.cellRanking = ranking;
    [self.rankingLb setHidden:ranking<4];
    [self.rankingImage setHidden:!(ranking<4)];
    if (ranking<4) {
        NSString *imageName = @"PK_ic_jin";

        if (ranking == 1) {
            imageName = @"PK_ic_jin";
        }
        else if (ranking == 2) {
            imageName = @"PK_ic_yin";
            
        }
        else if (ranking == 3) {
            imageName = @"PK_ic_tong";
            
        }
        [self.rankingImage setImage:[UIImage imageNamed:imageName]];
    }
    else {
        [self.rankingLb setText:[NSString stringWithFormat:@"%ld",(long)ranking]];

    }
    
    
}
- (BOOL)isSelfCell:(HMExercisePKModel *)model {
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    return user.userId == model.userId;
}
#pragma mark - event Response
- (void)praiseImageClick {
    
    if ([self isSelfCell:self.cellModel]) {
        if (self.block) {
            self.block(self.cellRanking);
        }
    }
    else {
        [UIView animateWithDuration:0.14 animations:^{
            [self.praiseImageBtn setTransform:CGAffineTransformMakeScale(1.2, 1.2)];
            
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    if (self.block) {
                        self.block(self.cellRanking);
                    }
                    [self.praiseImageBtn setTransform:CGAffineTransformMakeScale(1, 1)];
                }];
            }
        }];
    }
}
#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
- (void)fillDataWithModel:(HMExercisePKModel *)model ranking:(NSInteger)ranking{
    if (!model || ![model isKindOfClass:[HMExercisePKModel class]]) {
        return;
    }
    self.cellModel = model;
    [self configRankingView:ranking];
    NSURL *urlHead = avatarURL(avatarType_80, [NSString stringWithFormat:@"%lld",model.userId]);
    [self.headView sd_setImageWithURL:urlHead placeholderImage:[UIImage JW_acquireNameImageWithNameString:model.userName imageSize:CGSizeMake(40, 40)]];
    [self.nameLb setText:model.userName];
    [self.stepCountLb setText:[NSString stringWithFormat:@"%lld",model.stepCount]];
    [self.stepCountLb setTextColor:ranking == 1 ?[UIColor
                                                   colorWithHexString:@"ff9c37"]:[UIColor colorWithHexString:@"333333"]];
    [self.praiseCountLb setText:[NSString stringWithFormat:@"%lld",model.favourCount]];
    
    if ([self isSelfCell:model]) {
        [self.praiseImageBtn setSelected:model.favourCount > 0];
    }
    else {
        [self.praiseImageBtn setSelected:model.favoured == 1];
    }
}

- (void)praiseClick:(HMSetpPKMainTableViewCellBlock)block {
    self.block = block;
}

- (void)fillLoseWeightDataWithModel:(HMLoseWeightPkModel *)model ranking:(NSInteger)ranking {
    if (!model || ![model isKindOfClass:[HMLoseWeightPkModel class]]) {
        return;
    }
    [self configRankingView:ranking];
    NSURL *urlHead = avatarURL(avatarType_80, [NSString stringWithFormat:@"%lld",model.userId]);
    [self.headView sd_setImageWithURL:urlHead placeholderImage:[UIImage JW_acquireNameImageWithNameString:model.userName imageSize:CGSizeMake(40, 40)]];
    [self.nameLb setText:model.userName];
    

    [self.stepCountLb setTextColor:ranking == 1 ?[UIColor
                                                  colorWithHexString:@"ff9c37"]:[UIColor colorWithHexString:@"333333"]];
    [self.stepCountLb setFont:[UIFont systemFontOfSize:16]];
    
    [self.stepCountLb setAttributedText:[NSAttributedString getAttributWithString:[NSString stringWithFormat:@"%.1fkg",model.dValue] UnChangePart:@"kg" changePart:[NSString stringWithFormat:@"%.1f",model.dValue] changeColor:ranking == 1 ?[UIColor
                                                                                                                                                                                                                                               colorWithHexString:@"ff9c37"]:[UIColor colorWithHexString:@"333333"] changeFont:[UIFont systemFontOfSize:28]]];
    if ([self.contentView.subviews containsObject:self.praiseImageBtn]) {
        [self.praiseImageBtn removeFromSuperview];
        self.praiseImageBtn = nil;
    }
    
    if ([self.contentView.subviews containsObject:self.praiseCountLb]) {
        [self.praiseCountLb removeFromSuperview];
        self.praiseCountLb = nil;
    }
    
    [self.stepCountLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
    }];

}
#pragma mark - init UI
- (UIImageView *)rankingImage {
    if (!_rankingImage) {
        _rankingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PK_ic_jin"]];
    }
    return _rankingImage;
}

- (UIImageView *)headView {
    if (!_headView) {
        _headView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_user_head_80"]];
        [_headView.layer setCornerRadius:20];
        [_headView setClipsToBounds:YES];
    }
    return _headView;
}

- (UIButton *)praiseImageBtn {
    if (!_praiseImageBtn) {
        _praiseImageBtn = [[UIButton alloc] init];
        [_praiseImageBtn setImage:[UIImage imageNamed:@"PK_ic_zan_hui"] forState:UIControlStateNormal];
        [_praiseImageBtn setImage:[UIImage imageNamed:@"PK_ic_zan_red"] forState:UIControlStateSelected];
        [_praiseImageBtn addTarget:self action:@selector(praiseImageClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _praiseImageBtn;
}

- (UILabel *)rankingLb {
    if (!_rankingLb) {
        _rankingLb = [UILabel new];
        [_rankingLb setText:@"1"];
        [_rankingLb setTextColor:[UIColor colorWithHexString:@"666666"]];
        [_rankingLb setFont:[UIFont systemFontOfSize:16]];
    }
    return _rankingLb;
}

- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [UILabel new];
        [_nameLb setText:@"微辣"];
        [_nameLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_nameLb setFont:[UIFont systemFontOfSize:16]];
    }
    return _nameLb;
}

- (UILabel *)stepCountLb {
    if (!_stepCountLb) {
        _stepCountLb = [UILabel new];
        [_stepCountLb setText:@"1000"];
        [_stepCountLb setTextColor:[UIColor colorWithHexString:@"ff9c37"]];
        [_stepCountLb setFont:[UIFont systemFontOfSize:28]];
    }
    return _stepCountLb;
}

- (UILabel *)praiseCountLb {
    if (!_praiseCountLb) {
        _praiseCountLb = [UILabel new];
        [_praiseCountLb setText:@"5"];
        [_praiseCountLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_praiseCountLb setFont:[UIFont systemFontOfSize:14]];
    }
    return _praiseCountLb;
}

@end
