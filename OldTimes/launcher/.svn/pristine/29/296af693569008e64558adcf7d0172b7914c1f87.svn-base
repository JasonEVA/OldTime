//
//  GraphicLockSmallView.m
//  launcher
//
//  Created by William Zhang on 15/7/29.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "GraphicLockSmallView.h"
#import <Masonry/Masonry.h>

#define IMG_NORMAL      [UIImage imageNamed:@"graphicPsw_smallNormal"]
#define IMG_SELECTED    [UIImage imageNamed:@"graphicPsw_smallSelected"]
#define IMG_SELECTED_RED [UIImage imageNamed:@"graphicPsw_smallSelected_red"]


@interface GraphicLockSmallView ()

@property (nonatomic, strong) NSArray *arrImageView;
@end

@implementation GraphicLockSmallView

- (instancetype)init {
    if (self = [super init]) {
        [self createImage];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(34, 34);
}


- (void)createImage
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < 9 ; i ++)
    {
        UIImageView *imgViewCircle = [[UIImageView alloc] initWithImage:IMG_NORMAL];
        [self addSubview:imgViewCircle];
        [array addObject:imgViewCircle];
        [imgViewCircle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@9);
            make.left.equalTo(self).offset((i % 3) * 14);
            make.top.equalTo(self).offset((i / 3) * 14);
        }];
    }
    self.arrImageView = [NSArray arrayWithArray:array];
}

#pragma mark - Private Method
- (void)resetCircles {
    for (UIImageView *imageView in self.arrImageView) {
        [imageView setImage:IMG_NORMAL];
    }
}


#pragma mark - Interface Method
- (void)setPassword:(NSArray *)password
{
    [self resetCircles];
    for (NSString *keyString in password)
    {
        NSInteger key = [keyString integerValue];
        UIImageView *imageView = [self.arrImageView objectAtIndex:key];
        imageView.image = IMG_SELECTED;
    }
}

- (void)setPassword:(NSArray *)password withIsSecond:(BOOL)issecond
{
    [self resetCircles];
    for (NSString *keyString in password)
    {
        NSInteger key = [keyString integerValue];
        UIImageView *imageView = [self.arrImageView objectAtIndex:key];
        imageView.image = IMG_SELECTED_RED;
    }
}

@end