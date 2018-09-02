//
//  SEPersonSpaceInventFriendViewController.m
//  HMClient
//
//  Created by yinquan on 2017/7/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "SEPersonSpaceInventFriendViewController.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import "ClientHelper.h"

@interface SEPersonSpaceInventFriendViewController ()
{
    
}

@property (nonatomic, strong) UIView* inventView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* closeButton;
@property (nonatomic, strong) UILabel* explainLabel;

@property (nonatomic, strong) UIView* shareView;
@property (nonatomic, strong) UIButton* inventToSessionButton;
@property (nonatomic, strong) UIButton* inventToTimeLineButton;
@property (nonatomic, strong) UILabel* sessionLabel;
@property (nonatomic, strong) UILabel* timelineLabel;

@property (nonatomic, strong) UILabel* inventLabel;
@end

typedef NS_ENUM(NSUInteger, InventType) {
    InventType_Session,     //微信好友
    InventType_TimeLine,    //朋友圈
    
};

@implementation SEPersonSpaceInventFriendViewController

+ (void) show
{
    
    SEPersonSpaceInventFriendViewController* inventViewController = [[[self class] alloc] init];
//    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIWindow* rootwindow =[UIApplication sharedApplication].keyWindow;
    
    [rootwindow addSubview:inventViewController.view];
    [inventViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootwindow);
    }];
    UIViewController* topmostViewController = [HMViewControllerManager topMostController] ;
    [topmostViewController addChildViewController:inventViewController];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
    [self.closeButton addTarget:self action:@selector(closeController) forControlEvents:UIControlEventTouchUpInside];
    [self.inventToSessionButton addTarget:self action:@selector(inventButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     [self.inventToTimeLineButton addTarget:self action:@selector(inventButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) closeController
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.inventView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(@300);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.inventView);
        make.top.equalTo(self.inventView).with.offset(20);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.inventView).with.offset(15);
    }];
    
    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.inventView);
        make.top.equalTo(self.inventView).with.offset(63);
        make.width.equalTo(self.inventView).with.offset(-30);
    }];
    
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.inventView);
        make.top.equalTo(self.inventView).with.offset(130);
    }];
    
    [self.inventToSessionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(68, 68));
        make.left.top.equalTo(self.shareView);
    }];
    
    [self.inventToTimeLineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(68, 68));
        make.right.top.equalTo(self.shareView);
        make.left.equalTo(self.inventToSessionButton.mas_right).with.offset(60);
    }];
    
    [self.sessionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.inventToSessionButton);
        make.top.equalTo(self.inventToSessionButton.mas_bottom).with.offset(7);
    }];
    
    [self.timelineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.inventToTimeLineButton);
        make.top.equalTo(self.inventToTimeLineButton.mas_bottom).with.offset(7);
    }];
    
    [self.inventLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.inventView);
        make.top.equalTo(self.timelineLabel.mas_bottom).with.offset(20);
    }];
}

- (void) inventButtonClicked:(id) sender
{
    InventType inventype;
    if (sender == self.inventToTimeLineButton) {
        //朋友圈
        inventype = InventType_TimeLine;
    }
    else if (sender == self.inventToSessionButton)
    {
        //微信好友
        inventype = InventType_Session;
    }
    
    [self inventWithType:inventype];
}

- (void) inventWithType:(InventType) inventType
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
//    NSString* imgUrl = @"https://www.juyuejk.com/";
    NSArray* imageArray = @[[UIImage imageNamed:@"icon_h"]];

    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    NSString* desc = [NSString stringWithFormat:@"%@邀请您一起加入聚悦大家庭，让医生团管理您的健康！", curUser.userName];
    
    NSString* urlString = [NSString stringWithFormat:@"%@/zcdl/inviteRegister.htm?inviterId=%ld&inviterName=%@",kBaseShopUrl, curUser.userId, curUser.userName];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [shareParams SSDKSetupShareParamsByText:desc
                                     images:imageArray
                                        url:[NSURL URLWithString:urlString]
                                      title:@"注册邀请函"
                                       type:SSDKContentTypeWebPage];
    
    SSDKPlatformType platformType;
    switch (inventType) {
        case InventType_Session:
        {
            platformType = SSDKPlatformSubTypeWechatSession;
            break;
        }
        case InventType_TimeLine:
        {
            platformType = SSDKPlatformSubTypeWechatTimeline;
            break;
        }
    }
    //进行分享
    [ShareSDK share:platformType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
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
            default:
                break;
        }
        
    }];
    
    [self closeController];

}
#pragma mark - settingAndGetting
- (UIView*) inventView
{
    if (!_inventView)
    {
        _inventView = [[UIView alloc] init];
        [self.view addSubview:_inventView];
        [_inventView setBackgroundColor:[UIColor whiteColor]];
    }
    return _inventView;
}

- (UILabel*) titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self.inventView addSubview:_titleLabel];
        
        [_titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_titleLabel setTextColor:[UIColor commonTextColor]];
        [_titleLabel setText:@"邀请好友"];
    }
    return _titleLabel;
}

- (UIButton*) closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.inventView addSubview:_closeButton];
        [_closeButton setImage:[UIImage imageNamed:@"NewSite_RoundsClose"] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (UILabel*) explainLabel
{
    if (!_explainLabel) {
        _explainLabel = [[UILabel alloc] init];
        [self.inventView addSubview:_explainLabel];
        
        [_explainLabel setFont:[UIFont systemFontOfSize:15]];
        [_explainLabel setTextColor:[UIColor commonDarkGrayTextColor]];
        [_explainLabel setNumberOfLines:0];
        [_explainLabel setText:@"邀请1位好友注册且下载聚悦健康，成功登录，赚取100积分。每日上限500积分。"];
    }
    return _explainLabel;
}

- (UIView*) shareView
{
    if (!_shareView) {
        _shareView = [[UIView alloc] init];
        [self.inventView addSubview:_shareView];
    }
    return _shareView;
}

- (UIButton*) inventToSessionButton
{
    if (!_inventToSessionButton) {
        _inventToSessionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.inventView addSubview:_inventToSessionButton];
        [_inventToSessionButton setImage:[UIImage imageNamed:@"service_share_session"] forState:UIControlStateNormal];
    }
    return _inventToSessionButton;
}

- (UIButton*) inventToTimeLineButton
{
    if (!_inventToTimeLineButton) {
        _inventToTimeLineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.inventView addSubview:_inventToTimeLineButton];
        [_inventToTimeLineButton setImage:[UIImage imageNamed:@"service_share_timeline"] forState:UIControlStateNormal];
    }
    return _inventToTimeLineButton;
}

- (UILabel*) sessionLabel
{
    if (!_sessionLabel) {
        _sessionLabel = [[UILabel alloc] init];
        [self.inventView addSubview:_sessionLabel];
        [_sessionLabel setFont:[UIFont systemFontOfSize:16]];
        [_sessionLabel setText:@"微信好友"];
        [_sessionLabel setTextColor:[UIColor commonTextColor]];
    }
    return _sessionLabel;
}

- (UILabel*) timelineLabel
{
    if (!_timelineLabel) {
        _timelineLabel = [[UILabel alloc] init];
        [self.inventView addSubview:_timelineLabel];
        [_timelineLabel setFont:[UIFont systemFontOfSize:16]];
        [_timelineLabel setText:@"朋友圈"];
        [_timelineLabel setTextColor:[UIColor commonTextColor]];
    }
    return _timelineLabel;
}

- (UILabel*) inventLabel
{
    if (!_inventLabel) {
        _inventLabel = [[UILabel alloc] init];
        [self.inventView addSubview:_inventLabel];
        
        [_inventLabel setFont:[UIFont systemFontOfSize:12]];
        [_inventLabel setTextColor:[UIColor commonGrayTextColor]];
        [_inventLabel setNumberOfLines:0];
        [_inventLabel setTextAlignment:NSTextAlignmentCenter];
        [_inventLabel setText:@"欢迎更多的小伙伴加入聚悦健康\n获取的积分您可通过积分商城兑换相应优质服务"];
    }
    return _inventLabel;
}

@end
