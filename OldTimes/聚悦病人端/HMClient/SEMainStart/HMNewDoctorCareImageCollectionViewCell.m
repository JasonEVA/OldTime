//
//  HMNewDoctorCareImageCollectionViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/6/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMNewDoctorCareImageCollectionViewCell.h"

@interface HMNewDoctorCareImageCollectionViewCell ()
@end

@implementation HMNewDoctorCareImageCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"im_back"]];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}
@end
