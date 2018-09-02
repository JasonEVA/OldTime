//
//  HealthDetectPeriodTypePickerViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthDetectPeriodTypePickerViewController.h"

@interface HealthDetectPeriodTypePickerViewController ()
<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray* periodTypeStrings;
    NSArray* periodTypes;
}
@property (nonatomic, strong) NSString* typeStr;
@property (nonatomic, strong) UIPickerView* pickerView;
@property (nonatomic, strong) PeriodTypePickerBlock pickBlock;


@end

@implementation HealthDetectPeriodTypePickerViewController

+ (void) showWithPeriodTypeStr:(NSString*) typeStr
         PeriodTypePickerBlock:(PeriodTypePickerBlock) pickBlock
{
    HealthDetectPeriodTypePickerViewController* controller = [[HealthDetectPeriodTypePickerViewController alloc] initWithNibName:nil bundle:nil];
    [controller setTypeStr:typeStr];
    [controller setPickBlock:pickBlock];
    
    UIViewController* topMostController = [HMViewControllerManager topMostController];
    [topMostController addChildViewController:controller];
    [topMostController.view addSubview:controller.view];
    [controller.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topMostController.view);
    }];
    
}

- (void) loadView
{
    UIControl* closeControl = [[UIControl alloc] init];
    [closeControl setBackgroundColor:[UIColor commonTranslucentColor]];
    [self setView:closeControl];
    [closeControl addTarget:self action:@selector(closeControlClicked:) forControlEvents:UIControlEventAllTouchEvents];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    periodTypeStrings = @[@"日", @"周", @"月"];
    periodTypes = @[@"2", @"1", @"3"];
    
    [self layoutElements];
    
    [self.pickerView selectRow:[self typeStrIndex] inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) closeControlClicked:(id) sender
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void) layoutElements
{
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (NSInteger) typeStrIndex
{
    switch (self.typeStr.integerValue) {
        case PeriodType_Week:
        {
            return 1;
            break;
        }
        case PeriodType_Day:
        {
            return 0;
            break;
        }
        case PeriodType_Month:
        {
            return 2;
            break;
        }
    }
    return 0;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return periodTypeStrings.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return periodTypeStrings[row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString* typeString = periodTypes[row];
    if (self.pickBlock) {
        self.pickBlock(typeString);
    }
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
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


@end
