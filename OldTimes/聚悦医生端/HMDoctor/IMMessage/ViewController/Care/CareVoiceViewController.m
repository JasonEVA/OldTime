//
//  CareVoiceViewController.m
//  HMDoctor
//
//  Created by lkl on 16/6/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CareVoiceViewController.h"
#import "PatientInfo.h"
#import "PlaceholderTextView.h"
#import "CareVoiceRecordVolumeView.h"
#import "AudioRecord.h"
#import "AudioPlayer.h"

#import "PatientInfo.h"
#import "HMThirdEditionPatitentInfoModel.h"

@interface CareVoiceViewController ()<TaskObserver,UITextViewDelegate>
{
    PlaceholderTextView *txView;
    UIButton* sendButton;
    
    CareVoiceRecordVolumeView *recordVolumeView;
    CareVoiceMessageView* voiceMessageView;
    CareVoiceRecordView* recordView;
    
    AudioRecord *audioRecord;
    NSString* careVoiceFile;
    //NSString* targetUserId;
    PatientInfo* patient;
    
    NSTimer* durationTimer;
    NSInteger sec;
    NSInteger min;
}
@end

@implementation CareVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[PatientInfo class]])
    {
        patient = self.paramObject;
    }

    if (!patient.sex) {
        [self.navigationItem setTitle:[NSString stringWithFormat:@"%@ (空, 00)", patient.userName]];
        [self startPatientInfoRequest];
    }
    else {
        [self.navigationItem setTitle:[NSString stringWithFormat:@"%@ (%@, %ld)", patient.userName, patient.sex, patient.age]];
    }

    [self initWithSubViews];
    
    [self initWithRecordView];
    
    audioRecord = [[AudioRecord alloc] init];
}

- (void)initWithSubViews
{
    txView = [[PlaceholderTextView alloc]init];
    [self.view addSubview:txView];
    [txView setPlaceholder:@"请输入关怀文本"];
    [txView.layer setBorderWidth:1.0f];
    [txView.layer setBorderColor:[UIColor commonControlBorderColor].CGColor];
    
    [txView setFont:[UIFont systemFontOfSize:14]];
    [txView setTextColor:[UIColor commonTextColor]];
    [txView setReturnKeyType:UIReturnKeyDone];
    [txView setDelegate:self];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:sendButton];
    [sendButton setBackgroundColor:[UIColor mainThemeColor]];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton.layer setCornerRadius:5.0f];
    [sendButton.layer setMasksToBounds:YES];
    
    [sendButton addTarget:self action:@selector(sendButtonBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [txView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.top.equalTo(self.view).with.offset(15);
        make.height.mas_equalTo(@200);
    }];
    
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
        make.left.equalTo(txView);
        make.right.equalTo(self.view).with.offset(-15);
        make.height.mas_equalTo(45);
    }];
}

- (void)initWithRecordView
{
    recordView = [[CareVoiceRecordView alloc] init];
    [self.view addSubview:recordView];
    [recordView setBackgroundColor:[UIColor whiteColor]];
    [recordView.voiceIconButton addTarget:self action:@selector(voicebuttonTouchDown) forControlEvents:UIControlEventTouchDown];
    [recordView.voiceIconButton addTarget:self action:@selector(voicebuttonTouchUp) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    
    [recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(txView.mas_bottom).with.offset(35);
        make.height.mas_equalTo(100);
    }];
}

- (void)startPatientInfoRequest {
    //获取患者的信息
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",patient.userId] forKey:@"userId"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMThirdEditionPatitentInfoRequest" taskParam:dicPost TaskObserver:self];
}

//停止录音
- (void)voicebuttonTouchUp
{
    [recordVolumeView removeFromSuperview];
    [audioRecord stopRecord];

    sec = 0;
    min = 0;
    if (durationTimer)
    {
        [durationTimer invalidate];
        durationTimer = nil;
    }
    
    if (audioRecord.duration <= 0)
    {
        [self.view showAlertMessage:@"录音时长太短，请重新录入"];
        return;
    }
    [recordView removeFromSuperview];
    
    voiceMessageView = [[CareVoiceMessageView alloc] init];
    [self.view addSubview:voiceMessageView];
    [voiceMessageView.voiceControl addTarget:self action:@selector(voiceControlClicked) forControlEvents:UIControlEventTouchUpInside];
    [voiceMessageView.deleteButton addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [voiceMessageView.lbDuration setText:[NSString stringWithFormat:@"%d''",audioRecord.duration]];
    
    [voiceMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(txView.mas_bottom).with.offset(30);
        make.height.mas_equalTo(35);
    }];
    
    
    NSString* tmpFilePath = [[audioRecord cacheDir] stringByAppendingPathComponent:@"audiorecord.wav"];
    NSData* wavdata = [NSData dataWithContentsOfFile:tmpFilePath];
    
    //上传语音文件
    [[TaskManager shareInstance] createTaskWithTaskName:@"CareVoiceUploadFileTask" taskParam:nil extParam:wavdata TaskObserver:self];
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
    
    durationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(setDurationDataTimer:) userInfo:nil repeats:YES];
}

- (void)setDurationDataTimer:(NSTimer *)timer
{
    sec++;
    if (sec >= 60)
    {
        sec = 0;
        min ++;
    }
    
    [recordVolumeView.lbDuration setText:[NSString stringWithFormat:@"0%d:%d",min,sec]];
    if (sec < 10)
    {
        [recordVolumeView.lbDuration setText:[NSString stringWithFormat:@"0%d:0%d",min,sec]];
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
    [sendButton setEnabled:YES];
    [sendButton setBackgroundColor:[UIColor mainThemeColor]];
    [voiceMessageView removeFromSuperview];
    [self initWithRecordView];
}



//发送
- (void)sendButtonBtnClicked
{
    [self at_postLoading];
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    
    NSMutableDictionary* dicPost = [[NSMutableDictionary alloc] init];
    if (patient)
    {
        [dicPost setValue:@[[NSString stringWithFormat:@"%ld", patient.userId]] forKey:@"userIds"];
    }
    
    [dicPost setValue:[NSString stringWithFormat:@"%ld",(long)curStaff.userId] forKey:@"doctorUserId"];
    if (careVoiceFile && careVoiceFile.length) {
        [dicPost setValue:careVoiceFile forKey:@"soundCont"];
        [dicPost setValue:[NSString stringWithFormat:@"%d",audioRecord.duration] forKey:@"soundLength"];
    }
    
    [dicPost setValue:txView.text forKey:@"wordsCont"];
   
    [[TaskManager shareInstance] createTaskWithTaskName:@"HMSendConcernToGroupsOrPatientsRequest" taskParam:dicPost TaskObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    if (StepError_None != taskError) {
        [self at_hideLoading];
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    [self at_hideLoading];

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

    }
    else if ([taskname isEqualToString:@"HMSendConcernToGroupsOrPatientsRequest"])
    {
        NSLog(@"%@",taskResult);
        //[sendButton setEnabled:NO];
        //[sendButton setBackgroundColor:[UIColor commonCuttingLineColor]];
        [self.view showAlertMessage:@"发送成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([taskname isEqualToString:@"HMThirdEditionPatitentInfoRequest"])
    {
        HMThirdEditionPatitentInfoModel *model = (HMThirdEditionPatitentInfoModel *)taskResult;
        [self.navigationItem setTitle:[NSString stringWithFormat:@"%@ (%@, %ld)", model.userInfo.userName, model.userInfo.sex, model.userInfo.age]];

    }

}


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

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [sendButton setEnabled:YES];
    [sendButton setBackgroundColor:[UIColor mainThemeColor]];
}


@end
