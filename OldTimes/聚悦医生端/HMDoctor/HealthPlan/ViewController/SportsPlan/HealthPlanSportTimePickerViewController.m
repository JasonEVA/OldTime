//
//  HealthPlanSportTimePickerViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/29.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSportTimePickerViewController.h"

@interface HealthPlanSportTimePickerViewController ()
<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray* sportsTimeTitles;
}
@property (nonatomic, copy) NSString* sportTime;
@property (nonatomic, strong) HealthPlanSportTimePickHandle pickHandle;

@property (nonatomic, strong) UIPickerView* pickerView;
@end

@implementation HealthPlanSportTimePickerViewController


+ (void) showWithSportTime:(NSString*) sportTime
                pickHandle:(HealthPlanSportTimePickHandle) pickHandle
{
    HealthPlanSportTimePickerViewController* controller = [[HealthPlanSportTimePickerViewController alloc] initWithSportTime:sportTime pickHandle:pickHandle];
    
    UIViewController* topMostController = [HMViewControllerManager topMostController];
    [topMostController addChildViewController:controller];
    [topMostController.view addSubview:controller.view];
    [controller.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topMostController.view);
    }];
}


- (id) initWithSportTime:(NSString*) sportTime
              pickHandle:(HealthPlanSportTimePickHandle) pickHandle
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self setSportTime:sportTime];
        _pickHandle = pickHandle;
        
        NSMutableArray* titles = [NSMutableArray array];
        for (NSInteger index = 1; index <= 24; ++index) {
            [titles addObject:[NSString stringWithFormat:@"%ld分钟", index * 5]];
        }
        sportsTimeTitles = [NSArray arrayWithArray:titles];
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
    
    NSInteger row = self.sportTime.integerValue / 5 - 1;
    if (row >= 0) {
        [self.pickerView selectRow:row inComponent:0 animated:YES];
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
    if (sportsTimeTitles) {
        return sportsTimeTitles.count;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return sportsTimeTitles[row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString* sportsTime = [NSString stringWithFormat:@"%ld", (row + 1) * 5] ;
    if (self.pickHandle) {
        self.pickHandle(sportsTime);
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
