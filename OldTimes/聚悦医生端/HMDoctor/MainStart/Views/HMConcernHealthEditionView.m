//
//  HMConcernHealthEditionView.m
//  HMDoctor
//
//  Created by jasonwang on 2017/6/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMConcernHealthEditionView.h"
#import "HealthEducationItem.h"

@interface HMConcernHealthEditionView ()
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *titelLb;
//@property (nonatomic, strong) UILabel *subTitelLb;
@end

@implementation HMConcernHealthEditionView

- (instancetype)init {
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor colorWithHexString:@"f3f3f5"]];
        self.headView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_xuanjiao"]];
        self.titelLb = [UILabel new];
        [self.titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self.titelLb setFont:[UIFont systemFontOfSize:15]];
        [self.titelLb setText:@"122"];
        [self.titelLb setNumberOfLines:2];
        
//        self.subTitelLb  = [UILabel new];
//        [self.subTitelLb setTextColor:[UIColor colorWithHexString:@"999999"]];
//        [self.subTitelLb setFont:[UIFont systemFontOfSize:12]];
//        [self.subTitelLb setText:@"5444"];
        [self addSubview:self.headView];
        [self addSubview:self.titelLb];
//        [self addSubview:self.subTitelLb];
        
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(5);
            make.centerY.equalTo(self);
            make.width.equalTo(@40);
            make.height.equalTo(@40);
        }];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headView.mas_right).offset(5);
            make.centerY.equalTo(self.headView);
            make.right.lessThanOrEqualTo(self).offset(-10);
        }];
        
//        [self.subTitelLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.headView.mas_right).offset(5);
//            make.bottom.equalTo(self.headView);
//            make.right.lessThanOrEqualTo(self).offset(-10);
//        }];
    }
    return self;
}

- (void)fillDataWithModel:(HealthEducationItem *)model {
    [self.titelLb setText:model.title];
//    [self.subTitelLb setText:model.paper];
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [self.headView sd_setImageWithURL:[NSURL URLWithString:model.classPic] placeholderImage:[UIImage imageNamed:@"ic_xuanjiao"]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
