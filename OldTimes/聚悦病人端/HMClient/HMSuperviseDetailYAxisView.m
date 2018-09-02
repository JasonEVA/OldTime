//
//  HMSuperviseDetailYAxisView.m
//  HMClient
//
//  Created by jasonwang on 2017/7/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSuperviseDetailYAxisView.h"

@interface HMSuperviseDetailYAxisView ()
@property (nonatomic, copy) NSArray *dataList;
@end

@implementation HMSuperviseDetailYAxisView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)fillDataListWithArr:(NSArray *)array {
    if (array && array.count > 0) {
        if (self.subviews && self.subviews.count) {
            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperview];
            }];
        }
       
        CGFloat YheightUnit = self.frame.size.height / array.count;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *label = [UILabel new];
            [label setTextColor:[UIColor colorWithHexString:@"999999"]];
            [label setFont:[UIFont systemFontOfSize:11]];
            [label setText:obj];
            [self addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-3);
                make.centerY.equalTo(self.mas_top).offset(YheightUnit*(idx + 1)-7);
            }];
        }];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
