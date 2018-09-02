//
//  PersonInfoTableViewController.m
//  HMClient
//
//  Created by yinqaun on 16/4/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonInfoTableViewController.h"
#import "PersonInfoTableViewCell.h"
#import "PersonInfoBodySignTableViewCell.h"
#import "ImageCutViewController.h"

#import "ImageHttpClient.h"
#import "ClientHelper.h"

#import "UserOftenIllsSelectViewController.h"
#import "PersonCommitIDCardViewController.h"


typedef enum : NSUInteger {
    PersonInfoPortraitSection,
    PersonInfoBaseSection,
    PersonInfoBodySection,
    //PersonInfoDiseaseSection,
    PersonInfoSectionCount,
} PersonInfoSection;

typedef enum : NSInteger
{
    //PersonInfo_UserImageIndex,
    PersonInfo_UserNameIndex,
    PersonInfo_UserSexIndex,
    PersonInfo_UserMobileIndex,
    PersonInfo_UseridCardIndex,
    PersonInfoMaxCount,
}PersonInfoTableIndex;

typedef enum : NSUInteger {
    PersonBody_HeightIndex,
    PersonBody_WeightIndex,
    PersonBodySignIndexCount,
} PersonBodySignIndex;

@interface PersonInfoTableViewController ()
<UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
ImageCutViewDelegate,
TaskObserver>
{
    NSArray *titleArray;
    
    ImageHttpClient* imageHttpClient;
}
@end

@implementation PersonInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView setSeparatorColor:[UIColor colorWithHexString:@"E2E2E2"]];
    
    titleArray = @[@"姓名:",@"性别:",@"手机号:",@"身份证号:"];
    
    imageHttpClient = [[ImageHttpClient alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //UserInfoTask
    [self.tableView.superview showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserInfoTask" taskParam:nil TaskObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return PersonInfoSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case PersonInfoPortraitSection:
            return 1;
            break;
        case PersonInfoBaseSection:
            return PersonInfoMaxCount;
            break;
        case PersonInfoBodySection:
            return PersonBodySignIndexCount;
            break;
//        case PersonInfoDiseaseSection:
//            return 1;
//            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case PersonInfoPortraitSection:
            return 60;
            break;
            
        default:
            break;
    }
    
    return 45;
}

- (CGFloat) footerHeightWithSection:(NSInteger) section
{
    switch (section)
    {
        case PersonInfoPortraitSection:
            return 0.5;
            break;
        case PersonInfoBaseSection:
        case PersonInfoBodySection:
//        case PersonInfoDiseaseSection:
            return 14;
            break;
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return [self footerHeightWithSection:section];
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat height = [self footerHeightWithSection:section];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
    //[footerView setBackgroundColor:[UIColor lightGrayColor]];
    return footerView;
}

- (CGFloat) headerHeightWithSection:(NSInteger) section
{
    switch (section)
    {
        case PersonInfoPortraitSection:
            return 14;
            break;
            
        default:
            return 0;
            break;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self headerHeightWithSection:section];
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height = [self headerHeightWithSection:section];
    UIView *headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
    //[footerView setBackgroundColor:[UIColor lightGrayColor]];
    return headerview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case PersonInfoPortraitSection:
        {
            cell = [self PersonHeaderInfoTableViewCell];
        }
            break;
        case PersonInfoBaseSection:
        {
            cell = [self PersonInfoTableViewCell:indexPath];

        }
            break;
        case PersonInfoBodySection:
        {
            cell = [self bodySignCell:indexPath.row];
        }
            break;
//            case PersonInfoDiseaseSection:
//        {
//            cell = [self personDiseaseCell];
//        }
//            break;
        default:
            break;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (PersonHeaderInfoTableViewCell*)PersonHeaderInfoTableViewCell
{
    PersonHeaderInfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonHeaderInfoTableViewCell"];
    
    if (!cell) {
        cell = [[PersonHeaderInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonHeaderInfoTableViewCell"];
    }
    [cell updateUserInfo];
    return cell;
}


- (PersonInfoTableViewCell*)PersonInfoTableViewCell:(NSIndexPath*)indexPath
{
    UserInfo *user = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    NSString* cellClassName = @"PersonInfoTableViewCell";
    switch (indexPath.row) {
        case PersonInfo_UserMobileIndex:
        {
            cellClassName = @"PersonInfoEidtTableViewCell";
            break;
        }
        case PersonInfo_UserNameIndex:
        case PersonInfo_UserSexIndex:
        case PersonInfo_UseridCardIndex:
        {
            cellClassName = @"PersonInfoTableViewCell";
            break;
        }
            
    }
    PersonInfoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellClassName];
    
    if (!cell) {
        cell = [[NSClassFromString(cellClassName) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellClassName];
    }
    
    switch (indexPath.row)
    {
        case PersonInfo_UserNameIndex:
            [cell setUserInfo:user.userName];
            break;
        case PersonInfo_UserSexIndex:
            if (user.sex == 1)
            {
                [cell setUserInfo:@"男"];
            }
            else if (user.sex == 2)
            {
                [cell setUserInfo:@"女"];
            }
            else
            {
                [cell setUserInfo:@"未知"];
            }
            
            break;
            
        case PersonInfo_UserMobileIndex:
            [cell setUserInfo:user.mobile];
            break;
            
        case PersonInfo_UseridCardIndex:
            [cell setUserInfo:user.idCard];
            break;
        default:
            break;
    }
    
    [cell setlbTitle:[titleArray objectAtIndex:indexPath.row]];
   
    
    return cell;
}

- (UITableViewCell*) bodySignCell:(NSInteger) row
{
    UserInfo *user = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    PersonInfoBodySignTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonInfoBodySignTableViewCell"];
    if (!cell)
    {
        cell = [[PersonInfoBodySignTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonInfoBodySignTableViewCell"];
        
    }
    switch (row) {
        case PersonBody_HeightIndex:
        {
            [cell setTitle:@"身高"];
            NSString* heightStr = [NSString stringWithFormat:@"%d cm", (int)(user.userHeight * 100)];
            [cell setSignValue:heightStr];
        }
            break;
        case PersonBody_WeightIndex:
        {
            [cell setTitle:@"体重"];
            NSString* weightStr = [NSString stringWithFormat:@"%.1f kg", user.userWeight];
            [cell setSignValue:weightStr];
        }
            break;
        
        default:
            break;
    }
    
    return cell;
}

- (UITableViewCell*) personDiseaseCell
{
    PersonInfoDiseaseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonInfoDiseaseTableViewCell"];
    if (!cell)
    {
        cell = [[PersonInfoDiseaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonInfoDiseaseTableViewCell"];
        
    }
    
    [cell setUserInfo:[[UserInfoHelper defaultHelper] currentUserInfo]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case PersonInfoPortraitSection:
        {
            NSLog(@"编辑用户头像");
            UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机拍摄" otherButtonTitles:@"相册图片", nil];
            [sheet showInView:self.view];

        }
            break;
        case PersonInfoBaseSection:
        {
            switch (indexPath.row)
            {
                case PersonInfo_UserMobileIndex:
                {
                    //进入修改手机号界面 
                    [HMViewControllerManager createViewControllerWithControllerName:@"PersonSetMobileViewController" ControllerObject:nil];
                    break;
                }
                case PersonInfo_UseridCardIndex:
                {
                    //修改用户身份证
                    UserInfo* curUser =  [[UserInfoHelper defaultHelper] currentUserInfo];
                    if (curUser.idCard && [CommonFuncs validateIDCardNumber:curUser.idCard])
                    {
                        return;
                    }
                    
                    __weak typeof(self) weakSelf = self;
                    [PersonCommitIDCardViewController showWithHandleBlock:^{
                        if (!weakSelf) {
                            [weakSelf.tableView reloadData];
                        }
                    }];
                    break;
                }
            }
            break;
        }
        case PersonInfoBodySection:
        {
            switch (indexPath.row)
            {
                case PersonBody_HeightIndex:
                {
                    //修改用户身高
                    [HMViewControllerManager createViewControllerWithControllerName:@"PersonBodyHeightEditViewController" ControllerObject:nil];
                }
                    break;
                case PersonBody_WeightIndex:
                {
                    //修改用户体重
                    [HMViewControllerManager createViewControllerWithControllerName:@"PersonBodyWeightEditViewController" ControllerObject:nil];
                }
                    break;
                default:
                    break;
            }
        }
            break;
//        case PersonInfoDiseaseSection:
//        {
//            NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
//            [dicPost setValue:@"Y" forKey:@"isOften"];
//            [self.tableView.superview showWaitView];
//            [[TaskManager shareInstance] createTaskWithTaskName:@"OftenIllnessListTask" taskParam:dicPost TaskObserver:self];
//        }
//            break;
        default:
            break;
    }
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
    
    [self.navigationController presentViewController:imgpicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    NSLog(@"imagePickerControllerDidCancel");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"didFinishPickingImage");
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    ImageCutViewController* vcImageCut = [[ImageCutViewController alloc]initWithImage:image];
    [vcImageCut setDelegate:self];
    [vcImageCut setScaleInPex:512];
    
    [self.navigationController presentViewController:vcImageCut animated:YES completion:nil];
}

- (void) imageCutViewController:(ImageCutViewController*) controller imageCutAndScaled:(UIImage*) image
{
    UIImage* postImage = image;
    //[ivCuted setImage:image];
    [controller dismissViewControllerAnimated:YES completion:nil];
    NSData *imageData = UIImageJPEGRepresentation(postImage, 1.0);
    [self.tableView.superview showWaitView:@"更改用户头像"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"UserPhotoUpdateTask" taskParam:nil extParam:imageData TaskObserver:self];

}

#pragma mark - TaskObserver
- (void) task:(NSString *)taskId FinishError:(EStepErrorCode)taskError ErrorMessage:(NSString *)errorMessage
{
    [self.tableView.superview closeWaitView];
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        return;
    }
    
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    if ([taskname isEqualToString:@"UserInfoTask"])
    {
        
        [self.tableView reloadData];
        return;
    }
    if ([taskname isEqualToString:@"UserPhotoUpdateTask"])
    {
        //
        [self.tableView reloadData];
    }
    
    if ([taskname isEqualToString:@"OftenIllnessListTask"])
    {
        //获取到常用疾病列表
    }
    
    if ([taskname isEqualToString:@"UpdateUserInfoTask"])
    {
        //用户上传选择的疾病列表
        [self.tableView.superview showWaitView];
        [[TaskManager shareInstance] createTaskWithTaskName:@"UserInfoTask" taskParam:nil TaskObserver:self];
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
    
    if ([taskname isEqualToString:@"OftenIllnessListTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            NSArray* oftenIlls = (NSArray*) taskResult;
            //创建常见疾病选择列表
            [UserOftenIllsSelectViewController showInParentController:self.parentViewController OftenIlls:oftenIlls SelectBlock:^(NSArray *selectedIllIds)
             {
                //用户选择疾病列表
                
                 NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
                 [dicPost setValue:selectedIllIds forKey:@"jbIds"];
                 [self.tableView.superview showWaitView:@"修改用户疾病"];
                 [[TaskManager shareInstance] createTaskWithTaskName:@"UpdateUserInfoTask" taskParam:dicPost TaskObserver:self];
            }];
        }
    }
}
@end
