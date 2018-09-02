//
//  BodyTemperatureDetectResultInstructView.m
//  HMClient
//
//  Created by yinquan on 17/4/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BodyTemperatureDetectResultInstructView.h"

typedef NS_ENUM(NSUInteger, BodyTemperatureLevel) {
    BodyTemperature_Low_Level,
    BodyTemperature_Normal_Level,
    BodyTemperature_LowFever_Level,     //低烧
    BodyTemperature_FingerFever_Level,  //发烧
    BodyTemperature_HighFever_Level,    //高烧
    BodyTemperature_HotFever_Level,     //超高热
};

@interface NSString (BodyTemperatureLevel)
- (BodyTemperatureLevel) bodyTemperatureLevel;
@end

@implementation NSString (BodyTemperatureLevel)

- (BodyTemperatureLevel) bodyTemperatureLevel
{
    BodyTemperatureLevel level = BodyTemperature_Normal_Level;
    float temperature = self.floatValue;
    
    if (temperature <= 36) {
        level = BodyTemperature_Low_Level;
        return level;
    }
    if (temperature <= 37.2) {
        level = BodyTemperature_Normal_Level;
        return level;
    }
    if (temperature <= 38.0) {
        level = BodyTemperature_LowFever_Level;
        return level;
    }
    if (temperature <= 39.0) {
        level = BodyTemperature_FingerFever_Level;
        return level;
    }
    if (temperature <= 41.0) {
        level = BodyTemperature_HighFever_Level;
        return level;
    }
    
    level = BodyTemperature_HotFever_Level;
    return level;
}

@end

@interface BodyTemperatureDetectResultInstructBar : UIView
{
    
}

@property (nonatomic, readonly) NSMutableArray* colorViews;


@end

@implementation BodyTemperatureDetectResultInstructBar

@synthesize colorViews = _colorViews;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self colorViews];
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    __block MASViewAttribute* colorLeft = self.mas_left;
    __block UIView* perView = nil;
    
    [self.colorViews enumerateObjectsUsingBlock:^(UIView* colorView, NSUInteger idx, BOOL * _Nonnull stop) {
        [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self);
            make.left.equalTo(colorLeft);
            if (perView)
            {
                make.width.equalTo(perView);
            }
            if (colorView == [self.colorViews lastObject])
            {
                make.right.equalTo(self);
            }
        }];
        
        colorLeft = colorView.mas_right;
        perView = colorView;
    }];
}

#pragma mark - settingAndGetting
- (NSMutableArray*) colorViews
{
    if (!_colorViews)
    {
        _colorViews = [NSMutableArray array];
        
        NSArray* colors = @[[UIColor commonBlueColor], [UIColor commonGreenColor],[UIColor commonOrangeColor], [UIColor commonVioletColor], [UIColor commonRedColor], [UIColor colorWithHexString:@"F90E1B"]];
        
        for (UIColor* color in colors)
        {
            UIView* colorView = [[UIView alloc] init];
            [self addSubview:colorView];
            [colorView setBackgroundColor:color];
        
            [_colorViews addObject:colorView];
        }
        
    }
    return _colorViews;
}


@end

@interface BodyTemperatureInstructView : UIView

@property (nonatomic, readonly) UIImageView* instructImageView;
@property (nonatomic, readonly) UILabel* instructLable;

- (void) setTemperature:(NSString*) temperature;

@end

@implementation BodyTemperatureInstructView

@synthesize instructImageView = _instructImageView;
@synthesize instructLable = _instructLable;

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.instructImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.instructLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(21);
    }];
}

- (void) setTemperature:(NSString*) temperature
{
    [self setHidden:NO];
    [self.instructLable setText:temperature];
    
    switch ([temperature bodyTemperatureLevel])
    {
        case BodyTemperature_Low_Level:
        {
            //体温过低
            [self.instructImageView setImage:[UIImage imageNamed:@"ic_weightbmi_blue"]];
        }
            break;
        case BodyTemperature_Normal_Level:
        {
            //正常
            [self.instructImageView setImage:[UIImage imageNamed:@"ic_weightbmi_green"]];
        }
            break;
        case BodyTemperature_LowFever_Level:
        {
            //低烧
            [self.instructImageView setImage:[UIImage imageNamed:@"ic_weightbmi_orange"]];
        }
            break;
        case BodyTemperature_FingerFever_Level:
        {
            //发烧
            [self.instructImageView setImage:[UIImage imageNamed:@"ic_weightbmi_violet"]];
        }
            break;
        case BodyTemperature_HighFever_Level:
        {
            //高烧
            [self.instructImageView setImage:[UIImage imageNamed:@"ic_weightbmi_red"]];
        }
            break;
        case BodyTemperature_HotFever_Level:
        {
            //超高烧
            [self.instructImageView setImage:[UIImage imageNamed:@"ic_weightbmi_red_1"]];
        }
            break;
    }
}
#pragma mark - settingAndGetting

- (UIImageView*) instructImageView
{
    if (!_instructImageView) {
        _instructImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_30"]];
        [self addSubview:_instructImageView];
    }
    return _instructImageView;
}

- (UILabel*) instructLable
{
    if (!_instructLable)
    {
        _instructLable = [[UILabel alloc] init];
        [self.instructImageView addSubview:_instructLable];
        
        [_instructLable setFont:[UIFont boldSystemFontOfSize:17]];
        [_instructLable setTextColor:[UIColor whiteColor]];
    }
    
    return _instructLable;
}


@end

@interface BodyTemperatureDetectResultInstructView ()


@property (nonatomic, readonly) BodyTemperatureDetectResultInstructBar* instructBarView;
@property (nonatomic, readonly) NSMutableArray* temperatureLables;
@property (nonatomic, readonly) BodyTemperatureInstructView* temperatureInstruct;

- (void) setTemperature:(NSString*) temperature;
@end

@implementation BodyTemperatureDetectResultInstructView

@synthesize instructBarView = _instructBarView;
@synthesize temperatureLables = _temperatureLables;
@synthesize temperatureInstruct = _temperatureInstruct;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self instructBarView];
        
        [self showBottomLine];
        [self showTopLine];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.instructBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.right.equalTo(self).with.offset(-12.5);
        make.top.equalTo(self).with.offset(108);
        make.height.mas_equalTo(@19);
    }];
    
    __block NSArray* colorViews = self.instructBarView.colorViews;
    [self.temperatureLables enumerateObjectsUsingBlock:^(UILabel* temperatureLable, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView* colorView = colorViews[idx];
        [temperatureLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(colorView.mas_bottom).with.offset(3);
            make.centerX.equalTo(colorView.mas_right);
        }];
    }];
    
    [self.temperatureInstruct mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.instructBarView.mas_top).with.offset(-3);
        make.size.mas_equalTo(CGSizeMake(60, 70));
    }];
}

- (void) setTemperature:(NSString*) temperature
{
    if (!temperature || temperature.length == 0) {
        return;
    }
    [self.temperatureInstruct setTemperature:temperature];
    
    NSInteger index = [temperature bodyTemperatureLevel];
    UIView* colorView = self.instructBarView.colorViews[index];
    
    [self.temperatureInstruct mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(colorView);
    }];
}


#pragma mark settingAndGetting

- (UIView*) instructBarView
{
    if (!_instructBarView) {
        _instructBarView = [[BodyTemperatureDetectResultInstructBar alloc] init];
        [self addSubview:_instructBarView];
        
    }
    return _instructBarView;
}

- (NSMutableArray*) temperatureLables
{
    if (!_temperatureLables) {
        _temperatureLables = [NSMutableArray array];
        
        NSArray* temperatureTitles = @[@"36.1", @"37.3", @"38.1", @"39.1", @">41"];
        [temperatureTitles enumerateObjectsUsingBlock:^(NSString* title, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel* titleLable = [[UILabel alloc] init];
            [self addSubview:titleLable];
            [titleLable setText:title];
            [titleLable setFont:[UIFont systemFontOfSize:11]];
            [titleLable setTextColor:[UIColor commonGrayTextColor]];
        
            [_temperatureLables addObject:titleLable];
        }];
    }
    
    return _temperatureLables;
}

- (BodyTemperatureInstructView*) temperatureInstruct
{
    if (!_temperatureInstruct)
    {
        _temperatureInstruct = [[BodyTemperatureInstructView alloc] init];
        [self addSubview:_temperatureInstruct];
        [_temperatureInstruct setHidden:YES];
    }
    return _temperatureInstruct;
}

@end
