//
//  MissionMenuView.m
//  launcher
//
//  Created by Kyle He on 15/8/29.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MissionMenuView.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"

@interface MissionMenuView()

@property(nonatomic, strong) UIButton  *menuBtn;
@property(nonatomic, strong) UIButton  *addBtn;

@property(nonatomic, assign) NSInteger  index;

@end

@implementation MissionMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 0.3;
        self.layer.borderColor = [UIColor grayBackground].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        [self initComponents];
    }
    return self;
}

- (void)initComponents
{
    [self addSubview:self.menuBtn];
    [self addSubview:self.addBtn];
    [self.menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(self.addBtn);
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.right.equalTo(self);
        make.left.equalTo(self.menuBtn.mas_right);
    }];
    
    UIView *seperatorLine = [[UIView alloc] init];
    seperatorLine.backgroundColor = [UIColor borderColor];
    [self addSubview:seperatorLine];
    [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.centerX.equalTo(self);
        make.width.equalTo(@0.5);
    }];
}

#pragma mark - private method
- (void)addActionsWithBtn:(UIButton *)btn {
    //按钮暴力点击防御
    [self.menuBtn mtc_deterClickedRepeatedly];
    [self.addBtn mtc_deterClickedRepeatedly];
    
    if ([self.delegate respondsToSelector:@selector(missionMenuViewDelegateCallBack_showKeyBoardWithIndex:)]) {
        [self.delegate missionMenuViewDelegateCallBack_showKeyBoardWithIndex:btn.tag];
    }
}

#pragma maek - Initializer
- (UIButton *)menuBtn {
    if (!_menuBtn) {
        _menuBtn = [[UIButton alloc] init];
        [_menuBtn setTitle:@"menu" forState:UIControlStateNormal];
        [_menuBtn setTitleColor:[UIColor mtc_colorWithHex:0x959595] forState:UIControlStateNormal];
        [_menuBtn setImage:[UIImage imageNamed:@"mission_menu"] forState:UIControlStateNormal];
        
        [_menuBtn setImageEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 10)];
        
        [_menuBtn setTitleColor:[UIColor themeBlue] forState:UIControlStateHighlighted];
        [_menuBtn setImage:[UIImage imageNamed:@"menu_highlight"] forState:UIControlStateHighlighted];
        
        [_menuBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor buttonHighlightColor]] forState:UIControlStateHighlighted];
        
        [_menuBtn addTarget:self action:@selector(addActionsWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        _menuBtn.tag = kmenuBtn;
    }
    return _menuBtn;
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] init];
        [_addBtn setTitle:LOCAL(MISSION_ADD) forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor mtc_colorWithHex:0x959595] forState:UIControlStateNormal];
        [_addBtn setImage:[UIImage imageNamed:@"Cross_Add_Gray"] forState:UIControlStateNormal];
        
        [_addBtn setTitleColor:[UIColor themeBlue] forState:UIControlStateHighlighted];
        [_addBtn setImage:[[UIImage imageNamed:@"Cross_Add_Blue"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];

        [_addBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor buttonHighlightColor]] forState:UIControlStateHighlighted];
        
        [_addBtn addTarget:self action:@selector(addActionsWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.tag = kaddBtn;
    }
    return _addBtn;
}

@end
