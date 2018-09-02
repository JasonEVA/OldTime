//
//  CompanySelectViewController.m
//  launcher
//
//  Created by williamzhang on 15/11/5.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "CompanySelectViewController.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "UnifiedUserInfoManager.h"
#import "UnifiedLoginManager.h"
#import "LALoginResultModel.h"
#import "CompanyListRequest.h"
#import <MintcodeIM/MintcodeIM.h>
#import <Masonry/Masonry.h>
#import "LALoginRequest.h"
#import "SettingModel.h"
#import "CompanyModel.h"
#import "AppDelegate.h"
#import "Category.h"

@interface CompanySelectViewController () <BaseRequestDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *footerImageView;

@property (nonatomic, assign) BOOL isChangeCompany;
@property (nonatomic, strong) NSArray *arrayCompany;

@property (nonatomic, strong) CompanyModel *companymodelCached;
@end

@implementation CompanySelectViewController

- (instancetype)initWithChangeCompany:(BOOL)isChangeCompany {
    self = [super init];
    if (self) {
        _isChangeCompany = isChangeCompany;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCAL(ME_TEAM);
    self.view.backgroundColor = [UIColor themeBlue];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor mtc_colorWithHex:0x4db8ff];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage mtc_imageColor:[UIColor mtc_colorWithHex:0x4db8ff]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                    NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    
//    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"userInfo_backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(clickToBack)];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerImageView];
    [self.footerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-10);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.footerImageView.mas_top);
    }];
    
    if (!self.isChangeCompany) {
        AppDelegate *aDelegate = [UIApplication sharedApplication].delegate;
        self.arrayCompany = aDelegate.controllerManager.companyList;
        aDelegate.controllerManager.companyList = nil;
    } else {
        CompanyListRequest *request = [[CompanyListRequest alloc] initWithDelegate:self];
        UnifiedUserInfoManager *userInfo = [UnifiedUserInfoManager share];
        [request getCompanyListWithLoginName:[userInfo getAccountWithEncrypt:NO] password:[userInfo getPasswordWithEncrypt:NO]];
        [self postLoading];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage mtc_imageColor:[UIColor whiteColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

#pragma mark - Button Click
- (void)clickToBack {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayCompany count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifierspecial";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor mtc_colorWithHex:0x4db8ff];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 30, 17, 16, 16)];
        [imgview setImage:[UIImage imageNamed:@"Jump_white"]];
        [cell addSubview:imgview];
        cell.tintColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    }
    
    CompanyModel *model = [self.arrayCompany objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.code;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self postLoading];
    
    UnifiedUserInfoManager *userInfo = [UnifiedUserInfoManager share];
    
    CompanyModel *selectedModel = [self.arrayCompany objectAtIndex:indexPath.row];
    self.companymodelCached = selectedModel;
    if (self.isChangeCompany && [selectedModel.code isEqualToString:userInfo.companyCode]) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    userInfo.companyCodeCached = selectedModel.code;
    
    LALoginRequest *request = [[LALoginRequest alloc] initWithDelegate:self];
    [request loginName:[userInfo getAccountWithEncrypt:NO] password:[userInfo getPasswordWithEncrypt:NO]];
}

#pragma mark - BaseRequest Delegate 
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([request isKindOfClass:[CompanyListRequest class]]) {
        self.arrayCompany = [(id)response companyList];
        [self RecordToDiary:@"获取公司列表成功"];
        [self.tableView reloadData];
        [self hideLoading];
    }
    
    else if ([request isKindOfClass:[LALoginRequest class]])
    {
        [[MessageManager share] logout];
        
        LALoginResultModel *resultModel = [(id)response resultModel];
        UnifiedUserInfoManager *userInfo = [UnifiedUserInfoManager share];
        
        [userInfo setUserShowID:resultModel.userShowId];
        [userInfo setUserName:resultModel.userTrueName];
        [userInfo setLoginName:resultModel.userShowId];
        [userInfo setAuthToken:resultModel.lastLoginToken];
        [userInfo setCompanyCode:resultModel.companyCode];
        [userInfo setCompanyShowID:resultModel.companyShowId];
        [userInfo setCompanyName:self.companymodelCached.name];
        
        // sqlLogin
        SettingModel *settingModel = [[UnifiedLoginManager share] findDataModelWithLoginName:[[UnifiedUserInfoManager share] getAccountWithEncrypt:YES]];
        settingModel.isLogin = @YES;
        [[UnifiedLoginManager share] insertData:settingModel];
        
        AppDelegate *aDelegate = [UIApplication sharedApplication].delegate;
        
        if (self.isChangeCompany) {
            [aDelegate.controllerManager changeStatus];
        } else {
            [aDelegate.controllerManager showHome];
        }
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

#pragma mark - Creater
- (UILabel *)tableHeaderView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
    
    label.backgroundColor = [UIColor themeBlue];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    
    label.text = [[UnifiedUserInfoManager share] getAccountWithEncrypt:NO];
    
    return label;
}

- (void)setArrayCompany:(NSArray *)arrayCompany {
    _arrayCompany = arrayCompany;
    self.title = [NSString stringWithFormat:@"%@(%ld)", LOCAL(ME_TEAM), [arrayCompany count]];
}

#pragma mark - Initializer
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorColor = [UIColor themeBlue];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor themeBlue];
        _tableView.tableHeaderView = [self tableHeaderView];
    }
    return _tableView;
}

- (UIImageView *)footerImageView {
    if (!_footerImageView) {
        _footerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"company_Logo"]];
    }
    return _footerImageView;
}

@end
