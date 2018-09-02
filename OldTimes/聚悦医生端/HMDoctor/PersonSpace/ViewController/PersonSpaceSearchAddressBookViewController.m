//
//  PersonSpaceSearchAddressBookViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PersonSpaceSearchAddressBookViewController.h"
#import "PersonSpaceAddressBookViewController.h"
#import "PersonSpaceAddressBookTableViewCell.h"
#import "AddressBookInfo.h"

@interface PersonSpaceSearchAddressBookViewController ()<UISearchBarDelegate,TaskObserver,UITableViewDataSource,UITableViewDelegate>
{
    UISearchBar *searchBar;
    
    AddressBookTitleView *infoTitleView;
    UITableView *addressBookTableView;
    
    NSMutableArray *addressBookList;
    NSInteger totalCount;
}
@end

@implementation PersonSpaceSearchAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *titleView = [[UIView alloc] initWithFrame: CGRectMake(10, 0, kScreenWidth-80, 30)];
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-80, 30)];
    [titleView addSubview:searchBar];
    self.navigationItem.titleView = titleView;
    
    [searchBar setDelegate:self];
    [searchBar setPlaceholder:@"请输入姓名"];
    [searchBar setBackgroundImage:[UIImage new]];
    [searchBar setTranslucent:YES];
    
    [self initWithSubViews];
}

- (void)initWithSubViews
{
    UIImageView *ivBlank = [[UIImageView alloc] init];
    [self.view addSubview:ivBlank];
    [ivBlank setImage:[UIImage imageNamed:@"img_blank_list"]];
    
    [ivBlank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).with.offset(-50);
        make.size.mas_equalTo(CGSizeMake(100, 141));
    }];
    
    UILabel *lbContent = [[UILabel alloc] init];
    [self.view addSubview:lbContent];
    [lbContent setText:@"未找到该联系人信息"];
    [lbContent setTextColor:[UIColor commonGrayTextColor]];
    [lbContent setFont:[UIFont systemFontOfSize:20]];
    
    [lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(ivBlank.mas_bottom).with.offset(20);
    }];
}

- (void)initWithTableView
{
    infoTitleView = [[AddressBookTitleView alloc] init];
    [self.view addSubview:infoTitleView];
    [infoTitleView setBackgroundColor:[UIColor whiteColor]];
    
    [infoTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    addressBookTableView = [[UITableView alloc] init];
    [self.view addSubview:addressBookTableView];
    [addressBookTableView setDataSource:self];
    [addressBookTableView setDelegate:self];
    
    [addressBookTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(infoTitleView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", curStaff.orgId] forKey:@"orgId"];
    [dicPost setValue:searchBar.text forKey:@"staffName"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"AddressBookListTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - tableViewDelegate And DataSouce

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return addressBookList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 45;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    [headerview setBackgroundColor:[UIColor commonBackgroundColor]];
    [headerview showBottomLine];
    return headerview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddressBookInfo *info = [addressBookList objectAtIndex:indexPath.row];
    
    PersonSpaceAddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonSpaceAddressBookTableViewCell"];
    
    if (!cell) {
        cell = [[PersonSpaceAddressBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonSpaceAddressBookTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell setAddressBookInfo:info];
    return cell;
}


#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (StepError_None != taskError) {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"AddressBookListTask"])
    {
        
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            
            NSNumber* numCount = [dicResult valueForKey:@"count"];
            if (numCount && [numCount isKindOfClass:[NSNumber class]])
            {
                totalCount = numCount.integerValue;
                
                if (!totalCount || totalCount <= 0)
                {
                    [infoTitleView removeFromSuperview];
                    [addressBookTableView removeFromSuperview];

                    //[self initWithSubViews];
                    
                    return;
                }else
                {
                    [self initWithTableView];
                }
            }
            
            addressBookList = dicResult[@"list"];
            [addressBookTableView reloadData];
        }
    }
}


@end
