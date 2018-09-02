//
//  ZJKPickerSheet.m
//  ZJKPatient
//
//  Created by yinqaun on 15/5/6.
//  Copyright (c) 2015年 YinQ. All rights reserved.
//

#import "ZJKPickerSheet.h"
#import "UIView+SizeExtension.h"
#import "UIImage+SizeExtension.h"
#import "ZJKViewInc.h"

#define kPickerHeight       216
#define kToolbarHeight      40

#define kZJKPickerSheetTag   0x5780

@interface ZJKPickerSheet ()
{
    UIView* sheetview;
    
    UIView* toolbar;
}
@end

@implementation ZJKPickerSheet

@synthesize delegate = _delegate;

- (id) init
{
    CGRect rtFrame = [self topViewBounds];
    self = [super initWithFrame:rtFrame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self createSheet];
        
        [self setTag:kZJKPickerSheetTag];
    }
    return self;
}

- (void) createSheet
{
    sheetview = [[UIView alloc] init];
    [self addSubview:sheetview];
    [sheetview setBackgroundColor:[UIColor whiteColor]];
    
    toolbar = [[UIView alloc] init];
    [sheetview addSubview:toolbar];
    toolbar.backgroundColor = [UIColor mainThemeColor];
    
    UIButton* btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolbar addSubview:btnCancel];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancel.titleLabel setFont:[UIFont font_26]];
    [btnCancel addTarget:self action:@selector(onCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton* btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolbar addSubview:btnConfirm];
    [btnConfirm setTitle:@"确认" forState:UIControlStateNormal];
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnConfirm.titleLabel setFont:[UIFont font_30]];
    [btnConfirm addTarget:self action:@selector(onComfirmlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    pickerview = [[UIView alloc]init];
    [sheetview addSubview:pickerview];
    [pickerview setBackgroundColor:[UIColor whiteColor]];
    
    [sheetview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(self).dividedBy(2);
    }];
    
    [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sheetview);
        make.left.right.equalTo(sheetview);
        make.height.equalTo(@50);
    }];
    
    [btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(toolbar).offset(15);
        make.centerY.equalTo(toolbar);
        make.top.bottom.equalTo(toolbar);
    }];
    
    [btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(toolbar).offset(-15);
        make.centerY.equalTo(toolbar);
        make.height.equalTo(btnCancel);
    }];
    
    [pickerview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(sheetview);
        make.top.equalTo(toolbar.mas_bottom);
    }];
}



- (CGRect) topViewBounds
{
    UIView* vTop = [UIView appTopView];
    return vTop.bounds;
}

- (void) show
{
    UIView* vTop = [UIView appTopView];
    UIView* vSheet = [vTop viewWithTag:kZJKPickerSheetTag];
    if (vSheet)
    {
        return;
    }
    [vTop addSubview:self];
}

- (void)onCancelButtonClicked:(id) sender
{
    [self closeSheet];
}

- (void) onComfirmlButtonClicked:(id) sender
{
    [self makeResult];
    if (_delegate && [_delegate respondsToSelector:@selector(pickersheet:selectedResult:)])
    {
        if (sResult)
        {
            [_delegate pickersheet:self selectedResult:sResult];
        }
    }
    [self closeSheet];
}

- (void) makeResult
{
    
}

- (void) closeSheet
{
    [self removeFromSuperview];
}

@end
