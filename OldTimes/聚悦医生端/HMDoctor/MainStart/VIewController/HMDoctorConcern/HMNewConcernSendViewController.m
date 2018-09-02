//
//  HMNewConcernSendViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2016/12/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMNewConcernSendViewController.h"
#import "PlaceholderTextView.h"
#import "CareVoiceRecordVolumeView.h"
#import "AudioRecord.h"
#import "AudioPlayer.h"
#import "HMSendConcernSelectMemberViewController.h"
#import "PatientInfo.h"
#import "HMConcernSendGroupConcernRequest.h"
#import "HMConcernHealthEditionView.h"
#import "HealthEducationItem.h"
#import "JWSelectImageViewController.h"
#import "HMSelectGroupsViewController.h"
#import "NewPatientGroupListInfoModel.h"
#import "HMSendCareUploadImageRequest.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface HMNewConcernSendViewController ()<UITextViewDelegate,TaskObserver>
{
    CareVoiceRecordVolumeView *recordVolumeView;
    CareVoiceMessageView* voiceMessageView;
    CareVoiceRecordView* recordView;
    
    AudioRecord *audioRecord;
    NSString* careVoiceFile;
//    PatientInfo* patient;
    
    NSTimer* durationTimer;
    CGFloat sec;
    NSInteger min;
}
@property (nonatomic, strong) UIView *headView;     //头部View

@property (nonatomic, strong) UILabel *selectedTitelLb;
@property (nonatomic, strong) UITextView *selectedMemberLb;
@property (nonatomic, strong) UIButton *addMemberBtn;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *line2;

@property (nonatomic, strong) PlaceholderTextView *concernTextView;
@property (nonatomic, strong) UIBarButtonItem *rightBtn;
@property (nonatomic, copy) NSMutableArray *selectedMembers;

@property (nonatomic, copy) NSString *memberString;
@property (nonatomic, copy) concernSendedsuccessBlock block;
@property (nonatomic, strong) HMConcernHealthEditionView *healthEditionView;
@property (nonatomic, strong) HealthEducationItem *healthEducationModel;
@property (nonatomic, strong) JWSelectImageViewController *selectImageVC;
@property (nonatomic) BOOL isSendToGroup;    // 是否按组发送（YES为按群组发送，NO为按人发送）
@property (nonatomic, strong) NSMutableArray *selectedGroups;
@property (nonatomic, strong)  NSMutableArray<NSString *>  *arrayUploadedImagePath; // 已上传成功图片地址

@end

@implementation HMNewConcernSendViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithIsSendToGroup:(BOOL)isSendToGroup {
    if ([super init]) {
        self.isSendToGroup = isSendToGroup;
    }
    return self;
}

- (instancetype)initWithSelectMember:(NSArray *)selectedArr text:(NSString *)text isSendToGroup:(BOOL)isSendToGroup{
    if ([super init]) {
        self.isSendToGroup = isSendToGroup;
        if (self.isSendToGroup) {
            self.selectedGroups = [NSMutableArray arrayWithArray:selectedArr];
            [self fillGroupDataWith:selectedArr];
        }
        else {
            self.selectedMembers = [NSMutableArray arrayWithArray:selectedArr];
            [self fillMemberDataWith:selectedArr];
        }
        [self.concernTextView setText:text];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    [self setTitle:@"新建关怀"];
    [self.navigationItem setRightBarButtonItem:self.rightBtn];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    
    [self addChildViewController:self.selectImageVC];
    [self.view addSubview:self.headView];
    [self.headView addSubview:self.selectedMemberLb];
    [self.headView addSubview:self.selectedTitelLb];
    [self.headView addSubview:self.addMemberBtn];
    [self.headView addSubview:self.line];
    [self.headView addSubview:self.concernTextView];
    [self.headView addSubview:self.line2];
    [self.headView addSubview:self.healthEditionView];
    [self.headView addSubview:self.selectImageVC.view];
    
    [self configElements];
    
    [self initWithRecordView];
    
    audioRecord = [[AudioRecord alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBack) name:@"APPEnterBackground" object:nil];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark -private method
- (void)configElements {
    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
    
    [self.selectedTitelLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.headView).offset(20);
        make.right.lessThanOrEqualTo(self.headView).offset(-50);
    }];
    
    [self.addMemberBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectedTitelLb);
        make.right.equalTo(self.headView).offset(-15);
        
    }];
    
    [self.selectedMemberLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectedTitelLb.mas_bottom).offset(5);
        make.left.equalTo(self.headView).offset(15);
        make.right.lessThanOrEqualTo(self.headView).offset(-15);
        make.height.mas_equalTo([self acquireTextViewHeightWithString:self.selectedMemberLb.text]);
    }];
    
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectedMemberLb.mas_bottom).offset(15);
        make.right.left.equalTo(self.view);
        make.height.equalTo(@5);
    }];
    
    [self.concernTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(5);
        make.left.equalTo(self.headView).offset(15);
        make.right.equalTo(self.headView).offset(-15);
        make.height.equalTo(@158);
    }];
    
    [self.healthEditionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@50);
        make.top.equalTo(self.concernTextView.mas_bottom);
    }];
    [self.healthEditionView setHidden:!self.healthEducationModel];
    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.healthEducationModel?self.healthEditionView.mas_bottom : self.concernTextView.mas_bottom).offset(15);
        make.right.left.equalTo(self.view);
        make.height.equalTo(@0.5);
    }];
    
    [self.selectImageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@80);
        make.left.right.equalTo(self.headView);
        make.top.equalTo(self.line2.mas_bottom);
        make.bottom.equalTo(self.headView);

    }];
}

- (void)initWithRecordView
{
    recordView = [[CareVoiceRecordView alloc] init];
    [self.view addSubview:recordView];
    [recordView setBackgroundColor:[UIColor commonBackgroundColor]];
    [recordView.voiceIconButton addTarget:self action:@selector(voicebuttonTouchDown) forControlEvents:UIControlEventTouchDown];
    [recordView.voiceIconButton addTarget:self action:@selector(voicebuttonTouchUp) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    
    [recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(100);
    }];
}

//停止录音
- (void)voicebuttonTouchUp
{
    [recordVolumeView removeFromSuperview];
    recordVolumeView = nil;
    sec = 0;
    min = 0;
    if (durationTimer)
    {
        [durationTimer invalidate];
        durationTimer = nil;
    }

    [self.view showWaitView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [audioRecord stopRecord];

        if (audioRecord.duration < 1)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view closeWaitView];
                [self.view showAlertMessage:@"录音时长太短，请重新录入"];
                return;
                
            });
            
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view closeWaitView];
                
                [recordView removeFromSuperview];
                
                voiceMessageView = [[CareVoiceMessageView alloc] init];
                [self.view addSubview:voiceMessageView];
                [voiceMessageView.voiceControl addTarget:self action:@selector(voiceControlClicked) forControlEvents:UIControlEventTouchUpInside];
                [voiceMessageView.deleteButton addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                [voiceMessageView.lbDuration setText:[NSString stringWithFormat:@"%d''",audioRecord.duration]];
                
                [voiceMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.equalTo(self.view);
                    make.top.equalTo(self.headView.mas_bottom).with.offset(30);
                    make.height.mas_equalTo(35);
                }];

                return;
                
            });

            
        }

    });
    
    

    
}

//录制声音
- (void)voicebuttonTouchDown
{
    [audioRecord startRecord];
    
    recordVolumeView = [[CareVoiceRecordVolumeView alloc] init];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;

    [keyWindow addSubview:recordVolumeView];
    
    [recordVolumeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(keyWindow);
    }];
    
    durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(setDurationDataTimer:) userInfo:nil repeats:YES];
}
- (void)setDurationDataTimer:(NSTimer *)timer
{
    sec += 0.5;
    if (sec >= 60)
    {
        [self voicebuttonTouchUp];
        [self.view showAlertMessage:@"语音最长60秒"];
        return;
    }
    
    
    
    [recordVolumeView.lbDuration setText:[NSString stringWithFormat:@"0%ld:%ld",(long)min,(long)sec]];
    if (sec < 10)
    {
        [recordVolumeView.lbDuration setText:[NSString stringWithFormat:@"0%ld:0%ld",(long)min,(long)sec]];
    }
}
//播放声音
- (void)voiceControlClicked
{
    NSString* tmpFilePath = [[audioRecord cacheDir] stringByAppendingPathComponent:@"audiorecord.wav"];
    
    NSData* wavdata = [NSData dataWithContentsOfFile:tmpFilePath];
    
    if (wavdata)
    {
        [voiceMessageView.ivVoice startAnimating];
        
        [[AudioPlayer shareInstance] playAudioData:wavdata callBack:^{
            [voiceMessageView.ivVoice stopAnimating];
        }];
    }
}

//删除声音
- (void)deleteButtonClicked
{
//    [sendButton setEnabled:YES];
//    [sendButton setBackgroundColor:[UIColor mainThemeColor]];
    [voiceMessageView removeFromSuperview];
    careVoiceFile = nil;
    [self initWithRecordView];
}

- (void)fillMemberDataWith:(NSArray<PatientInfo *> *)array {
    self.memberString = @"";
    __weak typeof(self) weakSelf = self;
    [array enumerateObjectsUsingBlock:^(PatientInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!idx) {
          strongSelf.memberString = [strongSelf.memberString stringByAppendingString:obj.userName];
        }
        else {
            strongSelf.memberString = [strongSelf.memberString stringByAppendingString:[NSString stringWithFormat:@"、%@",obj.userName]];
        }
    }];
    [self.selectedMemberLb setText:self.memberString];
    [self.selectedTitelLb setText:[NSString stringWithFormat:@"已选用户共%ld位",array.count]];
    [self configElements];
}

- (void)fillGroupDataWith:(NSArray<NewPatientGroupListInfoModel *> *)array {
    __block NSString *tempGroupString = @"";
    [array enumerateObjectsUsingBlock:^(NewPatientGroupListInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!idx) {
            tempGroupString = [tempGroupString stringByAppendingString:obj.teamName];
        }
        else {
            tempGroupString = [tempGroupString stringByAppendingString:[NSString stringWithFormat:@"、%@",obj.teamName]];
        }
    }];
    [self.selectedMemberLb setText:tempGroupString];
    [self.selectedTitelLb setText:[NSString stringWithFormat:@"已选群组%ld个",array.count]];
    [self configElements];
}

/**
 *  自适应字体
 */
-(CGSize)sizeWithString:(NSString*)string font:(UIFont*)font width:(float)width {
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width,   80000) options:NSStringDrawingTruncatesLastVisibleLine |   NSStringDrawingUsesFontLeading    |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size;
}

- (CGFloat)acquireTextViewHeightWithString:(NSString *)string {
    if (!string.length) {
        return 0;
    }
    CGSize size1 = [self sizeWithString:string font:[UIFont font_32] width:ScreenWidth - 30];
    return MIN(60, size1.height + 10);
}

- (NSMutableArray *)acquireUserIdArrWithArr:(NSArray<PatientInfo *> *)array {
    NSMutableArray *tempGroup = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(PatientInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempGroup addObject:[NSString stringWithFormat:@"%ld",(long)obj.userId]];
    }];
    return tempGroup;
}

- (NSMutableArray *)acquireTeamIdArrWithArr:(NSArray<NewPatientGroupListInfoModel *> *)array {
    NSMutableArray *tempGroup = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NewPatientGroupListInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempGroup addObject:[NSString stringWithFormat:@"%ld",(long)obj.teamId]];
    }];
    return tempGroup;
}
//响应进入后台通知
- (void)enterBack {
    if (recordVolumeView) {
        [self voicebuttonTouchUp];
    }
}

- (void)uploadImageWithImage:(UIImage *)image {
    //上传图片
    [self at_postLoading];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    [[TaskManager shareInstance] createTaskWithTaskName:NSStringFromClass([HMSendCareUploadImageRequest class]) taskParam:nil extParam:imageData TaskObserver:self];
}

- (void)sentCareRequest {
    [self at_postLoading];
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    if (self.selectedMembers.count)
    {
        [dicPost setValue:[self acquireUserIdArrWithArr:self.selectedMembers] forKey:@"userIds"];
    }
    if (self.selectedGroups.count)
    {
        [dicPost setValue:[self acquireTeamIdArrWithArr:self.selectedGroups] forKey:@"teamIds"];
    }
    
    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)curStaff.userId] forKey:@"doctorUserId"];
    if (careVoiceFile && careVoiceFile.length) {
        [dicPost setValue:careVoiceFile forKey:@"soundCont"];
        [dicPost setValue:[NSString stringWithFormat:@"%d",audioRecord.duration] forKey:@"soundLength"];
    }
    
    [dicPost setValue:self.concernTextView.text forKey:@"wordsCont"];
    if (self.arrayUploadedImagePath.count) {
        [dicPost setValue:self.arrayUploadedImagePath forKey:@"imgList"];
    }
    if (self.healthEducationModel) {
        [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)self.healthEducationModel.classId] forKey:@"classId"];
    }
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMSendConcernToGroupsOrPatientsRequest" taskParam:dicPost TaskObserver:self];
}

- (void)uploadImage {
    // 上传第一张图片
    if (self.arrayUploadedImagePath.count < self.selectImageVC.selectImageView.selectedImageArr.count) {
        // 上传图片
        [self uploadImageWithImage:self.selectImageVC.selectImageView.selectedImageArr[self.arrayUploadedImagePath.count]];
    }
    else {
        // 发送关怀
        [self sentCareRequest];
    }

}

- (void)uploadVoice {
    [self at_postLoading];
    NSString* tmpFilePath = [[audioRecord cacheDir] stringByAppendingPathComponent:@"audiorecord.wav"];
    NSData* wavdata = [NSData dataWithContentsOfFile:tmpFilePath];
    
    //上传语音文件
    [[TaskManager shareInstance] createTaskWithTaskName:@"CareVoiceUploadFileTask" taskParam:nil extParam:wavdata TaskObserver:self];
    
}
#pragma mark - event Response

- (void)backClick {
    if (self.concernTextView.text.length == 0 && self.selectImageVC.selectImageView.selectedImageArr.count == 0 && !
        [self.view.subviews containsObject:voiceMessageView] && !self.healthEducationModel && self.selectedGroups.count == 0 && self.selectedMembers.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:nil message:@"确定要放弃编辑吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        __weak typeof(self) weakSelf = self;
        UIAlertAction *back = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }];
        
        [alterVC addAction:cancel];
        [alterVC addAction:back];
        
        [self presentViewController:alterVC animated:YES completion:nil];
        
    }
}
//发送
- (void)sendButtonBtnClicked
{
    if (self.concernTextView.text.length > 120) {
        [self showAlertMessage:@"输入文字不能超过120字"];
        return;
    }
    
    if (self.selectedMembers.count > 200) {
        [self showAlertMessage:@"群发人数不能超过200人"];
        return;
    }
    
    if (self.isSendToGroup) {
        if (self.selectedGroups.count < 1) {
            [self showAlertMessage:@"请至少选择一个群组发送"];
            return;
        }
    }
    else {
        if (self.selectedMembers.count < 1) {
            [self showAlertMessage:@"请至少选择一个用户发送"];
            return;
        }
    }
    
    if (self.concernTextView.text.length == 0 && self.selectImageVC.selectImageView.selectedImageArr.count == 0 && !
        [self.view.subviews containsObject:voiceMessageView] && !self.healthEducationModel) {
        [self showAlertMessage:@"请填写关怀内容"];
        return;
    }
    
    [self.concernTextView resignFirstResponder];
    
    if ([self.view.subviews containsObject:voiceMessageView]) {
        // 有录音，先上传语音
        [self uploadVoice];
    }
    else {
        [self uploadImage];
    }
    
 
    

    
}
//添加患者

- (void)addMemberClick {
    if (self.isSendToGroup) {
        HMSelectGroupsViewController *groupSelectVC = [[HMSelectGroupsViewController alloc] initWithSelectedGroups:self.selectedGroups];
        __weak typeof(self) weakSelf = self;
        [groupSelectVC getSelectedGroup:^(NSArray<NewPatientGroupListInfoModel *> *selectedPatients) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.selectedGroups = [NSMutableArray arrayWithArray:selectedPatients];
            [strongSelf fillGroupDataWith:selectedPatients];
        }];
        [self.navigationController pushViewController: groupSelectVC animated:YES];
    }
    else {
        HMSendConcernSelectMemberViewController *selectVC = [[HMSendConcernSelectMemberViewController alloc] initWithTitel:@"下一步" selectedMember:self.selectedMembers];
        __weak typeof(self) weakSelf = self;
        [selectVC acquireSelcetMember:^(NSArray<PatientInfo *> *selectedPatients) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.selectedMembers = [NSMutableArray arrayWithArray:selectedPatients];
            [strongSelf fillMemberDataWith:selectedPatients];
        }];
        [self.navigationController pushViewController: selectVC animated:YES];

    }
    
}

#pragma mark - Delegate
#pragma mark--UITextViewDelegate

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITableViewDelegate

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self at_postLoading];
    if (StepError_None != taskError) {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    [self at_postLoading];
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"CareVoiceUploadFileTask"])
    {
        careVoiceFile = taskResult[@"careFileUrl"];
        [self uploadImage];
        
    }
    
    if ([taskname isEqualToString:@"HMSendConcernToGroupsOrPatientsRequest"])
    {
        NSLog(@"%@",taskResult);
        //[sendButton setEnabled:NO];
        //[sendButton setBackgroundColor:[UIColor commonCuttingLineColor]];
        if (self.block) {
            self.block();
        }
        [self.view showAlertMessage:@"发送成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    else if ([taskname isEqualToString:NSStringFromClass([HMSendCareUploadImageRequest class])]) {
        if ([taskResult isKindOfClass:[NSString class]]) {
            [self.arrayUploadedImagePath addObject:taskResult];
            if (self.arrayUploadedImagePath.count < self.selectImageVC.selectImageView.selectedImageArr.count) {
                [self performSelector:@selector(uploadImageWithImage:) withObject:self.selectImageVC.selectImageView.selectedImageArr[self.arrayUploadedImagePath.count] afterDelay:0.5];
            }
            else {
                // 发送关怀
                [self sentCareRequest];
            }
        }
    }

}

#pragma mark - Interface
- (void)sendConcernSuccess:(concernSendedsuccessBlock)block {
    self.block = block;
}

- (void)configHealthEdition:(HealthEducationItem *)model {
    self.healthEducationModel = model;
    [self.healthEditionView fillDataWithModel:model];
    [self configElements];
}

- (void)configSelectedImageArr:(NSArray *)imageArr {
    self.arrayUploadedImagePath = [NSMutableArray arrayWithArray:imageArr];
    
}
#pragma mark - init UI
- (UIView *)headView
{
    if (!_headView) {
        _headView = [UIView new];
        [_headView setBackgroundColor:[UIColor whiteColor]];
    }
    return _headView;
}
- (UILabel *)selectedTitelLb {
    if (!_selectedTitelLb) {
        _selectedTitelLb = [UILabel new];
        [_selectedTitelLb setFont:[UIFont font_32]];
        [_selectedTitelLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_selectedTitelLb setText:self.isSendToGroup? @"已选群组0个": @"已选用户共0位"];
    }
    return _selectedTitelLb;
}

- (UITextView *)selectedMemberLb {
    if (!_selectedMemberLb) {
        _selectedMemberLb = [UITextView new];
        [_selectedMemberLb setFont:[UIFont font_32]];
        [_selectedMemberLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_selectedMemberLb setEditable:NO];
    }
    return _selectedMemberLb;
}

- (UIButton *)addMemberBtn {
    if (!_addMemberBtn) {
        _addMemberBtn = [UIButton new];
        [_addMemberBtn setImage:[UIImage imageNamed:@"concern_add"] forState:UIControlStateNormal];
        [_addMemberBtn addTarget:self action:@selector(addMemberClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addMemberBtn;
}

- (UIView *)line
{
    if (!_line) {
        _line = [UIView new];
        [_line setBackgroundColor:[UIColor colorWithHexString:@"dfdfdf"]];
    }
    return _line;
}

- (UIView *)line2
{
    if (!_line2) {
        _line2 = [UIView new];
        [_line2 setBackgroundColor:[UIColor colorWithHexString:@"dfdfdf"]];
    }
    return _line2;
}

- (PlaceholderTextView *)concernTextView {
    if (!_concernTextView) {
        _concernTextView = [PlaceholderTextView new];
        [_concernTextView setPlaceholder:@"请输入关怀内容"];
        [_concernTextView setFont:[UIFont systemFontOfSize:15]];
        [_concernTextView setTextColor:[UIColor commonTextColor]];
        [_concernTextView setReturnKeyType:UIReturnKeyDone];
        [_concernTextView setDelegate:self];
    }
    return _concernTextView;
}

- (UIBarButtonItem *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonBtnClicked)];
    }
    return _rightBtn;
}

- (HMConcernHealthEditionView *)healthEditionView {
    if (!_healthEditionView) {
        _healthEditionView = [HMConcernHealthEditionView new
                              ];
    }
    return _healthEditionView;
}

- (JWSelectImageViewController *)selectImageVC{
    if (!_selectImageVC) {
        _selectImageVC = [[JWSelectImageViewController alloc]initWithMaxSelectedCount:4];
    }
    return _selectImageVC;
}

- (NSMutableArray *)selectedGroups {
    if (!_selectedGroups) {
        _selectedGroups = [NSMutableArray array];
    }
    return _selectedGroups;
}

- (NSMutableArray<NSString *> *)arrayUploadedImagePath {
    if (!_arrayUploadedImagePath) {
        _arrayUploadedImagePath = [NSMutableArray array];
    }
    return _arrayUploadedImagePath;
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
