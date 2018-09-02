//
//  TrainingTableViewCell.m
//  Shape
//
//  Created by jasonwang on 15/10/30.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainingTableViewCell.h"
#import "UILabel+EX.h"
#import "MyDefine.h"
#import "UIColor+Hex.h"
#import <Masonry.h>
#import "UIImageView+WebCache.h"
#import "NSString+Manager.h"


@interface TrainingTableViewCell()

@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *dayLb;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *sellerLb;
@property (nonatomic, strong) TrainStrengthView *strengthView;
@property (nonatomic, strong) UIImageView *hotOrNewView; //高亮为NEW  普通为HOT
@property (nonatomic, strong) UIImageView *isJoinView;
@property (nonatomic) BOOL isNeedStrength;    //判断布局方式
@property (nonatomic, strong) TrainRoundnessProgressBar *round;

@end

@implementation TrainingTableViewCell
- (instancetype)initWithShowStrength:(BOOL)showStrength reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isNeedStrength = showStrength;
        [self initComponent];
        [self updateConstraints];
        [self.layer setCornerRadius:5.0f];
        [self setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
    }
    return self;
}

#pragma mark -private method

- (void)initComponent
{
    [self addSubview:self.backView];
    [self.backView addSubview:self.titelLb];
    [self.backView addSubview:self.dayLb];
    [self.backView addSubview:self.iconView];
    [self.backView addSubview:self.sellerLb];
    [self.backView addSubview:self.strengthView];
    [self.backView addSubview:self.hotOrNewView];
    [self.backView addSubview:self.round];
    [self.backView addSubview:self.isJoinView];
}

- (void)setMyData:(TrainGetTrainDataArrayModel *)model
{
    if (model.isHot) {
        [self.hotOrNewView setHidden:NO];
    }
    else
    {
        [self.hotOrNewView setHidden:YES];
    }
    [self.dayLb setText:[NSString stringWithFormat:@"共%ld天",(long)model.totalTime]];
    [self.titelLb setText:model.name];
    [self.backView
     sd_setImageWithURL:[NSString fullURLWithFileString:model.backgroundUrl]];
    [self.sellerLb setText:model.supplierName];
    [self.strengthView setTrainStrengLevel:model.difficulty];
}

- (void)setModelData:(TrainGetMyTrainListModel *)model
{
    [self.titelLb setText:model.name];
    [self.sellerLb setText:model.supplierName];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"完成%ld/%ld天",(long)model.completedDays,model.totalTime]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor themeOrange_ff5d2b] range:NSMakeRange(2, 1)];
    [self.dayLb setAttributedText:str];
    [self.backView
     sd_setImageWithURL:[NSString fullURLWithFileString:model.backgroundUrl]];
    NSString *totalStr = [NSString
                          stringWithFormat:@"%ld",(long)model.totalTime];
    CGFloat totalFloat = [totalStr floatValue];
    
    NSString *completStr = [NSString
                          stringWithFormat:@"%ld",(long)model.completedDays];
    CGFloat completFloat = [completStr floatValue];
    [self.round setMyAngale:completFloat / totalFloat] ;
}
#pragma mark - event Response

#pragma mark - request Delegate

#pragma mark - updateViewConstraints
- (void)updateConstraints
{
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self).offset(7);
        make.right.equalTo(self).offset(-7);
        make.bottom.equalTo(self);
    }];
    
    if (self.isNeedStrength) {
        
        [self.titelLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView).offset(15);
            make.left.equalTo(self.backView).offset(13);
            make.right.lessThanOrEqualTo(self.backView);
        }];
        
        [self.strengthView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(53);
            make.left.equalTo(self.titelLb);
            make.top.equalTo(self.titelLb.mas_bottom).offset(10);
        }];
        [self.dayLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.strengthView.mas_bottom).offset(10);
            make.left.equalTo(self.titelLb);
            make.right.lessThanOrEqualTo(self.backView);
        }];
        
        [self.isJoinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dayLb);
            make.top.equalTo(self.dayLb.mas_bottom).offset(10);
        }];
    }
    else
    {
        [self.titelLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView).offset(23);
            make.left.equalTo(self.backView).offset(13);
            make.right.lessThanOrEqualTo(self.backView);
        }];

        [self.dayLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titelLb.mas_bottom).offset(10);
            make.left.equalTo(self.titelLb);
            make.right.lessThanOrEqualTo(self.backView);
        }];
        
        [self.round mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backView).offset(5);
            make.centerX.equalTo(self.backView.mas_right).multipliedBy(0.85);
            make.height.width.equalTo(self.backView.mas_height).multipliedBy(0.5);
        }];

    }
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titelLb);
        make.bottom.equalTo(self.backView).offset(-11);
        make.width.height.mas_equalTo(13);
    }];
    
    [self.sellerLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(4);;
        make.centerY.equalTo(self.iconView);
        make.right.lessThanOrEqualTo(self.backView);
    }];
    
    [self.hotOrNewView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(47);
        make.right.top.equalTo(self.backView);
    }];
    
        [super updateConstraints];
}

#pragma mark - init UI

- (UIImageView *)backView
{
    if (!_backView) {
        _backView = [[UIImageView alloc]init];
        [_backView.layer setCornerRadius:6];
        [_backView setClipsToBounds:YES];
        [_backView setImage:[UIImage imageNamed:@"taining_back"]];
        [_backView setBackgroundColor:[UIColor clearColor]];
    }
    return _backView;
}

- (UILabel *)titelLb
{
    if (!_titelLb) {
        _titelLb = [UILabel setLabel:_titelLb text:@"零基础适应性训练" font:[UIFont systemFontOfSize:fontSize_18] textColor:[UIColor whiteColor]];
    }
    return _titelLb;
}

- (UILabel *)dayLb
{
    if (!_dayLb) {
        _dayLb = [UILabel setLabel:_dayLb text:@"完成4/8天" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor whiteColor]];
    }
    return _dayLb;
}


- (UILabel *)sellerLb
{
    if (!_sellerLb) {
        _sellerLb = [UILabel setLabel:_sellerLb text:@"shape官方" font:[UIFont systemFontOfSize:fontSize_15] textColor:[UIColor colorLightGray_898888]];
    }
    return _sellerLb;
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        [_iconView setImage:[UIImage imageNamed:@"taining_icon"]];
    }
    return _iconView;
}

- (TrainStrengthView *)strengthView
{
    if (!_strengthView) {
        _strengthView = [[TrainStrengthView alloc]init];
    }
    return _strengthView;
}

- (UIImageView *)hotOrNewView
{
    if (!_hotOrNewView) {
        _hotOrNewView = [[UIImageView alloc]init];
        [_hotOrNewView setImage:[UIImage imageNamed:@"train_hot"]];
        [_hotOrNewView setHighlightedImage:[UIImage imageNamed:@"train_new"]];
        [_hotOrNewView setHidden:YES];
    }
    return _hotOrNewView;
}

- (UIImageView *)isJoinView
{
    if (!_isJoinView) {
        _isJoinView = [[UIImageView alloc]init];
        [_isJoinView setImage:[UIImage imageNamed:@"train_join"]];
        [_isJoinView setHidden:YES];
    }
    return _isJoinView;
}

- (TrainRoundnessProgressBar *)round
{
    if (!_round) {
        _round = [[TrainRoundnessProgressBar alloc]init];
        
    }
    return _round;
}
@end
