//
//  JapanRegisterViewController.m
//  launcher
//
//  Created by williamzhang on 16/4/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "JapanRegisterViewController.h"
#import "BaseInputTableViewCell.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>
#import "JapanRegisterSectionFooterView.h"
#import "UnifiedUserInfoManager.h"
#import "JapanRegisterProgress.h"
#import "JapanRegisterRequest.h"
#import "AccountExistRequest.h"
#import "UnifiedLoginManager.h"
#import "JapanRegisterModule.h"
#import <Masonry/Masonry.h>
#import "JapanAlertView.h"
#import "CompanyModel.h"
#import "SettingModel.h"
#import "AppDelegate.h"
#import "Category.h"
#import "MyDefine.h"

@interface JapanRegisterViewController () <BaseRequestDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) JapanRegisterProgress *progress;

@property (nonatomic, strong) JapanRegisterModule *module;

@end

@implementation JapanRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCAL(REGISTER_EMAIL_REGISTER);
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"userInfo_backArrow"] style:UIBarButtonItemStyleDone target:self action:@selector(clickToDismiss)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.module addObserver:self forKeyPath:@"step" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)dealloc {
    [self.module removeObserver:self forKeyPath:@"step"];
}

#pragma mark - Button Click
- (void)clickToNext {
    [self.view endEditing:YES];
    
    switch (self.module.step) {
        case 0:
            [self checkStepOne];
            break;
        case 1:
            [self checkStepTwo];
            break;
        case 2:
            [self checkStepThree];
            break;
        case 3:
            [self registerAccount];
            break;
        default:
            break;
    }
}

- (void)clickToDismiss {
    if (self.module.step == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    [self.module preStep];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"step"]) {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.tableView.tableHeaderView = self.progress;
            [self.progress setProgress:self.module.step];
            self.title = self.module.navigationTitle;
            if (self.module.step == 0) {
                self.tableView.tableHeaderView = nil;
            }
            
            [self.tableView reloadData];
            
            self.nextButton.enabled = YES;
            [self.nextButton setTitle:LOCAL(REGISTER_NEXTSTEP) forState:UIControlStateNormal];
            
            if (self.module.step == 2) {
                self.nextButton.enabled = self.module.essentialReason;
            }
            
            if (self.module.step == 3) {
                [self.nextButton setTitle:LOCAL(LOGINCLASS_APPLYTRIAL) forState:UIControlStateNormal];
            }
        }];
    }
}

#pragma mark - Private Method
- (BOOL)checkStepOne {
    
    if (![self.module checkEmailAccount]) {
        [self postError:LOCAL(REGISTER_EMAIL_ERROR)];
        return NO;
    }
    
    
    [self postLoading];
    NSString *account = self.module.accountString;
    AccountExistRequest *request = [[AccountExistRequest alloc] initWithDelegate:self];
    [request accountIsExist:account];
    return YES;
}

- (BOOL)checkStepTwo {
    NSString *password = self.module.password;
    if ([password length] == 0) {
        [self postError:LOCAL(REGISTER_PASSWORD_ERROR)];
        return NO;
    }
    
    [self.module nextStep];
    return YES;
}

- (BOOL)checkStepThree {
    NSString *teamName   = self.module.teamName;
    NSString *teamDomain = self.module.teamDomain;
    NSString *name       = self.module.name;
    
    if (![teamName length]) {
        [self postError:LOCAL(REGISTER_TEAMNAME_ERROR)];
        return NO;
    }
    
    if (![teamDomain length]) {
        [self postError:LOCAL(REGISTER_TEAMDOMAIN_ERROR)];
        return NO;
    }
    
    if (![name length]) {
        [self postError:LOCAL(REGISTER_NAME_ERROR)];
        return NO;
    }
    
    [self.module nextStep];
    return YES;
}

- (void)registerAccount {
    JapanRegisterRequest *request = [[JapanRegisterRequest alloc] initWithDelegate:self];
    [request registerCompanyCode:self.module.teamDomain companyName:self.module.teamName account:self.module.accountString password:self.module.password userName:self.module.name];
    [self postLoading];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    [self hideLoading];
    
    if ([request isKindOfClass:[AccountExistRequest class]]) {
        BOOL isExist = [(id)response isExist];

        if (isExist) {
            // 显示卡片
            JapanAlertView *alertView = [JapanAlertView alertViewImage:[UIImage imageNamed:@"forgetPwd_email_warning"]
                                                                 title:self.module.accountString
                                                              subTitle:LOCAL(REGISTER_REGISTERED)
                                                         buttonsTitles:@[LOCAL(REGISTER_LOGIN_NOW), LOCAL(REGISTER_EMAIL_CHANGE)]];
            [alertView clickAtIndex:^(NSInteger index) {
                if (index == 1) {
                    return;
                }
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alertView show];
            
            return;
        }
        
        [self.module nextStep];
    }
    
    else if ([request isKindOfClass:[JapanRegisterRequest class]]) {
        JapanRegisterResponse *aResponse = (JapanRegisterResponse *)response;
        
        [[UnifiedUserInfoManager share] saveAccount:self.module.accountString];
        [[UnifiedUserInfoManager share] setUserShowID:aResponse.userShowId];
        [[UnifiedUserInfoManager share] setUserName:aResponse.userTrueName];
        [[UnifiedUserInfoManager share] setAuthToken:aResponse.token];
        
        [[UnifiedUserInfoManager share] setCompanyCode:aResponse.companyCode];
        [[UnifiedUserInfoManager share] setCompanyShowID:aResponse.companyShowId];
        [[UnifiedUserInfoManager share] setCompanyName:aResponse.companyName];
        

        // sqlLogin
        SettingModel *settingModel = [[UnifiedLoginManager share] findDataModelWithLoginName:[[UnifiedUserInfoManager share] getAccountWithEncrypt:YES]];
        AppDelegate *aDelegate = [UIApplication sharedApplication].delegate;
        
        CompanyModel *company = [[CompanyModel alloc] init];
        company.showId = aResponse.companyShowId;
        company.code   = aResponse.companyCode;
        company.name   = aResponse.companyName;
        
        aDelegate.controllerManager.companyList = @[company];
        
        if (settingModel && [settingModel.graphicPassword length]) {
            settingModel.isLogin = @YES;
            [[UnifiedLoginManager share] insertData:settingModel];
            
            [aDelegate.controllerManager showHome];
        }
        else {
            [aDelegate.controllerManager showGraphicSetting];
        }
 
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return self.module.tableViewRows; }
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 15; }
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return (self.module.step == 2 ? 120
 : 15); }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.module tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.module.step == 2) {
        JapanRegisterSectionFooterView *view = [[JapanRegisterSectionFooterView alloc] init];
        
        __weak typeof(self) weakSelf = self;
        [view changeBlock:^(NSUInteger changedIndex, BOOL select) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (changedIndex == 0 ) {
                strongSelf.module.essentialReason = !select;
                strongSelf.nextButton.enabled = !select;
            }
        }];
        return view;
    }
    
    return nil;
}

#pragma mark - Create
- (UIView *)footerView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IOS_SCREEN_WIDTH,  70)];
    
    [footerView addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footerView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    return footerView;
}

#pragma mark - Initializer

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate  = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [self footerView];;
        
        [_tableView registerClass:[BaseInputTableViewCell class] forCellReuseIdentifier:[BaseInputTableViewCell identifier]];
    }
    return _tableView;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton new];
        [_nextButton setTitle:LOCAL(REGISTER_NEXTSTEP) forState:UIControlStateNormal];
        [_nextButton setBackgroundImage:[UIImage mtc_imageColor:[UIColor themeBlue]] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(clickToNext) forControlEvents:UIControlEventTouchUpInside];
        
        _nextButton.layer.cornerRadius = 5.0;
        _nextButton.clipsToBounds = YES;
    }
    return _nextButton;
}

- (JapanRegisterProgress *)progress {
    if (!_progress) {
        _progress = [[JapanRegisterProgress alloc] initWithTotalProgress:4];
        [_progress setProgress:1];
    }
    return _progress;
}

- (JapanRegisterModule *)module {
    if (!_module) {
        _module = [[JapanRegisterModule alloc] init];
    }
    return _module;
}

@end

@implementation JapanNaviRegisterViewController

- (instancetype)init {
    JapanRegisterViewController *rootVC = [[JapanRegisterViewController alloc] init];
    if (self = [super initWithRootViewController:rootVC]) {
        self.navigationBar.barTintColor = [UIColor themeBlue];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                     NSFontAttributeName:[UIFont systemFontOfSize:18]}];
        self.navigationBar.tintColor = [UIColor whiteColor];
    }
    return self;
}

@end