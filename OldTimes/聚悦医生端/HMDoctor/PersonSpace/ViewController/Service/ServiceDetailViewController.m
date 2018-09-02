//
//  ServiceDetailViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ServiceDetailViewController.h"
#import "ServiceDetailTableViewCell.h"
#import "ServiceProviderDescViewController.h"
#import "SecondEditionStaffServiceQRCodeViewController.h"
#import "HMBaseNavigationViewController.h"

@interface ServiceDetailViewController ()
{
    ServiceInfo* serviceInfo;
    ServiceDetailTableViewController* tvcDetail;
    
}
@end

@implementation ServiceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"服务详情"];
    
    UIButton *homeCodeBtn = [[UIButton alloc] init];
    [homeCodeBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [homeCodeBtn setImage:[UIImage imageNamed:@"icon_home_code"] forState:UIControlStateNormal];
    
    UIBarButtonItem* homeCodeBtnItem = [[UIBarButtonItem alloc]initWithCustomView:homeCodeBtn];
    [self.navigationItem setRightBarButtonItem:homeCodeBtnItem];

    [homeCodeBtn addTarget:self action:@selector(homeCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[ServiceInfo class]])
    {
        serviceInfo = (ServiceInfo*)self.paramObject;
    }
    
    tvcDetail = [[ServiceDetailTableViewController alloc]initWithServiceUpID:serviceInfo.upId];
    [self addChildViewController:tvcDetail];
    [self.view addSubview:tvcDetail.tableView];
    [tvcDetail.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
}

- (void)homeCodeBtnClick
{
//    [HMViewControllerManager createViewControllerWithControllerName:@"StaffServiceQRCodeViewController" ControllerObject:serviceInfo];
    SecondEditionStaffServiceQRCodeViewController* qrCodevViewController = [[SecondEditionStaffServiceQRCodeViewController alloc] initWithServiceInfo:serviceInfo   ];
    HMBaseNavigationViewController* navigationViewController = [[HMBaseNavigationViewController alloc] initWithRootViewController:qrCodevViewController];
    [self presentViewController:navigationViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//@interface ServiceDetailTableHeaderView
//{
//    UIImageView* ivService;
//    UIImageView* ivDefault;
//}
//
//- (void) setImageUrl:(NSString*) imgUrl;
//@end

@implementation ServiceDetailTableHeaderView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"EDEDED"]];
        
        ivDefault = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_default"]];
        [self addSubview:ivDefault];
        
        ivService = [[UIImageView alloc]init];
        [self addSubview:ivService];
        
        [self subviewLayout];
    }
    return self;
}

- (void) setImageUrl:(NSString*) imgUrl
{
    if (!imgUrl)
    {
        [ivService setImage:nil];
    }
    else
    {
         // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
        // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
        [ivService sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    }
    
}

- (void) subviewLayout
{
    [ivDefault mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 50));
    }];
    
    [ivService mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self);
        make.center.equalTo(self);
    }];
}

@end

typedef enum : NSUInteger {
    DetailBaseInfoSection,
    DetailMustYesSection,
    DetailMustNoSection,
    DetailDescripitionSection,
    ServiceDetailSectionCount,
} ServiceDetailSection;

typedef enum : NSUInteger {
    ServicePriceIndex,
    ServiceProviderIndex,
    ServiceBillWayIndex,        //有效期
    ServiceBaseInfoIndexCount,
} ServiceBaseInfoIndex;

@interface ServiceDetailTableViewController ()
<TaskObserver>
{
    NSInteger upId;
    
    ServiceDetailTableHeaderView* tableheaderview;
    ServiceDetail* serviceDetail;
    
    NSMutableArray* selectedOptions;
}

@end

@implementation ServiceDetailTableViewController

@synthesize serviceDetail;

- (id) initWithServiceUpID:(NSInteger) aUpId
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        upId = aUpId;
    }
    
    tableheaderview = [[ServiceDetailTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 150)];
    [self.tableView setTableHeaderView:tableheaderview];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadServiceDetail];
}

- (void) loadServiceDetail
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", upId] forKey:@"upId"];
    StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.userId] forKey:@"userId"];
    [self.tableView.superview showWaitView];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceDetailTask" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return ServiceDetailSectionCount;
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
    return [self headerviewHeight:section];
}

- (CGFloat) headerviewHeight:(NSInteger) section
{
    switch (section)
    {
        case DetailMustYesSection:
        case DetailDescripitionSection:
            return 40;
        case DetailMustNoSection:
        {
            if (!serviceDetail || !serviceDetail.isMustNo || 0 == serviceDetail.isMustNo.count)
            {
                break;
            }
            return 40;
        }
            break;
            
            
        default:
            break;
    }
    return 0;
}

- (NSArray*) serviceProductIDList
{
    NSMutableArray* idList = [NSMutableArray array];
    if (!serviceDetail)
    {
        return idList;
    }
    
    for (ServiceDetailOption* opt in serviceDetail.isMustYes)
    {
        NSString* pid = [NSString stringWithFormat:@"%ld", opt.productId];
        [idList addObject:pid];
    }
    
    for (ServiceDetailOption* opt in selectedOptions)
    {
        NSString* pid = [NSString stringWithFormat:@"%ld", opt.productId];
        [idList addObject:pid];
    }
    
    return idList;
    
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, [self headerviewHeight:section])];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    switch (section)
    {
        case DetailBaseInfoSection:
            return headerview;
            break;
        case DetailMustYesSection:
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
            [lbTitle setFont:[UIFont systemFontOfSize:15]];
            [lbTitle setText:@"服务项目"];
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
            
            return headerview;
        }
            break;
            
        case DetailMustNoSection:
        {
            if (!serviceDetail || !serviceDetail.isMustNo)
            {
                break;
            }
            
            UIControl* optionControl = [[UIControl alloc]init];
            [headerview addSubview:optionControl];
            [optionControl setBackgroundColor:[UIColor clearColor]];
            [optionControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(headerview);
                make.center.equalTo(headerview);
            }];
            
            //[optionControl addTarget:self action:@selector(serviceOptionControlClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView* ivLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_list_line"]];
            [optionControl addSubview:ivLine];
            [ivLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(optionControl);
                make.left.equalTo(optionControl).with.offset(12.5);
                make.size.mas_equalTo(CGSizeMake(2, 14));
            }];
            
            UILabel* lbTitle = [[UILabel alloc]init];
            [optionControl addSubview:lbTitle];
            [lbTitle setTextColor:[UIColor mainThemeColor]];
            [lbTitle setFont:[UIFont systemFontOfSize:15]];
            [lbTitle setText:@"自选项目"];
            [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(optionControl);
                make.left.equalTo(ivLine.mas_right).with.offset(3);
            }];
            
//            UIImageView* icArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_x_arrows"]];
//            [optionControl addSubview:icArrow];
//            [icArrow mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(optionControl);
//                make.right.equalTo(optionControl).with.offset(-12.5);
//                make.size.mas_equalTo(CGSizeMake(7, 14));
//            }];
            
            UIView* lineview = [[UIView alloc]init];
            [headerview addSubview:lineview];
            [lineview setBackgroundColor:[UIColor commonControlBorderColor]];
            [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.equalTo(headerview);
                make.bottom.equalTo(headerview);
                make.height.mas_equalTo(@0.5);
            }];
            
            return headerview;
        }
            break;
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
            [lbTitle setFont:[UIFont systemFontOfSize:15]];
            [lbTitle setText:@"服务介绍"];
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
            
            return headerview;
        }
            break;
        default:
            break;
    }
    return headerview;
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
        case DetailMustYesSection:
        {
            if (serviceDetail.isMustYes)
            {
                return serviceDetail.isMustYes.count;
            }
        }
            break;
        case DetailMustNoSection:
        {
            if (serviceDetail.isMustNo)
            {
                return serviceDetail.isMustNo.count;
            }
        }
            break;
        case DetailDescripitionSection:
        {
            if (!serviceDetail || !serviceDetail.productDes)
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case DetailDescripitionSection:
        {
            if (!serviceDetail || !serviceDetail.productDes)
            {
                return 0;
            }
            
            CGFloat cellHeight = [serviceDetail.productDes heightSystemFont:[UIFont systemFontOfSize:13] width:self.tableView.width - 25];
            return cellHeight + 20;
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
                case ServiceProviderIndex:
                {
                    cellClassName = @"ServiceDetailProviderTableViewCell";
                }
                    break;
                case ServiceBillWayIndex:
                {
                    cellClassName = @"ServiceDetailBillWayTableViewCell";
                }
                    break;
                default:
                    break;
            }
            
            ServiceDetailTableViewCell* infoCell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
            if (!infoCell)
            {
                infoCell = [[NSClassFromString(cellClassName) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellClassName];
            }
            [infoCell setServiceDetail:serviceDetail];
            cell = infoCell;
        }
            break;
        case DetailMustYesSection:
        {
            NSArray* options = serviceDetail.isMustYes;
            ServiceDetailOptionTableViewCell* optCell = [tableView dequeueReusableCellWithIdentifier:@"ServiceDetailOptionTableViewCell"];
            if (!optCell)
            {
                optCell = [[ServiceDetailOptionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceDetailOptionTableViewCell"];
            }
            
            ServiceDetailOption* option = options[indexPath.row];
            [optCell setServiceOption:option];
            
            cell = optCell;
        }
            break;
        case DetailMustNoSection:
        {
            
            ServiceDetailOptionTableViewCell* optCell = [tableView dequeueReusableCellWithIdentifier:@"ServiceDetailOptionTableViewCell"];
            if (!optCell)
            {
                optCell = [[ServiceDetailOptionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceDetailOptionTableViewCell"];
            }
            NSArray* options = serviceDetail.isMustNo;
            ServiceDetailOption* option = options[indexPath.row];
            [optCell setServiceOption:option];
            
            cell = optCell;
        }
            break;
        case DetailDescripitionSection:
        {
            
            ServiceDetailDescriptionTableViewCell* descCell = [tableView dequeueReusableCellWithIdentifier:@"ServiceDetailDescriptionTableViewCell"];
            if (!descCell)
            {
                descCell = [[ServiceDetailDescriptionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceDetailDescriptionTableViewCell"];
            }
            
            [descCell setServiceDetail:serviceDetail];
            
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

- (void) serviceDetailLoaded:(ServiceDetail*) detail
{
    if (!detail)
    {
        return;
    }
    serviceDetail = detail;
    if (detail.img && 0 < detail.img)
    {
        [tableheaderview setImageUrl:detail.img];
    }
    
    [self.tableView reloadData];
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case DetailBaseInfoSection:
        {
            switch (indexPath.row)
            {
                case ServiceProviderIndex:
                {
                    //服务团队介绍
                    
                    [ServiceProviderDescViewController showInParentViewController:self.parentViewController ProviderDesc:serviceDetail.mainProviderDes];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
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
            [detail setUP_ID:upId];
            [self setServiceDetail:detail];
            [self serviceDetailLoaded:detail];
        }
    }
}

@end
