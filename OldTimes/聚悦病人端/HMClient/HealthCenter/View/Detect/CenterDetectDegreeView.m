//
//  CenterDetectDegreeView.m
//  HMClient
//
//  Created by yinqaun on 16/6/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "CenterDetectDegreeView.h"

@interface CenterDetectDegreeView ()
{
    UIImageView* ivBlank;
}
@end

@implementation CenterDetectDegreeView

- (id) init
{
    self = [super init];
    if (self)
    {
        UIImage* imgBlank = [UIImage circleBoarderImage:CGSizeMake(70, 70) Color:[UIColor commonLightGrayTextColor] BoarderWidth:10];
        ivBlank = [[UIImageView alloc]initWithImage:imgBlank];
        [self addSubview:ivBlank];
        [ivBlank mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.and.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void) setImageName:(NSString*) imageName
{
    if (!imageName || 0 == imageName.length) {
        return;
    }
    UIImage* img = [UIImage imageNamed:imageName];
    if (img)
    {
        [ivBlank setImage:img];
    }
}

@end
