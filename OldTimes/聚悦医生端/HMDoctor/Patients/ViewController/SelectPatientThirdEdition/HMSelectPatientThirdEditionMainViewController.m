//
//  HMSelectPatientThirdEditionMainViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2016/11/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMSelectPatientThirdEditionMainViewController.h"
#import "CoordinationFilterView.h"
#import "HMSelectPatientThirdEditionWithTeamViewController.h"
#import "HMSelectPatientThirdEditionBottomView.h"
#import "HMSelectPatientThirdEditionLetterOrderTableViewController.h"
#import "IMNewsModel.h"
#import "NewPatientListInfoModel.h"
#import "NewPatientGroupListInfoModel.h"
#import "DAOFactory.h"

//#import "HMSelectPatientThirdEditionFeeTableViewController.h"

#define DEFAULTMAXSELECTNUM        50
typedef NS_ENUM(NSUInteger, PatientSelectedVCType) {
    
    PatientSelectedVCType_Team,   //按团队
    
    PatientSelectedVCType_Letter, //按字母
    
    PatientSelectedVCType_Cost     //按费用

};

typedef NS_ENUM(NSUInteger, PayMentType) {
    
    PayMentType_Free = 1,  //免费

    PayMentType_Pay    //收费
    
};

@interface HMSelectPatientThirdEditionMainViewController ()<CoordinationFilterViewDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource,HMSelectPatientThirdEditionBottomViewDelegate,HMSelectPatientThirdEditionWithTeamViewControllerDelegate,HMSelectPatientThirdEditionLetterOrderTableViewControllerDelegate>
@property (nonatomic, strong)  CoordinationFilterView  *filterView; // <##>
@property (nonatomic, strong)  UIPageViewController  *pageViewController; //
@property (nonatomic, strong)  HMSelectPatientThirdEditionWithTeamViewController *withTeamSelectVC;    //按团队
@property (nonatomic, strong)  HMSelectPatientThirdEditionLetterOrderTableViewController *letterOrderSelectVC;  //按字母
@property (nonatomic, strong)  HMSelectPatientThirdEditionBottomView *bottomView;
@property (nonatomic)  PatientSelectedVCType selectedVC;
@property (nonatomic, strong)  NSArray *patientsSourceData;   //服务器请求到的原数据
@property (nonatomic, copy) PatientSelectedBlock selectedBlock;
@property (nonatomic, copy) NSString *sentTitel;
@end

@implementation HMSelectPatientThirdEditionMainViewController


- (instancetype)initWithSendTitel:(NSString *)titel selectedMember:(NSMutableArray<NewPatientListInfoModel *> *)selectedMember{
    if (self = [super init]) {
        if (titel && titel.length) {
            self.sentTitel = titel;
        }
        else {
            self.sentTitel = @"确定";
        }
        if (selectedMember && selectedMember.count) {
            self.allSelectedPatients = [NSMutableArray arrayWithArray:selectedMember];
        }
        else {
            self.allSelectedPatients = [NSMutableArray array];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.patientsSourceData = @[];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"排序" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    
//    [self.navigationItem setRightBarButtonItem:rightBtn];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.pageViewController didMoveToParentViewController:self];
    [self startPatientRequest];
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -private method
//数据源请求
- (void)startPatientRequest {
    [self at_postLoading];
    __weak typeof(self) weakSelf = self;
    
    [_DAO.patientInfoListDAO requestPatientListImmediately:NO CompletionHandler:^(BOOL success, NSString *errorMsg, NSArray<NewPatientListInfoModel *> *results) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf at_hideLoading];
        
        if (success) {
            NSArray* patients = results;
            __block NSMutableArray<NewPatientGroupListInfoModel *> *tempGroups = [NSMutableArray array];
            [patients enumerateObjectsUsingBlock:^(NewPatientListInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                __block BOOL isExist = NO;
                [tempGroups enumerateObjectsUsingBlock:^(NewPatientGroupListInfoModel * _Nonnull groupObj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.teamId.integerValue == groupObj.teamId) {
                        [groupObj.users addObject:obj];
                        isExist = YES;
                        *stop = YES;
                        return;
                    }
                }];
                
                if (isExist) {
                    return;
                }
                
                NewPatientGroupListInfoModel *groupModel = [NewPatientGroupListInfoModel new];
                groupModel.teamName = obj.teamName;
                groupModel.teamId = obj.teamId.integerValue;
                [groupModel.users addObject:obj];
                [tempGroups addObject:groupModel];
                
                
            }];
            [strongSelf.navigationItem.rightBarButtonItem setEnabled:YES];
            strongSelf.patientsSourceData = tempGroups;
            [strongSelf configData];

        }
        else {
            [strongSelf showAlertMessage:errorMsg];
        }
        
    }];

}

//获取剔除了历史订购的数组
- (NSMutableArray *)withoutHistoryArray {
    NSMutableArray *array = [NSMutableArray array];
    [self.patientsSourceData enumerateObjectsUsingBlock:^(NewPatientGroupListInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //筛选掉历史分组
        if (obj.teamId != 0) {
            [array addObjectsFromArray:obj.users];
        }
    }];
    return array;
}
// 免费患者
- (NSMutableArray *)freePatitentArray {
    NSMutableArray *temp = [NSMutableArray array];
    [[self withoutHistoryArray] enumerateObjectsUsingBlock:^(NewPatientListInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.paymentType == PayMentType_Free) {
            [temp addObject:obj];
        }
    }];
    return temp;
}
//付费患者
- (NSMutableArray *)payPatitentArray {
    NSMutableArray *temp = [NSMutableArray array];
    [[self withoutHistoryArray] enumerateObjectsUsingBlock:^(NewPatientListInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.paymentType == PayMentType_Pay) {
            [temp addObject:obj];
        }
    }];
    return temp;
}
//获取根据费用分组数据源
- (NSArray *)differentiatePatitentWithCost {
    NewPatientGroupListInfoModel *freeGroup = [NewPatientGroupListInfoModel new];
    freeGroup.teamName = @"免费用户";
    freeGroup.teamId = 10000;
    freeGroup.users = [self freePatitentArray];
    
    NewPatientGroupListInfoModel *payGroup = [NewPatientGroupListInfoModel new];
    payGroup.teamName = @"付费用户";
    payGroup.teamId = 10001;
    payGroup.users = [self payPatitentArray];
    return @[payGroup,freeGroup];
}

- (void)changeBottomWithArray:(NSMutableArray *)array {
    self.allSelectedPatients = array;
    [self.bottomView.sendBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",self.sentTitel,self.allSelectedPatients.count] forState:UIControlStateNormal];
    
    NSSet *selectedSet = [NSSet setWithArray:[self acquireUserIdArrWithArr:self.allSelectedPatients]];
    NSSet *groupSet = [NSSet setWithArray:[self acquireUserIdArrWithArr:[self withoutHistoryArray]]];
    
    [self.bottomView.selectBtn setSelected:[groupSet isSubsetOfSet:selectedSet]];
}

- (NSMutableArray *)acquireUserIdArrWithArr:(NSArray<NewPatientListInfoModel *> *)array {
    NSMutableArray *tempGroup = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NewPatientListInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempGroup addObject:@(obj.userId)];
    }];
    return tempGroup;
}
- (NSInteger)acquireMaxSelected {
    return self.maxSelectedNum ?:DEFAULTMAXSELECTNUM;
}
#pragma mark - event Response
- (void)rightClick {
    [self.withTeamSelectVC hideSearchVC];
    [self.letterOrderSelectVC hideSearchVC];
    
    if (![self.view.subviews containsObject:self.filterView]) {
        [self.view addSubview:self.filterView];
        [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    else {
        [self.filterView removeFromSuperview];
        _filterView = nil;
    }

}
#pragma mark - HMSelectPatientThirdEditionBottomViewDelegate
- (void)HMSelectPatientThirdEditionBottomViewDelegateCallBack_buttonClick:(UIButton *)button {
    if (button.tag) {
        //发送
        if (self.selectedBlock) {
            self.selectedBlock(self.allSelectedPatients);
        }
    }
    else {
        //全选
        
        
        if ([self withoutHistoryArray].count > [self acquireMaxSelected]) {
            [self.view showAlertMessage:[NSString stringWithFormat:@"选择人数不可超过%ld人",[self acquireMaxSelected]]];
            return;
        }
        
        button.selected ^= 1;
        __weak typeof(self) weakSelf = self;

        [[self withoutHistoryArray] enumerateObjectsUsingBlock:^(NewPatientListInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;

            if (button.selected) {
                if (![[strongSelf acquireUserIdArrWithArr:strongSelf.allSelectedPatients ] containsObject:@(obj.userId)]) {
                    [strongSelf.allSelectedPatients addObject:obj];
                }
            }
            else {
                [strongSelf.allSelectedPatients enumerateObjectsUsingBlock:^(NewPatientListInfoModel *patientObj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (patientObj.userId == obj.userId) {
                        [strongSelf.allSelectedPatients removeObject:patientObj];
                    }
                }];
            }
            
        }];

        switch (self.selectedVC) {
            case PatientSelectedVCType_Team:
            case PatientSelectedVCType_Cost:
            {
                //按团队
                
                [self.withTeamSelectVC.patientGroups enumerateObjectsUsingBlock:^(NewPatientGroupListInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.isAllSelected = button.selected;
                }];
                [self.withTeamSelectVC reloadTeamVCWithArray:self.allSelectedPatients];
                
                break;
            }
                
            case PatientSelectedVCType_Letter:
            {
                //按字母
                [self.letterOrderSelectVC reloadLetterVCWithArray:self.allSelectedPatients];
                
                
                break;
            }
            default:
                break;
        }
        [self.bottomView.sendBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",self.sentTitel,self.allSelectedPatients.count] forState:UIControlStateNormal];
        
    }
}

#pragma mark - HMSelectPatientThirdEditionWithTeamViewControllerDelegate
- (void)HMSelectPatientThirdEditionWithTeamViewControllerDelegateCallBack_selectedPatientChanged {
    [self changeBottomWithArray:self.withTeamSelectVC.selectedPatients];
    
}
#pragma mark - HMSelectPatientThirdEditionLetterOrderTableViewControllerDelegate
-(void)HMSelectPatientThirdEditionLetterOrderTableViewControllerDelegateCallBack_letterSelectedPatientChanged {
    [self changeBottomWithArray:self.letterOrderSelectVC.letterSelectedPatients];
}

#pragma mark - PageViewControllerDataSource && Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
}

#pragma mark - CoordinationFilterViewDelegate
- (void)CoordinationFilterViewDelegateCallBack_ClickWithTag:(NSInteger)tag
{
    if (self.selectedVC == tag) {
        return;
    }
    switch (tag) {
        case PatientSelectedVCType_Team:
        {
            //团队
            [self.withTeamSelectVC fillDataWithArray:self.patientsSourceData];
            __weak typeof(self) weakSelf = self;
            [self.withTeamSelectVC.patientGroups enumerateObjectsUsingBlock:^(NewPatientGroupListInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                NSMutableSet *groupSet = [NSMutableSet setWithArray:[strongSelf acquireUserIdArrWithArr:obj.users]];
                NSMutableSet *allSet = [NSMutableSet setWithArray:[strongSelf acquireUserIdArrWithArr:strongSelf.allSelectedPatients]];
                obj.isAllSelected = [groupSet isSubsetOfSet:allSet];
                [groupSet intersectSet:allSet];
                obj.isExpanded = groupSet.count;
                }];

            self.withTeamSelectVC.selectedPatients = [NSMutableArray arrayWithArray:self.allSelectedPatients];
            [self.withTeamSelectVC.tableView reloadData];
            [self.pageViewController setViewControllers:@[self.withTeamSelectVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

            break;
        }
        case PatientSelectedVCType_Letter:
        {
            //字母
            self.letterOrderSelectVC.letterSelectedPatients = [NSMutableArray arrayWithArray:self.allSelectedPatients];
            [self.letterOrderSelectVC setMaxSelectedNum:[self acquireMaxSelected]];
            [self.letterOrderSelectVC.tableView reloadData];
             [self.pageViewController setViewControllers:@[self.letterOrderSelectVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

            break;
        }
        case PatientSelectedVCType_Cost:
        {
            //按费用
            [self.withTeamSelectVC fillDataWithArray:[self differentiatePatitentWithCost]];
            [self.withTeamSelectVC.patientGroups enumerateObjectsUsingBlock:^(NewPatientGroupListInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSMutableSet *groupSet = [NSMutableSet setWithArray:[self acquireUserIdArrWithArr:obj.users]];
                NSMutableSet *allSet = [NSMutableSet setWithArray:[self acquireUserIdArrWithArr:self.allSelectedPatients]];
                
                obj.isAllSelected = [groupSet isSubsetOfSet:allSet];
                [groupSet intersectSet:allSet];
                obj.isExpanded = groupSet.count;
            }];
            
            self.withTeamSelectVC.selectedPatients = [NSMutableArray arrayWithArray:self.allSelectedPatients];
            [self.withTeamSelectVC.tableView reloadData];
            [self.pageViewController setViewControllers:@[self.withTeamSelectVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            break;
        }
        default:
            break;
            
    }
    [self changeBottomWithArray:self.allSelectedPatients];
    self.selectedVC = tag;


}


#pragma mark - Interface
- (void)getSelectedPatient:(PatientSelectedBlock)block {
    self.selectedBlock = block;
}
// 设置数据
- (void)configData {
    [self.withTeamSelectVC fillDataWithArray:self.patientsSourceData];
    [self.withTeamSelectVC setMaxSelectedNum:[self acquireMaxSelected]];
    __weak typeof(self) weakSelf = self;
    [self.withTeamSelectVC.patientGroups enumerateObjectsUsingBlock:^(NewPatientGroupListInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSMutableSet *groupSet = [NSMutableSet setWithArray:[strongSelf acquireUserIdArrWithArr:obj.users]];
        NSMutableSet *allSet = [NSMutableSet setWithArray:[strongSelf acquireUserIdArrWithArr:strongSelf.allSelectedPatients]];
        obj.isAllSelected = [groupSet isSubsetOfSet:allSet];
        [groupSet intersectSet:allSet];
        obj.isExpanded = groupSet.count;
        if (!idx) {
            obj.isExpanded = YES;
        }
    }];
    
    self.withTeamSelectVC.selectedPatients = [NSMutableArray arrayWithArray:self.allSelectedPatients];
    [self.withTeamSelectVC.tableView reloadData];
    [self.pageViewController setViewControllers:@[self.withTeamSelectVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self changeBottomWithArray:self.allSelectedPatients];
    self.selectedVC = PatientSelectedVCType_Team;
}

#pragma mark - init UI

- (CoordinationFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[CoordinationFilterView alloc] initWithImageNames:@[@"",@"",@"",@""] titles:@[@"按团队",@"按字母",@"按费用"] tags:@[@(PatientSelectedVCType_Team),@(PatientSelectedVCType_Letter),@(PatientSelectedVCType_Cost)]];
        [_filterView setSelectedRow:@(PatientSelectedVCType_Team)];
        _filterView.delegate = self;
    }
    return _filterView;
}



- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
    }
    return _pageViewController;
}

- (HMSelectPatientThirdEditionWithTeamViewController *)withTeamSelectVC {
    if (!_withTeamSelectVC) {
        _withTeamSelectVC = [HMSelectPatientThirdEditionWithTeamViewController new];
        [_withTeamSelectVC setSelectDelegate:self];
    }
    return _withTeamSelectVC;
}

- (HMSelectPatientThirdEditionBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[HMSelectPatientThirdEditionBottomView alloc] init];
        [_bottomView.sendBtn setTitle:[NSString stringWithFormat:@"%@()",self.sentTitel] forState:UIControlStateNormal];
        [_bottomView setDelegate:self];
        [_bottomView.selectBtn setHidden:!self.canSelectAll];
        [_bottomView.titelLb setHidden:!self.canSelectAll];
        
    }
    return _bottomView;
}

- (HMSelectPatientThirdEditionLetterOrderTableViewController *)letterOrderSelectVC {
    if (!_letterOrderSelectVC) {
        _letterOrderSelectVC = [[HMSelectPatientThirdEditionLetterOrderTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _letterOrderSelectVC.tableView.sectionIndexColor = [UIColor mainThemeColor];
        _letterOrderSelectVC.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        [_letterOrderSelectVC configPatientsData:[self withoutHistoryArray]];
        [_letterOrderSelectVC setDelegate:self];
    }
    return _letterOrderSelectVC;
}


@end
