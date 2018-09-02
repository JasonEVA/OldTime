//
//  JapanCompanySelectViewController.m
//  launcher
//
//  Created by williamzhang on 16/4/12.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "JapanCompanySelectViewController.h"
#import "JapanCreateTeamViewController.h"
#import "UnifiedUserInfoManager.h"
#import <MintcodeIM/MintcodeIM.h>
#import "UnifiedLoginManager.h"
#import "LALoginResultModel.h"
#import "CompanyListRequest.h"
#import <Masonry/Masonry.h>
#import "LALoginRequest.h"
#import "SettingModel.h"
#import "CompanyModel.h"
#import "AppDelegate.h"
#import "Category.h"
#import "MyDefine.h"

@interface JapanCompanySelectViewController () <UITableViewDelegate, UITableViewDataSource ,BaseRequestDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *createTeamButton;

@property (nonatomic, assign) BOOL isChangeCompany;

@property (nonatomic, strong) NSArray *companyArray;
@property (nonatomic, strong) CompanyModel *companyCache;

@end

@implementation JapanCompanySelectViewController

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
    self.view.backgroundColor = [UIColor grayBackground];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (self.isChangeCompany) {
        [self showLeftItemWithSelector:@selector(clickToBack)];
        
        CompanyListRequest *request = [[CompanyListRequest alloc] initWithDelegate:self];
        UnifiedUserInfoManager *userInfo = [UnifiedUserInfoManager share];
        [request getCompanyListWithLoginName:[userInfo getAccountWithEncrypt:NO] password:[userInfo getPasswordWithEncrypt:NO]];
        [self postLoading];
    }
    else {
        AppDelegate *aDelegate = [UIApplication sharedApplication].delegate;
        self.companyArray = aDelegate.controllerManager.companyList;
        aDelegate.controllerManager.companyList = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Button Click
- (void)clickToCreate {
    JapanCreateTeamViewController *VC = [[JapanCreateTeamViewController alloc] initWithChangeCompany:self.isChangeCompany];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)clickToBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return [self.companyArray count]; }
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 15; }
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01; }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        cell.detailTextLabel.textColor = [UIColor mediumFontColor];
    }
    
    CompanyModel *model = [self.companyArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.code;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self postLoading];
    
    UnifiedUserInfoManager *userInfo = [UnifiedUserInfoManager share];
    
    self.companyCache = [self.companyArray objectAtIndex:indexPath.row];
    if (self.isChangeCompany && [self.companyCache.code isEqualToString:userInfo.companyCode]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    userInfo.companyCodeCached = self.companyCache.code;
    
    LALoginRequest *request = [[LALoginRequest alloc] initWithDelegate:self];
    [request loginName:[userInfo getAccountWithEncrypt:NO] password:[userInfo getPasswordWithEncrypt:NO]];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([request isKindOfClass:[CompanyListRequest class]]) {
        self.companyArray = [(id)response companyList];
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
        [userInfo setAuthToken:resultModel.lastLoginToken];
        [userInfo setCompanyCode:resultModel.companyCode];
        [userInfo setCompanyShowID:resultModel.companyShowId];
        [userInfo setCompanyName:self.companyCache.name];
        
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

#pragma mark - Create
- (UIView *)footerView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 80)];
    view.backgroundColor = [UIColor clearColor];
    
    [view addSubview:self.createTeamButton];
    [self.createTeamButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(20, 12, 20, 12));
    }];
    
    return view;
}

#pragma mark - Set
- (void)setCompanyArray:(NSArray *)companyArray {
    _companyArray = companyArray;
    self.title = [NSString stringWithFormat:@"%@(%ld)", LOCAL(ME_TEAM), [companyArray count]];
}

#pragma mark - Initializer
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor grayBackground];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [self footerView];
    }
    return _tableView;
}

- (UIButton *)createTeamButton {
    if (!_createTeamButton) {
        _createTeamButton = [UIButton new];
        [_createTeamButton setTitle:LOCAL(REGISTER_TEAM_CREATE) forState:UIControlStateNormal];
        _createTeamButton.titleLabel.font = [UIFont mtc_font_30];
        
        _createTeamButton.layer.cornerRadius = 5.0;
        _createTeamButton.clipsToBounds = YES;
        
        [_createTeamButton setBackgroundImage:[UIImage mtc_imageColor:[UIColor themeBlue]] forState:UIControlStateNormal];
        
        [_createTeamButton addTarget:self action:@selector(clickToCreate) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createTeamButton;
}

@end

@implementation JapanNaviCompanySelectViewController

- (instancetype)initWithChangeCompany:(BOOL)isChangeCompany {
    JapanCompanySelectViewController *rootVC = [[JapanCompanySelectViewController alloc] initWithChangeCompany:isChangeCompany];
    if (self = [super initWithRootViewController:rootVC]) {
        self.navigationBar.barTintColor = [UIColor themeBlue];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                     NSFontAttributeName:[UIFont systemFontOfSize:18]}];
        self.navigationBar.tintColor = [UIColor whiteColor];
    }
    return self;
}

@end