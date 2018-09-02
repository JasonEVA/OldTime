//
//  HMFEPatientListViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/10/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMFEPatientListViewController.h"
#import "PatientListLetterOrderAdapter.h"
#import "PatientListTableViewCell.h"
#import "DAOFactory.h"
#import "JWSegmentView.h"
#import "HMHistoryPatientListViewController.h"
#import "ATModuleInteractor+PatientChat.h"
#import "HMFEAllPatientListViewController.h"

#define SEGMENTVIEWHEIGHT  40

@interface HMFEPatientListViewController ()<ATTableViewAdapterDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UISearchResultsUpdating>
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  PatientListLetterOrderAdapter  *letterOrderAdapter; // <##>
@property (nonatomic) HMFEPatientListViewType type;
@property (nonatomic, copy) NSArray *sourceDataArr;  // 所有患者

@property (nonatomic, copy) NSArray *showDataArr;  // 当前显示患者

@property (nonatomic, strong)  UILabel *patientsCountLb;    //显示当前展示人数lb
@property (nonatomic, strong) JWSegmentView *segmentView;

@end

@implementation HMFEPatientListViewController

- (instancetype)initWithType:(HMFEPatientListViewType)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1) cornerRadius:0]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    UIBarButtonItem *history = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_oldgroup"] style:UIBarButtonItemStylePlain target:self action:@selector(historyClick)];
    
    UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_select"] style:UIBarButtonItemStylePlain target:self action:@selector(searchClick)];
    
    [self.navigationItem setRightBarButtonItems:@[search,history]];
    
    if (self.paramObject)
    {
        self.type = [self.paramObject integerValue];
    }
    if (self.type == HMFEPatientListViewType_Free) {
        self.title = @"免费患者";
    }
    if (self.type == HMFEPatientListViewType_Package || self.type == HMFEPatientListViewType_Single) {
        self.title = @"收费患者";
    }
        
    [self configElements];
    [self requestPatientsListImmediately:NO];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    // Do any additional setup after loading the view.
}

#pragma mark -private method
- (void)configElements {
    if (self.type == HMFEPatientListViewType_Package || self.type == HMFEPatientListViewType_Single) {
        [self.view addSubview:self.segmentView];
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        if ([self.view.subviews containsObject:self.segmentView]) {
            make.top.equalTo(self.segmentView.mas_bottom);
        }
        else {
            make.top.equalTo(self.view);
        }
    }];
    
    [self.view addSubview:self.patientsCountLb];
    [self.patientsCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(10);
        if ([self.view.subviews containsObject:self.segmentView]) {
            make.top.equalTo(self.view).offset(5 + SEGMENTVIEWHEIGHT);
        }
        else {
            make.top.equalTo(self.view).offset(5);
        }
        make.height.equalTo(@25);
    }];
}

// 请求全部患者
- (void)requestPatientsListImmediately:(BOOL)immediately {
    [self at_postLoading];
    __weak typeof(self) weakSelf = self;
    [_DAO.patientInfoListDAO requestPatientListImmediately:immediately CompletionHandler:^(BOOL success, NSString *errorMsg, NSArray<NewPatientListInfoModel *> *results) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!success) {
            [strongSelf at_postError:errorMsg];
            return;
        }
        strongSelf.sourceDataArr = results;
        
        NSString *predicateString;
                switch (strongSelf.type) {
                    case HMFEPatientListViewType_Free:  // 免费用户
                        predicateString = @"SELF.classify = 3 AND rootTypeCode <> 'JTTC'";
                        break;
                    case HMFEPatientListViewType_Package: // 收费用户（套餐）
                        predicateString = @"SELF.classify IN {2,4} AND rootTypeCode <> 'JTTC'";
                        break;
                    case HMFEPatientListViewType_Single: // 收费用户（单项）
                        predicateString = @"SELF.classify = 5";
                        break;
                }
        
                if (predicateString) {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
                    strongSelf.showDataArr = [results filteredArrayUsingPredicate:predicate];
                }
                else {
                    strongSelf.showDataArr = results;
                }
        

        [strongSelf.patientsCountLb setText:[NSString stringWithFormat:@"  共%ld人   ",strongSelf.showDataArr.count]];
        [strongSelf.letterOrderAdapter reloadTableViewWithOriginData:strongSelf.showDataArr completion:^{
            [weakSelf at_hideLoading];
        }];

    
    
    }];
    

}

// 请求全部患者(单项，去重)
- (void)requestSinglePatientsListImmediately:(BOOL)immediately {
    [self at_postLoading];
    __weak typeof(self) weakSelf = self;
    [_DAO.patientInfoListDAO requestPatientListImmediately:immediately removeDuplicateWithId:@"userId" CompletionHandler:^(BOOL success, NSString *errorMsg, NSArray<NewPatientListInfoModel *> *results) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!success) {
            [strongSelf at_postError:errorMsg];
            return;
        }
        strongSelf.sourceDataArr = results;
        
        NSString *predicateString;
        switch (strongSelf.type) {
            case HMFEPatientListViewType_Free:  // 免费用户
                predicateString = @"SELF.classify = 3 AND rootTypeCode <> 'JTTC'";
                break;
            case HMFEPatientListViewType_Package: // 收费用户（套餐）
                predicateString = @"SELF.classify IN {2,4} AND rootTypeCode <> 'JTTC'";
                break;
            case HMFEPatientListViewType_Single: // 收费用户（单项）
                predicateString = @"SELF.classify = 5";
                break;
        }
        
        if (predicateString) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
            strongSelf.showDataArr = [results filteredArrayUsingPredicate:predicate];
        }
        else {
            strongSelf.showDataArr = results;
        }
        
        
        [strongSelf.patientsCountLb setText:[NSString stringWithFormat:@"  共%ld人   ",strongSelf.showDataArr.count]];
        [strongSelf.letterOrderAdapter reloadTableViewWithOriginData:strongSelf.showDataArr completion:^{
            [weakSelf at_hideLoading];
        }];
        
    }];
    
    
}
- (void)p_goToChatVC:(NSString *)userId {
    [[ATModuleInteractor sharedInstance] goToPatientInfoDetailWithUid:userId];
}
#pragma mark - event Response
- (void)historyClick {
    HMHistoryPatientListViewController *VC = [[HMHistoryPatientListViewController alloc] initWithType:self.type];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)searchClick {
    HMFEAllPatientListViewController *VC = [HMFEAllPatientListViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无用户" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"666666"]}];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"g"];
}



- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (!self.showDataArr ||self.showDataArr.count == 0) {
        return YES;
    }
    return NO;
}

#pragma mark - Adapter Delegate
- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath {
    NewPatientListInfoModel *model = (NewPatientListInfoModel *)cellData;
    [[ATModuleInteractor sharedInstance] goToPatientInfoDetailWithUid:[NSString stringWithFormat:@"%ld",model.userId]];
}
#pragma mark - request Delegate

#pragma mark - Interface

#pragma mark - init UI
- (JWSegmentView *)segmentView {
    if (!_segmentView) {
        __weak typeof(self) weakSelf = self;
        _segmentView = [[JWSegmentView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, SEGMENTVIEWHEIGHT) titelArr:@[@"套餐",@"单项"] tagArr:@[@(HMFEPatientListViewType_Package),@(HMFEPatientListViewType_Single)] titelSelectedJWColor:[UIColor colorWithHexString:@"ffffff"] titelUnSelectedJWColor:[UIColor colorWithHexString:@"ffffff"] lineJWColor:[UIColor colorWithHexString:@"fffffff"] backJWColor:[UIColor mainThemeColor] lineWidth:(ScreenWidth / 2.0) block:^(NSInteger selectedTag) {
            
            weakSelf.type = selectedTag;
            if (selectedTag == HMFEPatientListViewType_Single) {
                [weakSelf requestSinglePatientsListImmediately:NO];
            }
            else {
                [weakSelf requestPatientsListImmediately:NO];
            }
        }];
    }
    return _segmentView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor commonBackgroundColor]];
        _tableView.delegate = self.letterOrderAdapter;
        _tableView.dataSource = self.letterOrderAdapter;
        [_tableView registerClass:[PatientListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PatientListTableViewCell class])];
        _tableView.rowHeight = 60;
        _tableView.tableFooterView = [UIView new];
        _tableView.sectionIndexColor = [UIColor mainThemeColor];
//        _tableView.emptyDataSetSource = self.searchEmptyAdapter;
//        _tableView.emptyDataSetDelegate = self.searchEmptyAdapter;
        
    }
    return _tableView;
    
}
- (PatientListLetterOrderAdapter *)letterOrderAdapter {
    if (!_letterOrderAdapter) {
        _letterOrderAdapter = [PatientListLetterOrderAdapter new];
        _letterOrderAdapter.adapterDelegate = self;
        _letterOrderAdapter.tableView = self.tableView;
//        _letterOrderAdapter.customDelegate = self;
    }
    return _letterOrderAdapter;
}

- (UILabel *)patientsCountLb {
    if (!_patientsCountLb) {
        _patientsCountLb = [UILabel new];
        [_patientsCountLb setBackgroundColor:[UIColor colorWithHexString:@"0099ff"]];
        [_patientsCountLb setAlpha:0.7];
        [_patientsCountLb setFont:[UIFont systemFontOfSize:14]];
        [_patientsCountLb setText:@"  共0人   "];
        [_patientsCountLb.layer setCornerRadius:12.5];
        [_patientsCountLb setClipsToBounds:YES];
        [_patientsCountLb setTextColor:[UIColor whiteColor]];
    }
    return _patientsCountLb;
}

@end
