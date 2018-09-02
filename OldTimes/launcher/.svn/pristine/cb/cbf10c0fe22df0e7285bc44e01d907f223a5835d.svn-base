//
//  SelectContactBookContainerViewController.m
//  launcher
//
//  Created by williamzhang on 15/11/16.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "SelectContactBookContainerViewController.h"
#import "ContactBookDeptmentViewController.h"
#import "ContactBookTableView.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"

@interface SelectContactBookContainerViewController ()

@property (nonatomic, strong) ContactBookTableView *tableView;

@end

@implementation SelectContactBookContainerViewController

@synthesize tabbar = _tabbar;

- (instancetype)initWithSelectedPeople:(NSArray *)selectedPeople unableSelectPeople:(NSArray *)unableSelectPeople tabbar:(SelectContactTabbarView *)tabbar {
    self = [super initWithSelectedPeople:selectedPeople unableSelectPeople:unableSelectPeople];
    if (self) {
        _tabbar = tabbar;
        [_tabbar addObserver:self forKeyPath:@"arraycount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:LOCAL(CONTACT_ADD)];
    [self showLeftItemWithSelector:@selector(clickToBack)];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    if (self.tableView.mixModelArr.count == 0) {
        [self.tableView startGetCompanyDeptRequest];
        [self postLoading];
    }

    __weak typeof(self) weakSelf = self;
    [self.tableView selectDeptment:^(ContactDepartmentImformationModel *selectedModel, NSArray *allDeptmentArray) {
        // 选择部门
        __strong typeof(weakSelf) strongSelf = weakSelf;
        ContactBookDeptmentViewController *VC = [[ContactBookDeptmentViewController alloc] initWithCurrentDeptment:selectedModel tabbar:strongSelf.tabbar];
        
        [VC reloadData:^{
            [strongSelf.tableView reloadData];
        }];
        
        [strongSelf.navigationController pushViewController:VC animated:YES];
    }];
}


- (void)dealloc
{
    [_tabbar removeObserver:self forKeyPath:@"arraycount"];
}



#pragma mark - Private Method
- (void)clickToBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //   [self.searchTableView reloadData];
    [self.searchVC.searchResultsTableView reloadData];
}


#pragma mark - Initializer
- (ContactBookTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ContactBookTableView alloc] initWithSuperViewController:self tabbar:self.tabbar];
    }
    return _tableView;
}

@end
