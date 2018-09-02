//
//  HMPatientTabMainViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2016/12/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMPatientTabMainViewController.h"
#import "CoordinationSearchResultViewController.h"
#import "PatientStartViewController.h"
#import "NewPatientListViewController.h"

@interface HMPatientTabMainViewController ()<UISearchBarDelegate>
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) PatientStartViewController *chatListVC;
@property (nonatomic, strong) NewPatientListViewController *patientListVC;
@property (nonatomic, strong) UIBarButtonItem *rightBtn;
@property (nonatomic, strong) UIBarButtonItem *searchBtn;
@end

@implementation HMPatientTabMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.segment setFrame:CGRectMake(0, 0, 120, 30)];
    [self.navigationItem setTitleView:self.segment];
    
//    UISearchBar *searchBar = [UISearchBar new];
//    searchBar.placeholder = @"搜索";
//    [searchBar setDelegate:self];
//    [searchBar sizeToFit];
//    [searchBar setBackgroundImage:[UIImage imageColor:[UIColor colorWithHexString:@"f0f0f0"] size:CGSizeMake(1, 1) cornerRadius:0]];
//    [self.view addSubview:searchBar];
//    
//    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.view);
//        make.height.equalTo(@44);
//    }];
//    
    [self.view addSubview:self.chatListVC.view];
    [self.chatListVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-48);
        make.top.equalTo(self.view);
    }];
    [self addChildViewController:self.chatListVC];
    [self.chatListVC didMoveToParentViewController:self];
    
    
    [self.view addSubview:self.patientListVC.view];
    [self addChildViewController:self.patientListVC];
    [self.patientListVC didMoveToParentViewController:self];
    
    [self.patientListVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-48);
    }];
    [self.patientListVC.view setHidden:YES];
    
    self.rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshPatientList)];
    self.searchBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchClick)];
    [self.navigationItem setRightBarButtonItems:@[self.searchBtn]];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentClick:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == self.selectedIndex) {
        return;
    }
    [self.navigationItem setRightBarButtonItems:!self.selectedIndex ? @[self.searchBtn,self.rightBtn] : @[self.searchBtn]];
    self.selectedIndex = sender.selectedSegmentIndex;
    [self.patientListVC.view setHidden:!self.selectedIndex];
    [self.chatListVC.view setHidden:self.selectedIndex];
}
- (void)searchClick {
    CoordinationSearchResultViewController *resultVC = [CoordinationSearchResultViewController new];
    [resultVC setSearchType:searchType_searchPatientChatAndPatients];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:resultVC];
    [self presentViewController:nav animated:YES completion:nil];
    [self.view endEditing:YES];
}
- (void)refreshPatientList {
    [self.patientListVC requestPatientsListImmediately:YES];
}
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    CoordinationSearchResultViewController *resultVC = [CoordinationSearchResultViewController new];
    [resultVC setSearchType:searchType_searchPatientChatAndPatients];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:resultVC];
    [self presentViewController:nav animated:YES completion:nil];
    [self.view endEditing:YES];
    return YES;
}

- (UISegmentedControl *)segment {
    if (!_segment) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"消息",@"用户"]];
        [_segment setTintColor:[UIColor whiteColor]];
        [_segment setBackgroundColor:[UIColor mainThemeColor]];
        [_segment.layer setCornerRadius:3];
        [_segment.layer setBorderColor:[UIColor whiteColor].CGColor];
        [_segment.layer setBorderWidth:0.5];
        [_segment setClipsToBounds:YES];
        self.selectedIndex = 0;
        [_segment setSelectedSegmentIndex:self.selectedIndex];
        [_segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName,nil];
        [_segment setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    }
    return _segment;
}

- (PatientStartViewController *)chatListVC {
    if (!_chatListVC) {
        _chatListVC = [PatientStartViewController new];
    }
    return _chatListVC;
}

- (NewPatientListViewController *)patientListVC {
    if (!_patientListVC) {
        _patientListVC = [[NewPatientListViewController alloc] initWithPatientFilterViewType:PatientFilterViewTypeAll];
    }
    return _patientListVC;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
