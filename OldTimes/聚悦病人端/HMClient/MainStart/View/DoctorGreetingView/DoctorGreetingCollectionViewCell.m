//
//  DoctorGreetingCollectionViewCell.m
//  HMClient
//
//  Created by Andrew Shen on 16/5/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DoctorGreetingCollectionViewCell.h"
#import "DoctorGreetingView.h"

@interface DoctorGreetingCollectionViewCell()
@property (nonatomic, strong)  DoctorGreetingView  *greetingView; // <##>
@end
@implementation DoctorGreetingCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.greetingView];
        [self.greetingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (DoctorGreetingView *)greetingView {
    if (!_greetingView) {
        _greetingView = [DoctorGreetingView new];
        _greetingView.backgroundColor = [UIColor whiteColor];
        _greetingView.layer.cornerRadius = 5;
        _greetingView.clipsToBounds = YES;
    }
    return _greetingView;
}
@end
