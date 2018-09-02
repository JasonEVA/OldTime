//
//  HealthEducationDetailViewController.m
//  HMDoctor
//
//  Created by yinquan on 17/1/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthEducationDetailViewController.h"
#import "HealthEducationItem.h"
#import "ClientHelper.h"
#import "HealthEducationShareSelectionPatientViewController.h"
#import "HealthyEdcucationJSHelper.h"
#import "HMBottomShotView.h"
#import "HMNewConcernSendViewController.h"

@interface HealthEducationDetailViewController ()
<TaskObserver, UIWebViewDelegate>
{
    NSInteger classId;
    
//    UIBarButtonItem* bbiCollect;    //收藏按钮
    UIButton* collectButton;
    
//    UIBarButtonItem* bbiShare;    //分享按钮
    UIButton* shareButton;
}

@property (nonatomic, readonly) UIWebView* webview;
@property (nonatomic, readonly) BOOL isCollect;
@property (nonatomic, readonly) HealthyEdcucationJSHelper* jsHelper;
@property (nonatomic, strong) HMBottomShotView *shotView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic) BOOL isHideShareBtn;
@end


@implementation HealthEducationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"健康课堂-详情"];
    _jsHelper = [[HealthyEdcucationJSHelper alloc] init];
     [self.jsHelper setController:self];
    if (self.paramObject && [self.paramObject isKindOfClass:[HealthEducationItem class]])
    {
        HealthEducationItem* notesModel = (HealthEducationItem *)self.paramObject;
        //NSNumber* numNotesId = educationModel.notesId;
        self.isHideShareBtn = notesModel.isHideShareBtn;
        classId = notesModel.classId;
    }
    
    //收藏按钮
    collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectButton setImage:[UIImage imageNamed:@"ic_shoucang2"]
                   forState:UIControlStateNormal];
    [collectButton addTarget:self action:@selector(collectBarButtonClicked:)
            forControlEvents:UIControlEventTouchUpInside];
    collectButton.frame = CGRectMake(0, 0, 22, 20);
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:collectButton];
    
     UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_share"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    
    self.navigationItem.rightBarButtonItems = self.isHideShareBtn ? @[menuButton]:@[rightBtn, menuButton];
    
    _webview = [[UIWebView alloc] init];
    [self.view addSubview:self.webview];
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
        
    }];
    
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    NSString* webUrl = [NSString stringWithFormat:@"%@/newc/jkkt/jkktDetail.htm?vType=YS&userId=%ld&classId=%ld", kZJKHealthDataBaseUrl, curUser.userId, classId];
    
    //    [self.webview showWaitView];
    [self.webview setDelegate:self];
    [self.webview.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webview sizeToFit];
    [self.webview scalesPageToFit];
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]]];
    
    
    NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", classId] forKey:@"classId"];
    UserInfo* user = [UserInfoHelper defaultHelper].currentUserInfo;
    [dicPost setValue:[NSString stringWithFormat:@"%ld", user.userId] forKey:@"userId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"CheckUserClassHasCollectTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webview reload];
}

//收藏按钮
- (void) collectBarButtonClicked:(id) sender
{
    if (_isCollect) {
        
        NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:[NSString stringWithFormat:@"%ld", classId] forKey:@"classId"];
        UserInfo* user = [UserInfoHelper defaultHelper].currentUserInfo;
        [dicPost setValue:[NSString stringWithFormat:@"%ld", user.userId] forKey:@"userId"];
        [[TaskManager shareInstance] createTaskWithTaskName:@"cancelCollectTask" taskParam:dicPost TaskObserver:self];
        
    }
    else{
        
        NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:[NSString stringWithFormat:@"%ld", classId] forKey:@"classId"];
        UserInfo* user = [UserInfoHelper defaultHelper].currentUserInfo;
        [dicPost setValue:[NSString stringWithFormat:@"%ld", user.userId] forKey:@"userId"];
        [[TaskManager shareInstance] createTaskWithTaskName:@"addCollectTask" taskParam:dicPost TaskObserver:self];
        
    }
    
}

- (void)hideClick {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.shotView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 170)];
    }];
    [self.maskView removeFromSuperview];
    [self.shotView removeFromSuperview];
}

- (void)rightClick {
    [self.navigationController.view addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];
    [self.navigationController.view addSubview:self.shotView];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.shotView setFrame:CGRectMake(0, ScreenHeight - 170, ScreenWidth, 170)];
    }];
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [webView showWaitView];
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    context[@"h5_js"] = self.jsHelper;
}

#pragma mark - 分享给患者
- (void)shareBbiClicked:(id) sender {
   
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (taskError != StepError_None)
    {
        [self showAlertMessage:errorMessage];
        return;
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
    
    if ([taskname isEqualToString:@"CheckUserClassHasCollectTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dicResult = (NSDictionary *)taskResult;
            NSString *collected = dicResult[@"collected"];
            
            if ([collected isEqualToString:@"Y"]) {
                
                [collectButton setImage:[UIImage imageNamed:@"ic_shoucang2_down"] forState:UIControlStateNormal];
                _isCollect = YES;
            }
            else{
                
                [collectButton setImage:[UIImage imageNamed:@"ic_shoucang2"] forState:UIControlStateNormal];
                _isCollect = NO;
            }
        }
    }
    
    if ([taskname isEqualToString:@"addCollectTask"]) {
        
        [collectButton setImage:[UIImage imageNamed:@"ic_shoucang2_down"] forState:UIControlStateNormal];
        _isCollect = YES;
    }
    
    if ([taskname isEqualToString:@"cancelCollectTask"]) {
        
        [collectButton setImage:[UIImage imageNamed:@"ic_shoucang2"] forState:UIControlStateNormal];
        _isCollect = NO;
    }
    
    if ([taskname isEqualToString:@"HealthyClassroomDetailTask"])
    {
        //课堂详情
        if (taskResult && [taskResult isKindOfClass:[HealthEducationItem class]])
        {
            HealthEducationItem *classInfoModel = (HealthEducationItem*) taskResult;

            UIAlertController *alterSheet = [UIAlertController alertControllerWithTitle:nil message:nil     preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancael = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            __weak typeof(self) weakSelf = self;
            UIAlertAction *actOne = [UIAlertAction actionWithTitle:@"按人发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                HMNewConcernSendViewController *VC = [[HMNewConcernSendViewController alloc
                                                       ] initWithIsSendToGroup:NO];
                [VC configHealthEdition:classInfoModel];
                
                [VC sendConcernSuccess:^{
                    //                self.endTime = -1;
                    //                [self.concernDataList removeAllObjects];
                    //                [self startAcquireConcernListRequest];
                    
                }];
                [strongSelf.navigationController pushViewController:VC animated:YES];
            }];
            UIAlertAction *actTwo = [UIAlertAction actionWithTitle:@"按组发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                HMNewConcernSendViewController *VC = [[HMNewConcernSendViewController alloc
                                                       ] initWithIsSendToGroup:YES];
                [VC configHealthEdition:classInfoModel];
                
                [VC sendConcernSuccess:^{
                    //                self.endTime = -1;
                    //                [self.concernDataList removeAllObjects];
                    //                [self startAcquireConcernListRequest];
                    
                }];
                [strongSelf.navigationController pushViewController:VC animated:YES];
            }];
            [alterSheet addAction:cancael];
            [alterSheet addAction:actOne];
            [alterSheet addAction:actTwo];

            [self presentViewController:alterSheet animated:YES completion:nil];
            

        }
    }

}

- (HMBottomShotView *)shotView {
    if (!_shotView) {
        _shotView = [HMBottomShotView new];
        [_shotView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 170)];
        __weak typeof(self) weakSelf = self;
        [_shotView btnClick:^(NSInteger tag) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [_shotView setBackgroundColor:[UIColor clearColor]];
            
            [strongSelf hideClick];
            switch (tag) {
                case 1:
                {
                    //医患群
                    HealthEducationShareSelectionPatientViewController *VC = [HealthEducationShareSelectionPatientViewController new];
                    
                    VC.classId = classId;
                    [strongSelf.navigationController pushViewController:VC animated:YES];
                    break;
                }
                case 2:
                {
                    // 医生关怀
                    
                    //获取课堂详情
                    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
                    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)classId] forKey:@"classId"];
                    [dicPost setValue:@"N" forKey:@"isShow"];
                    [[TaskManager shareInstance] createTaskWithTaskName:@"HealthyClassroomDetailTask" taskParam:dicPost TaskObserver:strongSelf];
                    break;
                }
                default:
                    break;
            }
            
        }];
    }
    return _shotView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [UIView new];
        [_maskView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
        [_maskView setUserInteractionEnabled:YES];
    }
    return _maskView;
}

@end
