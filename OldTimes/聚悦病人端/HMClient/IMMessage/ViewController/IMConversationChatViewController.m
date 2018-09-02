//
//  IMConversationChatViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "IMConversationChatViewController.h"
#import "ChartInputView.h"
#import "ChatExtensionInputView.h"
#import "IMChatMessageTableViewController.h"
#import "IMVoiceRecordViewController.h"
#import "AtStaffSelectViewController.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "IMNoPrivilegeView.h"
//@interface IMNoPrivilegeView : UIView
//{
//    
//}
//@end
//
//@implementation IMNoPrivilegeView
//
//- (id) init
//{
//    self = [super init];
//    if (self)
//    {
//        [self setBackgroundColor:[UIColor colorWithHexString:@"FEFFEE"]];
//        UILabel* lbVip = [[UILabel alloc]init];
//        [self addSubview:lbVip];
//        [lbVip setBackgroundColor:[UIColor clearColor]];
//        [lbVip setText:@"订购VIP服务进行在线咨询"];
//        [lbVip setFont:[UIFont font_30]];
//        [lbVip setTextColor:[UIColor commonTextColor]];
//        
//        [lbVip mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).with.offset(12.5);
//            make.centerY.equalTo(self);
//        }];
//        
//        UIButton* updateServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self addSubview:updateServiceButton];
//        [updateServiceButton setBackgroundImage:[UIImage rectImage:CGSizeMake(90, 30) Color:[UIColor commonRedColor]] forState:UIControlStateNormal];
//        [updateServiceButton setTitle:@"立即订购" forState:UIControlStateNormal];
//        updateServiceButton.layer.cornerRadius = 2.5;
//        updateServiceButton.layer.masksToBounds = YES;
//        [updateServiceButton.titleLabel setFont:[UIFont font_24]];
//        [updateServiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        
//        [updateServiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(90, 30));
//            make.right.equalTo(self).with.offset(-12.5);
//            make.centerY.equalTo(self);
//        }];
//        
//        [updateServiceButton addTarget:self action:@selector(updateServiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return self;
//}

//- (void) updateServiceButtonClicked:(id) sender
//{
//    //ServiceCategoryStartViewController
//    [HMViewControllerManager createViewControllerWithControllerName:@"ServiceCategoryStartViewController" ControllerObject:nil];
//}
//
//@end

@interface IMConversationChatViewController ()
<ChartInputDelegate,
ChatExtensionInputDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
TaskObserver>
{
    ChartInputView* inputview;
    ChatExtensionInputView* extensionview;
    IMChatMessageTableViewController* tvcMessage;
    NSString* grouptargetId;
    ContactDetailModel* targetDetail;
    IMVoiceRecordViewController* vcVoiceRecord;
    CGFloat keyboardhight;
    
    IMNoPrivilegeView* noPrivilegeView;
}
@end

@implementation IMConversationChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    inputview = [[ChartInputView alloc]init];
    [self.view addSubview:inputview];
    [inputview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(@49);
    }];
    [inputview setDelegate:self];
    
    extensionview = [[ChatExtensionInputView alloc]init];
    [self.view addSubview:extensionview];
    [extensionview setDelegate:self];
    [extensionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(@90);
       
        
    }];
    
    [extensionview setHidden:YES];
    
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self registerForKeyboardNotifications];
    
    //update by YinQ at 2016.08.02
    //是否有权限进行图文资询
    if ([UserServicePrivilegeHelper userHasPrivilege:ServicePrivile_Conversation])
    {
        //拥有图文咨询权限
        if (noPrivilegeView)
        {
            [noPrivilegeView removeFromSuperview];
        }
    }
    else
    {
        //没有图文咨询权限
        if (!noPrivilegeView)
        {
            noPrivilegeView = [[IMNoPrivilegeView alloc]init];
            [inputview addSubview:noPrivilegeView];
            [noPrivilegeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.equalTo(inputview);
                make.top.and.height.equalTo(inputview);
            }];
        }
    }
}

- (void) setTeamId:(NSInteger) teamId
{
    //获取会话ID
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", teamId] forKey:@"teamId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"TeamImGroupIdTask" taskParam:dicPost TaskObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    [self closeExtensionView];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"hight_hitht:%f",kbSize.height);
    if (kbSize.height == keyboardhight)
    {
        return;
    }
    keyboardhight = kbSize.height;
    
    //输入框位置动画加载
    [self begainMoveAnimation:keyboardhight];
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    keyboardhight = 0;
    [self begainMoveAnimation:keyboardhight];
}

- (void) begainMoveAnimation:(CGFloat) height
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];

    [inputview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-height);
    }];
    
    [UIView commitAnimations];
    [self performSelector:@selector(scrollMessageTable) withObject:nil afterDelay:0.6];
//    [UIView animateWithDuration:animationDuration animations:^{
//        
//    } completion:^(BOOL finished) {
//        [tvcMessage scrollToBottom];
//    }];
    
    
}

#pragma mark - ChartInputDelegate

- (void) appendbuttonClicked
{
    if (extensionview.hidden)
    {
        [self showExtensionView];
    }
    else
    {
        [self closeExtensionView];
    }
}

- (void) inputtypebuttonClicked
{
    [self closeExtensionView];
}

- (void) showExtensionView
{
    [extensionview setHidden:NO];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGFloat inputHeitht = inputview.height;
    [inputview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(extensionview.mas_top);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo([NSNumber numberWithFloat:inputHeitht]);
    }];
    
    [tvcMessage scrollToBottom];
    
    [UIView commitAnimations];
    [self performSelector:@selector(scrollMessageTable) withObject:nil afterDelay:0.5];
//    [UIView animateWithDuration:animationDuration animations:^{
//        
//    } completion:^(BOOL finished) {
//        [tvcMessage scrollToBottom];
//    }];
}

- (void) closeExtensionView
{
    [extensionview setHidden:YES];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGFloat inputHeitht = inputview.height;
    [inputview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo([NSNumber numberWithFloat:inputHeitht]);
    }];
    
//   
//    [UIView animateWithDuration:animationDuration animations:^{
//        
//    } completion:^(BOOL finished) {
//         [tvcMessage scrollToBottom];
//    }];
    [UIView commitAnimations];
    [self performSelector:@selector(scrollMessageTable) withObject:nil afterDelay:0.5];
}

- (void) scrollMessageTable
{
    [tvcMessage scrollToBottom];
}

- (void) textInput:(NSString *)text
{
    //UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    [[MessageManager share] sendMessageTo:grouptargetId nick:targetDetail._nickName WithContent:text Type:msg_personal_text];
}

- (void) textInputAt
{
    NSLog(@"textInputAt");
    //弹出医生列表
    if (!_staffs || 0 == _staffs.count)
    {
        return;
    }
    
    UIViewController* vcTop = [HMViewControllerManager topMostController];
    [AtStaffSelectViewController showInParentController:vcTop StaffList:_staffs AtSelectStaffBlock:^(StaffInfo* staff) {
        [inputview appendAtStaff:staff.staffName];
    }];
}

- (void) voicestartrecord
{
    if (vcVoiceRecord) {
        [vcVoiceRecord.view removeFromSuperview];
        [vcVoiceRecord removeFromParentViewController];
        vcVoiceRecord = nil;
    }
    
    vcVoiceRecord = [[IMVoiceRecordViewController alloc]initWithTargetId:grouptargetId];
    [self addChildViewController:vcVoiceRecord];
    [self.view addSubview:vcVoiceRecord.view];
    [vcVoiceRecord.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(tvcMessage.view);
        make.top.bottom.equalTo(tvcMessage.view);
    }];
}

- (void) voiceendrecord
{
    if (vcVoiceRecord)
    {
        NSString* wavPath = [vcVoiceRecord stopRecord];
        
        //发送语音消息
        NSString *strRelativeOrigin = [[MsgFilePathMgr share] getRelativePathWithAllPath:wavPath];
        if (wavPath)
        {
            [[MessageManager share] anchorAttachMessageType:msg_personal_voice
                                                   toTarget:grouptargetId
                                                   nickName:targetDetail._nickName
                                                primaryPath:strRelativeOrigin
                                                  minorPath:nil];
        }
         
        vcVoiceRecord = nil;
    }
}

- (void) caremaButtonClicked
{
    [self closeExtensionView];
    UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypePhotoLibrary;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sourcheType = UIImagePickerControllerSourceTypeCamera;
    }
    [self createImagePicker:sourcheType];
}

- (void) pictureButtonClicked
{
    [self closeExtensionView];
    [self createImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void) createImagePicker:(UIImagePickerControllerSourceType)sourcheType
{
    UIImagePickerController* imgpicker = [[UIImagePickerController alloc]init];
    [imgpicker setSourceType:sourcheType];
    imgpicker.delegate = self;
    //[self presentModalViewController:imgpicker animated:YES];
    [self presentViewController:imgpicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image)
    {
        //生产缩略图
        UIImage* thumbImage = [image thumbnailImage];
        [self writeImageToFilePathWithOringnalImage:image thumbImage:thumbImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)writeImageToFilePathWithOringnalImage:(UIImage *)originImage thumbImage:(UIImage *)thumbImage;
{
    // 1.文件写入沙盒
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        
        // 得到路径
        long long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
        NSString *strDate = [NSString stringWithFormat:@"%lld",timeStamp];
        NSString *strFileNameOriginal = [NSString stringWithFormat:@"%@origin.jpg",strDate];
        NSString *strFileNameThumb = [NSString stringWithFormat:@"%@thumb.jpg",strDate];
        NSString *strPath = [[MsgFilePathMgr share] getMessageDirNamePathWithUid:grouptargetId];
        NSString *strOriginPath = [strPath stringByAppendingPathComponent:strFileNameOriginal];
        NSString *strThumbPath = [strPath stringByAppendingPathComponent:strFileNameThumb];
        
        // 写入文件夹
        [UIImageJPEGRepresentation(originImage, 0.5) writeToFile:strOriginPath atomically:YES];
        [UIImageJPEGRepresentation(thumbImage, 1.0) writeToFile:strThumbPath atomically:YES];
        
        
        // 转换成相对路径
        NSString *strRelativeOrigin = [[MsgFilePathMgr share] getRelativePathWithAllPath:strOriginPath];
        NSString *strRelativeThumb = [[MsgFilePathMgr share] getRelativePathWithAllPath:strThumbPath];
        
        // 回归主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 2. 下锚点
            [[MessageManager share] anchorAttachMessageType:msg_personal_image
                                                   toTarget:grouptargetId
                                                   nickName:targetDetail._nickName
                                                primaryPath:strRelativeOrigin
                                                  minorPath:strRelativeThumb];
        });
    });
}


#pragma mark -TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length) {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length) {
        return;
    }
    
    if ([taskname isEqualToString:@"TeamImGroupIdTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSString class]])
        {
            NSString* targetId = (NSString*) taskResult;
            if (!targetId || 0 == targetId) {
                return;
            }
            
            grouptargetId = (NSString*) taskResult;
            if (tvcMessage)
            {
                [tvcMessage.tableView removeFromSuperview];
                [tvcMessage removeFromParentViewController];
                tvcMessage = nil;
            }
            
            [[MessageManager share] querySessionDataWithUid:grouptargetId completion:^(ContactDetailModel *detailModel) {
                targetDetail = detailModel;
            }];
            
            tvcMessage = [[IMChatMessageTableViewController alloc]initWithTargetId:grouptargetId];
            [self addChildViewController:tvcMessage];
            [self.view addSubview:tvcMessage.tableView];
            [tvcMessage.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.equalTo(self.view);
                make.top.equalTo(self.view);
                make.bottom.equalTo(inputview.mas_top);
            }];
        }
    }
}
@end
