//
//  ServiceDetailTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceDetailTableViewController.h"
#import "ServiceInfo.h"
#import "ServiceDetailTableViewCell.h"
#import "ServiceOptionSelectedViewController.h"
#import "ServiceNeedMessageViewController.h"
#import "ServiceProviderDescViewController.h"
#import "ServiceOrderConfrimTableViewController.h"
#import "ServiceOrder.h"
#import "HMSecondEditionServiceOrderConfrimViewController.h"
#import "ServiceShareViewController.h"

@interface ServiceDetailStartViewController ()
<TaskObserver>
{
    ServiceDetailTableViewController* tvcDetail;
    ServiceInfo* serviceInfo;
    UIButton* purchasebutton;       //购买按钮
    ServiceOrder* serviceOrder;
}
@end

@implementation ServiceDetailStartViewController

- (void) dealloc
{
    if (tvcDetail)
    {
        [tvcDetail removeObserver:self forKeyPath:@"serviceDetail"];
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"服务详情"];
    if (self.paramObject && [self.paramObject isKindOfClass:[ServiceInfo class]])
    {
        //NSDictionary* dicParam = (NSDictionary*) self.paramObject;
        //serviceInfo = [ServiceInfo mj_objectWithKeyValues:dicParam];
        serviceInfo = (ServiceInfo*)self.paramObject;
        if (serviceInfo.productName)
        {
            [self.navigationItem setTitle:serviceInfo.productName];
        }
    }
    
    

    
    purchasebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:purchasebutton];
    [purchasebutton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 40) Color:[UIColor commonLightGrayTextColor]]  forState:UIControlStateNormal];
    //[purchasebutton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 40) Color:[UIColor commonLightGrayTextColor]] forState:UIControlStateDisabled];
    [purchasebutton setTitle:@"立即购买" forState:UIControlStateNormal];
    [purchasebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [purchasebutton.titleLabel setFont:[UIFont font_30]];
    [purchasebutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.view);
    }];
    
    [purchasebutton addTarget:self action:@selector(purchasebuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self createDetailTable];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (tvcDetail.serviceDetail)
    {
        [self purchasebuttonStatus:tvcDetail.serviceDetail.service_status];
    }
}

- (void) createShareButton
{
    //分享按钮
    UIButton* shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"ic_share"]
                 forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareBarButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    shareButton.frame = CGRectMake(0, 0, 22, 20);
    
    UIBarButtonItem* shareBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    [self.navigationItem setRightBarButtonItem:shareBarButton];
}

- (void) createDetailTable
{
    tvcDetail = [[ServiceDetailTableViewController alloc]initWithServiceUpID:serviceInfo.upId];
    [self addChildViewController:tvcDetail];
    
    [self.view addSubview:tvcDetail.tableView];
    [tvcDetail.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(purchasebutton.mas_top);
    }];
    
    [tvcDetail addObserver:self forKeyPath:@"serviceDetail" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void) shareBarButtonClicked:(id) sender
{
    [ServiceShareViewController showInParentController:self ServiceInfo:serviceInfo];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"serviceDetail"])
    {
        ServiceDetail* detail = [object valueForKey:@"serviceDetail"];
        [self.navigationItem setTitle:detail.comboName];
        [self purchasebuttonStatus:detail.service_status];
        serviceInfo.salePrice = detail.salePrice;
        serviceInfo.productName = detail.comboName;
        serviceInfo.desc = detail.productDes;
        [self createShareButton];
    }
}
- (void) purchasebuttonStatus:(NSInteger) status
{
    //商品服务
    /*if ([serviceInfo isGoods]) {
        
       [purchasebutton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 40) Color:[UIColor mainThemeColor]]  forState:UIControlStateNormal];
        return;
    }*/
    
    switch (status)
    {
        case 0:
        {
            //可订购服务
            //[purchasebutton setTitle:@"立即购买" forState:UIControlStateNormal];
            //[purchasebutton setEnabled:YES];
            [purchasebutton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 40) Color:[UIColor mainThemeColor]]  forState:UIControlStateNormal];
        }
            break;
            
        case 1:
        {
            //已订购
            //[purchasebutton setTitle:@"立即购买" forState:UIControlStateNormal];
            //[purchasebutton setEnabled:YES];
            [purchasebutton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 40) Color:[UIColor commonLightGrayTextColor]] forState:UIControlStateNormal];
        }
            break;
            
        case 2:
        {
            //库存不足，不可订购
            //[purchasebutton setTitle:@"立即购买" forState:UIControlStateNormal];
            //[purchasebutton setEnabled:YES];
            [purchasebutton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 40) Color:[UIColor commonLightGrayTextColor]] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }

}

- (void) purchasebuttonClicked:(id) sender
{
    if (5 == serviceInfo.classify) {
        //增值服务
    }
    else if (tvcDetail.serviceDetail.service_status == 1 || tvcDetail.serviceDetail.service_status == 2)
    {
        UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:nil message:tvcDetail.serviceDetail.alert_msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"我知道了！" style:UIAlertActionStyleCancel handler:nil];
        [alterVC addAction:cancel];
        [self presentViewController:alterVC animated:YES completion:nil];
        return;
    }
    
    //获取服务必填项
    NSArray* idList = [tvcDetail  serviceProductIDList];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:idList forKey:@"productIds"];
    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"ServiceNeedMsgsTask" taskParam:dicPost TaskObserver:self];
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }

    if ([taskname isEqualToString:@"CreateServiceOrderTask"])
    {
        //跳转到订单详情页面
        if (serviceOrder)
        {
            [HMViewControllerManager createViewControllerWithControllerName:@"OrderDetailStartViewController" ControllerObject:[NSString stringWithFormat:@"%ld", serviceOrder.orderId]];
        }
        
        //刷新用户服务
        [[TaskManager shareInstance] createTaskWithTaskName:@"CheckUserServiceTask" taskParam:nil TaskObserver:self];
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
    
    if ([taskname isEqualToString:@"ServiceNeedMsgsTask"])
    {
        [self purchasebuttonStatus:1];
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* needMsgs = (NSArray*) taskResult;
            if (needMsgs && 0 < needMsgs.count)
            {
                //需要填写服务必备信息
                ServiceNeedMessageViewController* vcNeedMsg = (ServiceNeedMessageViewController*)[HMViewControllerManager createViewControllerWithControllerName:@"ServiceNeedMessageViewController" ControllerObject:needMsgs];
                [vcNeedMsg setServiceDetail:tvcDetail.serviceDetail];
                return;
            }
            else
            {
                //不需要填写服务必备信息
                if (0 == tvcDetail.serviceDetail.salePrice)
                {
                    //免费服务，不需要跳转到订单确认页面
                    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
                    [dicPost setValue:[NSNumber numberWithInteger:tvcDetail.serviceDetail.UP_ID]  forKey:@"upId"];
                    [dicPost setValue:@"SERVICE" forKey:@"orderTypeCode"];
                    [dicPost setValue:@"IOS" forKey:@"sourceCode"];
                    NSMutableArray* options = [NSMutableArray array];
                    
                    if (tvcDetail.serviceDetail.isMustYes)
                    {
                        for (ServiceDetailOption* option in tvcDetail.serviceDetail.isMustYes)
                        {
                            NSDictionary* dicOption = [option mj_keyValues];
                            [options addObject:dicOption];
                        }
                    }
                    if (tvcDetail.serviceDetail.selectMust)
                    {
                        for (ServiceDetailOption* option in tvcDetail.serviceDetail.selectMust)
                        {
                            NSDictionary* dicOption = [option mj_keyValues];
                            [options addObject:dicOption];
                        }
                    }
                    
                    if (0 < options.count) {
                        [dicPost setValue:options forKey:@"orderBusinessDets"];
                    }
                    
                    [self.view showWaitView];
                    //直接创建订单
                    [[TaskManager shareInstance] createTaskWithTaskName:@"CreateServiceOrderTask" taskParam:dicPost TaskObserver:self];
                    return;
                }
            }
        }
        else
        {
            if (0 == tvcDetail.serviceDetail.salePrice)
            {
                //免费服务，不需要跳转到订单确认页面
                NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
                [dicPost setValue:[NSNumber numberWithInteger:tvcDetail.serviceDetail.UP_ID]  forKey:@"upId"];
                [dicPost setValue:@"SERVICE" forKey:@"orderTypeCode"];
                [dicPost setValue:@"IOS" forKey:@"sourceCode"];
                NSMutableArray* options = [NSMutableArray array];
                
                if (tvcDetail.serviceDetail.isMustYes)
                {
                    for (ServiceDetailOption* option in tvcDetail.serviceDetail.isMustYes)
                    {
                        NSDictionary* dicOption = [option mj_keyValues];
                        [options addObject:dicOption];
                    }
                }
                if (tvcDetail.serviceDetail.selectMust)
                {
                    for (ServiceDetailOption* option in tvcDetail.serviceDetail.selectMust)
                    {
                        NSDictionary* dicOption = [option mj_keyValues];
                        [options addObject:dicOption];
                    }
                }
                
                if (0 < options.count) {
                    [dicPost setValue:options forKey:@"orderBusinessDets"];
                }

                [self.view showWaitView];
                //直接创建订单
                [[TaskManager shareInstance] createTaskWithTaskName:@"CreateServiceOrderTask" taskParam:dicPost TaskObserver:self];
                return;
            }
//            ServiceOrderConfrimStartViewController* vcOrderConfirm = (ServiceOrderConfrimStartViewController*)[HMViewControllerManager createViewControllerWithControllerName:@"ServiceOrderConfrimStartViewController" ControllerObject:nil];
//            [vcOrderConfirm setServiceDetail:tvcDetail.serviceDetail];

            HMSecondEditionServiceOrderConfrimViewController *VC = [[HMSecondEditionServiceOrderConfrimViewController alloc] initWithServiceDetail:tvcDetail.serviceDetail];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    
    if ([taskname isEqualToString:@"CreateServiceOrderTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[ServiceOrder class]])
        {
            serviceOrder = (ServiceOrder*) taskResult;
        }
    }
    
}

@end




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
    
    tableheaderview = [[ServiceDetailTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, self.tableView.width * 0.4)];
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
            [lbTitle setFont:[UIFont font_30]];
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
            
            [optionControl addTarget:self action:@selector(serviceOptionControlClicked:) forControlEvents:UIControlEventTouchUpInside];
            
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
            [lbTitle setFont:[UIFont font_30]];
            [lbTitle setText:@"自选项目"];
            [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(optionControl);
                make.left.equalTo(ivLine.mas_right).with.offset(3);
            }];

            UIImageView* icArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_x_arrows"]];
            [optionControl addSubview:icArrow];
            [icArrow mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(optionControl);
                make.right.equalTo(optionControl).with.offset(-12.5);
                make.size.mas_equalTo(CGSizeMake(7, 14));
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
            if (selectedOptions)
            {
                return selectedOptions.count;
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
            
            CGFloat cellHeight = 20 + [serviceDetail.productDes heightSystemFont:[UIFont font_26] width:self.tableView.width - 25];
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
            
            ServiceDetailOption* option = selectedOptions[indexPath.row];
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

- (void) serviceOptionControlClicked:(id) sender
{
    [ServiceOptionSelectedViewController showSelectOptionView:selectedOptions
                                               ServiceOptions:serviceDetail.isMustNo
                               SelectOptionSelectOptionsBlock:^(NSArray *selectedItems)
    {
         selectedOptions = [NSMutableArray arrayWithArray:selectedItems];
        
        [serviceDetail setSelectMust:selectedOptions];
         [self.tableView reloadData];
     }];
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
