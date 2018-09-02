//
//  HealthEducationStartBottomView.m
//  HMDoctor
//
//  Created by yinquan on 17/1/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthEducationStartBottomView.h"

@interface HealthEducationStartBottomView ()

@property (nonatomic, readonly) UIButton* collectionButton; //收藏夹
@property (nonatomic, readonly) UIButton* fineButton;       //精品课堂

@end

@implementation HealthEducationStartBottomView

- (id) init
{
    self = [super init];
    if (self) {
        _collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.collectionButton];
        [self.collectionButton setTitle:@"收藏夹" forState:UIControlStateNormal];
        [self.collectionButton setTitleColor:[UIColor commonDarkGrayTextColor] forState:UIControlStateNormal];
        [self.collectionButton setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateHighlighted];
        [self.collectionButton.titleLabel setFont:[UIFont font_30]];
        [self.collectionButton setImage:[UIImage imageNamed:@"education_collection"] forState:UIControlStateNormal];
        [self.collectionButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        
        [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.bottom.equalTo(self);
        }];
        
        [self.collectionButton addTarget:self action:@selector(collectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _fineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.fineButton];
        [self.fineButton setTitle:@"精品课堂" forState:UIControlStateNormal];
        [self.fineButton setTitleColor:[UIColor commonDarkGrayTextColor] forState:UIControlStateNormal];
        [self.fineButton setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateHighlighted];
        [self.fineButton.titleLabel setFont:[UIFont font_30]];
        [self.fineButton setImage:[UIImage imageNamed:@"education_fine"] forState:UIControlStateNormal];
        [self.fineButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [self.fineButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.top.and.bottom.equalTo(self);
            make.left.equalTo(self.collectionButton.mas_right);
            make.width.equalTo(self.collectionButton);
        }];
        [self.fineButton addTarget:self action:@selector(fineButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView* midLine = [[UIView alloc] init];
        [self.fineButton addSubview:midLine];
        [midLine setBackgroundColor:[UIColor commonControlBorderColor]];
        
        [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fineButton);
            make.top.equalTo(self.fineButton).with.offset(8);
            make.bottom.equalTo(self.fineButton).with.offset(-8);
            make.width.mas_equalTo(@0.5);
        }];
    }
    return self;
}

- (void) collectionButtonClicked:(id) sender
{
    //跳转到收藏夹
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationCollectionStartViewController" ControllerObject:nil];
}

- (void) fineButtonClicked:(id) sender
{
    //跳转到极品课堂
    [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationFineViewController" ControllerObject:nil];
}

@end
