//
//  PrescribeSearchDrugViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PrescribeSearchDrugViewController.h"
#import "PrescrbeSearchDrugTableViewCell.h"
#import "DrugInfo.h"

@interface PrescribeSearchDrugViewController ()<TaskObserver,UISearchBarDelegate,PrescribeSearchDrugTableViewControllerDelegate>
{
    UISearchBar *searchBar;
    
    PrescribeSearchDrugTableViewController *tvcPrescribeSearDrug;
    NSInteger totalCount;
}
@end

@interface PrescribeSearchDrugTableViewController ()
{

    DrugInfo *drugInfo;
}
@property (nonatomic,strong) NSArray *drugList;
@property (nonatomic,assign) NSInteger totalCount;

- (void)setDrugList:(NSArray *)drugList numCount:(NSInteger)count;

@end

@implementation PrescribeSearchDrugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    UIView *titleView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth-80, 30)];
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-80, 30)];
    [titleView addSubview:searchBar];
    self.navigationItem.titleView = titleView;
    
    [searchBar setDelegate:self];
    [searchBar setPlaceholder:@"请输入药品名称，如感冒冲剂"];
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
    [lbContent setText:@"未找到该药品"];
    [lbContent setTextColor:[UIColor commonGrayTextColor]];
    [lbContent setFont:[UIFont systemFontOfSize:26]];
    
    [lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(ivBlank.mas_bottom).with.offset(20);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (StepError_None != taskError) {
        [self showAlertMessage:errorMessage];
        return;
    }
    
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    if ([taskname isEqualToString:@"SearchDrugsTask"])
    {
    
        NSDictionary* dicResult = (NSDictionary*)taskResult;
        NSNumber* numCount = [dicResult valueForKey:@"count"];
        
        NSArray* list = [dicResult valueForKey:@"list"];
        
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            totalCount = numCount.integerValue;

            if (!totalCount || totalCount <= 0) {
                [self initWithSubViews];
            }
            
            
            [tvcPrescribeSearDrug setDrugList:list numCount:totalCount];
            
            [tvcPrescribeSearDrug.tableView reloadData];
        }
        
    }
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
     
     tvcPrescribeSearDrug = [[PrescribeSearchDrugTableViewController alloc]initWithStyle:UITableViewStylePlain];
     [tvcPrescribeSearDrug setDelegate:self];
     [self addChildViewController:tvcPrescribeSearDrug];
     [self.view addSubview:tvcPrescribeSearDrug.tableView];
     [tvcPrescribeSearDrug.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.and.right.equalTo(self.view);
         make.top.and.bottom.equalTo(self.view);
     }];
     
     NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
     [dicPost setValue:searchBar.text forKey:@"drugName"];
     
     [dicPost setValue:[NSNumber numberWithLong:0] forKey:@"startRow"];
     [dicPost setValue:[NSNumber numberWithLong:20] forKey:@"size"];
     
     [[TaskManager shareInstance] createTaskWithTaskName:@"SearchDrugsTask" taskParam:dicPost TaskObserver:self];
 }

- (void)PrescribeSearchDrugTableViewControllerDelegateCallBack_cellClick:(DrugInfo *)model {
    if ([self.delegate respondsToSelector:@selector(PrescribeSearchDrugViewControllerDelegateCallBack_cellClick:)]) {
        [self.delegate PrescribeSearchDrugViewControllerDelegateCallBack_cellClick:model];
    }
}

@end



@implementation PrescribeSearchDrugTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    
}

- (void)setDrugList:(NSArray *)drugList numCount:(NSInteger)count
{
    _drugList = drugList;
    _totalCount = count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 60;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _drugList.count;
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
    drugInfo = [_drugList objectAtIndex:indexPath.row];
    
    PrescrbeSearchDrugTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrescrbeSearchDrugTableViewCell"];
    
    if (!cell)
    {
        cell = [[PrescrbeSearchDrugTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrescrbeSearchDrugTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell setDrugInfo:drugInfo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    drugInfo = [_drugList objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(PrescribeSearchDrugTableViewControllerDelegateCallBack_cellClick:)]) {
        [self.delegate PrescribeSearchDrugTableViewControllerDelegateCallBack_cellClick:drugInfo];
    }    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
