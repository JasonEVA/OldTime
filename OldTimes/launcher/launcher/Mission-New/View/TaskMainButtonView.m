//
//  TaskMainButtonView.m
//  launcher
//
//  Created by TabLiu on 16/2/23.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "TaskMainButtonView.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"

@interface TaskMainButtonView ()

@property (nonatomic,strong) UIButton * liftBtn;
@property (nonatomic,strong) UIButton * rightBtn;
@property (nonatomic,strong) UIView * lineView1;
@property (nonatomic,strong) UIView * lineView2 ;

@end

@implementation TaskMainButtonView

- (id)init
{
    self = [super init];
    if (self) {
        
        [self addSubview:self.liftBtn];
        [self addSubview:self.rightBtn];
        [self addSubview:self.lineView1];
        [self addSubview:self.lineView2];
        
        [self.liftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.equalTo(self);
            make.right.equalTo(self.mas_centerX);
        }];
        [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.liftBtn.mas_right);
//            make.width.equalTo(@0.5);
        }];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.left.equalTo(self.lineView1.mas_right);
        }];
        [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
    }
    return self;
}


- (void)setLiftButtonTitle:(NSString *)title imageName:(NSString *)string
{
    [self.liftBtn setTitle:title forState:UIControlStateNormal];
    [self.liftBtn setImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
}
- (void)setRightButtonTitle:(NSString *)title imageName:(NSString *)string
{
    [self.rightBtn setTitle:title forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
}

- (void)liftButtonClick:(UIButton *)button
{
    [self clickDelegateWithIndex:0];
}
- (void)rightMissionButtonClick:(UIButton *)button
{
    [self clickDelegateWithIndex:1];
}

- (void)clickDelegateWithIndex:(NSInteger)index
{
    if (_delegate && [_delegate respondsToSelector:@selector(TaskMainButtonViewDelegateCallBack_SelectButtonIndex:)]) {
        [_delegate TaskMainButtonViewDelegateCallBack_SelectButtonIndex:index];
    }
}

- (UIButton *)liftBtn
{
    if (!_liftBtn) {
        _liftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_liftBtn setImage:[UIImage imageNamed:@"Mission_NewMenu"] forState:UIControlStateNormal];
//        [_liftBtn setTitle:LOCAL(NEWMISSION_MENU) forState:UIControlStateNormal];
        [_liftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_liftBtn addTarget:self action:@selector(liftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _liftBtn;
}
- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"Add_Task"] forState:UIControlStateNormal];
//        [_rightBtn setTitle:LOCAL(NEWMISSION_ADD_MISSION) forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightMissionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UIView *)lineView1
{
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.userInteractionEnabled = YES;
        _lineView1.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    }
    return _lineView1;
}

- (UIView *)lineView2
{
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.userInteractionEnabled = YES;
        _lineView2.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    }
    return _lineView2;
}


@end
