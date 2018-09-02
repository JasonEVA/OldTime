//
//  OrderedServiceDetDetailViewController.m
//  HMClient
//
//  Created by yinquan on 16/11/15.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OrderedServiceDetDetailViewController.h"
#import "OrderedServiceModel.h"
#import "OrderedServiceDetContactView.h"
#import "OrderServiceDetView.h"
#import "OrderedServiceDetDescView.h"
#import "HMSessionListInteractor.h"

@interface OrderedServiceDetDetailViewController ()
<TaskObserver>

@property (nonatomic, readonly) NSInteger serviceDetId;
@property (nonatomic, readonly) NSString* serviceDetName;

@property (nonatomic, readonly) UserServiceDet* serviceDet;
@property (nonatomic, readonly) OrderedServiceDetContactView* serviceDetContactView;
@property (nonatomic, readonly) OrderServiceDetView* serviceDetView;
@property (nonatomic, readonly) OrderedServiceDetDescView* serviceDescView;


@property (nonatomic, readonly) UIButton* moreServiceButton;
@end

@implementation OrderedServiceDetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.paramObject && [self.paramObject isKindOfClass:[UserServiceDet class]])
    {
        UserServiceDet* serviceDet = self.paramObject;
        _serviceDetId = serviceDet.serviceDetId;
        _serviceDetName = serviceDet.childProductName;
    }
    [self.navigationItem setTitle:self.serviceDetName];
    
    if (!self.serviceDet) {
        return;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.view showWaitView];
    //ServiceDetDetailTask
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", self.serviceDetId] forKey:@"serviceDetId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceDetDetailTask" taskParam:dicPost TaskObserver:self];
}

- (void) createMoreServiceButton
{
    if (!self.serviceDet) {
        return;
    }
    
    if (self.serviceDet.subClassify == 0) {
        //设备商品
        return;
    }
    
    _moreServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.moreServiceButton];
    [self.moreServiceButton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 40) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
    [self.moreServiceButton setTitle:@"更多增值服务>" forState:UIControlStateNormal];
    [self.moreServiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.moreServiceButton.titleLabel setFont:[UIFont font_26]];
    
    [self.moreServiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(@40);
    }];
    
    [self.moreServiceButton addTarget:self action:@selector(moreServieButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) makeServiceDetView
{
    if (!self.serviceDet) {
        return;
    }
    if (self.serviceDet.subClassify == 0) {
        //设备商品
        return;
    }
    
    Class detViewClass = NSClassFromString(@"OrderServiceDetView");
    if (self.serviceDet.classify == 5) {
        detViewClass = NSClassFromString(@"OrderValueAddedServiceDetView");
    }
    else
    {
        detViewClass = NSClassFromString(@"OrderPackageServiceDetView");
    }
    _serviceDetView = [[detViewClass alloc] init];
    [self.view addSubview:self.serviceDetView];
    
    [self.serviceDetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@56);
    }];
    
    [self.serviceDetView setServiceDet:self.serviceDet];
}


- (void) makeContactView
{
    Class contactViewClass = NSClassFromString(@"OrderedServiceDetContactView");
    CGFloat contactHeihgt = 79;
    
    BOOL hasIMPrivilege = [UserServicePrivilegeHelper userHasPrivilege:ServicePrivile_Conversation];
    
    if (self.serviceDet.subClassify == 0) {
        contactViewClass = NSClassFromString(@"OrderedGoodsDetContactView");
        contactHeihgt = 109;
    }
    else if (hasIMPrivilege && (self.serviceDet.classify == 5 || self.serviceDet.status != 2))
    {
        contactViewClass = NSClassFromString(@"OrderedValueAddedServiceDetContactView");
    }
    else
    {
        contactViewClass = NSClassFromString(@"OrderedPackageServiceDetContactView");
    }
    
    _serviceDetContactView = [[contactViewClass alloc] init];
    [self.view addSubview:self.serviceDetContactView];
    
    MASViewAttribute* contactTop = self.view.mas_top;
    if (self.serviceDetView) {
        contactTop = self.serviceDetView.mas_bottom;
    }
    [self.serviceDetContactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo([NSNumber numberWithFloat:contactHeihgt]);
        make.top.equalTo(contactTop);
    }];
    
    [self.serviceDetContactView.contactButton addTarget:self action:@selector(contactButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.serviceDetContactView.contactAdviserButton addTarget:self action:@selector(contactAdviserButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) makeServiceDescView
{
    _serviceDescView = [[OrderedServiceDetDescView alloc] init];
    [self.view addSubview:self.serviceDescView];
    
    MASViewAttribute* descBottom = self.view.mas_bottom;
    if (self.moreServiceButton) {
        descBottom = self.moreServiceButton.mas_top;
    }
    
    [self.serviceDescView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.serviceDetContactView.mas_bottom);
        make.bottom.equalTo(descBottom);
    }];
    [self.serviceDescView setServiceDetDesc:self.serviceDet.desc];
}

- (void) moreServieButtonClicked:(id) sender
{
    //跳转到服务分类
    [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceStartViewController" ControllerObject:nil];
}

- (void) contactButtonClicked:(id) sender
{
    if (!self.serviceDet) {
        return;
    }
    if (self.serviceDet.subServicePhone && self.serviceDet.subServicePhone.length > 0) {
        NSString *phoneCall =[NSString stringWithFormat:@"tel:%@",self.serviceDet.subServicePhone];
        NSURL *url = [NSURL URLWithString:phoneCall];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    
}

- (void) contactAdviserButtonClicked:(id) sender
{
    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页-问医生"];
    //            if (![self userHasService])
    if (![UserServicePrivilegeHelper userHasPrivilege:ServicePrivile_Conversation])
    {
        [self showAlertMessage:@"您还没有购买服务。"];
        //[self showAlertWithoutServiceMessage];
        return;
    }
    
    //跳转到IM界面
    [[HMSessionListInteractor sharedInstance] goToSessionList];
}

#pragma mark - TaskObserver

- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    if (self.serviceDet) {
        [self createMoreServiceButton];
        [self makeServiceDetView];
        [self makeContactView];
        [self makeServiceDescView];
    }
    
}

- (void) task:(NSString *)taskId Result:(id)taskResult
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
    if ([taskname isEqualToString:@"ServiceDetDetailTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[UserServiceDet class]]) {
            _serviceDet = (UserServiceDet*) taskResult;
        }
    }

}

@end
