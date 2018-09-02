//
//  AboutUsViewController.m
//  launcher
//
//  Created by williamzhang on 15/11/13.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "AboutUsViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "WebViewController.h"
#import <NSDate+DateTools.h>
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "MyDefine.h"

static NSString * const latest_version_key = @"launchr_latest_version";

@interface AboutUsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel     *versionLabel;
@property (nonatomic, strong) UILabel     *latestVersionLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel     *copyRightLabel;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCAL(ME_ABOUT_P);
    
#if (!defined(JAPANMODE) && !defined(JAPANTESTMODE) )
    if ([LOCAL(ME_ABOUT_P) isEqualToString:@"关于WorkHub"]) {
        self.title = @"关于Launchr";
    }
#endif
    
    self.view.backgroundColor = [UIColor grayBackground];
    
    [self.view addSubview:self.logoView];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
    }];
    
    [self.view addSubview:self.versionLabel];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.logoView.mas_bottom).offset(20);
    }];
    
    [self.view addSubview:self.latestVersionLabel];
    [self.latestVersionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.versionLabel.mas_bottom).offset(10);
    }];
    [self setLastedVersion];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.latestVersionLabel.mas_bottom).offset(20);
        make.height.equalTo(@90);
    }];
    
    [self.view addSubview:self.copyRightLabel];
    [self.copyRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view);
    }];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    
    [manager GET:@"http://itunes.apple.com/lookup?id=1058784124" parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *resultsArray = [responseObject objectForKey:@"results"];
        if (!resultsArray) {
            return;
        }
        
        NSString *latestVersion = [[resultsArray firstObject] objectForKey:@"version"];
        if (latestVersion) {
            [[NSUserDefaults standardUserDefaults] setObject:latestVersion forKey:latest_version_key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self setLastedVersion];
        }
    } failure:nil];
}

#pragma mark - Private Method
- (NSString *)currentVersion {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
#ifdef JAPANMODE
    return [infoDict objectForKey:@"CFBundleShortVersionString"];
#else
    return [infoDict objectForKey:@"CFBundleVersion"];
#endif
}

- (void)setLastedVersion {
    NSString *latest_version = [[NSUserDefaults standardUserDefaults] objectForKey:latest_version_key];
#ifdef CHINAMODE
    latest_version = [[NSUserDefaults standardUserDefaults] objectForKey:@"build"];
#endif
    
    self.latestVersionLabel.text = [NSString stringWithFormat:@"%@ : %@",LOCAL(ABOUT_LAUNCHR_LATEST_VERSION),(latest_version ?:[self currentVersion])];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01;}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 0.01;}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = (indexPath.row == 0) ? LOCAL(ABOUT_LAUNCHR_PROTOCOL) : LOCAL(ABOUT_LAUNCHR_POLICY);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *url = indexPath.row == 0 ? @"https://www.workhub.jp/terms" : @"https://www.workhub.jp/privacy";
    WebViewController *webVC = [[WebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - Initializer
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    }
    return _tableView;
}

- (UIImageView *)logoView {
    if (!_logoView) {
#if (!defined(JAPANMODE) && !defined(JAPANTESTMODE) )
        _logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoIcon"]];
#else
        _logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoIcon-Japan"]];
#endif
        
    }
    return _logoView;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [UILabel new];
        _versionLabel.textColor = [UIColor grayColor];
        _versionLabel.font = [UIFont systemFontOfSize:13];

        _versionLabel.text = [NSString stringWithFormat:@"%@ : %@",LOCAL(ABOUT_LAUNCHR_VERSION),[self currentVersion]];
    }
    return _versionLabel;
}

- (UILabel *)latestVersionLabel {
    if (!_latestVersionLabel) {
        _latestVersionLabel = [UILabel new];
        _latestVersionLabel.textColor = [UIColor themeBlue];
        _latestVersionLabel.font = [UIFont systemFontOfSize:13];
    }
    return _latestVersionLabel;
}

- (UILabel *)copyRightLabel {
    if (!_copyRightLabel) {
        _copyRightLabel = [UILabel new];
        _copyRightLabel.font = [UIFont systemFontOfSize:12];
        _copyRightLabel.textColor = [UIColor grayColor];
        _copyRightLabel.text = [NSString stringWithFormat:@"Copyright © %ld mintcode,Inc. All rights reserved.", [[NSDate date] year]];
#if (defined(JAPANMODE) || defined(JAPANTESTMODE) )
        _copyRightLabel.text = [NSString stringWithFormat:@"Copyright © %ld WorkHub,Inc. All rights reserved.", [[NSDate date] year]];
#endif
    }
    return _copyRightLabel;
}

@end
