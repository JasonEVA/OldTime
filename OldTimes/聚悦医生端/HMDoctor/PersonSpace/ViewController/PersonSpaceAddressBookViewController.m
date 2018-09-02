//
//  PersonSpaceAddressBookViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PersonSpaceAddressBookViewController.h"
#import "PersonSpaceAddressBookTableViewCell.h"
#import "PersonSpaceAddressBookViewController.h"
#import "PersonSpaceAddressBookSelectedDepViewController.h"

@interface AddressBookTitleView ()
{
    UILabel *lbName;
    UILabel *lbDepName;
    UIImageView* ivDep;
    UILabel *lbHomeTel;
    UIView  *lineView;
}
@end

@implementation AddressBookTitleView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        lbName = [[UILabel alloc] init];
        [self addSubview:lbName];
        [lbName setText:@"姓名"];
        [lbName setTextColor:[UIColor commonTextColor]];
        [lbName setFont:[UIFont systemFontOfSize:15]];
        [lbName setTextAlignment:NSTextAlignmentCenter];
        
        _depControl = [[UIControl alloc] init];
        [self addSubview:_depControl];
        [_depControl setBackgroundColor:[UIColor commonLightGrayTextColor]];

        
        lbDepName = [[UILabel alloc] init];
        [_depControl addSubview:lbDepName];
        [lbDepName setText:@"科室"];
        [lbDepName setTextColor:[UIColor commonTextColor]];
        [lbDepName setFont:[UIFont systemFontOfSize:15]];
        [lbDepName setTextAlignment:NSTextAlignmentCenter];
        
        ivDep = [[UIImageView alloc] init];
        [_depControl addSubview:ivDep];
        [ivDep setImage:[UIImage imageNamed:@"icon_patient_list2"]];
        
        lbHomeTel = [[UILabel alloc] init];
        [self addSubview:lbHomeTel];
        [lbHomeTel setText:@"电话"];
        [lbHomeTel setTextColor:[UIColor commonTextColor]];
        [lbHomeTel setFont:[UIFont systemFontOfSize:15]];
        [lbHomeTel setTextAlignment:NSTextAlignmentCenter];
        
        lineView = [[UIView alloc] init];
        [self addSubview:lineView];
        [lineView setBackgroundColor:[UIColor commonCuttingLineColor]];
        
        [self subViewsLayout];
        
    }
    return self;
}

- (void)subViewsLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(100*kScreenScale);
    }];
    
    [_depControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbName.mas_right);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(100*kScreenScale);
    }];
    
    [lbDepName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_depControl);
        make.width.lessThanOrEqualTo(_depControl);
    }];
    
    [ivDep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_depControl.mas_right).with.offset(-10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(10, 5));
    }];
    
    [lbHomeTel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_depControl.mas_right);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(120*kScreenScale);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.bottom.equalTo(self).with.offset(-1);
        make.height.mas_equalTo(1);
    }];
}


@end


#define kSurveyPageSize         20

@interface PersonSpaceAddressBookViewController ()<TaskObserver,UITableViewDataSource,UITableViewDelegate>
{
    
    AddressBookTitleView *infoTitleView;
    UITableView *addressBookTableView;
    
    NSMutableArray *addressBookList;
    NSInteger totalCount;
    UIWebView* webview;
}

@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation PersonSpaceAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"医院通讯录"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    [self initWithSubViews];
    
    NSInteger rows = kSurveyPageSize;
    if (addressBookList)
    {
        rows = addressBookList.count;
    }
    
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", curStaff.orgId] forKey:@"orgId"];
    [dicPost setValue:[NSNumber numberWithLong:0] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithLong:rows] forKey:@"rows"];
    
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"AddressBookListTask" taskParam:dicPost TaskObserver:self];
}

- (void)initWithSubViews
{
    UISearchBar* searchBar = [[UISearchBar alloc]init];
    [self.view addSubview:searchBar];
    
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@56);
    }];
    //[searchBar setDelegate:self];
    [searchBar setPlaceholder:@"请输入姓名"];
    
    UIControl *searchControl = [[UIControl alloc] init];
    [self.view addSubview:searchControl];
    [searchControl addTarget:self action:@selector(searchControllerClick) forControlEvents:UIControlEventTouchUpInside];
    
    [searchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@56);
    }];
    
    infoTitleView = [[AddressBookTitleView alloc] init];
    [self.view addSubview:infoTitleView];
    [infoTitleView setBackgroundColor:[UIColor whiteColor]];
    [infoTitleView.depControl addTarget:self action:@selector(depControlClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [infoTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(searchBar.mas_bottom);
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

- (void)searchControllerClick
{
    [HMViewControllerManager createViewControllerWithControllerName:@"PersonSpaceSearchAddressBookViewController" ControllerObject:nil];
}


- (void)depControlClick:(UIControl *)sender
{
    //通过关键词查询科室列表
    [PersonSpaceAddressBookSelectedDepViewController createWithParentViewController:self selectblock:^(AddressBookDepNameInfo *DepNameInfo) {
        
        if (DepNameInfo)
        {

            NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
            
            StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
            [dicPost setValue:[NSString stringWithFormat:@"%ld", curStaff.orgId] forKey:@"orgId"];
            
            if (![DepNameInfo.depId isEqualToString:@"0"])
            {
                [dicPost setValue:DepNameInfo.depId forKey:@"depId"];
            }
            
            [self.view showWaitView];
            [[TaskManager shareInstance] createTaskWithTaskName:@"AddressBookListTask" taskParam:dicPost TaskObserver:self];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [cell.homeTelBtn addTarget:self action:@selector(homeTelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)homeTelBtnClick:(UIButton *)sender
{
    if (!sender.titleLabel.text || sender.titleLabel.text.length <= 0)
    {
        return;
    }

    if (webview == nil) {
        webview = [[UIWebView alloc] init];
    }
    //    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    //    [self.view addSubview:_webView];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",sender.titleLabel.text]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webview loadRequest:request];
}


#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
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
        NSLog(@"%@",taskResult);
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
            
            NSNumber* numCount = [dicResult valueForKey:@"count"];
            if (numCount && [numCount isKindOfClass:[NSNumber class]])
            {
                totalCount = numCount.integerValue;
            }
            
            NSArray *list = dicResult[@"list"];
            
           // addressBookList = list;
           // NSLog(@"%@",list);
            
            NSDictionary* dicParam = [TaskManager taskparamWithTaskId:taskId];
            NSNumber* numStart = [dicParam valueForKey:@"startRow"];
            if (numStart && [numStart isKindOfClass:[NSNumber class]] && 0 < numStart.integerValue)
            {
                //加载
                [self moreAddressBookListLoaded:list];
                return;
            }
            else
            {
                [self AddressBookListLoaded:list];
            }
        }
    }
    
    //科室查询
    if ([taskname isEqualToString:@"getDepsByKeyNameListTask"])
    {
        NSLog(@"%@",taskResult);
        
        //[addressBookTableView  reloadData];
    }
}

- (void) AddressBookListLoaded:(NSArray*) items
{
    addressBookList = [NSMutableArray arrayWithArray:items];
    [addressBookTableView reloadData];
    
    if (addressBookList.count >= totalCount)
    {
        [addressBookTableView.mj_footer endRefreshingWithNoMoreData ];
    }
    else
    {
        [addressBookTableView.mj_footer endRefreshing];
        addressBookTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAddressBookItem)];
    }
    
}

- (void) moreAddressBookListLoaded:(NSArray*) items
{
    if (!addressBookList)
    {
        addressBookList = [NSMutableArray array];
    }
    [addressBookList addObjectsFromArray:items];
    [addressBookTableView reloadData];
    
    if (addressBookList.count >= totalCount)
    {
        [addressBookTableView.mj_footer endRefreshingWithNoMoreData ];
    }
    else
    {
        [addressBookTableView.mj_footer endRefreshing];
        addressBookTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAddressBookItem)];
    }
}

- (void) loadMoreAddressBookItem
{
    NSDictionary* dicPost = [NSMutableDictionary dictionary];

    if (addressBookList)
    {
        [dicPost setValue:[NSNumber numberWithLong:addressBookList.count] forKey:@"startRow"];
    }
    
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", curStaff.orgId] forKey:@"orgId"];
    [dicPost setValue:[NSNumber numberWithLong:kSurveyPageSize] forKey:@"rows"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"AddressBookListTask" taskParam:dicPost TaskObserver:self];
}

@end
