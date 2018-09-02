//
//  DealUserAlertOtherwayView.m
//  HMDoctor
//
//  Created by lkl on 2017/9/11.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "DealUserAlertOtherwayView.h"

@interface DealUserAlertOtherwayView () <UITextViewDelegate>

@property (nonatomic, strong) UIView *dealView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation DealUserAlertOtherwayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6]];
        
        [self addSubview:self.dealView];
        [self.dealView addSubview:self.cancelBtn];
        [self.dealView addSubview:self.promptLabel];
        [self.dealView addSubview:self.txtView];
        [self.dealView addSubview:self.submitBtn];
        
        [self.dealView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.height.mas_equalTo(@240);
        }];
        
        [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.dealView).offset(12);
        }];
        
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.dealView.mas_right).offset(-12);
            make.center.equalTo(self.promptLabel);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self.txtView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dealView).offset(12);
            make.right.equalTo(self.dealView).offset(-12);
            make.top.equalTo(self.promptLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.dealView).offset(-65);
        }];
        
        [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.txtView);
            make.top.equalTo(self.txtView.mas_bottom).offset(10);
            make.height.mas_equalTo(@45);
        }];
    }
    return self;
}

- (void)cancelBtnClick{
    [self removeFromSuperview];
}

#pragma mark -- textViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    //字数限制操作
    if (textView.text.length > 20) {
        textView.text = [textView.text substringToIndex:20];
        [self showAlertMessage:@"最多输入20个字"];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

#pragma mark -- init
- (UIView *)dealView{
    if (!_dealView) {
        _dealView = [UIView new];
        [_dealView setBackgroundColor:[UIColor whiteColor]];
        [_dealView.layer setCornerRadius:5.0f];
        [_dealView.layer setMasksToBounds:YES];
    }
    return _dealView;
}

- (UILabel *)promptLabel{
    if (!_promptLabel) {
        _promptLabel = [UILabel new];
        _promptLabel.text = @"预警处理：其他方式";
        _promptLabel.textColor = [UIColor commonTextColor];
    }
    return _promptLabel;
}

- (PlaceholderTextView *)txtView{
    if (!_txtView) {
        _txtView = [[PlaceholderTextView alloc] init];
        [_txtView setPlaceholder:@"请输入处理意见（20字以内）"];
        [_txtView.layer setBorderWidth:1.0f];
        [_txtView.layer setBorderColor:[UIColor commonControlBorderColor].CGColor];
        [_txtView setReturnKeyType:UIReturnKeyDone];
        [_txtView setDelegate:self];
    }
    return _txtView;
}

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton new];
        [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:[UIColor mainThemeColor]];
    }
    return _submitBtn;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        [_cancelBtn setImage:[UIImage imageNamed:@"X_gray"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
@end


@interface DealUserAlertInfoView ()

@property (nonatomic, strong) UILabel *patientName;
@property (nonatomic, strong) UILabel *patientInfoLb;
@property (nonatomic, strong) UILabel *detectValueLb;
@property (nonatomic, strong) UILabel *timeLb;

@end

@implementation DealUserAlertInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:self.patientName];
        [self addSubview:self.patientInfoLb];
        [self addSubview:self.detectValueLb];
        [self addSubview:self.timeLb];
        
        [self.patientName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(12.5);
        }];
        
        [self.patientInfoLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.patientName.mas_right).offset(10);
            make.centerY.equalTo(self.patientName);
        }];
        
        [self.detectValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.patientName.mas_left);
            make.bottom.equalTo(self).offset(-10);
        }];
        
        [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.detectValueLb.mas_right).offset(15);
            make.bottom.equalTo(self).offset(-10);
        }];
        
    }
    return self;
}

- (void)setUserAlertInfo:(UserWarningDetInfo *)alert
{
    [_patientName setText:alert.userName];
    
    if (kStringIsEmpty(alert.ill)) {
        [_patientInfoLb setText:[NSString stringWithFormat:@"(%@|%ld)", alert.sex, alert.age]];
    }
    else{
        [_patientInfoLb setText:[NSString stringWithFormat:@"(%@|%ld %@)", alert.sex, alert.age,alert.ill]];
    }
    
    [_detectValueLb setText:[NSString stringWithFormat:@"%@ %@",alert.kpiName,alert.testValue]];
    
    [_timeLb setText:alert.warmingTime];
}

#pragma mark -- init
- (UILabel *)patientName{
    if (!_patientName) {
        _patientName = [UILabel new];
        _patientName.textColor = [UIColor commonTextColor];
        [_patientName setFont:[UIFont font_32]];
    }
    return _patientName;
}

- (UILabel *)patientInfoLb{
    if (!_patientInfoLb) {
        _patientInfoLb = [UILabel new];
        _patientInfoLb.textColor = [UIColor commonLightGrayTextColor];
        [_patientInfoLb setFont:[UIFont font_28]];
    }
    return _patientInfoLb;
}

- (UILabel *)detectValueLb{
    if (!_detectValueLb) {
        _detectValueLb = [UILabel new];
        _detectValueLb.textColor = [UIColor commonLightGrayTextColor];
        [_detectValueLb setFont:[UIFont font_28]];
    }
    return _detectValueLb;
}

- (UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [UILabel new];
        _timeLb.textColor = [UIColor commonLightGrayTextColor];
        [_timeLb setFont:[UIFont font_28]];
    }
    return _timeLb;
}
@end
