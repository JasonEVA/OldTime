//
//  HMStepPKViewController.m
//  HMClient
//
//  Created by JasonWang on 2017/5/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMStepPKViewController.h"
#import "HMSetpPKMainTableViewCell.h"
#import "HMExercisePKModel.h"
#import "HMPramiseMeFriendsViewController.h"
#import "HMStepUploadManager.h"
#import "HMStepHistoryViewController.h"

@interface HMStepPKViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver>
@property (nonatomic, strong) UILabel *stepCountLb;
@property (nonatomic, strong) UILabel *myRankingLb;
@property (nonatomic, strong) UIButton *praiseMeCountLb;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray <HMExercisePKModel *>*dataList;
@property (nonatomic, strong) HMExercisePKModel *myExerciseModel;
@property (nonatomic, strong) UIImageView *topView;

@property (nonatomic) BOOL isFirstIn;

@end

@implementation HMStepPKViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[HMStepUploadManager shareInstance] JWCanUploadStepData];
    [[HMStepUploadManager shareInstance] upLoadCurrentStep:^(BOOL success) {
        if (success) {
            [self startRequestPKlist];
        }
    }];
    
    [self configElements];
    [self startRequestPKlist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSteps) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -private method
- (void)configElements {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-45-64);
    }];
}

- (void)fillTopViewDataWith:(NSArray <HMExercisePKModel *>*)array {
    __block HMExercisePKModel *tempModel = nil;
    __block NSInteger tempRank = 0;
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    [array enumerateObjectsUsingBlock:^(HMExercisePKModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.userId == user.userId) {
            tempModel = obj;
            tempRank = idx + 1;
            *stop = YES;
        }
    }];
    
    if (!tempModel) {
        return;
    }
    self.myExerciseModel = tempModel;
    [self.stepCountLb setText:[NSString stringWithFormat:@"%lld",tempModel.stepCount]];
    [self.praiseMeCountLb setTitle:[NSString stringWithFormat:@"点赞 %lld",tempModel.favourCount] forState:UIControlStateNormal];
    [self.myRankingLb setText:[NSString stringWithFormat:@"当前排名第%ld名",tempRank]];
}
// 获取PK列表
- (void)startRequestPKlist {
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"userId"];
    
    if (!self.isFirstIn) {
        [self at_postLoading];
        self.isFirstIn = YES;
    }

    [[TaskManager shareInstance] createTaskWithTaskName:@"HMGetUserExercisePKlistRequest" taskParam:dict TaskObserver:self];
    
}
// 点赞
- (void)startAddFavourRequst:(HMExercisePKModel *)model {
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"userId"];
    [dict setObject:model.userExerciseId forKey:@"userExerciseId"];

    [[TaskManager shareInstance] createTaskWithTaskName:@"HMAddUserExerciseFavourRequest" taskParam:dict TaskObserver:self];
}

// 取消点赞
- (void)startCancelFavourRequst:(HMExercisePKModel *)model {
    UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)user.userId] forKey:@"userId"];
    [dict setObject:model.userExerciseId forKey:@"userExerciseId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMCancelUserExFavourRequest" taskParam:dict TaskObserver:self];
}

- (void)updateSteps {
    [[HMStepUploadManager shareInstance] upLoadCurrentStep:^(BOOL success) {
        if (success) {
            [self startRequestPKlist];
        }
    }];
}
#pragma mark - event Response


- (void)myPraiseClick {
    HMPramiseMeFriendsViewController *VC = [HMPramiseMeFriendsViewController new];
    VC.userExerciseId = self.myExerciseModel.userExerciseId;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)toHistoryVC {
    HMStepHistoryViewController *VC = [HMStepHistoryViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - Delegate

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSValue *dict = change[@"new"];
        CGPoint point = dict.CGPointValue;
        if (point.y < 0) {
            [self.tableView setContentOffset:CGPointZero];
        }
    }
}
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00000001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMExercisePKModel *model = self.dataList[indexPath.row];
    HMSetpPKMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HMSetpPKMainTableViewCell at_identifier]];
    [cell fillDataWithModel:model ranking:indexPath.row + 1];
    __weak typeof(self) weakSelf = self;

    [cell praiseClick:^(NSInteger ranking) {
        if (model.userId == weakSelf.myExerciseModel.userId) {
            [weakSelf myPraiseClick];
            return;
        }
        if (model.favoured == 0) {
            // 点赞
            [weakSelf startAddFavourRequst:model];
        }
        else {
            // 取消点赞
            [weakSelf startCancelFavourRequst:model];
        }
    }];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    HMConsultingRecordsModel *model = self.dataList[indexPath.row];
//    HMStaffNavTitleHistoryChatViewController *VC = [[HMStaffNavTitleHistoryChatViewController alloc] initWithHMConsultingRecordsModel:model];
//    
//    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - TaskObservice
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    
    if (StepError_None != taskError)
    {
        [self at_hideLoading];
        [self showAlertMessage:errorMessage];
        return;
    }
    if (!taskId || 0 == taskId.length)
    {
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
    
    if ([taskname isEqualToString:@"HMGetUserExercisePKlistRequest"]) {
        [self at_hideLoading];
        self.dataList = taskResult;
        [self fillTopViewDataWith:self.dataList];
        [self.tableView reloadData];
    }
    else if ([taskname isEqualToString:@"HMAddUserExerciseFavourRequest"]) {
        [self startRequestPKlist];
    }
    else if ([taskname isEqualToString:@"HMCancelUserExFavourRequest"]) {
        [self startRequestPKlist];

    }
}

#pragma mark - Interface

#pragma mark - init UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        [_tableView setRowHeight:70];
        [_tableView setTableHeaderView:self.topView];
        [_tableView registerClass:[HMSetpPKMainTableViewCell class] forCellReuseIdentifier:[HMSetpPKMainTableViewCell at_identifier]];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
    }
    return _tableView;
}

- (UIImageView *)topView {
    if (!_topView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PK_im_back3"]];
        imageView.frame = CGRectMake(0, 0, ScreenWidth, (220 * (ScreenWidth / 375)));
        [imageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toHistoryVC)];
        [imageView addGestureRecognizer:tap];
        [imageView setUserInteractionEnabled:YES];
        
        [self.view addSubview:imageView];
        
        self.stepCountLb = [UILabel new];
        [self.stepCountLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [self.stepCountLb setFont:[UIFont systemFontOfSize:60]];
        [self.stepCountLb setText:@"0"];
        
        [imageView addSubview:self.stepCountLb];
        [self.stepCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageView);
            make.centerY.equalTo(imageView).offset(-10);
        }];
        
        UILabel *todayLb = [UILabel new];
        [todayLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [todayLb setFont:[UIFont systemFontOfSize:14]];
        [todayLb setText:@"今日步数"];
        
        [imageView addSubview:todayLb];
        [todayLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageView);
            make.bottom.equalTo(self.stepCountLb.mas_top);
        }];
        
        self.myRankingLb  = [UILabel new];
        [self.myRankingLb setText:@"当前排名第0名"];
        [self.myRankingLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [self.myRankingLb setFont:[UIFont systemFontOfSize:14]];
        
        [imageView addSubview:self.myRankingLb];
        [self.myRankingLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageView);
            make.top.equalTo(self.stepCountLb.mas_bottom).offset(3);
        }];
        
        self.praiseMeCountLb = [UIButton new];
        [self.praiseMeCountLb.titleLabel setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [self.praiseMeCountLb.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.praiseMeCountLb setTitle:@"点赞 0" forState:UIControlStateNormal];
        [self.praiseMeCountLb addTarget:self action:@selector(myPraiseClick) forControlEvents:UIControlEventTouchUpInside];
        
        [imageView addSubview:self.praiseMeCountLb];
        [self.praiseMeCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView).offset(36);
            make.bottom.equalTo(imageView).offset(-5);
        }];
        
        UIButton *praiseImage = [[UIButton alloc] init];
        [praiseImage setImage:[UIImage imageNamed:@"PK_ic_zan_white"] forState:UIControlStateNormal];
        [praiseImage addTarget:self action:@selector(myPraiseClick) forControlEvents:UIControlEventTouchUpInside];
        
        [imageView addSubview:praiseImage];
        [praiseImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.praiseMeCountLb);
            make.right.equalTo(self.praiseMeCountLb.mas_left).offset(-5);
        }];
        
        UILabel *stepHistoryLb = [UILabel new];
        [stepHistoryLb setText:@"步数记录"];
        [stepHistoryLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [stepHistoryLb setFont:[UIFont systemFontOfSize:14]];
        
        [imageView addSubview:stepHistoryLb];
        
        [stepHistoryLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(praiseImage);
            make.right.equalTo(imageView).offset(-15);
        }];
        
        UIImageView *stepHistoryImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_record"]];
        
        [imageView addSubview:stepHistoryImage];
        [stepHistoryImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(stepHistoryLb);
            make.right.equalTo(stepHistoryLb.mas_left).offset(-5);
        }];

        _topView = imageView;
    }
    return _topView;
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
