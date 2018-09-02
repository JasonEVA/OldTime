//
//  ATPunchAlertView.m
//  Clock
//
//  Created by SimonMiao on 16/7/20.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATPunchAlertView.h"
#import "ATTextView.h"

#import <Masonry/Masonry.h>
#import "UIColor+ATHex.h"
#import "UILabel+ATCreate.h"
#import "UIButton+AtCreate.h"

static NSString *const k_status_Error = @"请填写原因";
static NSString *const k_status_Normal = @"备注";
@interface ATPunchAlertView () <UITextFieldDelegate>
{
    NSString *_remark;
}

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *titleBottomLine;
@property(nonatomic, strong) UITextField  *reasonTextField;

@property (nonatomic, strong) UIButton *closeBtn; //取消按钮
@property (nonatomic, strong) UIButton *sureBtn;  //确认按钮

@property(nonatomic, strong) UIView  *locationContentView;
@property(nonatomic, strong) UILabel  *locationLabel;  //地址显示内网
@property(nonatomic, strong) UIImageView  *locationIcon; //地址图标


@end

@implementation ATPunchAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.alertView];
        [self.alertView addSubview:self.titleLab];
        [self.alertView addSubview:self.titleBottomLine];
        [self.alertView addSubview:self.reasonTextField];
        
        [self.alertView addSubview:self.locationContentView];
        [self.locationContentView addSubview:self.locationLabel];
        [self.locationContentView addSubview:self.locationIcon];
        
        [self.alertView addSubview:self.sureBtn];
        [self.alertView addSubview:self.closeBtn];
        [self initConstraints];
    }
    return self;
}

- (void)initConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.width.equalTo(@270);
        make.height.equalTo(@250);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertView).offset(20);
        make.left.equalTo(self.alertView).offset(15);
        make.right.equalTo(self.alertView).offset(- 15);
    }];
    
    [self.locationContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alertView).offset(25);
        make.right.equalTo(self.alertView).offset(-25);
        make.height.equalTo(@27);
        make.top.equalTo(self.titleLab.mas_bottom).offset(10);
    }];
    
    [self.locationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationContentView);
        make.left.top.equalTo(self.locationContentView).offset(3);
        make.bottom.equalTo(self.locationContentView).offset(-3);
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.locationContentView);
        make.left.equalTo(self.locationIcon.mas_right).offset(10);
    }];
    
    
    [self.reasonTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.locationContentView);
        make.height.equalTo(self.locationContentView);
        make.top.equalTo(self.locationContentView.mas_bottom).offset(10);
    }];
    
    [self.titleBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.reasonTextField);
        make.top.equalTo(self.reasonTextField.mas_bottom).offset(2);
        make.height.equalTo(@1);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleLab);
        make.top.equalTo(self.titleBottomLine).offset(15);
        make.left.equalTo(self.alertView).offset(35);
        make.right.equalTo(self.alertView).offset(-35);
        make.height.equalTo(@50);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sureBtn.mas_bottom).offset(5);
        make.centerX.equalTo(self.sureBtn);
        make.left.right.equalTo(self.sureBtn);
        make.height.equalTo(self.sureBtn);
    }];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - interfacMethod

- (void)setTitle:(NSString *)title {
    self.titleLab.text = title;
}

- (void)setLocation:(NSString *)location
{
    _location = location;
    self.locationLabel.text = location;
}

- (void)setRemark:(NSString *)remark {
    _remark = remark;
    self.reasonTextField.text = remark;
}

- (void)setStatue:(CurrentStatue)statue
{
    _statue = statue;
    self.reasonTextField.placeholder = statue == 0 ?k_status_Normal:k_status_Error;
}

#pragma mark - privateMethod
- (void)gestureClick {
    [self resignKeyboard];
}

- (void)closeBtnClicked {
    [self removeFromSuperview];
    [self resignKeyboard];
}

- (void)sureBtnClicked {
    [self removeFromSuperview];
    [self resignKeyboard];
    if (_block) {
        _block(_remark);
    }
}

- (void)writeText:(ATPunchAlertViewBlock)block
{
    _block = block;
}

- (void)resignKeyboard
{
    [self moveDownAlertViewFrame];
    [self.reasonTextField resignFirstResponder];
}

- (void)moveUpAlertViewFrame {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = weakSelf.alertView.frame;
        rect.origin.y = rect.origin.y - 90;
        weakSelf.alertView.frame = rect;
    }];
}

- (void)moveDownAlertViewFrame {
    if (self.alertView.center.y == self.bgView.center.y) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = weakSelf.alertView.frame;
        rect.origin.y = rect.origin.y + 90;
        weakSelf.alertView.frame = rect;
    }];
}


#pragma mark - UITextViewDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self moveUpAlertViewFrame];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _remark = textField.text;
}



#pragma mark - setterAndGetter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureClick)];
        [_bgView addGestureRecognizer:gesture];
    }
    
    return _bgView;
}


- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 10.0;
        _alertView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _alertView.layer.shadowOffset = CGSizeMake(0, 0);
        _alertView.layer.shadowRadius = 10;
        _alertView.layer.shadowOpacity = 1;
    }
    
    return _alertView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel at_createLabWithText:@"" fontSize:23.0 titleColor:[UIColor at_redColor]];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLab;
}

- (UIView *)titleBottomLine {
    if (!_titleBottomLine) {
        _titleBottomLine = [[UIView alloc] init];
        _titleBottomLine.backgroundColor = [UIColor at_lightGrayColor];
    }
    
    return _titleBottomLine;
}

- (UITextField *)reasonTextField
{
    if (!_reasonTextField) {
        _reasonTextField = [[UITextField alloc] init];
        _reasonTextField.delegate = self;
    }
    return _reasonTextField;
}


- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton at_createBtnWithTitle:@"取消" fontSize:15.0 titleColor:[UIColor at_blueColor] imgName:nil bgColor:[UIColor clearColor] addTarget:self selector:@selector(closeBtnClicked)];
    }
    
    return _closeBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        
        _sureBtn = [UIButton at_createBtnWithTitle:@"确定" fontSize:15.0 titleColor:[UIColor whiteColor] imgName:nil bgColor:[UIColor at_blueColor] addTarget:self selector:@selector(sureBtnClicked)];
        _sureBtn.layer.cornerRadius = 10;
        _sureBtn.layer.masksToBounds = YES;
    }
    
    return _sureBtn;
}

- (UIView *)locationContentView
{
    if (!_locationContentView) {
        _locationContentView = [[UIView alloc] init];
    }
    return _locationContentView;
}

//图标
- (UIImageView *)locationIcon
{
    if (!_locationIcon) {
        _locationIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_checkAttendance_address"]];
        _locationIcon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _locationIcon;
}
//地理位置文字
- (UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
    }
    return _locationLabel;
}


@end

