//
//  HMRainysEmptyView.m
//  HMClient
//
//  Created by jasonwang on 2017/2/21.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMRainysEmptyView.h"

@interface HMRainysEmptyView ()
@property (nonatomic, strong) UIImageView *emptyImageView;
@property (nonatomic, strong) UILabel *emptyWordLb;
@end

@implementation HMRainysEmptyView

- (instancetype)initWithImage:(UIImage *)image emptyWord:(NSString *)emptyWord {
    if (self = [super init]) {
        _emptyImageView = [[UIImageView alloc] initWithImage:image];
        _emptyWordLb = [UILabel new];
        [_emptyWordLb setFont:[UIFont font_30]];
        [_emptyWordLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_emptyWordLb setText:emptyWord];
        
        [self addSubview:_emptyImageView];
        [self addSubview:_emptyWordLb];
        
        [_emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_centerY).offset(-15);
        }];
        
        [_emptyWordLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.mas_centerY);
        }];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
