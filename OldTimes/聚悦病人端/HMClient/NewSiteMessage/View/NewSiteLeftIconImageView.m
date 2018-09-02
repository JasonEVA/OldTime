//
//  NewSiteLeftIconImageView.m
//  HMClient
//
//  Created by jasonwang on 2016/11/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewSiteLeftIconImageView.h"
#import "RoundCountView.h"

@interface NewSiteLeftIconImageView ()
@property (nonatomic, strong) RoundCountView *countLb;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation NewSiteLeftIconImageView

-(instancetype)init {
    if (self = [super init]) {

        [self addSubview:self.iconImageView];
        [self addSubview:self.countLb];
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.countLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_top).offset(5);
            make.centerX.equalTo(self.mas_right).offset(-5);
        }];
    }
    return self;
}

- (void)fillinImage:(UIImage *)image unreadCount:(NSInteger)unreadCount {
    [self.iconImageView setImage:image];
    [self.countLb setCount:unreadCount];
    [self.countLb setHidden:(unreadCount <= 0)];
    if (unreadCount < 10) {
        [self.countLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@20);
        }];
    }
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        [_iconImageView.layer setCornerRadius:25];
        [_iconImageView setClipsToBounds:YES];
    }
    return _iconImageView;
}

- (RoundCountView *)countLb {
    if (!_countLb) {
        _countLb = [[RoundCountView alloc] init];
        [_countLb.layer setBorderWidth:1];
        [_countLb.layer setBorderColor:[UIColor whiteColor].CGColor];
    }
    return _countLb;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
