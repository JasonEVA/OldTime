//
//  HealthPlanMentailityPeriodPickerViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/28.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanMentailityPeriodPickerViewController.h"

@interface HealthPlanMentailityPeriodPickerViewController ()
<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray* periodTypes;
}
@property (nonatomic, strong) UIPickerView* pickerView;
@property (nonatomic, strong) UIToolbar* toolBar;

@property (nonatomic, copy) NSString* periodType;
@property (nonatomic, copy) NSString* periodValue;

@property (nonatomic, strong) HealthPlanMentailityPeriodPickHandle pickHandle;

- (id) initWithPeriodType:(NSString*) periodType
              periodValue:(NSString*) periodValue
                   handle:(HealthPlanMentailityPeriodPickHandle) pickHandle;
@end

@implementation HealthPlanMentailityPeriodPickerViewController

+ (void) showWithPeriodType:(NSString*) type
                periodValue:(NSString*) periodValue
                     handle:(HealthPlanMentailityPeriodPickHandle) pickHandle
{
    HealthPlanMentailityPeriodPickerViewController* controller = [[HealthPlanMentailityPeriodPickerViewController alloc] initWithPeriodType:type periodValue:periodValue handle:pickHandle];
    
    
    UIViewController* topMostController = [HMViewControllerManager topMostController];
    [topMostController addChildViewController:controller];
    [topMostController.view addSubview:controller.view];
    [controller.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topMostController.view);
    }];
}

- (id) initWithPeriodType:(NSString*) periodType
              periodValue:(NSString*) periodValue
                   handle:(HealthPlanMentailityPeriodPickHandle) pickHandle
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _periodType = periodType;
        _periodValue = periodValue;
        _pickHandle = pickHandle;
    }
    return self;
}

- (void) loadView
{
    UIControl* closeControl = [[UIControl alloc] init];
    [closeControl setBackgroundColor:[UIColor commonTranslucentColor]];
    [closeControl addTarget:self action:@selector(closeControlClicked:) forControlEvents:UIControlEventAllTouchEvents];
    [self setView:closeControl];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    periodTypes = @[@"日", @"周", @"月"];
    [self layoutElements];
    
    if ([self.periodType mj_isPureInt] && self.periodType.integerValue > 0)
    {
        [self.pickerView selectRow:self.periodValue.integerValue - 1 inComponent:0 animated:NO];
    }
    else
    {
        [self.pickerView selectRow:0 inComponent:0 animated:NO];
    }
    
    
    switch (self.periodType.integerValue) {
        case 3:
        {
            [self.pickerView selectRow:0 inComponent:1 animated:NO];
        }
            break;
        case 2:
        {
            [self.pickerView selectRow:1 inComponent:1 animated:NO];
        }
            break;
        case 1:
        {
            [self.pickerView selectRow:2 inComponent:1 animated:NO];
        }
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) layoutElements
{
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.pickerView.mas_top);
    }];
}

#pragma mark - control click event
- (void) closeControlClicked:(id) sender
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void) confirmButtonClicked:(id) sender
{
    NSInteger valueRow = [self.pickerView selectedRowInComponent:0];
    
    self.periodValue = [NSString stringWithFormat:@"%ld", valueRow + 1];
    
    if (self.pickHandle) {
        self.pickHandle(self.periodValue, self.periodType);
    }
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rows = 0;
    
    switch (component) {
        case 0:
        {
            if (![self.periodType mj_isPureInt])
            {
                return 7;
            }
            switch (self.periodType.integerValue)
            {
                case 2:
                {
                    return 4;
                    break;
                }
                case 3:
                {
                    return 7;
                    break;
                }
                case 1:
                {
                    return 12;
                    break;
                }
            }
            break;
        }
        case 1:
        {
            return periodTypes.count;
        }
    }
    return rows;
}

#pragma mark - UIPickerViewDelegate

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* title = nil;
    switch (component) {
        case 0:
        {
            title = [NSString stringWithFormat:@"%ld", row + 1];
            break;
        }
        case 1:
        {
            title = periodTypes[row];
            break;
        }
    }
    return title;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 1) {
        switch (row) {
            case 0:
            {
                [self setPeriodType:@"3"];
                break;
            }
            case 1:
            {
                [self setPeriodType:@"2"];
                break;
            }
            case 2:
            {
                [self setPeriodType:@"1"];
                break;
            }
        }
    }
    
    [self.pickerView reloadComponent:0];
}

#pragma mark - settingAndGetting
- (UIPickerView*) pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        [self.view addSubview:_pickerView];
        [_pickerView setBackgroundColor:[UIColor whiteColor]];
        [_pickerView setDelegate:self];
        [_pickerView setDataSource:self];
    }
    return _pickerView;
}

- (UIToolbar*) toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] init];
        [self.view addSubview:_toolBar];
        [_toolBar setBackgroundColor:[UIColor whiteColor]];
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem* confirmBBI = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmButtonClicked:)];
        [_toolBar setItems:@[space, confirmBBI]];
    }
    return _toolBar;
}

@end
