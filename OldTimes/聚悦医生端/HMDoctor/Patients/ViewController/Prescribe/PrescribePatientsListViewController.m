//
//  PrescribePatientsListViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PrescribePatientsListViewController.h"
#import "PrescribePatientsTableViewController.h"
#import "HMSwitchView.h"
#import "PatientListTableViewCell.h"

@interface PrescribePatientsListViewController ()
<HMSwitchViewDelegate,
UISearchBarDelegate>
{
    HMSwitchView* switchview;
    UISearchBar* searchBar;
    PrescribePatientsTableViewController* tvcPatients;
}
@end

@implementation PrescribePatientsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"请选择用户"];
    /*searchBar = [[UISearchBar alloc]init];
    [self.view addSubview:searchBar];
    NSLog(@"serchabar %f", searchBar.height);
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@56);
    }];
    [searchBar setDelegate:self];
    [searchBar setPlaceholder:@"搜索"];*/
    /*
    switchview = [[HMSwitchView alloc]init];
    [self.view addSubview:switchview];
    [switchview createCells:@[@"服务患者", @"院内患者"]];
    [switchview setDelegate:self];
    
    [switchview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(searchBar.mas_bottom);
        make.height.mas_equalTo(@50);
    }];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!tvcPatients)
    {
        
        tvcPatients = [[PrescribePatientsTableViewController alloc]initWithStyle:UITableViewStylePlain];
        //[tvcPatients.tableView setFrame:rtTable];
        [self addChildViewController:tvcPatients];
        [self.view addSubview:tvcPatients.tableView];
        
        [tvcPatients.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.view);
            //make.top.equalTo(searchBar.mas_bottom);
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }

}

//- (void) viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    if (!tvcPatients)
//    {
//        
//        tvcPatients = [[PrescribePatientsTableViewController alloc]initWithStyle:UITableViewStylePlain];
//        //[tvcPatients.tableView setFrame:rtTable];
//        [self addChildViewController:tvcPatients];
//        [self.view addSubview:tvcPatients.tableView];
//        
//        [tvcPatients.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.and.right.equalTo(self.view);
//            make.top.equalTo(searchBar.mas_bottom);
//            make.bottom.equalTo(self.view);
//        }];
//    }
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - HMSwitchViewDelegate
- (void) switchview:(HMSwitchView *)switchview SelectedIndex:(NSUInteger)selectedIndex
{
    
}

#pragma makr - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchbar
{
    [searchbar setShowsCancelButton:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchbar
{
    [searchbar setShowsCancelButton:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchbar
{
    [searchbar setText:nil];
    [searchbar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchbar
{
    [searchbar resignFirstResponder];
}
@end

