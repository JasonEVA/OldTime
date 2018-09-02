//
//  HMDoctorIconNavView.m
//  HMClient
//
//  Created by jasonwang on 2016/10/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMDoctorIconNavView.h"

#define DOCTORICONHEIGHT    25
#define NUMCOUNTHEIGHT      15

@interface HMDoctorIconNavView ()
@property (nonatomic, strong) UIImageView *tempView;    //头像
@end

@implementation HMDoctorIconNavView

- (instancetype)init {
    if (self = [super init]) {
        
}
    return self;
}


- (void)fillDataWithDataList:(NSArray<StaffInfo *> *)dataList {
    [dataList enumerateObjectsUsingBlock:^(StaffInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_default_staff"]];
        [iconView sd_setImageWithURL:[NSURL URLWithString:obj.imgUrl] placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
        [iconView.layer setBorderWidth:1];
        [iconView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [iconView.layer setCornerRadius:DOCTORICONHEIGHT / 2];
        [iconView setClipsToBounds:YES];
        [iconView setUserInteractionEnabled:YES];
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (idx) {
                make.left.equalTo(self.tempView.mas_right).offset(-4);
            }
            else {
                make.left.equalTo(self);
            }
            make.top.bottom.equalTo(self);
            make.width.height.equalTo(@DOCTORICONHEIGHT);
        }];
        self.tempView = iconView;
        if (idx == 2) {
            *stop = YES;
        }
    }];
    
    UILabel *numCount = [UILabel new];
    [numCount setBackgroundColor:[UIColor whiteColor]];
    [numCount setTextColor:[UIColor colorWithHexString:@"999999"]];
    [numCount.layer setCornerRadius:(self.height * 0.6) / 2];
    [numCount setClipsToBounds:YES];
    [numCount setTextAlignment:NSTextAlignmentCenter];
    [numCount setFont:[UIFont font_18]];
    [numCount setText:[NSString stringWithFormat:@"%ld",dataList.count]];
    [self addSubview:numCount];
    [numCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(self);
        make.left.equalTo(self.tempView.mas_right).offset(-4);
        make.height.width.mas_equalTo(self.height * 0.6);
    }];

    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIImageView *)tempView {
    if (!_tempView) {
        _tempView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_default_staff"]];
    }
    return _tempView;
}

@end
