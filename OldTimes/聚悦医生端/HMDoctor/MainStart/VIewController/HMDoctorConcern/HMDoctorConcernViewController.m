//
//  HMDoctorConcernViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2016/12/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMDoctorConcernViewController.h"
#import "HMDoctorConcernMainTableViewCell.h"
#import "AudioPlayHelper.h"
#import "PatientInfo.h"
#import "HMNewConcernSendViewController.h"
#import "HMConcernAcquireListRequest.h"
#import "HMConcernModel.h"
#import "HMConcernPatientModel.h"
#import "CoordinationFilterView.h"
#import <MWPhotoBrowser-ADS/MWPhotoBrowser.h>
#import "HealthEducationItem.h"
#import "NewPatientGroupListInfoModel.h"
#import "EncodeAudio.h"

#define PAGEROWS   10

@interface HMDoctorConcernViewController ()<UITableViewDelegate,UITableViewDataSource,TaskObserver,CoordinationFilterViewDelegate,MWPhotoBrowserDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<HMConcernModel *> *concernDataList;
@property (nonatomic) long long endTime;
@property (nonatomic, strong) NSMutableArray *selectedArr;
@property (nonatomic, strong) HMDoctorConcernMainTableViewCell *lastCell;
@property (nonatomic, strong) UIImageView *emptyImageView;
@property (nonatomic, strong) UILabel *emptyLb;
@property (nonatomic, strong) AudioPlayHelper *player;
@property (nonatomic, strong)  CoordinationFilterView  *filterView; // <##>
@property (nonatomic,strong) NSMutableArray * arrayPhotos;
@property (nonatomic,strong) MWPhotoBrowser * photoBrowser ;
@property (nonatomic) BOOL isVoiceDownLoading;     //语音是否正在下载


@end

@implementation HMDoctorConcernViewController
- (void)dealloc {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.concernDataList) {
        self.concernDataList = [NSMutableArray array];
    }

    [self setTitle:@"医生关怀"];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.emptyImageView];
    [self.view addSubview:self.emptyLb];
    
    [self configElements];

    self.endTime = -1;
    [self startAcquireConcernListRequest];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.endTime == -1) {
        [self performSelector:@selector(scrollViewToBottom:) withObject:@(1) afterDelay:0.01];
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player = nil;
    if (self.lastCell) {
        [self.lastCell.ivVoice stopAnimating];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method

- (void)startAcquireConcernListRequest {
    
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];

//    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)curStaff.userId] forKey:@"userId"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)curStaff.userId] forKey:@"staffId"];
    [dicPost setValue:@(self.endTime) forKey:@"endTime"];
    [dicPost setValue:@PAGEROWS forKey:@"rows"];

    [[TaskManager shareInstance] createTaskWithTaskName:@"HMConcernAcquireListRequest" taskParam:dicPost TaskObserver:self];
    [self.view showWaitView];

}

//重新发送
- (void)resendWithModel:(HMConcernModel *)model isSendToGroup:(BOOL)isSendToGroup
{
    self.selectedArr = [NSMutableArray array];
    if (isSendToGroup) {
        __weak typeof(self) weakSelf = self;
        [model.teamRemarks enumerateObjectsUsingBlock:^(HMConcernTeamModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NewPatientGroupListInfoModel *model = [NewPatientGroupListInfoModel new];
            model.teamName = obj.teamName;
            model.teamId = obj.teamId.integerValue;
            [strongSelf.selectedArr addObject:model];
        }];
    }
    else {
        __weak typeof(self) weakSelf = self;
        [model.userRemarks enumerateObjectsUsingBlock:^(HMConcernPatientModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            PatientInfo *model = [PatientInfo new];
            model.userName = obj.userName;
            model.userId = obj.userId.integerValue;
            [strongSelf.selectedArr addObject:model];
        }];
    }
    
    
    HMNewConcernSendViewController *VC = [[HMNewConcernSendViewController alloc] initWithSelectMember:self.selectedArr text:model.careCon isSendToGroup:isSendToGroup];
    
    if (model.classId.length && model.classId.integerValue) {
        HealthEducationItem *editionModel = [HealthEducationItem new];
        editionModel.classId = model.classId.integerValue;
        editionModel.title = model.classTitle;
        editionModel.paper = model.classPaper;
        
        [VC configHealthEdition:editionModel];
    }
    __weak typeof(self) weakSelf = self;
    [VC sendConcernSuccess:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.endTime = -1;
        [strongSelf.concernDataList removeAllObjects];
        [strongSelf startAcquireConcernListRequest];
        
    }];
    [self.navigationController pushViewController:VC animated:YES];
    
//    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
//    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
//    
//    [dicPost setValue:[HMConcernPatientModel mj_keyValuesArrayWithObjectArray:model.remarks] forKey:@"users"];
//    
//    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)curStaff.userId] forKey:@"doctorUserId"];
//    
//    [dicPost setValue:model.voice forKey:@"soundCont"];
//    [dicPost setValue:model.careCon forKey:@"wordsCont"];
//    [[TaskManager shareInstance] createTaskWithTaskName:@"HMConcernSendGroupConcernRequest" taskParam:dicPost TaskObserver:self];
//    [self.view showWaitView];
    
}

- (void)configElements {
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-30);

    }];
    
    [self.emptyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.emptyImageView.mas_bottom).offset(15);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

//播放声音
- (void)voiceControlClicked:(HMDoctorConcernMainTableViewCell *)cell model:(HMConcernModel *)model
{
    
    //语音播放
    NSString* string = model.voice;
    
    if (model.voice && model.voice.length)
    {
        if (!self.lastCell) {   //第一次点击
        }
        else if (self.lastCell == cell) {  //点击同一个
            if (self.isVoiceDownLoading) {
                return;
            }
            
            if ([self.player isPlaying]) {
                [self.player stopPlay];
                [[self.lastCell ivVoice] stopAnimating];
                return;
            }
        }
        else {  //点击其他cell的语音播放
            self.isVoiceDownLoading = NO;
            [[self.lastCell ivVoice] stopAnimating];
        }
        
        self.lastCell = cell;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            self.isVoiceDownLoading = YES;
            NSData* wavdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.voice]];
            //amr转wav播放
            NSData* armToWavData = [EncodeAudio convertAmrToWavFile:wavdata];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!wavdata)
                {
                    return;
                }
                if ([string containsString:@".wav"])
                {
                    [[cell ivVoice] startAnimating];
                    [self.player playAudioData:wavdata callBack:^{
                        [[cell ivVoice] stopAnimating];
                        
                    }];
                } else
                {
                    [[cell ivVoice] startAnimating];
                    
                    [self.player playAudioData:armToWavData callBack:^{
                        [[cell ivVoice] stopAnimating];
                        
                    }];
                }
                self.isVoiceDownLoading = NO;
                
            });
        });
    }

}

- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}

- (long long)acquireTimeWithString:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:string];
    return [date timeIntervalSince1970];
}

- (void)isShowEmptyView {
    self.tableView.hidden = !self.concernDataList.count;
    self.emptyImageView.hidden = self.concernDataList.count;
    self.emptyLb.hidden = self.concernDataList.count;
}
#pragma mark - event Response
- (void)rightClick {
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
- (void)pullRefreshData {
    if (self.concernDataList.count) {
        self.endTime = [self acquireTimeWithString:self.concernDataList[self.concernDataList.count - 1].careTime] * 1000;
        [self startAcquireConcernListRequest];
    }
    else {
        [self.tableView.mj_header endRefreshing];
    }

}

- (void)clickImageView:(NSInteger)row sourceArr:(NSArray *)sourceArr
{
    // 封装图片数据
    MWPhoto *photo;
    NSInteger currentSelectIndex = 0;
    [self.arrayPhotos removeAllObjects];
    
    for (NSInteger i = 0; i < sourceArr.count; i ++)
    {
        // 网络下载图片
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:sourceArr[i]]];
        [self.arrayPhotos addObject:photo];
        if (row == i)
        {
            currentSelectIndex =  row;
        }
        
    }
    
    // Modal
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self.photoBrowser reloadData];
    [self.photoBrowser setCurrentPhotoIndex:currentSelectIndex];
    [self presentViewController:nc animated:YES completion:nil];
    
}

#pragma mark - CoordinationFilterViewDelegate
- (void)CoordinationFilterViewDelegateCallBack_ClickWithTag:(NSInteger)tag
{
    ConcernSendType type = (ConcernSendType)tag;
    HMNewConcernSendViewController *VC = [[HMNewConcernSendViewController alloc
                                           ] initWithIsSendToGroup:type];
    __weak typeof(self) weakSelf = self;
    [VC sendConcernSuccess:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.endTime = -1;
        [strongSelf.concernDataList removeAllObjects];
        [strongSelf startAcquireConcernListRequest];
        
    }];
    [self.navigationController pushViewController:VC animated:YES];
    
    
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    NSLog(@"%ld",self.arrayPhotos.count);
    return self.arrayPhotos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.arrayPhotos.count)
        return [self.arrayPhotos objectAtIndex:index];
    return nil;
}

#pragma mark - UITableViewDelegate
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.concernDataList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"myCell";
    HMDoctorConcernMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HMDoctorConcernMainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    HMConcernModel *model = [HMConcernModel new];
    if (self.concernDataList.count) {
        model = self.concernDataList[self.concernDataList.count - 1 - indexPath.row];
    }
    if (model) {
        [cell fillDataWithModel:model];
    }
    __weak typeof(self) weakSelf = self;

    [cell concernBlock:^(NSInteger resendTag, BOOL palyVoiceClick) {
        if (resendTag >=0 ) {
            //重发
            [weakSelf resendWithModel:model isSendToGroup:resendTag];
        }
        if (palyVoiceClick) {
            //播放
            [weakSelf voiceControlClicked:cell model:model];
        }
    }];
    
    [cell imageClick:^(NSIndexPath *concernIndexPath) {
        [weakSelf clickImageView:concernIndexPath.row sourceArr:model.careImg];
    }];
    
    [cell editionClick:^(NSString *classId) {
        HealthEducationItem *collectModel = [HealthEducationItem new];
        collectModel.classId = classId.integerValue;
        collectModel.isHideShareBtn = YES;
        //跳转到宣教详情
        [HMViewControllerManager createViewControllerWithControllerName:@"HealthEducationDetailViewController" ControllerObject:collectModel];
    }];
    return cell;
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];

    [self.view closeWaitView];
    if (StepError_None != taskError) {
        if ([taskname isEqualToString:@"HMConcernAcquireListRequest"])
        {
            [self.tableView.mj_header endRefreshing];
        }
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    [self.view closeWaitView];

    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"HMConcernAcquireListRequest"])
    {
        [self.tableView.mj_header endRefreshing];
        if ([taskResult count]) {
            [self.concernDataList addObjectsFromArray:taskResult];
            [self.tableView reloadData];
            if (self.endTime == -1) {
                [self performSelector:@selector(scrollViewToBottom:) withObject:@(0) afterDelay:0.01];
            }
        }
        [self isShowEmptyView];
    }
    else if ([taskname isEqualToString:@"HMConcernSendGroupConcernRequest"])
    {
        [self.view showAlertMessage:@"发送成功"];
        self.endTime = -1;
        [self.concernDataList removeAllObjects];
        [self startAcquireConcernListRequest];
    }

}

#pragma mark - Interface

#pragma mark - init UI

- (UITableView *)tableView

{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefreshData)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        _tableView.mj_header = header;
        
        _tableView.estimatedRowHeight = 60;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setBackgroundColor:[UIColor commonBackgroundColor]];
        
    }
    return _tableView;
}

- (UILabel *)emptyLb {
    if (!_emptyLb) {
        _emptyLb = [UILabel new];
        [_emptyLb setText:@"您还没有关怀记录哦"];
        [_emptyLb setTextColor:[UIColor commonBlackTextColor_333333]];
        [_emptyLb setFont:[UIFont font_32]];
    }
    return _emptyLb;
}

- (UIImageView *)emptyImageView {
    if (!_emptyImageView) {
        _emptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_wujilu"]];
    }
    return _emptyImageView;
}

- (AudioPlayHelper *)player {
    if (!_player) {
        _player = [AudioPlayHelper new];
    }
    return _player;
}

- (CoordinationFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[CoordinationFilterView alloc] initWithImageNames:@[@"ic_ren",@"ic_qun"] titles:@[@"按人发送",@"按组发送"] tags:@[@(SendToPatientsType),@(SendToGroupsType)]];
        _filterView.delegate = self;
    }
    return _filterView;
}

- (NSMutableArray *)arrayPhotos {
    if (!_arrayPhotos) {
        _arrayPhotos = [NSMutableArray array];
    }
    return _arrayPhotos;
}
- (MWPhotoBrowser *)photoBrowser
{
    if (!_photoBrowser)
    {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = YES; // 分享按钮，默认是
        _photoBrowser.displayNavArrows = NO;     // 左右分页切换，默认否
        _photoBrowser.displaySelectionButtons = NO; // 是否显示选择按钮
        _photoBrowser.alwaysShowControls = NO;  // 控制条件控件
        _photoBrowser.zoomPhotosToFill = NO;    // 是否全屏
        _photoBrowser.enableGrid = NO;//是否允许用网格查看所有图片,默认是
        _photoBrowser.startOnGrid = NO;//是否第一张,默认否
        _photoBrowser.enableSwipeToDismiss = YES;
        [_photoBrowser showNextPhotoAnimated:YES];
        [_photoBrowser showPreviousPhotoAnimated:YES];
        [_photoBrowser setCurrentPhotoIndex:1];
    }
    return _photoBrowser;
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
