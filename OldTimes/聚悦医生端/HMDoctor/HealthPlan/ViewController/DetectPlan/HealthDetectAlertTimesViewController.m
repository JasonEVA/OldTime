//
//  HealthDetectAlertTimesView.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthDetectAlertTimesViewController.h"
#import "HealthDetectAlertTimePickerViewController.h"

@interface HealthDetectPlanAlertTimeButton : UIButton

- (id) initWithHealthDetectPlanAlertModel:(HealthDetectPlanAlertModel*) model;

@end

@implementation HealthDetectPlanAlertTimeButton

- (id) initWithHealthDetectPlanAlertModel:(HealthDetectPlanAlertModel*) model
{
    self = [super init];
    if (self) {
        
        self.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        
        [self setTitle:model.alertTime forState:UIControlStateNormal];
        [self setTitleColor:[UIColor commonTextColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(-6);
            make.centerY.equalTo(self);
        }];
        
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"healthplan_close"]];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
    }
    return self;
}

@end

@interface HealthDetectAppendPlanAlertTime : UIButton

@end

@implementation HealthDetectAppendPlanAlertTime

- (id) init
{
    self = [super init];
    if (self) {
        
        self.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        
        [self setTitle:@"添加" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self setImage:[UIImage imageNamed:@"icon_set_add"] forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect) imageRectForContentRect:(CGRect)contentRect
{
//    CGRectMake(10, (contentRect.size.height - 15)/2, 15, 15);
    return CGRectMake(10, (contentRect.size.height - 15)/2, 15, 15);
}

@end

@interface HealthDetectAlertTimesViewController ()
{
    NSMutableArray* buttons;
}
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIView* buttonsView;
@property (nonatomic, strong) HealthDetectAlertTimesCountBlock countBlock;


@end

@implementation HealthDetectAlertTimesViewController

- (id) initWithAlertTimesModels:(NSArray*) alerts countBlock:(HealthDetectAlertTimesCountBlock) block
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _alertTimeModels = [NSMutableArray arrayWithArray:alerts];
        _countBlock = block;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view showBottomLine];
    
    [self layoutElements];
    
    [self createAlertTimeButtons];
}

- (void) layoutElements
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12.5);
        make.top.equalTo(self.view).offset(15);
    }];
    
    [self.buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.view).offset(-10);
    }];
    
    
}

- (void) createAlertTimeButtons
{
    if (buttons) {
        [buttons enumerateObjectsUsingBlock:^(UIButton* button, NSUInteger idx, BOOL * _Nonnull stop) {
            [button removeFromSuperview];
            
        }];
        [buttons removeAllObjects];
    }
    else
    {
        buttons = [NSMutableArray array];
    }
    
    [self.alertTimeModels enumerateObjectsUsingBlock:^(HealthDetectPlanAlertModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
        HealthDetectPlanAlertTimeButton* button = [[HealthDetectPlanAlertTimeButton alloc] initWithHealthDetectPlanAlertModel:model];
        [self.buttonsView addSubview:button];
        [button addTarget:self action:@selector(alertTimeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttons addObject:button];
    }];
    
    HealthDetectAppendPlanAlertTime* appendButton = [[HealthDetectAppendPlanAlertTime alloc] init];
    [self.buttonsView addSubview:appendButton];
    [buttons addObject:appendButton];
    [appendButton addTarget:self action:@selector(appendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttons enumerateObjectsUsingBlock:^(UIButton* button, NSUInteger idx, BOOL * _Nonnull stop)
    {
        __block CGFloat buttonWidth = (kScreenWidth - 58)/4;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(buttonWidth, 29));
            make.left.equalTo(self.buttonsView).offset(14 + (idx % 4) * 10 + buttonWidth * (idx % 4));
            make.top.equalTo(self.buttonsView).offset((idx / 4) * 40 + 11);
        }];
    }];
}

#pragma mark - Button Clicked Event

- (void) alertTimeButtonClicked:(id) sender
{
    NSInteger index = [buttons indexOfObject:sender];
    if (index == NSNotFound) {
        return;
    }
    if (index >= self.alertTimeModels.count) {
        return;
    }
    
//    if (self.alertTimeModels.count == 1) {
//        [self showAlertMessage:@"不能删除最后一个测量时间。"];
//        return;
//    }
    HealthDetectPlanAlertModel* model = self.alertTimeModels[index];
    [self.alertTimeModels removeObject:model];
    
    [self createAlertTimeButtons];
    
    if (self.countBlock) {
        self.countBlock(self.alertTimeModels.count);
    }
}

- (void) appendButtonClicked:(id) sender
{
    __weak typeof(self) weakSelf = self;
    [HealthDetectAlertTimePickerViewController showWithPickerBlock:^(NSString *pickTime) {
        __strong typeof(self) strongSelf = weakSelf;
        HealthDetectPlanAlertModel* model = [[HealthDetectPlanAlertModel alloc] init];
        model.alertTime = pickTime;
        [strongSelf.alertTimeModels addObject:model];
        [strongSelf createAlertTimeButtons];
        
        if (strongSelf.countBlock) {
            strongSelf.countBlock(strongSelf.alertTimeModels.count);
        }
    }];
    
    
}

#pragma mark - settingAndGetting
- (UILabel*) titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self.view addSubview:_titleLabel];
        
        [_titleLabel setText:@"测量时间"];
        [_titleLabel setTextColor:[UIColor commonTextColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _titleLabel;
}

- (UIView*) buttonsView
{
    if (!_buttonsView) {
        _buttonsView = [[UIView alloc] init];
        [self.view addSubview:_buttonsView];
    }
    return _buttonsView;
}

@end
