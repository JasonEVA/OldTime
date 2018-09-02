//
//  HealthDetectWarningRelationPickerViewController.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/23.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthDetectWarningRelationPickerViewController.h"

@interface HealthDetectWarningRelationPickerViewController ()
<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray* relations;
    NSArray* relationStrings;
}
@property (nonatomic, strong) UIPickerView* pickerView;
@property (nonatomic, strong) HealthDetectWarningRelationPickHandle pickHandle;

- (id) initWithHandle:(HealthDetectWarningRelationPickHandle) handle;
@end


@implementation HealthDetectWarningRelationPickerViewController

+ (void) showWithHandle:(HealthDetectWarningRelationPickHandle) handle
{
    HealthDetectWarningRelationPickerViewController* pickViewController = [[HealthDetectWarningRelationPickerViewController alloc] initWithHandle:handle];
    
    UIViewController* topMostViewController = [HMViewControllerManager topMostController];
    [topMostViewController addChildViewController:pickViewController];
    [topMostViewController.view addSubview:pickViewController.view];
    
    [pickViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topMostViewController.view);
    }];
}

- (id) initWithHandle:(HealthDetectWarningRelationPickHandle) handle
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _pickHandle = handle;
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
    relations = @[@"&&", @"||"];
    relationStrings = @[@"与", @"或"];
    
    [self layoutElements];
}

- (void) layoutElements
{
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
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

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (relationStrings) {
        return relationStrings.count;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return relationStrings[row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickHandle) {
        self.pickHandle(relations[row]);
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
