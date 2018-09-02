//
//  BloodFatDetectResultViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodSugarDetectResultViewController.h"
#import "BloodSugarDetectRecord.h"

#import "BloodSugarResultDetectTimeView.h"
#import "BloodSugarResultView.h"
#import "BloodSugarResultSymptomView.h"
#import "UpdateResultSymptomView.h"

#import "ImageCutViewController.h"

@interface BloodSugarDetectResultViewController ()
<UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
ImageCutViewDelegate,
UITextViewDelegate>
{
    UIScrollView* scrollview;
    UIView* contentview;
    BloodSugarResultDetectTimeView* detectTimeView;
    BloodSugarResultView* resultView;
//    BloodSugarResultSymptomView* symptomView;
//    
//    BloodSugarResultSymptomImageControl* clickedImageControl;
    
    UpdateResultSymptomView *updateSymptomView;
    
    CGFloat keyboardHeight;
}
@end

@implementation BloodSugarDetectResultViewController


- (void) dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"测量结果"];
    [self.view setBackgroundColor:[UIColor commonBackgroundColor]];
    
    UIButton* historybutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 25)];
    [historybutton setTitle:@"历史记录" forState:UIControlStateNormal];
    [historybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [historybutton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [historybutton addTarget:self action:@selector(entryRecordHistoryViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* bbiHistory = [[UIBarButtonItem alloc]initWithCustomView:historybutton];
    [self.navigationItem setRightBarButtonItem:bbiHistory];
    
    CGRect rtScroll = CGRectMake(0, 0, self.view.width, 504);
    scrollview = [[UIScrollView alloc]initWithFrame:rtScroll];
    [self.view addSubview:scrollview];
    
    
    contentview = [[UIView alloc]initWithFrame:scrollview.bounds];
    [scrollview addSubview:contentview];
    //[contentview setBackgroundColor:[UIColor redColor]];
    [self createResultView];
    
    

    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void) entryRecordHistoryViewController:(id) sender
{
    UserInfo* targetUser = [[UserInfo alloc]init];
    if (!detectResult || 0 == detectResult.userId) {
        return;
    }
    [targetUser setUserId:detectResult.userId];
    [HMViewControllerManager createViewControllerWithControllerName:@"BloodSugarRecordsStartViewController" ControllerObject:targetUser];
}

- (NSString*) resultTaskName
{
    return @"BloodSugarDetectResultTask";
}

- (void) createResultView
{
    detectTimeView = [[BloodSugarResultDetectTimeView alloc]init];
    [contentview addSubview:detectTimeView];
    
    resultView = [[BloodSugarResultView alloc]init];
    [contentview addSubview:resultView];
    
//    symptomView = [[BloodSugarResultSymptomView alloc]initWithImageControlBlock:^(id control) {
//        
//        [self imageControlClicked:control];
//    }];
//    [symptomView.tvSymptom setReturnKeyType:UIReturnKeyDone];
//    [symptomView.tvSymptom setDelegate:self];
//    
//    [contentview addSubview:symptomView];

    //[contentview setUserInteractionEnabled:YES];
    [self subviewLayout];
    
    [scrollview setContentSize:contentview.size];
}

- (void) subviewLayout
{
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self.view);
        make.bottom.and.right.equalTo(self.view);
    }];
    
    [contentview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(scrollview);
        make.width.equalTo(scrollview);
        make.height.mas_equalTo(504 * kScreenScale);
    }];
    
    [detectTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(contentview);
        make.top.equalTo(contentview);
        make.height.mas_equalTo(@60);
    }];
    
    [resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(contentview);
        make.top.equalTo(detectTimeView.mas_bottom).with.offset(5);
        make.height.mas_equalTo(@200);
    }];
    
//    [symptomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(contentview);
//        make.bottom.equalTo(contentview);
//        make.top.equalTo(resultView.mas_bottom);
//    }];
}


- (void) detectResultLoaded:(BloodSugarDetectResult*) result
{
    if (!result)
    {
        return;
    }
    
    if (result.dataDets.XT_IMGS.count > 0 || result.diet.length > 0)
    {
        updateSymptomView = [[UpdateResultSymptomView alloc] init];
        [self.view addSubview:updateSymptomView];
        [updateSymptomView setSymptom:result.diet];
        [updateSymptomView setImage:result.dataDets.XT_IMGS];
        
        [updateSymptomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(contentview);
            make.bottom.equalTo(contentview);
            make.top.equalTo(resultView.mas_bottom);
        }];
    }
    
    [detectTimeView setDetectResult:result];
    [resultView setDetectResult:result];
}

- (void) imageControlClicked:(id) sender
{
    if (![sender isKindOfClass:[BloodSugarResultSymptomImageControl class]])
    {
        return;
    }
//    clickedImageControl = (BloodSugarResultSymptomImageControl*) sender;
//    [symptomView.tvSymptom resignFirstResponder];
    
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机拍摄" otherButtonTitles:@"相册图片", nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionSheet clickedButtonAtIndex %ld", buttonIndex);
    UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypePhotoLibrary;
    switch (buttonIndex)
    {
        case 0:
        {
            //相机拍摄
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                sourcheType = UIImagePickerControllerSourceTypeCamera;
            }
        }
            break;
        case 1:
        {
            //相册图片
            sourcheType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
            break;
        case 2:
        {
            //取消
            return;
        }
            break;
        default:
            break;
    }
    
    //创建ImagePicker
    UIImagePickerController* imgpicker = [[UIImagePickerController alloc]init];
    [imgpicker setSourceType:sourcheType];
    imgpicker.delegate = self;
    //[self presentModalViewController:imgpicker animated:YES];
    [self presentViewController:imgpicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    NSLog(@"imagePickerControllerDidCancel");
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"didFinishPickingImage");
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    ImageCutViewController* vcImageCut = [[ImageCutViewController alloc]initWithImage:image];
    [vcImageCut setDelegate:self];
    [vcImageCut setScaleInPex:512];
    //UINavigationController* navCut = [[UINavigationController alloc]initWithRootViewController:vcImageCut];
    
    [self.navigationController presentViewController:vcImageCut animated:YES completion:nil];
}


- (void) imageCutViewController:(ImageCutViewController*) controller imageCutAndScaled:(UIImage*) image
{
    UIImage* postImage = image;
    
//    [clickedImageControl setImage:postImage];
//    [symptomView imageListChanged];
    //[ivCuted setImage:image];
//    [controller dismissViewControllerAnimated:YES completion:nil];
//    NSData *imageData = UIImageJPEGRepresentation(postImage, 1.0);
//    [self.tableView.superview showWaitView:@"更改用户头像"];
    
//    [[TaskManager shareInstance] createTaskWithTaskName:@"UserPhotoUpdateTask" taskParam:nil extParam:imageData TaskObserver:self];
    
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text && [text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    keyboardHeight = keyboardSize.height;
    ///keyboardWasShown = YES;
    /*
    if (symptomView.tvSymptom)
    {
        
        CGFloat offsetHeight = scrollview.height - 32 - (keyboardHeight + symptomView.tvSymptom.bottom + symptomView.top);
        if (offsetHeight > 0) {
            offsetHeight = 0;
        }
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
        
        contentview.frame = CGRectMake(0.0f, offsetHeight, contentview.width, contentview.height);//64-216
        
        [UIView commitAnimations];
    }
    */
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    keyboardHeight = 0;
    // keyboardWasShown = NO;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    contentview.frame = CGRectMake(0.0f, 0.0f, contentview.width, contentview.height);//64-216
    [UIView commitAnimations];
}
@end
