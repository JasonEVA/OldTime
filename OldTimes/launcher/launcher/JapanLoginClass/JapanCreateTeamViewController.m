//
//  JapanCreateTeamViewController.m
//  launcher
//
//  Created by williamzhang on 16/4/12.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "JapanCreateTeamViewController.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>
#import "JapanRegisterSectionFooterView.h"
#import "CreateNewCompanyRequest.h"
#import "BaseInputTableViewCell.h"
#import "UnifiedLoginManager.h"
#import "JapanRegisterModule.h"
#import <Masonry/Masonry.h>
#import "CompanyModel.h"
#import "SettingModel.h"
#import "AppDelegate.h"
#import "MyDefine.h"
#import "Category.h"

@interface JapanCreateTeamViewController () <UITableViewDelegate, UITableViewDataSource, BaseRequestDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, assign) BOOL isChangeCompany;

@property (nonatomic, strong) JapanRegisterModule *module;

@end

@implementation JapanCreateTeamViewController

- (instancetype)initWithChangeCompany:(BOOL)isChangeCompany {
    self = [super init];
    if (self) {
        _isChangeCompany = isChangeCompany;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.module.navigationTitle;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.module addObserver:self forKeyPath:@"step" options:NSKeyValueObservingOptionNew context:NULL];
    
    if (!self.isChangeCompany) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)dealloc {
    [self.module removeObserver:self forKeyPath:@"step"];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"step"]) {
        [UIView animateWithDuration:0.5 animations:^{
            self.title = self.module.navigationTitle;
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
    [self postLoading];
    
    CreateNewCompanyRequest *request = [[CreateNewCompanyRequest alloc] initWithDelegate:self];
    [request requestCompanyName:self.module.teamName companyCode:self.module.teamDomain userName:self.module.name];
}

#pragma mark - Button Click
- (void)clickToNext {
    [self.view endEditing:YES];
    
    switch (self.module.step) {
        case 2:
            [self checkStepOne];
            break;
        case 3:
            [self registerAccount];
            break;
        default:
            break;
    }
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([request isKindOfClass:[CreateNewCompanyRequest class]]) {
        CreateNewCompanyResponse *aResponse = (CreateNewCompanyResponse *)response;
        
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
        
        if (self.isChangeCompany) {
            [aDelegate.controllerManager changeStatus];
        }
        
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.module.tableViewRows;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 15; }
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return self.module.step == 2 ? 100 : 15; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.module tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.module.step == 2) {
        JapanRegisterSectionFooterView *view = [[JapanRegisterSectionFooterView alloc] init];
        __weak typeof(self) weakSelf = self;
        [view changeBlock:^(NSUInteger changedIndex, BOOL select) {
           __strong typeof(weakSelf) strongSelf = weakSelf;
            if (changedIndex == 0) {
                strongSelf.module.essentialReason = !select;
                strongSelf.nextButton.enabled = !select;
            }
        }];
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
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [self footerView];
        
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

- (JapanRegisterModule *)module {
    if (!_module) {
        _module = [[JapanRegisterModule alloc] init];
        [_module setStep:2];
        [_module setAccountString:[[UnifiedUserInfoManager share] getAccountWithEncrypt:NO]];
    }
    return _module;
}

@end
