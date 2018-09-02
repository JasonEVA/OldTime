//
//  ServiceGoodsDetailViewController.m
//  HMDoctor
//
//  Created by lkl on 16/11/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ServiceGoodsDetailViewController.h"
#import "ServiceInfo.h"
#import "ServiceDetailTableViewCell.h"
#import "ServiceDetailViewController.h"

@interface ServiceGoodsDetailTableViewController ()
<TaskObserver>
{
    ServiceDetailTableHeaderView* tableheaderview;
}
@property (nonatomic, readonly) NSInteger upId;
@property (nonatomic, readonly) ServiceDetail* serviceDetail;

- (id) initWithServiceUpID:(NSInteger) aUpId;
- (NSArray*) serviceProductIDList;
@end

@interface ServiceGoodsDetailViewController ()
{
    ServiceInfo* serviceInfo;
    ServiceGoodsDetailTableViewController* goodsTableViewController;
}
@end

@implementation ServiceGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"商品详情"];
    if (self.paramObject && [self.paramObject isKindOfClass:[ServiceInfo class]])
    {
        serviceInfo = (ServiceInfo*)self.paramObject;
        if (serviceInfo.productName)
        {
            [self.navigationItem setTitle:serviceInfo.productName];
        }
    }
    
    [self createDetailTable];
}

- (void) createDetailTable
{
    goodsTableViewController = [[ServiceGoodsDetailTableViewController alloc]initWithServiceUpID:serviceInfo.upId];
    [self addChildViewController:goodsTableViewController];
    [self.view addSubview:goodsTableViewController.tableView];
    
    [goodsTableViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


typedef enum : NSUInteger {
    DetailBaseInfoSection,
    DetailDescripitionSection,
    ServiceDetailSectionCount,
} ServiceDetailSection;

typedef enum : NSUInteger {
    ServicePriceIndex,
    ServiceBillWayIndex,
    ServiceBaseInfoIndexCount,
} ServiceBaseInfoIndex;

@implementation ServiceGoodsDetailTableViewController

- (id) initWithServiceUpID:(NSInteger)aUpId
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _upId = aUpId;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    tableheaderview = [[ServiceDetailTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 150)];
    [self.tableView setTableHeaderView:tableheaderview];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.serviceDetail) {
        [self loadServiceDetail];
    }
    
}

- (void) loadServiceDetail
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", self.upId] forKey:@"upId"];
    [self.tableView.superview showWaitView];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceDetailTask" taskParam:dicPost TaskObserver:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return ServiceDetailSectionCount;
}

- (void) serviceDetailLoaded:(ServiceDetail*) detail;
{
    if (!detail) {
        return;
    }
    _serviceDetail = detail;
    if (detail.img && 0 < detail.img)
    {
        [tableheaderview setImageUrl:detail.img];
    }
    [self.tableView reloadData];
}

- (NSArray*) serviceProductIDList
{
    NSMutableArray* idList = [NSMutableArray array];
    if (!self.serviceDetail)
    {
        return idList;
    }
    
    for (ServiceDetailOption* opt in self.serviceDetail.isMustYes)
    {
        NSString* pid = [NSString stringWithFormat:@"%ld", opt.productId];
        [idList addObject:pid];
    }
    
    
    
    return idList;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    switch (section)
    {
        case DetailBaseInfoSection:
        {
            return ServiceBaseInfoIndexCount;
        }
            break;
        case DetailDescripitionSection:
        {
            if (!self.serviceDetail || !self.serviceDetail.productDes)
            {
                return 0;
            }
            return 1;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 5)];
    [footerview setBackgroundColor:[UIColor commonBackgroundColor]];
    return footerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case DetailDescripitionSection:
            return 40;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 40)];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    switch (section)
    {
        case DetailDescripitionSection:
        {
            UIImageView* ivLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_list_line"]];
            [headerview addSubview:ivLine];
            [ivLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerview);
                make.left.equalTo(headerview).with.offset(12.5);
                make.size.mas_equalTo(CGSizeMake(2, 14));
            }];
            
            UILabel* lbTitle = [[UILabel alloc]init];
            [headerview addSubview:lbTitle];
            [lbTitle setTextColor:[UIColor mainThemeColor]];
            [lbTitle setFont:[UIFont font_30]];
            [lbTitle setText:@"介绍"];
            [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerview);
                make.left.equalTo(ivLine.mas_right).with.offset(3);
            }];
            
            UIView* lineview = [[UIView alloc]init];
            [headerview addSubview:lineview];
            [lineview setBackgroundColor:[UIColor commonControlBorderColor]];
            [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.equalTo(headerview);
                make.bottom.equalTo(headerview);
                make.height.mas_equalTo(@0.5);
            }];
            break;
        }
            
    }
    return headerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case DetailDescripitionSection:
        {
            if (!self.serviceDetail || !self.serviceDetail.productDes)
            {
                return 0;
            }
            
            CGFloat cellHeight = 20 + [self.serviceDetail.productDes heightSystemFont:[UIFont font_26] width:self.tableView.width - 25];
            return cellHeight;
        }
            break;
            
        default:
            break;
    }
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =nil;
    switch (indexPath.section)
    {
        case DetailBaseInfoSection:
        {
            NSString* cellClassName = @"ServiceDetailTableViewCell";
            switch (indexPath.row)
            {
                case ServicePriceIndex:
                {
                    cellClassName = @"ServiceDetailPriceTableViewCell";
                }
                    break;
                case ServiceBillWayIndex:
                {
                    cellClassName = @"ServiceGoodsDetailBillWayTableViewCell";
                    break;
                }
                default:
                    break;
            }
            
            ServiceDetailTableViewCell* infoCell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
            if (!infoCell)
            {
                infoCell = [[NSClassFromString(cellClassName) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellClassName];
            }
            [infoCell setServiceDetail:self.serviceDetail];
            [infoCell setServiceIsGoods:YES];
            cell = infoCell;
        }
            break;
        case DetailDescripitionSection:
        {
            
            ServiceDetailDescriptionTableViewCell* descCell = [tableView dequeueReusableCellWithIdentifier:@"ServiceDetailDescriptionTableViewCell"];
            if (!descCell)
            {
                descCell = [[ServiceDetailDescriptionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceDetailDescriptionTableViewCell"];
            }
            
            [descCell setServiceDetail:self.serviceDetail];
            
            cell = descCell;
            
        }
            break;
        default:
            break;
    }
    
    // Configure the cell...
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceDetailTableViewCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView.superview closeWaitView];
    if (StepError_None != taskError)
    {
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
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"ServiceDetailTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[ServiceDetail class]])
        {
            ServiceDetail* detail = (ServiceDetail*) taskResult;
            [detail setUP_ID:self.upId];
            
            [self serviceDetailLoaded:detail];
        }
    }
}

@end

