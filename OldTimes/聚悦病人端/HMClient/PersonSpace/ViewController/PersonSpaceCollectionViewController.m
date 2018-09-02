//
//  PersonSpaceCollectionViewController.m
//  HMClient
//
//  Created by lkl on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonSpaceCollectionViewController.h"
#import "PersonStartCollectionServiceHeaderView.h"
#import "PersonSpaceUserInfoCollectionViewCell.h"
#import "PersonSpaceServiceCollectionViewCell.h"
#import "PersonServiceComplainViewController.h"
#import "PersonCommentViewController.h"
#import "InitializationHelper.h"
#import "GetOnlineCustomServiceTask.h"
#import "OnlineCustomServiceModel.h"
#import "ChatSingleViewController.h"
typedef enum : NSUInteger {
    //PersonSpaceInfoSection,
    PersonSpaceServiceSection,
    PersonSpaceManagerSection,
    PersonSpaceSystemSection,
    PersonSpaceSectionCount,
} PersonSpaceCollectionSection;

typedef enum : NSUInteger {
    PersonManageDocumentIndex,
    PersonManageAppointmentIndex,
    PersonManageOrderIndex,
    PersonManageDeviceIndex,
    PersonManageRelativesIndex,
    PersonManageAttentionsIndex,
    PersonManageCollectionIndex,
    PersonManageCardIndex,
    PersonManageIndexCount,
} PersonSpaceManageIndex;

typedef enum : NSUInteger {
    PersonSystemAboutIndex,
    PersonSystemFeedbackIndex,
    PersonSystemOnLineIndex,            //在线客服
    PersonSystemIndexCount,
} PersonSpaceSystemIndex;

typedef NS_ENUM(NSUInteger, EPersonServiceStatus) {
    PersonService_None,             //没有服务
    PersonService_ValueAdded,       //只有增值服务
    PersonService_Package,          //有套餐服务
};

@interface PersonSpaceCollectionViewController ()
<TaskObserver>
{
    UserServiceInfo* userService;
    NSArray* serviceDets;
    NSDictionary *dicService;
    BOOL isAddedService;
    
    EPersonServiceStatus serviceStatus; //服务状态
    
    BOOL isOpen;
}
@end

@implementation PersonSpaceCollectionViewController

static NSString * const reuseIdentifier = @"PersonSpaceCollectionViewCell";
//static NSString * const personInfoReuseIdentifier = @"PersonSpaceUserInfoCollectionViewCell";
static NSString * const managerInfoReuseIdentifier = @"PersonSpaceManageCollectionViewCell";

static NSString * const serviceReuseIdentifier =  @"PersonSpaceServiceCollectionViewCell";
static NSString * const serviceAddedReuseIdentifier =  @"PersonSpaceAddedServiceCollectionViewCell";
static NSString * const noneServiceReuseIdentifier =  @"PersonSpaceNoneServiceCollectionViewCell";

static NSString *const HeaderIdentifier = @"HeaderIdentifier";
static NSString *const FooterIdentifier = @"FooterIdentifier";
//static NSString *const serviceHeaderIdentifier = @"PersonStartCollectionServiceHeaderView";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.backgroundColor = [UIColor whiteColor];
    //self.collectionView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
//    [self.collectionView registerClass:[PersonSpaceUserInfoCollectionViewCell class] forCellWithReuseIdentifier:personInfoReuseIdentifier];
    [self.collectionView registerClass:[PersonSpaceManageCollectionViewCell class] forCellWithReuseIdentifier:managerInfoReuseIdentifier];
    [self.collectionView registerClass:[PersonSpaceCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
   
    [self.collectionView registerClass:[PersonSpaceNoneServiceCollectionViewCell class] forCellWithReuseIdentifier:noneServiceReuseIdentifier];
    [self.collectionView registerClass:[PersonSpaceServiceCollectionViewCell class] forCellWithReuseIdentifier:serviceReuseIdentifier];
    [self.collectionView registerClass:[PersonSpaceAddedServiceCollectionViewCell class] forCellWithReuseIdentifier:serviceAddedReuseIdentifier];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
//    [self.collectionView registerClass:[PersonStartCollectionServiceHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:serviceHeaderIdentifier];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadUserService
{
    [[TaskManager shareInstance] createTaskWithTaskName:@"PersonServiceSummaryTask" taskParam:nil TaskObserver:self];
    
    /*NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:@[@"2"] forKey:@"status"];
    [self.collectionView.superview showWaitView];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"PersonServiceListTask" taskParam:dicPost TaskObserver:self];*/
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //PersonServiceListTask
}

// 获取客服列表
- (void)loadOnlineCustomServiceList {
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([GetOnlineCustomServiceTask class]) taskParam:nil TaskObserver:self];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    return PersonSpaceSectionCount;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section)
    {
        case PersonSpaceServiceSection:
            return 1;
            break;
        case PersonSpaceManagerSection:
            return PersonManageIndexCount;
            break;
        case PersonSpaceSystemSection:
            return PersonSystemIndexCount + (serviceStatus == PersonService_None ? 0 : 1);
            break;
        default:
            break;
    }
    return 0;
}

- (PersonSpaceCollectionViewCell*) serviceInfoCell:(NSIndexPath *)indexPath
{
    PersonSpaceCollectionViewCell *cell = nil;
    switch (serviceStatus)
    {
        case PersonService_None:
        {
            //没有服务
            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:noneServiceReuseIdentifier forIndexPath:indexPath];
            break;
        }
        case PersonService_ValueAdded:
        {
            //只有增值服务
            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:serviceAddedReuseIdentifier forIndexPath:indexPath];
            PersonSpaceAddedServiceCollectionViewCell* addedServiceCell = (PersonSpaceAddedServiceCollectionViewCell*) cell;
            if (dicService) {
                [addedServiceCell createUserServiceDets:dicService];
            }
            break;
        }
        case PersonService_Package:
        {
            //有套餐服务
            cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:serviceReuseIdentifier forIndexPath:indexPath];
            PersonSpaceServiceCollectionViewCell* serviceCell = (PersonSpaceServiceCollectionViewCell*) cell;
            if (dicService) {
                [serviceCell createUserServiceDets:dicService];
                break;
            }
            
        }
    }
    
    return cell;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PersonSpaceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    switch (indexPath.section)
    {
        case PersonSpaceServiceSection:
        {
            //服务信息Cell
            cell = [self serviceInfoCell:indexPath];
        }
            break;
        case PersonSpaceManagerSection:
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:managerInfoReuseIdentifier forIndexPath:indexPath];
            PersonSpaceManageCollectionViewCell* managerCell = (PersonSpaceManageCollectionViewCell*) cell;
            [managerCell setNoOpenImage:NO];
            switch (indexPath.row)
            {
                case PersonManageDocumentIndex:
                {
                    [managerCell setGirdImage:[UIImage imageNamed:@"ic_personspace_document"] GirdName:@"我的档案"];
                }
                    break;
                case PersonManageAppointmentIndex:
                {
                    [managerCell setGirdImage:[UIImage imageNamed:@"ic_personspace_appointment"] GirdName:@"我的约诊"];
                }
                    break;
                case PersonManageOrderIndex:
                {
                    [managerCell setGirdImage:[UIImage imageNamed:@"ic_personspace_order"] GirdName:@"我的订单"];
                }
                    break;
                case PersonManageDeviceIndex:
                {
                    [managerCell setGirdImage:[UIImage imageNamed:@"ic_personspace_device"] GirdName:@"我的设备"];
                }
                    break;
                case PersonManageRelativesIndex:
                {
                    [managerCell setGirdImage:[UIImage imageNamed:@"ic_personspace_relatives"] GirdName:@"我的亲友"];
                }
                    break;
                case PersonManageAttentionsIndex:
                {
                    [managerCell setGirdImage:[UIImage imageNamed:@"ic_personspace_attention"] GirdName:@"我的关注"];
                }
                    break;
                case PersonManageCollectionIndex:
                {
                    [managerCell setGirdImage:[UIImage imageNamed:@"ic_personspace_collections"] GirdName:@"我的收藏"];
                    [managerCell setNoOpenImage:YES];
                }
                    break;
                case PersonManageCardIndex:
                {
                    [managerCell setGirdImage:[UIImage imageNamed:@"ic_personspace_card"] GirdName:@"我的就诊卡"];
                    [managerCell setNoOpenImage:YES];
                }
                    break;
                
                default:
                    break;
            }
        }
            break;
        case PersonSpaceSystemSection:
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:managerInfoReuseIdentifier forIndexPath:indexPath];
            PersonSpaceManageCollectionViewCell* systemCell = (PersonSpaceManageCollectionViewCell*) cell;
             [systemCell setNoOpenImage:NO];
            /*
             PersonSystemAboutIndex,
             PersonSystemFeedbackIndex,
             PersonSystemOnLineIndex,            //在线客服
             PersonSystemIndexCount,
             */
            switch (indexPath.row)
            {
                case PersonSystemAboutIndex:
                {
                    [systemCell setGirdImage:[UIImage imageNamed:@"ic_personspace_about"] GirdName:@"关于我们"];
                }
                    break;
                case PersonSystemFeedbackIndex:
                {
                    [systemCell setGirdImage:[UIImage imageNamed:@"ic_personspace_feedback"] GirdName:@"意见反馈"];
                }
                    break;
                case PersonSystemOnLineIndex:
                {
                    [systemCell setGirdImage:[UIImage imageNamed:@"ic_personspace_online"] GirdName:@"在线客服"];
                }
                    break;
                case PersonSystemIndexCount:
                {
                    [systemCell setGirdImage:[UIImage imageNamed:@"ic_personspace_feedback"] GirdName:@"服务投诉"];
                }
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
//    [cell setImage:[UIImage imageNamed:@"icon_device"]];
//    [cell setName:@"我的设备"];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    switch (indexPath.section)
    {
        case PersonSpaceServiceSection:
        {
            InitializationHelper* helper = [InitializationHelper defaultHelper];
//            if (!helper.userHasService)
            switch (serviceStatus) {
                case PersonService_None:
                    size = CGSizeMake(self.collectionView.width, 60);
                    break;
                case PersonService_ValueAdded:
                    size = CGSizeMake(self.collectionView.width, 85);
                    break;
                case PersonService_Package:
                    size = CGSizeMake(self.collectionView.width, 125);
                    break;
                default:
                    break;
            }
            
        }
            break;
        case PersonSpaceManagerSection:
        case PersonSpaceSystemSection:
        {
            
            size = CGSizeMake(80 * kScreenScale, 94);
        }
            break;
        default:
            break;
    }
    
    return size;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    CGFloat height = 0;
    switch (section)
    {
        case PersonSpaceServiceSection:
        {
            height = 0;
        }
            break;
            
        default:
            break;
    }
    return CGSizeMake(320 * kScreenScale, height);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    
    CGFloat height = 0;
    switch (section)
    {
//        case PersonSpaceInfoSection:
//        {
//            height = 0;
//        }
//            break;
            
        default:
            height = 5;
            break;
    }
    return CGSizeMake(320 * kScreenScale, height);
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *headReusableView;
    
    //此处是headerView
    
    if (kind == UICollectionElementKindSectionHeader) {
    
        headReusableView = (UICollectionReusableView*)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        //        [headReusableView setBackgroundColor:[UIColor redColor]];
        //
        /*
        switch (indexPath.section)
        {
            case PersonSpaceServiceSection:
            {
                headReusableView = (PersonStartCollectionServiceHeaderView*)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:serviceHeaderIdentifier forIndexPath:indexPath];
            }
                break;
            
            default:
                break;
        }
         */
    }
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        headReusableView = (UICollectionReusableView*)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FooterIdentifier forIndexPath:indexPath];
        [headReusableView setBackgroundColor:[UIColor commonBackgroundColor]];
    }
    
    return headReusableView;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case PersonSpaceManagerSection:
        {
            switch (indexPath.row)
            {
                case PersonManageDocumentIndex:
                {
                    //健康档案
                    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－我的档案"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"HealthDocutmentStartViewController" ControllerObject:nil];
                }
                    break;
                case PersonManageAppointmentIndex:
                {
                    //我的约诊
                    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－我的约诊"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"AppointmentListViewController" ControllerObject:nil];
                }
                    break;
                case PersonManageOrderIndex:
                {
                    //我的订单
                    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－我的订单"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"OrderListStartViewController" ControllerObject:nil];
                }
                    break;
                case PersonManageDeviceIndex:
                {
                    //设备管理
                    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－我的设备"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"DeviceManagerViewController" ControllerObject:nil];
                }
                    break;
                    
                case PersonManageRelativesIndex:
                {
                    //我的好友
                    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－我的亲友"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"FriendsStartViewController" ControllerObject:nil];
                }
                    break;
                    
                case PersonManageAttentionsIndex:
                {
                    //我的关注
                    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－我的关注"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"AttentionListStartViewController" ControllerObject:nil];
                }
                    break;

                default:
                    break;
            }
        }
            break;
        case PersonSpaceSystemSection:
        {
            switch (indexPath.row)
            {
                case PersonSystemAboutIndex:
                {
                    //关于我们 HMAboutViewController
                    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－关于我们"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"HMAboutViewController" ControllerObject:nil];
                }
                    break;
                    
                case PersonSystemFeedbackIndex:
                {
                    //意见反馈
                    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的-意见反馈"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"PersonSpaceFeedbackViewController" ControllerObject:nil];
                }
                    break;
                case PersonSystemOnLineIndex:
                {
                    //在线客服
                    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的-在线客服"];
                    [self loadOnlineCustomServiceList];
                }
                    break;
                case PersonSystemIndexCount:
                {
                   //服务投诉
                    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的-服务投诉"];
                    [HMViewControllerManager createViewControllerWithControllerName:@"PersonServiceComplainViewController" ControllerObject:nil];
                    
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

#pragma mark - TaskObservice
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    
    if (StepError_None != taskError)
    {
        [self.collectionView.superview closeWaitView];
        [self showAlertMessage:errorMessage];
        return;
    }
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
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
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
 
    
    if ([taskname isEqualToString:@"PersonServiceSummaryTask"])
    {
//        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
//        {
//            serviceDets = (NSArray*) taskResult;
//            [self.collectionView reloadData];
//        }
        
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]]) {
            
            dicService = (NSDictionary*)taskResult;
            //如果productName为空，是增值服务
            NSString* productName = [dicService objectForKey:@"productName"];
            NSArray* serviceDetsItems = [dicService valueForKey:@"serviceDets"];
            if (!serviceDetsItems || serviceDetsItems.count == 0) {
                //没有服务
                serviceStatus = PersonService_None;
            }
            else if (!productName || productName.length == 0) {
               // 只有增值服务
                serviceStatus = PersonService_ValueAdded;
            }
            else
            {
                //有套餐服务
                serviceStatus = PersonService_Package;
            }
            [self.collectionView reloadData];
        }
        else {
            serviceStatus = PersonService_None;
            [self.collectionView reloadData];
        }
    }
    else if ([taskname isEqualToString:NSStringFromClass([GetOnlineCustomServiceTask class])]) {
        // 在线客服
        if ([taskResult isKindOfClass:[NSArray class]]) {
            NSArray *result = taskResult;
            if (result.count == 0) {
                return;
            }
            OnlineCustomServiceModel *sourceModel = result.firstObject;
            ContactDetailModel *model = [ContactDetailModel new];
            model._target = [NSString stringWithFormat:@"%ld",sourceModel.userName];
            model._nickName = sourceModel.nickName;
            model._headPic = sourceModel.avatar;
            ChatSingleViewController *VC  = [[ChatSingleViewController alloc] initWithDetailModel:model];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}
@end
