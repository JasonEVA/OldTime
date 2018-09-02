//
//  TrainProgressView.m
//  Shape
//
//  Created by jasonwang on 15/11/11.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainProgressView.h"
#import <Masonry.h>
#import "UIColor+Hex.h"
#import "UILabel+EX.h"

@interface TrainProgressView()
@property (nonatomic, strong) MASConstraint *progressLeft;
@end

@implementation TrainProgressView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setBackgroundColor:[UIColor themeBackground_373737]];
        [self addSubview:self.progressView];
        [self addSubview:self.hideView];
        [self addSubview:self.totalPtogressLb];
        [self addSubview:self.timeLb];
        [self addSubview:self.precentLb];
        
        [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(5);
            make.right.bottom.equalTo(self).offset(-5);
        }];
        [self.hideView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.width.equalTo(self.progressView);
             self.progressLeft = make.left.equalTo(self.progressView);
        }];
        
        [self.totalPtogressLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(21);
            make.centerY.equalTo(self);
        }];
        
        [self.timeLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.centerX.equalTo(self);
        }];
        [self.precentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-21);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (void)setMyProgress:(CGFloat)progress
{
    self.progressLeft.offset = self.progressView.frame.size.width * progress;
    [self setNeedsDisplay];
    [self.precentLb setText:[NSString stringWithFormat:@"%0.0f%%",progress * 100]];
}

- (UIImageView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIImageView alloc]init];
        [_progressView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"train_progress"]]];
    }
    return _progressView;
}

- (UILabel *)totalPtogressLb
{
    if (!_totalPtogressLb) {
        _totalPtogressLb = [UILabel setLabel:_totalPtogressLb text:@"总进度" font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor]];
    }
    return _totalPtogressLb;
}

- (UILabel *)timeLb
{
    if (!_timeLb) {
        _timeLb = [UILabel setLabel:_timeLb text:@"02:45" font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor]];
    }
    return _timeLb;
}
- (UILabel *)precentLb
{
    if (!_precentLb) {
        _precentLb = [UILabel setLabel:_precentLb text:@"0%" font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor]];
    }
    return _precentLb;
}
- (UIView *)hideView
{
    if (!_hideView) {
        _hideView = [[UIView alloc]init];
        [_hideView setBackgroundColor:[UIColor themeBackground_373737]];
    }
    return _hideView;
}
@end
