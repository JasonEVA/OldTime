//
//  PraviteTeachCollectionViewCell.m
//  Shape
//
//  Created by Andrew Shen on 15/11/11.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "PraviteTeachCollectionViewCell.h"
#import <Masonry/Masonry.h>

@implementation PraviteTeachCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *lb = [[UILabel alloc] init];
        [lb setFont:[UIFont boldSystemFontOfSize:30]];
        [lb setText:@"暂无"];
        [lb setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return self;
}
@end
