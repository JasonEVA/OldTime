//
//  MainStartFuncViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/4.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MainStartFuncViewController.h"
#import "StartFuncInfo.h"
#import "ATModuleInteractor+CoordinationInteractor.h"
#import "HMDoctorConcernViewController.h"
#import "ATModuleInteractor+PatientChat.h"

@interface MainStartFuncCell : UIControl
{
    UIImageView* ivIcon;
    UILabel* lbName;
    UIImageView* ivNoOpen;
}

- (void) setStartFunc:(StartFuncInfo*) funcInfo;
@end

@implementation MainStartFuncCell

- (id) init
{
    self = [super init];
    if (self)
    {
        ivIcon = [[UIImageView alloc]init];
        [self addSubview:ivIcon];
        
        lbName = [[UILabel alloc]init];
        [self addSubview:lbName];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setTextColor:[UIColor whiteColor]];
        [lbName setFont:[UIFont systemFontOfSize:13]];
        [lbName setTextAlignment:NSTextAlignmentCenter];
        
        ivNoOpen = [[UIImageView alloc] init];
        [self addSubview:ivNoOpen];
        [ivNoOpen setImage:[UIImage imageNamed:@"icon_no_open_1"]];

        [self subviewsLayout];
    }
    return self;
}

- (void) subviewsLayout
{
    [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.top.equalTo(self).with.offset(8);
        make.centerX.equalTo(self);
    }];
    
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(@17);
        make.top.equalTo(ivIcon.mas_bottom).with.offset(5);
    }];
    
    [ivNoOpen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(ivIcon).with.offset(-8);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
}

- (void) setStartFunc:(StartFuncInfo*) funcInfo
{
    [lbName setText:funcInfo.funcName];
    [ivIcon setImage:[UIImage imageNamed:funcInfo.funcIconName]];
    [ivNoOpen setHidden:funcInfo.isValid];
}

@end

@interface MainStartFuncViewController ()<UIScrollViewDelegate>
{
    UIScrollView* scrollview;
    NSInteger showPageNum;
    StartFuncInfoHelper* funcHelper;
    NSMutableArray* funcItems;
    NSMutableArray* funcCells;
}
@end

@implementation MainStartFuncViewController

- (void) loadView
{
    scrollview = [[UIScrollView alloc]init];
    [self setView:scrollview];
    [scrollview setDelegate:self];
    [scrollview setPagingEnabled:YES];
    [scrollview setShowsHorizontalScrollIndicator:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    funcHelper = [[StartFuncInfoHelper defaultHelper] init];
    [self refreshFuncInfoCells];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor mainThemeColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -计算scrollView显示几页
-(void)calculationOfPageNum
{
    if (funcItems.count%8 != 0)
    {
        showPageNum = funcItems.count/8+1;
    }else
    {
        showPageNum = funcItems.count/8;
    }
}

- (void) refreshFuncInfoCells
{
    NSArray* items = [funcHelper startFuncItems];
    funcItems = [NSMutableArray arrayWithArray:items];

    //添加自定义
    StartFuncInfo* customFunc = [[StartFuncInfo alloc]init];
    [customFunc setIsMust:YES];
    [customFunc setIsValid:YES];
    [customFunc setFuncIndex:StartFunc_Custom];
    [customFunc setFuncName:@"自定义"];
    [customFunc setFuncIconName:@"img_main_more"];
    [funcItems addObject:customFunc];
    
    [self calculationOfPageNum];
    
    [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    if (!funcCells)
    {
        funcCells = [NSMutableArray array];
    }
    for (MainStartFuncCell* cell in funcCells)
    {
        [cell removeFromSuperview];
    }
    
    [funcCells removeAllObjects];
    
    for (NSInteger index = 0; index < funcItems.count; ++index)
    {
        MainStartFuncCell* cell = [[MainStartFuncCell alloc]init];
        CGRect cellFrame = [self frameOfCell:index];
        [scrollview addSubview:cell];
        [funcCells addObject:cell];
        [cell setStartFunc:funcItems[index]];

        if (index < 8)
        {
            //NSLog(@"--%f",cellFrame.origin.x);
            [scrollview setContentSize:CGSizeMake(showPageNum*ScreenWidth, 0)];
            
            [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).with.offset(cellFrame.origin.x);
                make.top.equalTo(self.view).with.offset(cellFrame.origin.y);
                make.size.mas_equalTo(cellFrame.size);
            }];
            
        }else{
            
            [scrollview setContentSize:CGSizeMake(showPageNum*ScreenWidth, 0)];

            //NSLog(@"%f  %f",cellFrame.origin.x,ScreenWidth);
            [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(scrollview).with.offset((showPageNum-1)*ScreenWidth-80*kScreenScale+cellFrame.origin.x);
                make.top.equalTo(self.view).with.offset(cellFrame.origin.y);
                make.size.mas_equalTo(cellFrame.size);
            }];
            
        }

        [cell addTarget:self action:@selector(funcCellClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (CGRect) frameOfCell:(NSInteger) index
{
    CGFloat cellWidth = kScreenWidth / 4;
    CGFloat left = ((index / 8) + (index % 4)) * cellWidth;
    
    
    NSInteger mod = (index / 4)%2;
    CGFloat top = 145.0/2 * mod;
    
    CGRect rtCell = CGRectMake(left, top, cellWidth, 145.0/2);
    return rtCell;
}

- (void) funcCellClicked:(id) sender
{
    if (![sender isKindOfClass:[MainStartFuncCell class]])
    {
        return;
    }
    
    MainStartFuncCell* cell = (MainStartFuncCell*)sender;
    NSInteger index = [funcCells indexOfObject:cell];
    if (NSNotFound == index)
    {
        return;
    }
    
    StartFuncInfo* funcInfo = funcItems[index];
    if (!funcInfo.isValid)
    {
        //没开通
        return;
    }
    
    [self cellFuncWithIndex:funcInfo.funcIndex];
}

- (void) cellFuncWithIndex:(NSInteger) index
{
    switch (index)
    {
        case StartFunc_PatientsFree:
        {
            //我的患者 跳转到我的患者界面
            [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－随访用户"];
            [[ATModuleInteractor sharedInstance] goPatientListVCWithPatientFilterViewType:PatientFilterViewTypeFree];

        }
            break;
        case StartFunc_PatientsCharge:
        {
            //我的患者 跳转到我的患者界面
            [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－收费用户"];
            [[ATModuleInteractor sharedInstance] goPatientListVCWithPatientFilterViewType:PatientFilterViewTypeCharge];

            break;
        }

        case StartFunc_Prescription:
        {
            [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－开处方"];
            BOOL processPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreatePrescriptionMode Status:0xFF OperateCode:kPrivilegeProcessOperate];
            if (!processPrivilege)
            {
                [self showAlertMessage:@"对不起，您没有该权限。"];
                return;
            }
            //开处方
            [HMViewControllerManager createViewControllerWithControllerName:@"NewPrescribeSelectPatientViewController" ControllerObject:nil];
        }
            break;
        case StartFunc_Interrogation:
        {
            //问诊表
            [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－问诊表"];
            BOOL processPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateInterrogationtMode Status:0xFF OperateCode:kPrivilegeProcessOperate];
            if (!processPrivilege)
            {
                [self showAlertMessage:@"对不起，您没有该权限。"];
                return;
            }
            
            [HMViewControllerManager createViewControllerWithControllerName:@"InterrogationStartViewController" ControllerObject:nil];
        }
            break;
        case StartFunc_Survey:
        {
            //随访
            [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－随访表"];
            BOOL processPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeCreateSurveytMode Status:0xFF OperateCode:kPrivilegeProcessOperate];
            if (!processPrivilege)
            {
                [self showAlertMessage:@"对不起，您没有该权限。"];
                return;
            }
            [HMViewControllerManager createViewControllerWithControllerName:@"SurveryStartViewController" ControllerObject:nil];
        }
            break;
            
        case StartFunc_Concern: {
            //医生关怀
            [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"医生关怀"];
            HMDoctorConcernViewController *VC = [HMDoctorConcernViewController new];
            [self.navigationController pushViewController:VC animated:YES];
            
            break;
        }
        case StartFunc_Workgroup:
        {
            //工作组
            [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－工作组"];
            //[[ATModuleInteractor sharedInstance] goTaskList];
            [[HMViewControllerManager defaultManager].tabRoot setSelectedIndex:2];
        }
            break;
            
        case StartFunc_Nutrition:
        {
            //营养库
            [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－营养库"];
            [HMViewControllerManager createViewControllerWithControllerName:@"NutritionLibsStartViewController" ControllerObject:nil];
        }
            break;
            
        case StartFunc_Custom:
        {
            //自定义
            [[ActionStatusManager shareInstance] addActionStatusWithPageName:@"工作台－自定义"];
            [HMViewControllerManager createViewControllerWithControllerName:@"MainStartCustomFuncViewController" ControllerObject:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark --UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MainStartScroll" object:nil];
}
@end
