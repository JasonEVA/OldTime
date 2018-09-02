//
//  HMSEHealthPlanMissionHeadView.m
//  HMClient
//
//  Created by jasonwang on 2017/6/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSEHealthPlanMissionHeadView.h"

@interface HMSEHealthPlanMissionHeadView ()
@property (nonatomic, strong) UILabel *allMissionLb;
@property (nonatomic, strong) UILabel *doneMissionLb;

@end

@implementation HMSEHealthPlanMissionHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.allMissionLb = [UILabel new];
        self.doneMissionLb = [UILabel new];
        [self.allMissionLb setFont:[UIFont systemFontOfSize:15]];
        [self.allMissionLb setTextColor:[UIColor colorWithHexString:@"ff9c37"]];
        [self.doneMissionLb setFont:[UIFont systemFontOfSize:15]];
        [self.doneMissionLb setTextColor:[UIColor colorWithHexString:@"ff9c37"]];
        
        [self addSubview:self.allMissionLb];
        [self addSubview:self.doneMissionLb];
        
        [self.allMissionLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        
        [self.doneMissionLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.allMissionLb.mas_right).offset(15);
            make.centerY.equalTo(self);
        }];
        
    }
    return self;
}

- (void)fillDataWithAllMissionCount:(NSInteger)allMissionCount {
    [self.allMissionLb setAttributedText:[NSAttributedString getAttributWithChangePart:[NSString stringWithFormat:@"%ld",(long)allMissionCount] UnChangePart:@"任务 " UnChangeColor:[UIColor colorWithHexString:@"666666"] UnChangeFont:[UIFont systemFontOfSize:15]]];
}

- (void)fillDataWithdoneMissionCount:(NSInteger)doneMissionCount {
    [self.doneMissionLb setAttributedText:[NSAttributedString getAttributWithChangePart:[NSString stringWithFormat:@"%ld",(long)doneMissionCount] UnChangePart:@"已完成 " UnChangeColor:[UIColor colorWithHexString:@"666666"] UnChangeFont:[UIFont systemFontOfSize:15]]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
