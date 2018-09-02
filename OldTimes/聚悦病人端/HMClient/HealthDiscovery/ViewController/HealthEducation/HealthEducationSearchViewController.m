//
//  HealthEducationSearchViewController.m
//  HMClient
//
//  Created by yinquan on 16/12/14.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthEducationSearchViewController.h"
#import "HealthEducationSearchTableViewController.h"

@interface HealthEducationSearchViewController ()
<UISearchBarDelegate>
{
    UISearchBar* searchBar;
    
}

@property (nonatomic, readonly) HealthEducationSearchTableViewController* searchTableViewController;

@end

@implementation HealthEducationSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 190, 31)];
    self.navigationItem.titleView = searchBar;
    [searchBar setPlaceholder:@"请输入关键字"];
    [searchBar setDelegate:self];
    searchBar.tintColor=[UIColor mainThemeColor];
    
    UILabel* searchExplainLable = [[UILabel alloc]init];
    [self.view addSubview:searchExplainLable];
    [searchExplainLable setText:@"温馨提示：您可以输入标题关键字进行搜索"];
    [searchExplainLable setFont:[UIFont font_28]];
    [searchExplainLable setTextColor:[UIColor commonGrayTextColor]];
    [searchExplainLable setNumberOfLines:0];
    [searchExplainLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.top.equalTo(self.view).with.offset(35);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar
{
    NSString* keyword = aSearchBar.text;
    if (keyword.length == 0) {
        [self showAlertMessage:@"请输入搜索的关键字"];
        return;
    }
    if (keyword.length > 15) {
        [self showAlertMessage:@"输入的关键字不能超过15个字符"];
        [aSearchBar setText:nil];
        return;
    }
    
    if (!self.searchTableViewController)
    {
        _searchTableViewController = [[HealthEducationSearchTableViewController alloc]initWithKeyword:keyword];
        [self addChildViewController:self.searchTableViewController];
        [self.view addSubview:self.searchTableViewController.tableView];
        [self.searchTableViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.equalTo(self.view);
            make.top.equalTo(self.view);
        }];
    }
    else
    {
        [self.searchTableViewController setKeyword:keyword];
    }
    
    [aSearchBar resignFirstResponder];
}

@end
