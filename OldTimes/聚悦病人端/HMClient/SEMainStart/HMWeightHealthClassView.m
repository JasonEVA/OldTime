//
//  HMWeightHealthClassView.m
//  HMClient
//
//  Created by jasonwang on 2017/8/9.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMWeightHealthClassView.h"
#import "HealthEducationItem.h"

@interface HMWeightHealthClassView ()

@property (nonatomic, strong) UIImageView *jwImageView;
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UILabel *dateLb;
@property (nonatomic, strong) UILabel *readedCountLb;

@end

@implementation HMWeightHealthClassView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setCornerRadius:2];
        [self.layer setBorderColor:[[UIColor colorWithHexString:@"dfdfdf"] CGColor]];
        [self.layer setBorderWidth:0.5];
        
        [self addSubview:self.jwImageView];
        [self addSubview:self.titelLb];
        [self addSubview:self.dateLb];
        [self addSubview:self.readedCountLb];
        
        [self.jwImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(self);
            make.height.width.equalTo(@(self.frame.size.width));
        }];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.jwImageView.mas_bottom).offset(5);
            make.left.equalTo(self.jwImageView).offset(10);
            make.right.lessThanOrEqualTo(self.jwImageView).offset(-10);
        }];
        
        [self.dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titelLb);
            make.bottom.equalTo(self).offset(-8);
        }];
        
        
        [self.readedCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.dateLb);
            make.right.equalTo(self).offset(-10);
        }];
        
    }
    return self;
}

- (void)fillDataWithModel:(HealthEducationItem *)model {
    [self.jwImageView sd_setImageWithURL:[NSURL URLWithString:model.classPic] placeholderImage:[UIImage imageNamed:@""]];
    [self.titelLb setText:model.title];
    NSDate *date = [NSDate dateWithString:model.publishDate formatString:@"yyyy-MM-dd"];
    NSString *dateString = [date formattedDateWithFormat:@"MM.dd"];
    [self.dateLb setText:dateString];
    [self.readedCountLb setText:[NSString stringWithFormat:@"阅读量 %ld",(long)model.readTotal]];
}

- (UIImageView *)jwImageView {
    if (!_jwImageView) {
        _jwImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _jwImageView.contentMode = UIViewContentModeScaleAspectFill;
        _jwImageView.clipsToBounds = YES;
    }
    return _jwImageView;
}

- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setFont:[UIFont systemFontOfSize:15]];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titelLb setNumberOfLines:2];
    }
    return _titelLb;
}

- (UILabel *)dateLb {
    if (!_dateLb) {
        _dateLb = [UILabel new];
        [_dateLb setFont:[UIFont systemFontOfSize:12]];
        [_dateLb setTextColor:[UIColor colorWithHexString:@"999999"]];
    }
    return _dateLb;
}

- (UILabel *)readedCountLb {
    if (!_readedCountLb) {
        _readedCountLb = [UILabel new];
        [_readedCountLb setFont:[UIFont systemFontOfSize:12]];
        [_readedCountLb setTextColor:[UIColor colorWithHexString:@"999999"]];
    }
    return _readedCountLb;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
