//
//  BloodSugarAddDietViewController.m
//  HMClient
//
//  Created by lkl on 2017/7/6.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BloodSugarAddDietViewController.h"
#import "UIView+ImageProgress.h"
#import "BloodSugarEditDietView.h"
#import "HMPhotoPickerManager.h"

static NSString *const bloodSugarNotificationName = @"bloodSugarNotification";

@interface BloodSugarAddDietViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,TaskObserver>
{
    BloodSugarEditDietView *editDietViw;
    NSString *recordId;
}
@property (nonatomic, copy) NSMutableArray *picUrls;
@property (nonatomic, copy) NSString *dietContent;
@property (nonatomic, copy) NSArray *photos;
@end

@implementation BloodSugarAddDietViewController

- (instancetype)initWithDetectRecord:(DetectRecord *)record photos:(NSArray *)photos diet:(NSString *)diet
{
    self = [super init];
    if (self) {
        recordId = record.testDataId;
        self.photos = photos;
        _dietContent = diet;
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6]];
    UIControl* closeControl = [[UIControl alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:closeControl];
    //[closeControl addTarget:self action:@selector(closeAddDietVC) forControlEvents:UIControlEventTouchUpInside];
    
    editDietViw = [[BloodSugarEditDietView alloc] init];
    [self.view addSubview:editDietViw];
    [editDietViw.tvSymptom setDelegate:self];
    [editDietViw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12.5);
        make.right.equalTo(self.view).offset(-12.5);
        make.centerY.equalTo(self.view).offset(-50);
        make.height.mas_equalTo(260);
    }];
    //动画
    [self shakeToShow:editDietViw];
    
    if (!kArrayIsEmpty(self.photos)) {
        [editDietViw reloadPhotos:self.photos];
        [self.picUrls addObjectsFromArray:self.photos];
    }
    
    if (!kStringIsEmpty(_dietContent) || !kArrayIsEmpty(self.photos)) {
        [editDietViw isHasPhotosOrDiet:YES];
        [editDietViw.tvSymptom setText:_dietContent];
        [editDietViw.tv setPlaceholder:@""];
        [editDietViw.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [editDietViw isHasPhotosOrDiet:NO];
    }
    
    [editDietViw.btnAddPhoto addTarget:self action:@selector(btnAddPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [editDietViw.commitButton addTarget:self action:@selector(commitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletePhotoClick:) name:@"detelePhontNotification" object:nil];
}

- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

#pragma mark -- Click

- (void)deletePhotoClick:(NSNotification *)noti
{
    NSString *flag = noti.object;
    [self.picUrls removeObjectAtIndex:flag.integerValue];
}

//移除
- (void)closeAddDietVC
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)commitButtonClick:(UIButton *)sender
{
    [self.view closeWaitView];
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];
    [dicPost setValue:recordId forKey:@"testDataId"];
    [dicPost setValue:[NSString stringWithFormat:@"%@", editDietViw.tvSymptom.text] forKey:@"diet"];
    [dicPost setValue:self.picUrls forKey:@"picUrls"];

    [self.view showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"UpdateUserBloodSugarDietTask" taskParam:dicPost TaskObserver:self];
}

- (void)deleteButtonClick:(UIButton *)sender
{
    editDietViw.tvSymptom.text = @"";
    if (!kArrayIsEmpty(self.picUrls)) {
        [self.picUrls removeAllObjects];
    }
    //上传空数据 相当于删除
    NSMutableDictionary *dicPost = [[NSMutableDictionary alloc] init];

    [dicPost setValue:recordId forKey:@"testDataId"];
    [dicPost setValue:@"" forKey:@"diet"];
    [dicPost setValue:@[] forKey:@"picUrls"];

    [[TaskManager shareInstance] createTaskWithTaskName:@"UpdateUserBloodSugarDietTask" taskParam:dicPost TaskObserver:self];
}

- (void)btnAddPhoto:(UIButton *)sender
{
    [[HMPhotoPickerManager shareInstance] addTarget:self showImageViewSelcteWithResultBlock:^(UIImage *img) {
        
        //上传图片
        NSData *imageData = UIImageJPEGRepresentation(img, 1);
        [self at_postLoading:@"正在上传"];
        [[TaskManager shareInstance] createTaskWithTaskName:@"UserBloodSugarImageUpdateTask" taskParam:nil extParam:imageData TaskObserver:self];
    }];
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

#pragma mark - TaskObserver
- (NSString*) resultTaskName
{
    return @"BloodSugarDetectResultTask";
}

- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.view closeWaitView];
    [self at_hideLoading];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
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

    //保存
    if ([taskname isEqualToString:@"UpdateUserBloodSugarDietTask"])
    {
        [self closeAddDietVC];

        [[NSNotificationCenter defaultCenter] postNotificationName:bloodSugarNotificationName object:self];
    }
    
    if ([taskname isEqualToString:@"UserBloodSugarImageUpdateTask"])
    {
        NSString *imageUrl = [taskResult valueForKey:@"picUrl"];
    
        if(imageUrl)
        {
            [self.picUrls addObject:imageUrl];
            
            [editDietViw.phonelist addObject:imageUrl];
            [editDietViw resetLayout];
        }
    }
}

#pragma mark -- init

- (NSMutableArray *)picUrls{
    if (!_picUrls) {
        _picUrls = [NSMutableArray array];
    }
    return _picUrls;
}

- (NSArray *)photos{
    if (!_photos) {
        _photos = [NSArray array];
    }
    return _photos;
}

@end
