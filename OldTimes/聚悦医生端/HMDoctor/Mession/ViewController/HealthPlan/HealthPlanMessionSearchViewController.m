//
//  HealthPlanMessionSearchViewController.m
//  HMDoctor
//
//  Created by lkl on 2017/2/14.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanMessionSearchViewController.h"
#import "HealthPlanMessionTableViewController.h"

@interface HealthPlanMessionSearchViewController ()<UISearchBarDelegate>
{
    UISearchBar* searchBar;
}
@property (nonatomic, readonly)HealthPlanMessionTableViewController *searchTableViewController;
@end

@implementation HealthPlanMessionSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 80, 31)];
    self.navigationItem.titleView = searchBar;
    [searchBar setPlaceholder:@"请输入用户姓名"];
    [searchBar setDelegate:self];
    searchBar.tintColor=[UIColor mainThemeColor];
    
    UILabel* searchExplainLable = [[UILabel alloc]init];
    [self.view addSubview:searchExplainLable];
    [searchExplainLable setText:@"温馨提示：您可以输入用户姓名进行搜索"];
    [searchExplainLable setFont:[UIFont font_28]];
    [searchExplainLable setTextColor:[UIColor commonGrayTextColor]];
    [searchExplainLable setNumberOfLines:0];
    [searchExplainLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.top.equalTo(self.view).with.offset(35);
    }];
    
    [self setupRightItem];
}

-(void)setupRightItem
{
    //Right
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    //字体颜色
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [rightBtn setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
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
        [self showAlertMessage:@"请输入用户姓名进行搜索"];
        return;
    }
    if (keyword.length > 15) {
        [self showAlertMessage:@"输入的关键字不能超过15个字符"];
        [aSearchBar setText:nil];
        return;
    }
    
    if (!self.searchTableViewController)
    {
        _searchTableViewController = [[HealthPlanMessionTableViewController alloc]initWithKeyword:keyword];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
