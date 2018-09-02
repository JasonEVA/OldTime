//
//  PersonSpaceAddressBookSelectedDepViewController.m
//  HMDoctor
//
//  Created by lkl on 16/7/14.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PersonSpaceAddressBookSelectedDepViewController.h"
#import "AddressBookInfo.h"

@interface PersonSpaceAddressBookSelectedDepViewController ()<TaskObserver,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView* depNameTableView;
    
    NSMutableArray *depNameList;
    
}

@end

@implementation PersonSpaceAddressBookSelectedDepViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.orgId] forKey:@"orgId"];
    
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"AddressBookDepNameListTask" taskParam:dicPost TaskObserver:self];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6]];
    UIControl* closeControl = [[UIControl alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:closeControl];
    [closeControl addTarget:self action:@selector(closeControlClicked:) forControlEvents:UIControlEventTouchUpInside];

}

+ (PersonSpaceAddressBookSelectedDepViewController*) createWithParentViewController:(UIViewController*) parentviewcontroller
                                                                        selectblock:(DepNameSelectBlock)block;
{
    if (!parentviewcontroller)
    {
        return nil;
    }
    PersonSpaceAddressBookSelectedDepViewController* vcBankName = [[PersonSpaceAddressBookSelectedDepViewController alloc]initWithNibName:nil bundle:nil];
    [parentviewcontroller addChildViewController:vcBankName];
    [vcBankName.view setFrame:parentviewcontroller.view.bounds];
    [parentviewcontroller.view addSubview:vcBankName.view];
    
    
    [vcBankName setSelectblock:block];
    
    return vcBankName;
}


- (void) closeControlClicked:(id) sender
{
    if (_selectblock)
    {
        _selectblock(nil);
    }
    [self closeTestTimeView];
}

- (void) closeTestTimeView
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (depNameList)
    {
        return depNameList.count;
    }
    return 0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
    [headerview setBackgroundColor:[UIColor commonBackgroundColor]];
    [headerview showBottomLine];
    return headerview;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textLabel setText:[[depNameList objectAtIndex:indexPath.row] depName]];
    
    return cell;
}
#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressBookDepNameInfo* depNameInfo = [depNameList objectAtIndex:indexPath.row];
    if (_selectblock)
    {
        _selectblock(depNameInfo);
    }
    
    [self closeTestTimeView];
    
}
- (void) createBankNameTableView
{
    if (!depNameList)    {

        return;
    }
    float tableheight = depNameList.count * 44;
     if (tableheight > self.view.height - 150)
     {
         tableheight = self.view.height- 150;
     }
    
    depNameTableView = [[UITableView alloc]init];
    [self.view addSubview:depNameTableView];
    [depNameTableView setDataSource:self];
    [depNameTableView setDelegate:self];
    [depNameTableView.layer setCornerRadius:5.0f];
    [depNameTableView.layer setMasksToBounds:YES];
    
    [depNameTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(depNameTableView.superview).with.offset(70*kScreenScale);
        make.top.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(150*kScreenScale, tableheight));
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if ([taskname isEqualToString:@"AddressBookDepNameListTask"])
    {
        NSLog(@"%@",taskResult);
        
        AddressBookDepNameInfo* depNameAll = [[AddressBookDepNameInfo alloc] init];
        depNameAll.depId = @"0";
        depNameAll.depName = @"全部科室";
        
        NSArray* depNameArray = (NSArray *)taskResult;
        if (!depNameList) {
            depNameList = [[NSMutableArray alloc] init];
        }
        [depNameList addObject:depNameAll];
        for (NSDictionary* dicDep in depNameArray)
        {
            
            AddressBookDepNameInfo* depNameInfo = [AddressBookDepNameInfo mj_objectWithKeyValues:dicDep];
            
            [depNameList addObject:depNameInfo];
        }
        
        [self createBankNameTableView];
    }
}



@end

