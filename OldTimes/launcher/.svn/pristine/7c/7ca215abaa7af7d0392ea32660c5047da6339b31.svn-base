//
//  NewApplyStyleViewController.m
//  launcher
//
//  Created by conanma on 16/1/6.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyStyleViewController.h"
#import "ApplySenderViewController.h"
#import "ApplyAcceptViewController.h"
#import "ApplyAddViewController.h"
#import "ApplyTableBar.h"
#import "Masonry.h"
#import "MyDefine.h"
#import "BaseNavigationController.h"
#import "ApplyAddForExpenseViewController.h"
#import "ApplyGetSenderListRequest.h"
#import "UIColor+Hex.h"
#import "ApplyStyleModel.h"
#import "ApplyAddNewUserDefinedViewController.h"
#import "MixpanelMananger.h"
#import "UIViewController+Loading.h"
#import "ApplyStyleRequest.h"
#import "NewApplyAddNewUserDefindedApplyViewController.h"
#import "NewApplyAddNewApplyV2ViewController.h"
#import "NewestApplyAddUserDefinedViewController.h"
#import "NewApplyCreatAndEditViewController.h"
@interface NewApplyStyleViewController ()<BaseRequestDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *arrStyle;
@property (nonatomic, strong) NSMutableArray *arrStyleModels;
@property (nonatomic, strong) UITableView *tableview;
@end

@implementation NewApplyStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayBackground];
    self.title = LOCAL(APPLY_CHOOSE_APPLYKIND);

    [self setframes];
    
    ApplyStyleRequest *stylerequest = [[ApplyStyleRequest alloc] initWithDelegate:self];
    [stylerequest getInfo];
    
    [self postLoading];
}

- (void)setframes
{
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrStyle.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellID"];
    }
    cell.textLabel.text = [self.arrStyle objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ApplyStyleModel *model = [self.arrStyleModels objectAtIndex:indexPath.row];
    
    NewApplyCreatAndEditViewController *vc = [[NewApplyCreatAndEditViewController alloc] initWithFormID:model.FORM_ID WorkFlowID:model.T_WORKFLOW_ID ApplyType:kNewApply_Type_Add] ;
    vc.navigationItem.title = model.name;
    vc.applyTypeShowID = model.showid;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 15;}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01;}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    view.backgroundColor = [UIColor grayBackground];
    return view;
}
#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([response isKindOfClass:[ApplyStyleResponse class]])
    {
        if (((ApplyStyleResponse *)response).arrrTitles.count >0)
        {
            for (NSInteger i = 0; i<((ApplyStyleResponse *)response).arrrTitles.count; i++)
            {
                ApplyStyleModel *model = [((ApplyStyleResponse *)response).arrrTitles objectAtIndex:i];
//                if (model.def == 0)
//                {
                    [self.arrStyleModels addObject:model];
                    [self.arrStyle addObject:model.name];
//                }
            }
        }
    }
    [self hideLoading];
    [self.tableview reloadData];
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
}

- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - init
- (NSMutableArray *)arrStyle
{
    if (!_arrStyle)
    {
        _arrStyle = [[NSMutableArray alloc] init];
    }
    return _arrStyle;
}

- (NSMutableArray *)arrStyleModels
{
    if (!_arrStyleModels)
    {
        _arrStyleModels = [[NSMutableArray alloc] init];
    }
    return _arrStyleModels;
}

- (UITableView *)tableview
{
    if (!_tableview)
    {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.backgroundColor = [UIColor grayBackground];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}
@end
