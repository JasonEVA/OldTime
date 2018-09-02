//
//  HealthDetectWaringTypePickerViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/22.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthDetectWaringTypePickerViewController.h"

@interface HealthDetectWaringTypePickerViewController ()
<UIPickerViewDelegate, UIPickerViewDataSource>
{
    
}
@property (nonatomic, assign) HealthDetectWarningType defaultType;
@property (nonatomic, strong) HealthDetectWaringTypePick pickBlock;
@property (nonatomic, strong) UIPickerView* pickerView;
@end

@implementation HealthDetectWaringTypePickerViewController

+ (void) showWithDefaultWarningType:(HealthDetectWarningType) defaultType
                          PickBlock:(HealthDetectWaringTypePick) pickBlock
{
    HealthDetectWaringTypePickerViewController* pickerViewController = [[HealthDetectWaringTypePickerViewController alloc] init];
    [pickerViewController setPickBlock:pickBlock];
    [pickerViewController setDefaultType:defaultType];
    
    UIViewController* topMostViewController = [HMViewControllerManager topMostController];
    [topMostViewController addChildViewController:pickerViewController];
    [topMostViewController.view addSubview:pickerViewController.view];
    [pickerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topMostViewController.view);
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
    [self layoutElements];
    if (self.defaultType > 0) {
        [self.pickerView selectRow:self.defaultType - 1 inComponent:0 animated:NO];
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
}

- (void) closeControlClicked:(id) sender
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

#pragma mark - UIPickerViewDelegate
- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* title = @"自定义";
    switch (row + 1) {
        case WarningType_Custom:
        {
            title = @"自定义";
            break;
        }
        case WarningType_High:
        {
            title = @"高值预警";
            break;
        }
        case WarningType_Low:
        {
            title = @"低值预警";
            break;
        }
    }
    return title;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickBlock && self.defaultType != (row + 1)) {
        self.pickBlock(row + 1);
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
        [_pickerView setDataSource:self];
        [_pickerView setDelegate:self];
    }
    return _pickerView;
}

@end
