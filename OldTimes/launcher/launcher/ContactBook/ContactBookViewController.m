//
//  ContactBookViewController.m
//  launcher
//
//  Created by kylehe on 15/10/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ContactBookViewController.h"
#import "ContactBookDeptmentViewController.h"
#import "ContactBookDetailViewController.h"
#import "ContactBookGroupViewController.h"
#import "ContactBookNormalTableView.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "RelationViewController.h"

@interface ContactBookViewController () <ContactBookNormalTableViewDelegate,BaseRequestDelegate>

@property (nonatomic, strong) ContactBookNormalTableView *tableView;

@end

@implementation ContactBookViewController

@synthesize tabbar = _tabbar;
- (instancetype)initWithTabbar:(SelectContactTabbarView *)tabbar {
    self = [super init];
    if (self) {
        _tabbar = tabbar;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCAL(HOMETABBAR_CONTACT);
    
    if (self.tabbar) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStylePlain target:self action:@selector(clickToDismiss)];
        [self.navigationItem setLeftBarButtonItem:leftItem];
    }
    
    [self initComponents];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView downloadDataIfNeed];
}

- (void)initComponents {
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Button Click
- (void)clickToDismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Method
- (void)pushViewController:(UIViewController *)viewController {
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - ContactBookNormalTableView Delegate
- (void)contactBookNormalTableViewDidSelectFriend:(ContactBookNormalTableView *)tableView {
    RelationViewController *VC = [[RelationViewController alloc] initWithTabbar:self.tabbar];
    [self pushViewController:VC];
}
- (void)contactBookNormalTableViewDidSelectGroup:(ContactBookNormalTableView *)tableView {
    ContactBookGroupViewController *VC = [[ContactBookGroupViewController alloc] initWithTabbar:self.tabbar];
    [self pushViewController:VC];
}

- (void)contactBookNormalTableView:(ContactBookNormalTableView *)tableView didSelectDepartment:(ContactDepartmentImformationModel *)department {
    ContactBookDeptmentViewController *VC = [[ContactBookDeptmentViewController alloc] initWithCurrentDeptment:department tabbar:self.tabbar];
    [self pushViewController:VC];
}

- (void)contactBookNormalTableView:(ContactBookNormalTableView *)tableView didSelectPerson:(ContactPersonDetailInformationModel *)person {
    if (!self.tabbar) {
        ContactBookDetailViewController *VC = [[ContactBookDetailViewController alloc] initWithUserModel:person];
        [self pushViewController:VC];
        return;
    }
    
    [self.tabbar addOrDeletePerson:person];
}

#pragma mark - Initializer
- (ContactBookNormalTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ContactBookNormalTableView alloc] initWithViewController:self tabbar:self.tabbar];
        _tableView.delegate = self;
    }
    return _tableView;
}

@end
