//
//  HMDoctorConcernViewController.m
//  HMClient
//
//  Created by jasonwang on 2017/6/14.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMDoctorConcernViewController.h"
#import "HMNewDoctorCareAlterTextTableViewCell.h"
#import "HMNewDoctorCareAlterVoiceTableViewCell.h"
#import "HMSEMainStartEnum.h"
#import "HMNewDoctorCareAlterImageTableViewCell.h"
#import "HMNewDoctorCareAlterEditionTableViewCell.h"
#import "DoctorGreetingInfo.h"
#import <MWPhotoBrowser-ADS/MWPhotoBrowser.h>
#import "HealthEducationItem.h"
#import "AudioPlayHelper.h"
#import "EncodeAudio.h"


#define TABLEVIEWWIDTH   273

#define iOS9Before ([UIDevice currentDevice].systemVersion.floatValue < 9.0f)

@interface HMDoctorConcernViewController ()<UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate,TaskObserver>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray <DoctorGreetingInfo *>*dataList;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) NSMutableArray *showRowsArr;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) DoctorGreetingInfo *model;
@property (nonatomic,strong) NSMutableArray * arrayPhotos;
@property (nonatomic,strong) MWPhotoBrowser * photoBrowser ;
@property (nonatomic) BOOL isVoiceDownLoading;     //语音是否正在下载
@property (nonatomic, strong) AudioPlayHelper *player;
@property (nonatomic, copy) CareShowMore block;
@end

@implementation HMDoctorConcernViewController
- (instancetype)initWithArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        self.dataList = array;
        self.model = self.dataList.firstObject;
        [self fillDataWithArr:self.model];
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.definesPresentationContext = YES;
        self.providesPresentationContextTransitionStyle = YES;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"333333"alpha:0.7]];
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage imageNamed:@"SEMainStartic_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *leftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_xinfen_left"]];
    UIImageView *rightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_xinfen_right"]];
    
    [self.view addSubview:leftImage];
    [self.view addSubview:rightImage];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@TABLEVIEWWIDTH);
        make.height.equalTo(@([self configTableHeight:self.model]));
    }];
    
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tableView);
        make.bottom.equalTo(self.tableView.mas_top).offset(-15);
    }];
    
   
    
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tableView);
        make.right.equalTo(self.tableView.mas_left).offset(1);
    }];
    
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tableView);
        make.left.equalTo(self.tableView.mas_right).offset(-1);
    }];

    [self.view addSubview:self.moreBtn];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(20);
        make.centerX.equalTo(self.tableView);
        make.width.equalTo(@186);
        make.height.equalTo(@35);
    }];
    
    [self markCareRead];
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.player isPlaying]) {
        [self.player stopPlay];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
}
- (HMNewDoctorCareAlterCellType)acquireTypeWithIndexPath:(NSIndexPath *)indexPath {
    return [self.showRowsArr[indexPath.row] integerValue];
}

- (void)fillDataWithArr:(DoctorGreetingInfo *)model {

    if (model.careCon && model.careCon.length) {
        [self.showRowsArr addObject:@(HMNewDoctorCareAlterCellType_Text)];
    }
    
    if (model.voice && model.voice.length) {
        [self.showRowsArr addObject:@(HMNewDoctorCareAlterCellType_Voice)];
    }
    
    if (model.careImg.count) {
        [self.showRowsArr addObject:@(HMNewDoctorCareAlterCellType_Image)];
    }
    
    if (model.classId && model.classId.integerValue) {
        [self.showRowsArr addObject:@(HMNewDoctorCareAlterCellType_Education)];
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

- (CGFloat)configTableHeight:(DoctorGreetingInfo *)model {
    CGFloat tableHeight = 80 + 35;
    if (model.voice && model.voice.length) {
        tableHeight += 50;
    }
    
    if (model.careImg.count) {
        tableHeight += 60;
    }
    
    if (model.classId && model.classId.integerValue) {
        tableHeight += 50;
    }
    
    if (model.careCon && model.careCon.length) {
        tableHeight += [self getTextHeightWithString:model.careCon];
    }
    
    return MIN(MAX(tableHeight, 260), 372);
}

- (CGFloat)getTextHeightWithString:(NSString *)string {
    NSString *text = string;
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    UIFont *font;
    if (iOS9Before) {
        font = [UIFont systemFontOfSize:15];
    }
    else {
        font = [UIFont fontWithName:@"PingFang-SC-Light" size:15];
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:font forKey:NSFontAttributeName];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:2.0];
    [dict setObject:paragraphStyle1 forKey:NSParagraphStyleAttributeName];
    CGSize size = [text boundingRectWithSize:CGSizeMake(TABLEVIEWWIDTH - 40, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;

    return size.height;
}

- (void)markCareRead
{
    __block NSMutableArray *tempArr = [NSMutableArray array];
    [self.dataList enumerateObjectsUsingBlock:^(DoctorGreetingInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempArr addObject:obj.careId];
    }];
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    
    [dicPost setValue:tempArr forKey:@"careIds"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMNewCareReadedRequest" taskParam:dicPost TaskObserver:self];
}

#pragma mark - event Response
- (void)closeClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)moreClick {
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.block) {
            weakSelf.block(0);
        }
    }];
    
    
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
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.showRowsArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMNewDoctorCareAlterCellType type = [self acquireTypeWithIndexPath:indexPath];
    id cell;
    switch (type) {
        case HMNewDoctorCareAlterCellType_Text:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[HMNewDoctorCareAlterTextTableViewCell at_identifier]];
            [cell fillDataWithString:self.model.careCon];
            break;
        }
        case HMNewDoctorCareAlterCellType_Voice:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[HMNewDoctorCareAlterVoiceTableViewCell at_identifier]];
            __weak typeof(self) weakSelf = self;
            [cell fillDataWithVoiceLenth:self.model.voiceLength];
            [cell playVoiceClickBlock:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;

                //语音播放
                NSString* string = strongSelf.model.voice;
                
                if (string && string.length)
                {
                   
                        if (strongSelf.isVoiceDownLoading) {
                            return;
                        }
                        
                        if ([self.player isPlaying]) {
                            [self.player stopPlay];
                            [[cell voiceImages] stopAnimating];
                            return;
                        
                
                        }
                    
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        
                        self.isVoiceDownLoading = YES;
                        NSData* wavdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
                        //amr转wav播放
                        NSData* armToWavData = [EncodeAudio convertAmrToWavFile:wavdata];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (!wavdata)
                            {
                                return;
                            }
                            if ([string containsString:@".wav"])
                            {
                                [[cell voiceImages] startAnimating];
                                [self.player playAudioData:wavdata callBack:^{
                                    [[cell voiceImages] stopAnimating];
                                    
                                }];
                            } else
                            {
                                [[cell voiceImages] startAnimating];
                                
                                [self.player playAudioData:armToWavData callBack:^{
                                    [[cell voiceImages] stopAnimating];
                                    
                                }];
                            }
                            self.isVoiceDownLoading = NO;
                            
                        });
                    });
                }
                
            }];

            break;
        }
        case HMNewDoctorCareAlterCellType_Image:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[HMNewDoctorCareAlterImageTableViewCell at_identifier]];
            [cell fillDataWithImageDataList:self.model.careImgDesc];
            __weak typeof(self) weakSelf = self;

            [cell imageClick:^(NSIndexPath *concernIndexPath) {
                [weakSelf clickImageView:concernIndexPath.row sourceArr:self.model.careImg];
            }];
            break;
        }
        case HMNewDoctorCareAlterCellType_Education:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[HMNewDoctorCareAlterEditionTableViewCell at_identifier]];
            HealthEducationItem *model = [HealthEducationItem new];
            model.classId = self.model.classId.integerValue;
            model.title = self.model.classTitle;
            model.paper = self.model.classPaper;
            
            [cell fillDataWithModel:model];
            break;
        }
        default:
            break;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HMNewDoctorCareAlterCellType type = [self acquireTypeWithIndexPath:indexPath];
    if (type == HMNewDoctorCareAlterCellType_Education) {
        
        __weak typeof(self) weakSelf = self;
        [self dismissViewControllerAnimated:YES completion:^{
            if (weakSelf.block) {
                weakSelf.block(1);
            }
        }];
    }
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
    [self at_hideLoading];
    
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"HMNewCareReadedRequest"]) {
        
    }

}

#pragma mark - Interface
- (void)doctorCareShowMore:(CareShowMore)block {
    self.block = block;
}
#pragma mark - init UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        [_tableView setTableHeaderView:self.headView];
        [_tableView setTableFooterView:self.footView];
        [_tableView setEstimatedRowHeight:45];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
        [_tableView.layer setCornerRadius:5];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:[HMNewDoctorCareAlterTextTableViewCell class] forCellReuseIdentifier:[HMNewDoctorCareAlterTextTableViewCell at_identifier]];
        [_tableView registerClass:[HMNewDoctorCareAlterVoiceTableViewCell class] forCellReuseIdentifier:[HMNewDoctorCareAlterVoiceTableViewCell at_identifier]];
        [_tableView registerClass:[HMNewDoctorCareAlterImageTableViewCell class] forCellReuseIdentifier:[HMNewDoctorCareAlterImageTableViewCell at_identifier]];
        [_tableView registerClass:[HMNewDoctorCareAlterEditionTableViewCell class] forCellReuseIdentifier:[HMNewDoctorCareAlterEditionTableViewCell at_identifier]];
    }
    return _tableView;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TABLEVIEWWIDTH, 70)];
        UILabel *titelLb = [UILabel new];
        [titelLb setText:@"来自医生的关怀"];
        [titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [titelLb setFont:[UIFont fontWithName:@"PingFang-SC-Light" size:16]];
        // 下划线
//        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleDouble]};
//        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"来自医生的关怀" attributes:attribtDic];
        
//        //赋值
//        titelLb.attributedText = attribtStr;
        
        [_headView addSubview:titelLb];
        [titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headView);
            make.top.equalTo(_headView).offset(15);
        }];
        
        UILabel *nameLb = [UILabel new];
        UserInfo *user = [UserInfoHelper defaultHelper].currentUserInfo;

        [nameLb setText:[NSString stringWithFormat:@"%@用户：",user.userName]];
        [nameLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [nameLb setFont:[UIFont fontWithName:@"PingFang-SC-Light" size:15]];
        
        [_headView addSubview:nameLb];
        [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headView).offset(20);
            make.bottom.equalTo(_headView);
        }];
        
    }
    return _headView;
}

- (UIView *)footView {
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TABLEVIEWWIDTH, 35)];
        UILabel *footLb = [UILabel new];
        [footLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [footLb setFont:[UIFont fontWithName:@"PingFang-SC-Light" size:15]];
        [footLb setText:[NSString stringWithFormat:@"——%@医生",self.model.carerName]];
        [footLb setTextAlignment:NSTextAlignmentRight];
        
        [_footView addSubview:footLb];
        [footLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_footView);
            make.right.equalTo(_footView).offset(-20);
        }];
    }
    return _footView;
}

- (NSMutableArray *)showRowsArr {
    if (!_showRowsArr) {
        _showRowsArr = [NSMutableArray array];
    }
    return _showRowsArr;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton new];
        [_moreBtn.layer setCornerRadius:3];
        [_moreBtn.layer setBorderColor:[[UIColor colorWithHexString:@"ffffff"] CGColor]];
        [_moreBtn.layer setBorderWidth:1];
        [_moreBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_moreBtn.titleLabel setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        if (self.dataList.count > 1) {
            [_moreBtn setTitle:[NSString stringWithFormat:@"查看更多(%lu封未读)",(unsigned long)self.dataList.count ] forState:UIControlStateNormal];
        }
        else {
            [_moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        }
        [_moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
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

- (NSMutableArray *)arrayPhotos {
    if (!_arrayPhotos) {
        _arrayPhotos = [NSMutableArray array];
    }
    return _arrayPhotos;
}

- (AudioPlayHelper *)player {
    if (!_player) {
        _player = [AudioPlayHelper new];
    }
    return _player;
}
@end
