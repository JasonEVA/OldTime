//
//  HealthPlanSportsStrengthPickerViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/29.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSportsStrengthPickerViewController.h"

@interface HealthPlanSportsStrengthPickerViewController ()
<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray* strengthSuggests;
}
@property (nonatomic, copy) NSString* exerciseIntensity;

@property (nonatomic, strong) UIPickerView* pickerView;

@property (nonatomic, strong) HealthPlanSportsStrengthPickHandle pickHandle;

@end

@implementation HealthPlanSportsStrengthPickerViewController

+ (void) showWithExerciseIntensity:(NSString*) exerciseIntensity
                pickHandle:(HealthPlanSportsStrengthPickHandle) pickHandle
{
    HealthPlanSportsStrengthPickerViewController* controller = [[HealthPlanSportsStrengthPickerViewController alloc]initWithExerciseIntensity:exerciseIntensity pickHandle:pickHandle];
    
    UIViewController* topMostController = [HMViewControllerManager topMostController];
    [topMostController addChildViewController:controller];
    [topMostController.view addSubview:controller.view];
    [controller.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topMostController.view);
    }];
}

- (id) initWithExerciseIntensity:(NSString*) exerciseIntensity
             pickHandle:(HealthPlanSportsStrengthPickHandle) pickHandle
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self setExerciseIntensity:exerciseIntensity];
        _pickHandle = pickHandle;
        
        strengthSuggests = @[@"轻柔", @"低强", @"稍强"];
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
    
    [self layoutElements];
    
    
    if ([self.exerciseIntensity mj_isPureInt])
    {
        if (self.exerciseIntensity.integerValue > 0 && self.exerciseIntensity.integerValue <= strengthSuggests.count) {
            [self.pickerView selectRow:self.exerciseIntensity.integerValue - 1 inComponent:0 animated:NO];
        }
    }
    else
    {
        [self.pickerView selectRow:0 inComponent:0 animated:NO];
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

#pragma mark - control click event
- (void) closeControlClicked:(id) sender
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (strengthSuggests) {
        return strengthSuggests.count;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return strengthSuggests[row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString* exerciseIntensity = [NSString stringWithFormat:@"%ld", row + 1];
    if (self.pickHandle) {
        self.pickHandle(exerciseIntensity);
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
