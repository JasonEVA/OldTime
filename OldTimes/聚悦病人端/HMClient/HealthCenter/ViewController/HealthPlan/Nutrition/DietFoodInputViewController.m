//
//  DietFoodInputViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DietFoodInputViewController.h"
#import "NuritionDetail.h"
#import "ZJKDatePickerSheet.h"
#import "PlaceholderTextView.h"
#import "DeviceTestTimeSelectView.h"


@interface DietFoodDateInputControl : UIControl
{
    UILabel* lbDate;
    NSDate *currentDate;
}
- (void) setDate:(NSDate*) date;
- (NSDate *) getDate;
@end

@implementation DietFoodDateInputControl

- (id) init
{
    self = [super init];
    if (self)
    {
        self.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 2.5;
        self.layer.masksToBounds = YES;

        lbDate = [[UILabel alloc]init];
        [self addSubview:lbDate];
        [lbDate setFont:[UIFont font_30]];
        [lbDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(10);
            make.centerY.equalTo(self);
        }];
        
        UIImageView* ivArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_down_list_arrow"]];
        [self addSubview:ivArrow];
        [ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-10);
            make.centerY.equalTo(self);
            //make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        [self setDate:[NSDate date]];
    }
    return self;
}

- (void) setDate:(NSDate*) date
{
    currentDate = date;
    NSString* dateStr = [date formattedDateWithFormat:@"yyyy年MM月dd日"];
    [lbDate setText:dateStr];
}

- (NSDate *) getDate {
    return currentDate;
}

@end


@interface DietFoodInputViewController ()
<ZJKPickerSheetDelegate,
UITextViewDelegate,
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
TaskObserver,UIScrollViewDelegate>
{
    NuritionDietAppendParam* appendParam;
    DietFoodDateInputControl* dateControl;
    NSDate* date;
    
    PlaceholderTextView* tvFood;
    UIImageView* ivPhoto;
    
    NSString* imageUrl;
}

@property(nonatomic, strong) UIScrollView  *scrollview;
@property(nonatomic, strong) UIView  *comPickerview;

@end

@implementation DietFoodInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"添加饮食"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollview];
    [self.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIButton* bbi = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 25)];
    [bbi setTitle:@"保存" forState:UIControlStateNormal];
    [bbi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bbi.titleLabel setFont:[UIFont font_30]];
    [bbi addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* bbisave = [[UIBarButtonItem alloc]initWithCustomView:bbi];
    
    [self.navigationItem setRightBarButtonItem:bbisave];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NuritionDietAppendParam class]])
    {
        appendParam = (NuritionDietAppendParam*) self.paramObject;
        if (appendParam.date)
        {
            date = [NSDate dateWithString:appendParam.date formatString:@"yyyy-MM-dd"];
        }
        NSString* title = @"添加饮食";
        switch (appendParam.dietType) {
            case 1:
                title = @"添加早餐";
                break;
            case 2:
                title = @"添加午餐";
                break;
            case 3:
                title = @"添加晚餐";
                break;
            case 4:
                title = @"添加加餐";
                break;
            default:
                break;
        }
        [self.navigationItem setTitle:title];
    }

    [self createDateControl];
    
    tvFood = [[PlaceholderTextView alloc]init];
    [self.scrollview addSubview:tvFood];
    [tvFood mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.top.equalTo(dateControl.mas_bottom).with.offset(10);
        make.height.mas_equalTo(@58);
    }];
    [tvFood setFont:[UIFont font_28]];
    [tvFood setPlaceholder:@"请简单描述这一餐(不超过30个字)，如2个蔬菜包子，一杯豆浆"];
    
    tvFood.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
    tvFood.layer.borderWidth = 0.5;
    tvFood.layer.cornerRadius = 2.5;
    tvFood.layer.masksToBounds = YES;
    [tvFood setReturnKeyType:UIReturnKeyDone];
    [tvFood setDelegate:self];
    
    UIButton* imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scrollview addSubview:imageButton];
    [imageButton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 45) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
    [imageButton setTitle:@"给你的美食拍张照" forState:UIControlStateNormal];
    [imageButton.titleLabel setFont:[UIFont font_30]];
    [imageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    imageButton.layer.cornerRadius = 2.5;
    imageButton.layer.masksToBounds = YES;
    
    [imageButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollview).with.offset(12.5);
        make.width.equalTo(@(ScreenWidth - 25));
        make.top.equalTo(tvFood.mas_bottom).with.offset(300);
        make.height.mas_equalTo(@45);
    }];
    
    [imageButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self createPhotoView];
}

#pragma mark - UIScrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self checkForOnce];
    [self.view endEditing:YES];
    
}

#pragma mark - privateMethod
- (void)checkForOnce {
    if (self.comPickerview) {
        [self.comPickerview removeFromSuperview];
        self.comPickerview = nil;
    }
}

- (void) saveButtonClicked:(id) sender
{
    [self checkForOnce];
    [self.view endEditing:YES];
    NSString* foodname = tvFood.text;
    if (!foodname || 0 == foodname.length)// || !imageUrl || 0 == imageUrl.length)
    {
        [self showAlertMessage:@"请输入食物的描述。"];
        return;
    }
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSNumber numberWithInteger:appendParam.dietType] forKey:@"dietType"];
    if (date)
    {
        NSString* dateStr = [date formattedDateWithFormat:@"yyyy-MM-dd"];
        [dicPost setValue:dateStr forKey:@"date"];
        
        
    }
    [dicPost setValue:foodname forKey:@"dietDesc"];
    if (imageUrl)
    {
        NSArray* images = @[imageUrl];
        [dicPost setValue:images forKey:@"foodPicUrls"];
    }
    [self.view showWaitView];
    //AppendDietRecordTask
    [[TaskManager shareInstance] createTaskWithTaskName:@"AppendDietRecordTask" taskParam:dicPost TaskObserver:self];
}

- (void) createDateControl
{
    dateControl = [[DietFoodDateInputControl alloc]init];
    [self.scrollview addSubview:dateControl];
    
    [dateControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollview).with.offset(12.5);
        make.width.equalTo(@(ScreenWidth - 25));
        make.top.equalTo(self.scrollview).with.offset(10);
        make.height.mas_equalTo(@38);
    }];
    [dateControl addTarget:self action:@selector(dateControlClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (date)
    {
        [dateControl setDate:date];
    }
}

- (void) createPhotoView
{
    ivPhoto = [[UIImageView alloc]init];
    [self.scrollview addSubview:ivPhoto];
    [ivPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollview).with.offset(12.5);
        make.width.equalTo(@(ScreenWidth - 25));
        make.top.equalTo(tvFood.mas_bottom).with.offset(10);
        make.height.mas_equalTo(230);
    }];
    
}

#pragma mark - eventResponed
- (void) imageButtonClicked:(id) sender
{
    [self checkForOnce];
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机拍摄" otherButtonTitles:@"相册图片", nil];
    [sheet showInView:self.view];
}

- (void) dateControlClicked:(id) sender
{
//    ZJKDatePickerSheet* dateSheet = [[ZJKDatePickerSheet alloc]init];
//    [dateSheet setDelegate:self];
//    if (date)
//    {
//        [dateSheet setDate:[date formattedDateWithFormat:@"yyyy-MM-dd"]];
//    }
//    [dateSheet show];
    [self checkForOnce];
    [self.view endEditing:YES];
    DeviceTestTimeSelectView *timePickerView = [[DeviceTestTimeSelectView alloc] init];
    self.comPickerview = timePickerView;
    [timePickerView setDateModel:UIDatePickerModeDate];
    [timePickerView getSelectedItemWithBlock:^(NSDate *selectedTime) {
        [dateControl setDate:selectedTime];
        date = selectedTime;
    }];
    [self.view addSubview:timePickerView];
    [timePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@160);
    }];
    [timePickerView setDate:[dateControl getDate]?:[NSDate date]];
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = [textView.text length];
    if (number > 30)
    {
        [self showAlertMessage:@"食物描述不能超过30个字。"];
        textView.text = [textView.text substringToIndex:30];
        return;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self checkForOnce];
    return YES;
}
#pragma mark - UIActivityItemSource
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
    picker.sourceType=sourcheType;
    picker.mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    picker.allowsEditing=YES;
    picker.delegate=self;
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

//上传图片的协议与代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    UIImage* thumbImage = [self thumbImageFromImage:image];
    [ivPhoto setImage:thumbImage];
    //[photoListView imageListChanged];
    
    //选取完图片之后关闭视图
    [self dismissViewControllerAnimated:YES completion:nil];
    //[ivPhoto showImageProgressView:0];
    //上传图片
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"UploadFoodImageTask" taskParam:nil extParam:imageData TaskObserver:self];
}

- (UIImage*) thumbImageFromImage:(UIImage*) image
{
    if (!image)
    {
        return nil;
    }
    
    CGSize thumbSize = ivPhoto.size;
    thumbSize.height *= [UIScreen mainScreen].scale;
    thumbSize.width *= [UIScreen mainScreen].scale;
    CGSize imgSize = image.size;
    UIImage* thumbImage = image;
    
    if (imgSize.height / imgSize.width > thumbSize.height/thumbSize.width)
    {
        UIImage* scaledImage = [image scaleImageToScale:(thumbSize.width/imgSize.width)];
        thumbImage = [scaledImage getSubImage:CGRectMake(0, (scaledImage.size.height - thumbSize.height)/2, thumbSize.width, thumbSize.height)];
    }
    else
    {
        UIImage* scaledImage = [image scaleImageToScale:(thumbSize.height/imgSize.height)];
        thumbImage = [scaledImage getSubImage:CGRectMake((scaledImage.size.width - thumbSize.width)/2, 0, thumbSize.width, thumbSize.height)];
    }
    
    return thumbImage;
}

#pragma mark TaskObserver
- (void) task:(NSString*) taskId PostProgress:(NSInteger) postedUnit Total:(NSInteger) totalUnit
{
    
    float progress = (CGFloat)postedUnit/totalUnit;
    NSLog(@"progress = %f", progress);
    //[self.view showWaitView];
    [ivPhoto showImageProgressView:progress];
    
}

- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [ivPhoto closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
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
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"UploadFoodImageTask"])
    {
        //上传图片完成
        if (taskResult && [taskResult isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicResult = (NSDictionary*) taskResult;
           //
            NSString* imageUrlStr = [dicResult valueForKey:@"picUrl"];
            if (imageUrlStr && [imageUrlStr isKindOfClass:[NSString class]])
            {
                imageUrl = imageUrlStr;
            }
        }
        
    }
    
    if ([taskname isEqualToString:@"AppendDietRecordTask"])
    {
        [self.view closeWaitView];
        [HMViewControllerManager createViewControllerWithControllerName:@"NuritionDietRecordsStartViewController" ControllerObject:appendParam.date];
    }
}

#pragma mark - setterAndGetter 
- (UIScrollView *)scrollview {
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] init];
        _scrollview.contentSize = self.view.bounds.size;
        _scrollview.backgroundColor = [UIColor whiteColor];
        _scrollview.scrollEnabled = YES;
        _scrollview.directionalLockEnabled = YES;
        _scrollview.delegate = self;
        _scrollview.alwaysBounceHorizontal = NO;
        _scrollview.alwaysBounceVertical = YES;
        _scrollview.bounces = YES;
    }
    return _scrollview;
}
@end
