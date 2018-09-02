//
//  ATManagerClockSelectDateView.m
//  Clock
//
//  Created by SimonMiao on 16/7/25.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATManagerClockSelectDateView.h"
#import <Masonry/Masonry.h>

#import "UIColor+ATHex.h"
#import "UILabel+ATCreate.h"
#import "UIButton+AtCreate.h"

@interface ATManagerClockSelectDateView ()

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIView   *titleTopLine;
@property (nonatomic, strong) UILabel  *titleLab;
@property (nonatomic, strong) UIView   *titleBottomLine;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation ATManagerClockSelectDateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cancelBtn];
        [self addSubview:self.sureBtn];
        [self addSubview:self.titleTopLine];
        [self addSubview:self.titleLab];
        [self addSubview:self.titleBottomLine];
        [self addSubview:self.datePicker];
        
        [self initConstraints];
    }
    return self;
}

- (void)initConstraints {
    
}

- (void)timePickerChanged:(UIDatePicker *)datePicker
{
    
}

- (void)cancelBtnClicked {
    
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton at_createBtnWithTitle:@"取消" fontSize:15.0 titleColor:[UIColor at_redColor] imgName:nil bgColor:nil addTarget:self selector:@selector(cancelBtnClicked)];
//        [_cancelBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    return _cancelBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton at_createBtnWithTitle:@"确定" fontSize:15.0 titleColor:[UIColor at_redColor] imgName:nil bgColor:nil addTarget:self selector:@selector(cancelBtnClicked)];
    }
    
    return _sureBtn;
}

- (UIView *)titleTopLine {
    if (!_titleTopLine) {
        _titleTopLine = [[UIView alloc] init];
        _titleTopLine.backgroundColor = [UIColor at_lightGrayColor];
    }
    
    return _titleTopLine;
}

- (UIView *)titleBottomLine {
    if (!_titleBottomLine) {
        _titleBottomLine = [[UIView alloc] init];
        _titleBottomLine.backgroundColor = [UIColor at_lightGrayColor];
    }
    
    return _titleBottomLine;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel at_createLabWithText:@"设置上班时间" fontSize:15.0 titleColor:[UIColor at_lightGrayColor]];
    }
    
    return _titleLab;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeTime;
        [_datePicker addTarget:self action:@selector(timePickerChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _datePicker;
}

@end
