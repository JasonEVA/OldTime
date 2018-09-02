//
//  IntegralSourceListViewController.m
//  HMClient
//
//  Created by yinquan on 2017/7/17.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "IntegralSourceListViewController.h"
#import "AppDelegate.h"
#import "IntegralSourceModel.h"



@interface IntegralSourceListViewController ()
<TaskObserver, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray* integralSourceModels;
@property (nonatomic, assign) NSInteger selectedSourceId;
@property (nonatomic, strong) IntegralSourceChoose chooseBlock;
@end

@implementation IntegralSourceListViewController

+ (void) showWithIntegralSourceChooseBlock:(IntegralSourceChoose) block selectedSourceId:(NSInteger) selectedSourceId
{
    IntegralSourceListViewController* listViewController = [[IntegralSourceListViewController alloc] initWithNibName:nil bundle:nil];
    [listViewController setSelectedSourceId:selectedSourceId];
    
    [listViewController setChooseBlock:block];
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [app.window addSubview:listViewController.view];
    [listViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app.window);
    }];
    UIViewController* topmostViewController = [HMViewControllerManager topMostController] ;
    [topmostViewController addChildViewController:listViewController];
}

- (void) loadView
{
    UIControl* closeControl = [[UIControl alloc] init];
    [self setView:closeControl];
    [closeControl setBackgroundColor:[UIColor commonTranslucentColor]];
    [closeControl addTarget:self action:@selector(closeController) forControlEvents:UIControlEventAllTouchEvents];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSourceList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadSourceList
{
    //IntegralSourceListTask
    NSMutableDictionary* postDictionary = [NSMutableDictionary dictionary];
    [postDictionary setValue:@1 forKey:@"status"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"IntegralSourceListTask" taskParam:postDictionary TaskObserver:self];
}

- (void) closeController
{
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
    if (self.integralSourceModels) {
        return self.integralSourceModels.count + 1;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)componen
{
    NSString* sourceName = nil;
    if (row == 0)
    {
        sourceName = @"全部";
    }
    else
    {
        IntegralSourceModel* model = self.integralSourceModels[row - 1];
        
        sourceName = model.sourceName;
    }
    return sourceName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger sourceId = 0;
    NSString* sourceName = @"全部";
    if (row > 0) {
        IntegralSourceModel* model = self.integralSourceModels[row - 1];
        sourceId = model.id;
        sourceName = model.sourceName;
    }
    if (self.chooseBlock) {
        self.chooseBlock(sourceId, sourceName);
    }
    
    [self closeController];
}


#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (taskError != StepError_None) {
        [self showAlertMessage:errorMessage clicked:^{
            [self closeController];
        }];
    }
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"IntegralSourceListTask"]) {
        
        UIPickerView* pickerView = [[UIPickerView alloc] init];
        [self.view addSubview:pickerView];
        [pickerView setBackgroundColor:[UIColor whiteColor]];
        
        pickerView.dataSource = self;
        pickerView.delegate = self;
        [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
        }];
        
        [pickerView showTopLine];
        
        __block NSInteger selectIndex = 0;
        if (self.integralSourceModels && self.selectedSourceId > 0) {
            [self.integralSourceModels enumerateObjectsUsingBlock:^(IntegralSourceModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
                if (self.selectedSourceId == model.id) {
                    selectIndex = idx + 1;
                    *stop = YES;
                    return ;
                }
            }];
        }
        
        [pickerView selectRow:selectIndex inComponent:0 animated:NO];
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"IntegralSourceListTask"]) {
        if ([taskResult isKindOfClass:[NSArray class]]) {
            _integralSourceModels = (NSArray*) taskResult;
        }
    }
}

@end
