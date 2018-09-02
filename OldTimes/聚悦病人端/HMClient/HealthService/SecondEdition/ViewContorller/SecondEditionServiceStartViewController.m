//
//  SecondEditionServiceStartViewController.m
//  HMClient
//
//  Created by yinquan on 2017/6/6.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "SecondEditionServiceStartViewController.h"
#import "UIBarButtonItem+BackExtension.h"
#import "ClientHelper.h"
#import <CoreLocation/CoreLocation.h>

@interface SecondEditionServiceStartViewController ()
<UIWebViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, readonly) UIWebView* webview;
@property (nonatomic, strong) CLLocationManager* locationManager;

@end

@implementation SecondEditionServiceStartViewController

@synthesize webview = _webview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"服务"];
    
    [self layoutElements];
    
    //TODO:替换back方法
    /*
    UIBarButtonItem* backupBBI = [UIBarButtonItem itemWithImageNamed:@"back.png" targe:self action:@selector(backUp)];
    UIBarButtonItem *spaceBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceBar.width = 15;
    
    UIBarButtonItem* popBBI = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(popUp)];
    [self.navigationItem setLeftBarButtonItems:@[backupBBI, spaceBar, popBBI]];
    */
    
    
    UIBarButtonItem* backupBBI = [UIBarButtonItem itemWithImageNamed:@"back.png" targe:self action:@selector(backUp)];
    [self.navigationItem setLeftBarButtonItem:backupBBI];
    
    [self startLocation];
}

- (void) backUp
{
    if ([self.webview canGoBack])
    {
        [self.webview goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) popUp
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) layoutElements
{
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}



- (void) locationCityLoaded:(NSString*) cityName
{
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    //10.0.0.139
    //http://test.joyjk.com/shop/jkglsc/newc/index.htm
    NSString* urlString = [NSString stringWithFormat:@"%@/app/index.htm?locationCity=%@", kBaseShopUrl, cityName];
    if (curUser && curUser.userId > 0) {
        urlString = [urlString stringByAppendingFormat:@"&userId=%ld", curUser.userId];
    }
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* startUrl = [NSURL URLWithString:urlString];
    [self.webview loadRequest:[NSURLRequest requestWithURL:startUrl]];
    
}

#pragma mark - settingAndGetting
- (UIWebView*) webview
{
    if (!_webview) {
        _webview = [[UIWebView alloc] init];
        [self.view addSubview:_webview];
        
        [_webview setDelegate:self];
        [_webview.scrollView setShowsVerticalScrollIndicator:NO];
        [_webview sizeToFit];
        [_webview scalesPageToFit];
    }
    return _webview;
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@", request.URL.absoluteString);
    NSArray* pathComponents = request.URL.pathComponents;
    if ([[pathComponents lastObject] isEqualToString:@"detail.htm"])
    {
        NSDictionary* queryDictionary = [request.URL dictionaryWithQuery];
        if (queryDictionary)
        {
            NSString* upId = [queryDictionary valueForKey:@"upId"];
            if (upId && [upId isPureInt])
            {
                //跳转到详情界面 SecondEditionServiceDetailViewController
                [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceDetailViewController" ControllerObject:upId];
            }
        }
        
        return NO;
    }
    return YES;
}

#pragma mark Location and Delegate
- (void)startLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        NSLog(@"requestWhenInUseAuthorization");
        [self.locationManager requestWhenInUseAuthorization];
//        [self.locationManager requestAlwaysAuthorization];
    }
    
    
    //开始定位，不断调用其代理方法
    [self.locationManager startUpdatingLocation];
    NSLog(@"start gps");
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);

    
    // 2.停止定位
    [manager stopUpdatingLocation];
    
    __weak typeof(self) weakSelf = self;
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"%@",placemark.name);
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"cityName, %@",city);

            // 市
            NSLog(@"locality,%@",city);
            if (city && city.length > 0) {
                //TODO:
                [weakSelf locationCityLoaded:city];
            }
            
        }else if (error == nil && [placemarks count] == 0) {
//            [weakSelf showAlertMessage:@"获取地址信息失败。"];
            [weakSelf locationCityLoaded:@"重庆市"];
        } else if (error != nil){
//            [weakSelf showAlertMessage:@"获取地址信息失败。"];
            [weakSelf locationCityLoaded:@"重庆市"];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [self locationCityLoaded:@"重庆市"];
    return;
    [self showAlertMessage:@"获取地址信息失败。"];
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        
    }
}

@end
