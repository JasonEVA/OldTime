//
//  MeShareCollectionViewCell.m
//  launcher
//
//  Created by Conan Ma on 15/9/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeShareCollectionViewCell.h"

@implementation MeShareCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.imgview];
    }
    return self;
}

- (UIImageView *)imgview
{
    if (!_imgview)
    {
        _imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    return _imgview;
}
@end
