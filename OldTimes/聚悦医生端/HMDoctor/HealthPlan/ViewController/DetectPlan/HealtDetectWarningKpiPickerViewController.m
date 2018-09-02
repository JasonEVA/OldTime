//
//  HealtDetectWarningKpiPickerViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/22.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealtDetectWarningKpiPickerViewController.h"

@interface HealtDetectWarningKpiPickerViewController ()
<TaskObserver, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) NSString* kpiCode;
@property (nonatomic, strong) NSString* subKpiCode;

@property (nonatomic, strong) NSArray* kpiModels;

@property (nonatomic, strong) UIPickerView* pickerView;
@property (nonatomic, strong) UIToolbar* confirmBar;
@property (nonatomic, strong) HealtDetectWarningKpiPickerHandle pickHandle;

- (id) initWithKpiCode:(NSString*) kpiCode
            subKpiCode:(NSString*) subKpiCode
          subKpiModels:(NSArray*) subKpiModels;
@end

@implementation HealtDetectWarningKpiPickerViewController


+ (void) showWithKpiCode:(NSString*) kpiCode
              subKpiCode:(NSString*) subKpiCode
            subKpiModels:(NSArray*) subKpiModels
                  handle:(HealtDetectWarningKpiPickerHandle)handle
{
    HealtDetectWarningKpiPickerViewController* pickViewController = [[HealtDetectWarningKpiPickerViewController alloc] initWithKpiCode:kpiCode subKpiCode:subKpiCode subKpiModels:subKpiModels ];
    [pickViewController setPickHandle:handle];
    
    UIViewController* topMostViewController = [HMViewControllerManager topMostController];
    [topMostViewController addChildViewController:pickViewController];
    [topMostViewController.view addSubview:pickViewController.view];
    
    [pickViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topMostViewController.view);
    }];
}

- (id) initWithKpiCode:(NSString*) kpiCode
            subKpiCode:(NSString*) subKpiCode
          subKpiModels:(NSArray*) subKpiModels
{
    self = [super init];
    if (self) {
        _kpiCode = kpiCode;
        _subKpiCode = subKpiCode;
        _kpiModels = subKpiModels;
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
    
    
    if (self.kpiModels && self.kpiModels.count)
    {
        __block NSInteger index = 0;
        [self.kpiModels enumerateObjectsUsingBlock:^(HealthDetectWarningSubKpiModel* subKpi, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([subKpi.subKpiCode isEqual:self.subKpiCode])
            {
                index = idx;
                *stop = YES;
                return;
            }
        }];
        [self.pickerView selectRow:index inComponent:0 animated:YES];
    }
}

- (void) layoutElements
{
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.confirmBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pickerView.mas_top);
        make.left.right.equalTo(self.view);
    }];
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

#pragma mark - Control Click Event
- (void) confirmButtonClicked:(id) sender
{
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    HealthDetectWarningSubKpiModel* warningModel = self.kpiModels[row];
    if (self.pickHandle ) {
        self.pickHandle(warningModel);
    }
    
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
    if (self.kpiModels)
    {
        return self.kpiModels.count;
    }
    return 0;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    HealthDetectWarningSubKpiModel* warningModel = self.kpiModels[row];
    return warningModel.subKpiName;
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

- (UIToolbar*) confirmBar
{
    if (!_confirmBar) {
        _confirmBar = [[UIToolbar alloc] init];
        [self.view addSubview:_confirmBar];
        
        [_confirmBar setBackgroundColor:[UIColor whiteColor]];
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem* confirmBBI = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmButtonClicked:)];
        [_confirmBar setItems:@[space, confirmBBI]];
    }
    return _confirmBar;
}
@end
