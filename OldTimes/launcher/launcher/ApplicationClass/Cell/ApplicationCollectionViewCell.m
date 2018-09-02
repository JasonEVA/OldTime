//
//  ApplicationCollectionViewCell.m
//  launcher
//
//  Created by Conan Ma on 15/7/29.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplicationCollectionViewCell.h"
#import "UnifiedUserInfoManager.h"
#import "UIFont+Util.h"

@implementation ApplicationCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.imgView];
        [self addSubview:self.lblTitle];
    }
    return self;
}

#pragma mark - init
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8.5, 0, 62.5, 62.5)];
    }
    return _imgView;
}

- (UILabel *)lblTitle
{
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(-5, 70, 90, 20)];
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        if ([[[UnifiedUserInfoManager share] getLanguageIdentifier] isEqualToString:@"zh-zn"])
        {
            _lblTitle.font = [UIFont mtc_font_30];
        }
        else
        {
            _lblTitle.font = [UIFont mtc_font_24];
        }
        
    }
    return _lblTitle;
}
@end
