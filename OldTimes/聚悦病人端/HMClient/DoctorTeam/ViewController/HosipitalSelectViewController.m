//
//  HosipitalSelectViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HosipitalSelectViewController.h"

@interface HosipitalSelectTableViewController : UITableViewController
{
    NSArray* hosipitalItems;
    
}

@property (nonatomic, weak) id<HosipitalSelectDelegate> selectedDelegate;
- (id) initWithHosipitalItem:(NSArray*) hosipitals;
@end


@interface HosipitalSelectViewController ()
<TaskObserver,
HosipitalSelectDelegate>
{
    UIControl* closecontrol;
    
}

@property (nonatomic, weak) id<HosipitalSelectDelegate> delegate;

@end



@implementation HosipitalSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    closecontrol = [[UIControl alloc]init];
    [self.view addSubview:closecontrol];
    [closecontrol setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
    [closecontrol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.and.top.equalTo(self.view);
    }];
    
    [closecontrol addTarget:self action:@selector(closecontrolClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self loadHosipitals];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) closecontrolClicked:(id) sender
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}


+ (void) showInParentController:(UIViewController*) parentController
                       Delegate:(id<HosipitalSelectDelegate>) delegate
{
    if (!parentController)
    {
        return;
    }
    
    NSArray* childlist = [parentController childViewControllers];
    for (UIViewController* vcChild in childlist)
    {
        if ([vcChild isKindOfClass:[OrgTeamSelectViewController class]])
        {
            return;
        }
    }
    
    HosipitalSelectViewController* vcSelect = [[HosipitalSelectViewController alloc]initWithNibName:nil bundle:nil];
    [vcSelect setDelegate:delegate];
    
    [parentController addChildViewController:vcSelect];
    [parentController.view addSubview:vcSelect.view];
    
    [vcSelect.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(parentController.view);
        make.top.and.bottom.equalTo(parentController.view);
    }];
}

- (void) loadHosipitals
{
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceProviderOrgListTask" taskParam:nil TaskObserver:self];
    
}

#pragma mark - HosipitalSelectDelegate
- (void) hosipitalSelected:(HosipitalInfo *)hosipital
{
    if (hosipital)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(hosipitalSelected:)])
        {
            [_delegate hosipitalSelected:hosipital];
        }
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
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
    if (!taskId && 0 == taskId.length) {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname && 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"ServiceProviderOrgListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSMutableArray* hosipitals = [NSMutableArray arrayWithArray:(NSArray*) taskResult];
            HosipitalInfo* hosipital = [[HosipitalInfo alloc]init];
            [hosipital setOrgName:@"所有医院"];
            [hosipital setOrgShortName:@"所有医院"];
            [hosipitals insertObject:hosipital atIndex:0];
            
            CGFloat maxHeihgt = self.view.height/2;
            if (maxHeihgt > hosipitals.count * 44)
            {
                maxHeihgt = hosipitals.count * 44;
            }
            HosipitalSelectTableViewController* tvcSelect = [[HosipitalSelectTableViewController alloc]initWithHosipitalItem:hosipitals];
            [self addChildViewController:tvcSelect];
            [tvcSelect setSelectedDelegate:self];
            [self.view addSubview:tvcSelect.tableView];
            [tvcSelect.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.equalTo(self.view);
                make.top.equalTo(self.view);
                make.height.mas_equalTo([NSNumber numberWithFloat:maxHeihgt]);
            }];
            
            
        }
        
    }
}

@end

@implementation HosipitalSelectTableViewController

- (id) initWithHosipitalItem:(NSArray *)hosipitals
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        hosipitalItems = [NSArray arrayWithArray:hosipitals];
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (hosipitalItems)
    {
        return hosipitalItems.count ;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 0.5)];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    return footerview;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HosipitalSelectTableCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HosipitalSelectTableCell"];
    }
    
    HosipitalInfo* hosipital = hosipitalItems[indexPath.row];
    [cell.textLabel setText:hosipital.orgShortName];
    [cell.textLabel setFont:[UIFont font_30]];
    [cell.textLabel setTextColor:[UIColor commonTextColor]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HosipitalInfo* hosipital = hosipitalItems[indexPath.row];
    if (_selectedDelegate && [_selectedDelegate respondsToSelector:@selector(hosipitalSelected:)])
    {
        [_selectedDelegate hosipitalSelected:hosipital];
    }
}

@end


