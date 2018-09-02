//
//  HealthDetectAlertTimePickerViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthDetectAlertTimePickerViewController.h"

@interface HealthDetectAlertTimePickerViewController ()
<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray* hours;
    NSArray* minutes;
    
}
@property (nonatomic, strong) AlertTimePickerBlock pickBlock;
@property (nonatomic, strong) UIPickerView* pickerView;
@property (nonatomic, strong) UIToolbar* toolBar;
@end

@implementation HealthDetectAlertTimePickerViewController

+ (void) showWithPickerBlock:(AlertTimePickerBlock) pickBlock
{
    HealthDetectAlertTimePickerViewController* controller = [[HealthDetectAlertTimePickerViewController alloc] initWithNibName:nil bundle:nil];
    
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
    hours = @[@"00", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23",];
    minutes = @[@"00", @"10", @"20", @"30", @"40", @"50"];
    
    [self layoutElements];
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

- (void) confirmButtonClicked:(id) sender
{
    NSInteger hourIndex = [self.pickerView selectedRowInComponent:0];
    NSInteger minuteIndex = [self.pickerView selectedRowInComponent:1];
    
    NSString* alerttime = [NSString stringWithFormat:@"%@:%@", hours[hourIndex], minutes[minuteIndex]];
    if (self.pickBlock)
    {
        self.pickBlock(alerttime);
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
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

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return hours.count;
            break;
        }
        case 1:
        {
            return minutes.count;
            break;
        }
    }
    return 0;
}



#pragma mark - UIPickerViewDelegate
- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* title = nil;
    
    switch (component) {
        case 0:
        {
            title = hours[row];
            break;
        }
        case 1:
        {
            title = minutes[row];
            break;
        }
        default:
            break;
    }
    return title;
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
