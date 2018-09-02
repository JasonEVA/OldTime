//
//  HealthDetectWarningValueView.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/22.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthDetectWarningValueView.h"
#import "HealthDetectWarningRelationPickerViewController.h"

@implementation HealthDetectWarningValueModel

@end

@interface HealthDetectWarningKpiControl : UIControl

@property (nonatomic, strong) UILabel* kpiNameLabel;
@property (nonatomic, strong) UIImageView* arrowImageView;

- (void) setKpiName:(NSString*) kpiName;
@end

@implementation HealthDetectWarningKpiControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        
        [self layoutElements];
    }
    return self;
}

- (void) layoutElements
{
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.right.equalTo(self).offset(-12.5);
    }];
    
    [self.kpiNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self.arrowImageView.mas_left).offset(-15);
    }];
}

- (void) setKpiName:(NSString*) kpiName
{
    [self.kpiNameLabel setText:kpiName];
}

#pragma mark - settingAndGetting
- (UILabel*) kpiNameLabel
{
    if (!_kpiNameLabel) {
        _kpiNameLabel = [[UILabel alloc] init];
        [self addSubview:_kpiNameLabel];
        [_kpiNameLabel setTextColor:[UIColor commonTextColor]];
        [_kpiNameLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _kpiNameLabel;
}

- (UIImageView*) arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_down_list_arrow"]];
        [self addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

@end

@interface HealthDetectBloodPressureWarningKpiControl : HealthDetectWarningKpiControl

@end

@implementation HealthDetectBloodPressureWarningKpiControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        
        
        [self layoutElements];
    }
    return self;
}

- (void) layoutElements
{
    [self.kpiNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
}


@end

@implementation HealthDetectWarningValueView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self layoutElements];
        [self showBottomLine];
    }
    return self;
}

- (void) layoutElements
{
    [self.kipControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@30);
        make.center.equalTo(self);
    }];
    
    [self.oneBeginSymbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.kipControl.mas_left).offset(-10);
    }];
    
    [self.oneBeginValueTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.right.equalTo(self.oneBeginSymbolLabel.mas_left).offset(-10);
    }];
    
    [self.oneEndSymbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.kipControl.mas_right).offset(10);
    }];
    
    [self.oneEndValueTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.left.equalTo(self.oneEndSymbolLabel.mas_right).offset(10);
    }];
}

- (void) setHealthDetectWarningValueModel:(HealthDetectWarningValueModel*) model
{
    HealthDetectWarningKpiControl* kpiControl = (HealthDetectWarningKpiControl*)self.kipControl;
    [kpiControl setKpiName:model.oneKpiName];
    [self.oneBeginValueTextField setText:model.oneBeginValue];
    [self.oneEndValueTextField setText:model.oneEndValue];
    
}

- (void) setSubKpiModel:(HealthDetectWarningSubKpiModel*) model
{
    HealthDetectWarningKpiControl* kpiControl = (HealthDetectWarningKpiControl*)self.kipControl;
    [kpiControl setKpiName:model.subKpiName];
}

#pragma mark - settingAndGetting
- (UITextField*) oneBeginValueTextField
{
    if (!_oneBeginValueTextField) {
        _oneBeginValueTextField = [[UITextField alloc] init];
        [self addSubview:_oneBeginValueTextField];
        
        [_oneBeginValueTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [_oneBeginValueTextField setTextColor:[UIColor commonTextColor]];
        [_oneBeginValueTextField setFont:[UIFont systemFontOfSize:15]];
        [_oneBeginValueTextField setTextAlignment:NSTextAlignmentCenter];
        [_oneBeginValueTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    }
    return _oneBeginValueTextField;
}

- (UILabel*) oneBeginSymbolLabel
{
    if (!_oneBeginSymbolLabel) {
        _oneBeginSymbolLabel = [[UILabel alloc] init];
        [self addSubview:_oneBeginSymbolLabel];
        [_oneBeginSymbolLabel setText:@"<"];
        [_oneBeginSymbolLabel setTextAlignment:NSTextAlignmentCenter];
        [_oneBeginSymbolLabel setTextColor:[UIColor commonTextColor]];
    }
    return _oneBeginSymbolLabel;
}

- (UITextField*) oneEndValueTextField
{
    if (!_oneEndValueTextField) {
        _oneEndValueTextField = [[UITextField alloc] init];
        [self addSubview:_oneEndValueTextField];
        
        [_oneEndValueTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [_oneEndValueTextField setTextColor:[UIColor commonTextColor]];
        [_oneEndValueTextField setFont:[UIFont systemFontOfSize:15]];
        [_oneEndValueTextField setTextAlignment:NSTextAlignmentCenter];
        [_oneEndValueTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    }
    return _oneEndValueTextField;
}

- (UILabel*) oneEndSymbolLabel
{
    if (!_oneEndSymbolLabel) {
        _oneEndSymbolLabel = [[UILabel alloc] init];
        [self addSubview:_oneEndSymbolLabel];
        [_oneEndSymbolLabel setText:@"<"];
        [_oneEndSymbolLabel setTextAlignment:NSTextAlignmentCenter];
        [_oneEndSymbolLabel setTextColor:[UIColor commonTextColor]];
    }
    return _oneEndSymbolLabel;
}

- (UIControl*) kipControl
{
    if (!_kipControl) {
        _kipControl = [[HealthDetectWarningKpiControl alloc] init];
        [self addSubview:_kipControl];
    }
    return _kipControl;
}
@end

@implementation HealthDetectWarningHighValueView

- (void) layoutElements
{
    [self.oneEndSymbolLabel setText:@">"];
    
    [self.oneEndSymbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.kipControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@30);
        make.centerY.equalTo(self);
        make.right.equalTo(self.oneEndSymbolLabel.mas_left).offset(-10);
    }];
    
    [self.oneEndValueTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(74, 30));
        make.centerY.equalTo(self);
        make.left.equalTo(self.oneEndSymbolLabel.mas_right).offset(10);
    }];
}



@end

@implementation HealthDetectWarningLowValueView

- (void) layoutElements
{
    [self.oneEndSymbolLabel setText:@"<"];
    
    [self.oneEndSymbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.kipControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@30);
        make.centerY.equalTo(self);
        make.right.equalTo(self.oneEndSymbolLabel.mas_left).offset(-10);
    }];
    
    [self.oneEndValueTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(74, 30));
        make.centerY.equalTo(self);
        make.left.equalTo(self.oneEndSymbolLabel.mas_right).offset(10);
    }];
}

@end

@implementation HealthDetectBloodPressureWarningValueView

- (UIControl*) kipControl
{
    if (!_kipControl) {
        _kipControl = [[HealthDetectBloodPressureWarningKpiControl alloc] init];
        [self addSubview:_kipControl];
        [_kipControl setEnabled:NO];
    }
    return _kipControl;
}

@end

@implementation HealthDetectBloodPressureWarningHighValueView

- (UIControl*) kipControl
{
    if (!_kipControl) {
        _kipControl = [[HealthDetectBloodPressureWarningKpiControl alloc] init];
        [self addSubview:_kipControl];
        [_kipControl setEnabled:NO];
    }
    return _kipControl;
}

@end

@implementation HealthDetectBloodPressureWarningLowValueView

- (UIControl*) kipControl
{
    if (!_kipControl) {
        _kipControl = [[HealthDetectBloodPressureWarningKpiControl alloc] init];
        [self addSubview:_kipControl];
        [_kipControl setEnabled:NO];
    }
    return _kipControl;
}

@end

@interface HealthDetectWarningRelationControl ()
@property (nonatomic, strong) UILabel* relationLabel;
@property (nonatomic, strong) UIImageView* arrowImageView;
@end

@implementation HealthDetectWarningRelationControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        
        [self layoutElements];
    }
    return self;
}

- (void) layoutElements
{
    [self.relationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.right.equalTo(self).offset(-12.5);
    }];
}

- (void) setRelationString:(NSString*) relationString
{
    [self.relationLabel setText:relationString];
}

#pragma mark - settingAndGetting
- (UILabel*) relationLabel
{
    if (!_relationLabel) {
        _relationLabel = [[UILabel alloc] init];
        [self addSubview:_relationLabel];
        [_relationLabel setTextColor:[UIColor commonTextColor]];
        [_relationLabel setFont:[UIFont systemFontOfSize:15]];
        
        [_relationLabel setText:@"或"];
    }
    return _relationLabel;
}

- (UIImageView*) arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_down_list_arrow"]];
        [self addSubview:_arrowImageView];
    }
    return _arrowImageView;
}



@end

@interface HealthDetectWarningRelationView ()



@end

@implementation HealthDetectWarningRelationView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self showBottomLine];
        [self layoutElements];
    }
    return self;
}

- (void) layoutElements
{
    [self.relationControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.center.equalTo(self);
    }];
}

- (NSString*) relationString
{
    NSString* relationString = nil;
    if ([self.relation isEqualToString:@"||"])
    {
        relationString = @"或";
    }
    else
    {
        relationString = @"且";
    }
    return relationString;
}

- (void) relationControlClicked:(id) sender
{
    [HealthDetectWarningRelationPickerViewController showWithHandle:^(NSString *relation) {
        [self setRelation:relation];
    }];
}

#pragma mark - settingAndGetting
- (HealthDetectWarningRelationControl*) relationControl
{
    if (!_relationControl) {
        _relationControl = [[HealthDetectWarningRelationControl alloc] init];
        [self addSubview:_relationControl];
        [_relationControl addTarget:self action:@selector(relationControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _relationControl;
}

- (void) setRelation:(NSString *)relation
{
    _relation = [relation copy];
    [self.relationControl setRelationString:[self relationString]];
}
@end
