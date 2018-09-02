//
//  BodyTemperatureDetectResultRemarksView.m
//  HMClient
//
//  Created by yinquan on 17/4/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BodyTemperatureDetectResultRemarksView.h"


@interface BodyTemperatureDetectResultRemarksView ()
<UITextViewDelegate>
{
    UIImageView* lineImageView; //icon_list_line
    
}

@property (nonatomic, readonly) UILabel* titleLable;

@end

@implementation BodyTemperatureDetectResultRemarksView

@synthesize titleLable = _titleLable;
@synthesize symptomTextView = _symptomTextView;
@synthesize commitButton = _commitButton;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_list_line"]];
        [self addSubview:lineImageView];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.equalTo(self).with.offset(12);
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineImageView);
        make.left.equalTo(lineImageView.mas_right).with.offset(4);
    }];
    
    [self.symptomTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.equalTo(self.titleLable.mas_bottom).with.offset(7);
        make.right.equalTo(self).with.offset(-12.5);
        make.height.mas_equalTo(@94);
        
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 30, 45));
    }];
}


#pragma mark - settingAndGetting

- (UILabel*) titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        [self addSubview:_titleLable];
        [_titleLable setText:@"备注"];
        [_titleLable setFont:[UIFont font_30]];
        [_titleLable setTextColor:[UIColor mainThemeColor]];
    }
    
    return _titleLable;
}

- (PlaceholderTextView*) symptomTextView
{
    if (!_symptomTextView)
    {
        _symptomTextView = [[PlaceholderTextView alloc] init];
        [self addSubview:_symptomTextView];
        [_symptomTextView setTextColor:[UIColor commonTextColor]];
        [_symptomTextView setFont:[UIFont font_28]];
        [_symptomTextView setPlaceholder:@"如果测量时有不适的症状，请输入您的症状。"];
        
        _symptomTextView.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        _symptomTextView.layer.borderWidth = 0.5;
        _symptomTextView.layer.cornerRadius = 2.5;
        _symptomTextView.layer.masksToBounds = YES;
        [_symptomTextView setReturnKeyType:UIReturnKeyDone];
        [_symptomTextView setDelegate:self];
    }
    
    return _symptomTextView;
}

- (UIButton*) commitButton
{
    if (!_commitButton)
    {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_commitButton];
        [_commitButton setBackgroundImage:[UIImage rectImage:CGSizeMake(300, 45) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [_commitButton setTitle:@"保存" forState:UIControlStateNormal];
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitButton.titleLabel setFont:[UIFont boldFont_28]];
        
        _commitButton.layer.cornerRadius = 2;
        _commitButton.layer.masksToBounds = YES;
    }
    
    return _commitButton;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == _symptomTextView && [text isEqualToString:@"\n"])
    {
        [_symptomTextView resignFirstResponder];
        return NO;
    }
    return YES;
}
@end

@interface BodyTemperatureDetectResponsibilityRemarksView ()
{
    UILabel* responsibilityLable;
}
@end

@implementation BodyTemperatureDetectResponsibilityRemarksView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        responsibilityLable = [[UILabel alloc] init];
        [self addSubview:responsibilityLable];
        [responsibilityLable setText:@"任何关于疾病的建议都不能替代执业医师的面对面诊断。请谨慎参阅，本应用不承担由此引起的法律责任。"];
        [responsibilityLable setNumberOfLines:0];
        [responsibilityLable setTextColor:[UIColor commonLightGrayTextColor]];
        [responsibilityLable setFont:[UIFont systemFontOfSize:12]];
        
        
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [responsibilityLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(kScreenWidth - 90);
    }];
}


@end
