//
//  AppointmentSymptomInputViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AppointmentSymptomInputViewController.h"
#import "PlaceholderTextView.h"
#import "AppointmentImageList.h"

@interface AppointmentSymptomInputViewController ()
<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,TaskObserver>
{
    UIView* headerview;
    PlaceholderTextView* tvSymptom;
    
    UIView* imagelistview;  //添加图片View
    
    AppointmentImageListView* photoListView;
    AppointmentImageClickControl *clickedImageControl;
    NSMutableArray *picUrls;
}

@end

@implementation AppointmentSymptomInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self createHeaderView];
    
    tvSymptom = [[PlaceholderTextView alloc]init];
    [self.view addSubview:tvSymptom];
    [tvSymptom setPlaceholder:@"请输入详细症状，病因，想获取的帮助等。"];
    [tvSymptom.layer setBorderWidth:0.5];
    [tvSymptom.layer setBorderColor:[UIColor commonControlBorderColor].CGColor];
    
    [tvSymptom setFont:[UIFont font_28]];
    [tvSymptom setTextColor:[UIColor commonTextColor]];
    [tvSymptom setReturnKeyType:UIReturnKeyDone];
    [tvSymptom setDelegate:self];
    
    [tvSymptom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.top.equalTo(headerview.mas_bottom);
        make.height.mas_equalTo(@93);
    }];
    
    imagelistview = [[UIView alloc]init];
    [self.view addSubview:imagelistview];
    [imagelistview setBackgroundColor:[UIColor whiteColor]];
    
    [imagelistview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(tvSymptom);
        make.height.mas_equalTo(@50);
        make.top.equalTo(tvSymptom.mas_bottom);
    }];
    
    [self initImageListView];
    
    UILabel* lbAppendImage = [[UILabel alloc]init];
    [self.view addSubview:lbAppendImage];
    [lbAppendImage setTextColor:[UIColor commonTextColor]];
    [lbAppendImage setFont:[UIFont font_25]];
    [lbAppendImage setText:@"添加图片"];
    
    [lbAppendImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imagelistview);
        make.top.equalTo(imagelistview.mas_bottom).with.offset(3);
    }];
    
    UILabel* lbAppendLimit = [[UILabel alloc]init];
    [self.view addSubview:lbAppendLimit];
    [lbAppendLimit setTextColor:[UIColor commonGrayTextColor]];
    [lbAppendLimit setFont:[UIFont font_25]];
    [lbAppendLimit setText:@"(最多5张)"];
    
    [lbAppendLimit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbAppendImage.mas_right);
        make.top.equalTo(lbAppendImage);
    }];
    
    UILabel* lbAppendNotice = [[UILabel alloc]init];
    [self.view addSubview:lbAppendNotice];
    [lbAppendNotice setTextColor:[UIColor commonTextColor]];
    [lbAppendNotice setFont:[UIFont font_25]];
    [lbAppendNotice setText:@"症状部位，检查报告或者其他病情资料"];
    
    [lbAppendNotice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbAppendImage);
        make.top.equalTo(lbAppendImage.mas_bottom).with.offset(3);
    }];
    
    if (!picUrls) {
        picUrls = [[NSMutableArray alloc] init];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createHeaderView
{
    headerview = [[UIView alloc]init];
    [self.view addSubview:headerview];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    [headerview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@40);
    }];
    
    UIImageView* ivFlag = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_list_line"]];
    [headerview addSubview:ivFlag];
    [ivFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerview);
        make.left.equalTo(headerview).with.offset(12.5);
        make.size.mas_equalTo(CGSizeMake(2, 14));
    }];
    
    UILabel* lbHeader = [[UILabel alloc]init];
    [headerview addSubview:lbHeader];
    [lbHeader setTextColor:[UIColor mainThemeColor]];
    [lbHeader setFont:[UIFont font_30]];
    [lbHeader setText:@"症状描述"];
    [lbHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerview);
        make.left.equalTo(ivFlag).with.offset(5);
    }];
}

- (void) initImageListView
{
    photoListView = [[AppointmentImageListView alloc]initWithImageControlBlock:^(id control) {
        
        [self imageControlClick:control];
    }];
    [imagelistview addSubview:photoListView];
    [photoListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imagelistview);
        make.centerY.equalTo(imagelistview);
        make.width.equalTo(imagelistview);
        make.height.mas_equalTo(50);
    }];
}

- (void) imageControlClick:(id) sender
{
    if (![sender isKindOfClass:[AppointmentImageClickControl class]])
    {
        return;
    }
    clickedImageControl = (AppointmentImageClickControl*) sender;
    
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
    
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    picker.allowsEditing=YES;
    picker.delegate=self;
    [self presentViewController:picker animated:YES completion:nil];

}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    NSLog(@"imagePickerControllerDidCancel");
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

//上传图片的协议与代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    [clickedImageControl setImage:image];
    //[photoListView imageListChanged];
    
    //选取完图片之后关闭视图
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //上传图片
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"SymptomImageListTask" taskParam:nil extParam:imageData TaskObserver:self];
}



#pragma mark--UITextViewDelegate

- (NSString*) symptomText
{
    if (tvSymptom)
    {
        return tvSymptom.text;
    }
    return nil;
}


- (NSArray*)imageUrls
{
    [photoListView imageListChanged];
    [picUrls removeAllObjects];
    
    for (NSInteger index = 0; index < photoListView.imageControls.count; ++index)
    {
        AppointmentImageClickControl* curControl = photoListView.imageControls[index];
        if (curControl.imgUrl)
        {
            [picUrls addObject:curControl.imgUrl];
        }
        
    }
    return picUrls;
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    
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
    
    if ([taskname isEqualToString:@"SymptomImageListTask"])
    {
       NSString *imageUrl = [taskResult valueForKey:@"picUrl"];
        
        if(imageUrl)
        {
            [clickedImageControl setimageUrl:imageUrl];
            [photoListView imageListChanged];
        }
    }
}
@end
