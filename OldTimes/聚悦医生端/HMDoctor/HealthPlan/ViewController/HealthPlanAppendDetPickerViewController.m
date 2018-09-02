//
//  HealthPlanAppendDetPickerViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/31.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanAppendDetPickerViewController.h"

@implementation HealthPlanDetModel

@end

@interface HealthPlanAppendDetPickerViewController ()
<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray* dets;

@property (nonatomic, strong) UIPickerView* pickerView;
@property (nonatomic, strong) HealthPlanAppendDetPickHandle pickHandle;
@property (nonatomic, strong) UIToolbar* confirmBar;

- (id) initWithExistedDets:(NSArray*) existDets pickHandle:(HealthPlanAppendDetPickHandle) handle;
@end

@implementation HealthPlanAppendDetPickerViewController

+ (void) showWithExistedDets:(NSArray*) existDets pickHandle:(HealthPlanAppendDetPickHandle) handle
{
    HealthPlanAppendDetPickerViewController* pickerViewController = [[HealthPlanAppendDetPickerViewController alloc] initWithExistedDets:existDets pickHandle:handle];
    
    UIViewController* topMostViewController = [HMViewControllerManager topMostController];
    [topMostViewController addChildViewController:pickerViewController];
    [topMostViewController.view addSubview:pickerViewController.view];
    [pickerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topMostViewController.view);
    }];

}

- (id) initWithExistedDets:(NSArray*) existDets pickHandle:(HealthPlanAppendDetPickHandle) handle
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _pickHandle = handle;
        
        NSArray* detCodes = @[@"test", @"survey", @"nutrition", @"assessment", @"wards", @"sports", @"mentality", @"live", @"review"];
        NSArray* detNames = @[@"监测计划", @"随访计划", @"营养计划", @"评估计划", @"查房计划", @"运动计划", @"心理计划", @"生活计划", @"复查计划"];
        __block NSMutableArray* allDets = [NSMutableArray array];
        [detCodes enumerateObjectsUsingBlock:^(NSString* code, NSUInteger idx, BOOL * _Nonnull stop) {
            HealthPlanDetModel* detModel = [[HealthPlanDetModel alloc] init];
            detModel.code = code;
            detModel.title = detNames[idx];
            
            __block BOOL isExisted = NO;
            [existDets enumerateObjectsUsingBlock:^(HealthPlanDetModel* model, NSUInteger idx, BOOL * _Nonnull existstop) {
                if ([code isEqualToString:model.code])
                {
                    *existstop = YES;
                    isExisted = YES;
                    return ;
                }
            }];
            if (!isExisted) {
                [allDets addObject:detModel];
            }
            
        }];
        
        _dets = [NSArray arrayWithArray:allDets];
    }
    return self;
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
}

- (void) layoutElements
{
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.confirmBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.pickerView.mas_top);
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
    __block HealthPlanDetModel* model = self.dets[row];
    
    if (self.pickHandle) {
        self.pickHandle(model);
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.dets) {
        return self.dets.count;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    HealthPlanDetModel* model = self.dets[row];
    return model.title;
}

//- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    __block HealthPlanDetModel* model = self.dets[row];
//    
//    if (self.pickHandle) {
//        self.pickHandle(model);
//    }
//    [self.view removeFromSuperview];
//    [self removeFromParentViewController];
//}

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
        
        UIBarButtonItem* confirmBBI = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(confirmButtonClicked:)];
        [_confirmBar setItems:@[space, confirmBBI]];
    }
    return _confirmBar;
}

@end
