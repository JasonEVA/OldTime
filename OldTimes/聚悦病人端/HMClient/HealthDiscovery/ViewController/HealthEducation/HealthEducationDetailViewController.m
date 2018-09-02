//
//  HealthEducationDetailViewController.m
//  HMClient
//
//  Created by yinquan on 16/12/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthEducationDetailViewController.h"
#import "IMNewsModel.h"
#import "HMSessionListInteractor.h"
#import "HealthEducationItem.h"
#import "ClientHelper.h"

//#import "HealthyEdcucationJSHelper.h"

#import "WXApi.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>


@interface HealthEducationDetailViewController ()<UIWebViewDelegate,TaskObserver>
{
    HealthEducationItem* classInfoModel;
    NSString* classId;
    UIButton *collectButton;    //收藏按钮
    UIButton *shareButton;
    UIBarButtonItem *collectionBarButton;
    UIBarButtonItem *shareBarButton;
}
//@property (nonatomic, strong) HMBottomShotView *shotView;
@property (nonatomic, readonly) UIWebView* webview;
@property (nonatomic, strong) IMNewsModel *newsModel;
@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, readonly) HMWebViewJSHelper* jsHelper;
@property (nonatomic, assign) BOOL isLoaded;
@end

@implementation HealthEducationDetailViewController

//从推送进入详情
- (instancetype)initWithNotsID:(NSString *)notsID {
    classId = notsID;
    IMNewsModel *model = [IMNewsModel new];
    model.notesID = notsID;
    return [self initWithNewsModel:model];
}

- (instancetype)initWithNewsModel:(IMNewsModel *)model {
    if (self = [super init]) {
        self.newsModel = model;
        classId = model.notesID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"健康课堂-详情"];
    _jsHelper = [[HMWebViewJSHelper alloc] init];
    [self.jsHelper setController:self];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[HealthEducationItem class]])
    {
        HealthEducationItem* notesModel = (HealthEducationItem *)self.paramObject;
        //NSNumber* numNotesId = educationModel.notesId;
//        notesId = [NSString stringWithFormat:@"%ld", notesModel.notesId];
        classId = [NSString stringWithFormat:@"%ld", notesModel.classId];
        
        //获取课堂详情
        NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:classId forKey:@"classId"];
        [dicPost setValue:@"N" forKey:@"isShow"];
        [[TaskManager shareInstance] createTaskWithTaskName:@"HealthyClassroomDetailTask" taskParam:dicPost TaskObserver:self];
        
    }
    
    //问医生按钮
    UIButton* conversationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:conversationButton];
    [conversationButton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 45) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
    [conversationButton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 45) Color:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [conversationButton setTitle:@"问医生" forState:UIControlStateNormal];
    [conversationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [conversationButton.titleLabel setFont:[UIFont font_30]];
    
    [conversationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    BOOL conversationPrivile = [UserServicePrivilegeHelper userHasPrivilege:ServicePrivile_Conversation];
    [conversationButton setEnabled:conversationPrivile];
    
    [conversationButton addTarget:self action:@selector(conversationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //收藏按钮
    collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectButton setImage:[UIImage imageNamed:@"ic_shoucang2"]
                      forState:UIControlStateNormal];
    [collectButton addTarget:self action:@selector(collectBarButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    collectButton.frame = CGRectMake(0, 0, 22, 20);
    
    
    
     //分享按钮
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"ic_share"]
                   forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareBarButtonClicked:)
            forControlEvents:UIControlEventTouchUpInside];
    shareButton.frame = CGRectMake(0, 0, 22, 20);
    
    
//    [self.navigationItem setRightBarButtonItems:@[collectionBarButton, shareBarButton]];
//    self.navigationItem.rightBarButtonItem = menuButton;
    _webview = [[UIWebView alloc] init];
    [self.view addSubview:self.webview];
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(conversationButton.mas_top);
    }];
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    NSString* webUrl = [NSString stringWithFormat:@"%@/newc/jkkt/jkktDetail.htm?vType=YH&userId=%ld&classId=%@", kZJKHealthDataBaseUrl, curUser.userId, classId];
//    [self.webview showWaitView];
    [self.webview setDelegate:self];
    [self.webview.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webview sizeToFit];
    [self.webview scalesPageToFit];

    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]]];
    
    
    NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:classId forKey:@"classId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"CheckUserClassHasCollectTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) conversationButtonClicked:(id) sender
{
    //跳转到会话界面
    [[HMSessionListInteractor sharedInstance] goToSessionList];
}

//收藏按钮
- (void) collectBarButtonClicked:(id) sender
{
    if (_isCollect) {

        NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:classId forKey:@"classId"];
        
        [[TaskManager shareInstance] createTaskWithTaskName:@"cancelCollectTask" taskParam:dicPost TaskObserver:self];
        
    }
    else{
        
        NSMutableDictionary *dicPost = [NSMutableDictionary dictionary];
        [dicPost setValue:classId forKey:@"classId"];
        
        [[TaskManager shareInstance] createTaskWithTaskName:@"addCollectTask" taskParam:dicPost TaskObserver:self];
    
    }

}

//分享按钮
- (void) shareBarButtonClicked:(id) sender
{
    //分享内容
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSArray* imageArray = @[[UIImage imageNamed:@"icon_h"]];
    NSString* webUrl = [NSString stringWithFormat:@"%@/newc/jkkt/jkktDetail.htm?vType=YH&classId=%@&shared=1", kZJKHealthDataBaseUrl, classId];
    
    [shareParams SSDKSetupShareParamsByText:classInfoModel.paper
                                         images:imageArray
                                            url:[NSURL URLWithString:webUrl]
                                        title:classInfoModel.title
                                           type:SSDKContentTypeWebPage];
    
    
    //进行分享
    [ShareSDK showShareActionSheet:nil
                             items:@[@(SSDKPlatformSubTypeWechatSession), @(SSDKPlatformSubTypeWechatTimeline)]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   switch (state)
                   {
                        case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                           message:[NSString stringWithFormat:@"%@",@"分享失败"]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                   }
                   
    }];
    
    
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (taskError != StepError_None)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"CheckUserClassHasCollectTask"])
    {
        collectionBarButton = [[UIBarButtonItem alloc] initWithCustomView:collectButton];
    }
    if ([taskname isEqualToString:@"HealthyClassroomDetailTask"]) {
        shareBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    }
    
    NSMutableArray* bbiList = [NSMutableArray array];
    if (collectionBarButton) {
        [bbiList addObject:collectionBarButton];
    }
    if (shareBarButton) {
        [bbiList addObject:shareBarButton];
    }
    [self.navigationItem setRightBarButtonItems:bbiList];
    
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
            classInfoModel = (HealthEducationItem*) taskResult;
        }
    }
}


#pragma mark - UIWebViewDelegate

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webview reload];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    [webView showWaitView];
    
    
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [webView closeWaitView];
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    context[@"h5_js"] = self.jsHelper;
}


@end
