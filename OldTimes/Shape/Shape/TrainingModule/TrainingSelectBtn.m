//
//  TrainingSelectBtn.m
//  Shape
//
//  Created by jasonwang on 15/10/30.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainingSelectBtn.h"
#import "UIColor+Hex.h"
#import <Masonry.h>

@implementation TrainingSelectBtn

- (instancetype)initWithTitel:(NSString *)titel tag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.myImageView];
        [self setTag:tag];
        [self setTitle:titel forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor colorLightGray_898888] forState:UIControlStateNormal];
        
        [self.myImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.titleLabel.mas_right).offset(4);
            make.right.lessThanOrEqualTo(self);
        }];
    }
    return self;
}



#pragma mark -private method

- (void)setState:(BOOL)isSelect
{
    if (isSelect) {
        [self.myImageView setHighlighted:YES];
        [self setSelected:YES];
    }else
    {
        [self.myImageView setHighlighted:NO];
        [self setSelected:NO];
    }
}
- (void)setMyTitel:(NSString *)titel
{
    [self setTitle:titel forState:UIControlStateNormal];
    
}
#pragma mark - event Response

#pragma mark - request Delegate

#pragma mark - updateViewConstraints

#pragma mark - init UI

- (UIImageView *)myImageView
{
    if (!_myImageView) {
        _myImageView = [[UIImageView alloc]init];
        [_myImageView setImage:[UIImage imageNamed:@"taining_arrow_disable"]];
        [_myImageView setHighlightedImage:[UIImage imageNamed:@"taining_arrow"]];
    }
    return _myImageView;
}


@end
