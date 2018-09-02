//
//  MainStartAdvertiseListViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MainStartAdvertiseListViewController.h"

@interface MainStartAdvertiseListViewController ()
<TaskObserver>
{
    
}
@end


@interface MainStartWebBourwsViewController ()
<UIWebViewDelegate>

@property (nonatomic, readonly) NSString* webUrl;
@property (nonatomic, readonly) UIWebView* webViwe;

- (id) initWithWebUrl:(NSString*) webUrl;
@end



@implementation MainStartAdvertiseListViewController

- (void)viewDidLoad {
    //[self setViewHeight:112];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString* advertiseCode = [PlantformConfig mainAdvertiseCode];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:advertiseCode forKey:@"code"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"AdvertiseListTask" taskParam:dicPost TaskObserver:self];
    
}

//- (void) viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    NSArray* advertiseUrls = @[@"http://img5.imgtn.bdimg.com/it/u=688219513,2791176826&fm=206&gp=0.jpg",
//                               @"http://pic.58pic.com/58pic/12/59/38/58q58PICFyv.jpg",
//                               @"http://pic37.nipic.com/20131231/6608733_152530893000_2.jpg",
//                               @"http://pic19.nipic.com/20120315/852879_195827001320_2.jpg"];
//    
//    NSMutableArray* advetiseItems = [NSMutableArray array];
//    for (NSInteger index = 0; index < advertiseUrls.count; ++index)
//    {
//        AdvertiseInfo* advertise = [[AdvertiseInfo alloc]init];
//        [advertise setImgUrl:[advertiseUrls objectAtIndex:index]];
//        [advertise setAdvertiseId:0x100 + index];
//        [advetiseItems addObject:advertise];
//    }
//    [self advertiseListLoaded:advetiseItems];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) advertiseInfoSelected:(AdvertiseInfo*) advertise
{
    //服务分类列表
//    [advertise setLinkUrl:@"jyhmclient://healthService/serviceCategory"];
    
    //服务分类列表
//    [advertise setLinkUrl:@"jyhmclient://healthService/serviceDetail?upId=1027"];
    
    //团队详情
//    [advertise setLinkUrl:@"jyhmclient://staffTeam/teamDetail?teamId=426"];
    
    //医生详情 3023593
//    [advertise setLinkUrl:@"jyhmclient://staffTeam/staffDetail?staffId=3023593"];
    //根据URL跳转Web页面
//    [advertise setLinkUrl:@"http://www.juyuejk.com"];
    
    if (advertise.linkUrl && advertise.linkUrl.length > 0)
    {
        //根据URL跳转
        NSURL* urlLink = [NSURL URLWithString:advertise.linkUrl];
        if (urlLink)
        {
            NSString* scheme = [urlLink scheme];
            if (scheme && ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]))
            {
                //跳转到Web页面
                MainStartWebBourwsViewController* webController = [[MainStartWebBourwsViewController alloc] initWithWebUrl:urlLink.absoluteString];
                [self.navigationController pushViewController:webController animated:YES];
                return;
            }
            
            if ([scheme isEqualToString:@"jyhmclient"])
            {
                //根据url跳转App页面
                [HMViewControllerRouterHelper routerControllerWithUrlString:advertise.linkUrl];
                return;
            }
        }
    }
    else
    {
        //缺省跳转到服务分类
        [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceStartViewController" ControllerObject:nil];
    }
    
}

#pragma mark - TaskObserver

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
    if ([taskname isEqualToString:@"AdvertiseListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* items = (NSArray*) taskResult;
            [self advertiseListLoaded:items];
        }
        
    }
}
@end



@implementation MainStartWebBourwsViewController

- (id) initWithWebUrl:(NSString*) webUrl
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _webUrl = webUrl;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    _webViwe = [[UIWebView alloc] init];
    [self.view addSubview:self.webViwe];
    [self.webViwe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.bottom.equalTo(self.view);
    }];
    
    NSURL* url = [NSURL URLWithString:self.webUrl];
    [self.webViwe setDelegate:self];
    
    [self.webViwe.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webViwe sizeToFit];
    [self.webViwe scalesPageToFit];
    
    [self.webViwe loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString* title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (title) {
        [self.navigationItem setTitle:title];
    }
}
@end
