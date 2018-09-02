//
//  PersonStaffInfoTableViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/4/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PersonStaffInfoTableViewController.h"
#import "PersonStaffInfoTableViewCell.h"
#import "ImageCutViewController.h"
#import "PersonStaffDescriptionViewController.h"

@interface PersonStaffInfoViewController ()
{
    PersonStaffInfoTableViewController* tvcStaffInfo;
}
@end

@implementation PersonStaffInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"个人信息设置"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    if(!tvcStaffInfo)
    {
        tvcStaffInfo = [[PersonStaffInfoTableViewController alloc]initWithStyle:UITableViewStylePlain];
        [self addChildViewController:tvcStaffInfo];
        [tvcStaffInfo.tableView setFrame:self.view.bounds];
        [self.view addSubview:tvcStaffInfo.tableView];
    }

}

//- (void) viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [self.navigationController.navigationBar setTranslucent:NO];
//    if(!tvcStaffInfo)
//    {
//        tvcStaffInfo = [[PersonStaffInfoTableViewController alloc]initWithStyle:UITableViewStylePlain];
//        [self addChildViewController:tvcStaffInfo];
//        [tvcStaffInfo.tableView setFrame:self.view.bounds];
//        [self.view addSubview:tvcStaffInfo.tableView];
//    }
//    
//}

@end

typedef enum : NSUInteger {
    StaffPortraitSection,
    StaffBaseInfoSection,
    StaffCertificateInfoSection,
    StaffHospitalInfoSection,
    StaffDescInfoSection,
    StaffInfoSectionCount,
} StaffInfoTableSection;

typedef enum : NSUInteger {
    StaffBaseInfoNameIndex,     //姓名
    StaffBaseInfoGenderIndex,   //性别
    StaffBaseInfoIndexCount,
} StaffBaseInfoIndex;

typedef enum : NSUInteger {
    StafffVerifiedIndex,   //实名认证
    StaffLicenceIdIndex, //医师执照号
    StaffCertificateInfoIndexCount,
}StaffCertificateInfoIndex;

typedef enum : NSUInteger {
    StaffHospitalIndex,  //医院
    StaffDepartmentsIndex, //科室
    StaffJobTitleIndex,    //职称
    StaffHospitalInfoIndexCount,
}StaffHospitalInfoIndex;

typedef enum : NSUInteger {
    StaffGoodAtIndex,  //擅长
    StaffDescIndex,    //简介
    StaffDescInfoIndexCount,
}StaffDescInfoIndex;

@interface PersonStaffInfoTableViewController ()
<TaskObserver,UIActionSheetDelegate,
UINavigationControllerDelegate,UIImagePickerControllerDelegate,ImageCutViewDelegate>

@end

@implementation PersonStaffInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor commonBackgroundColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    
    NSMutableDictionary* dicParam = [NSMutableDictionary dictionary];
    [dicParam setValue:[NSString stringWithFormat:@"%ld", curStaff.staffId] forKey:@"staffId"];
    [[self.tableView superview] showWaitView];
    [[TaskManager shareInstance] createTaskWithTaskName:@"LoadStaffInfoTask" taskParam:dicParam TaskObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return StaffInfoSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    switch (section) {
        case StaffPortraitSection:
            return 1;
            break;
            
        case StaffBaseInfoSection:
            return StaffBaseInfoIndexCount;
            break;
            
        case StaffCertificateInfoSection:
            return StaffCertificateInfoIndexCount;
            break;
        
        case StaffHospitalInfoSection:
            return StaffHospitalInfoIndexCount;
            break;
            
        case StaffDescInfoSection:
            return StaffDescInfoIndexCount;
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 14)];
    [headerview setBackgroundColor:[UIColor commonBackgroundColor]];
    [headerview showBottomLine];
    return headerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    [headerview setBackgroundColor:[UIColor commonBackgroundColor]];
    [headerview showBottomLine];
    return headerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case StaffPortraitSection:
            return 80;
            break;
            
        default:
            break;
    }
    return 47;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    {
        case StaffPortraitSection:
        {
            cell = [self staffPortraitCell];
        }
            break;
        case StaffBaseInfoSection:
        {
            cell = [self staffBasesInfoCell:indexPath.row];
        }
            break;
            
        case StaffCertificateInfoSection:
        {
            cell = [self staffCertificateInfoCell:indexPath.row];
        }
            break;
            
        case StaffHospitalInfoSection:
        {
            cell = [self staffHosptialInfoCell:indexPath.row];
        }
            break;
            
        case StaffDescInfoSection:
        {
            cell = [self staffDescInfoCell:indexPath.row];
        }
            
        default:
            break;
    }
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonStaffInfoTableViewCell"];
    }
    // Configure the cell...
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


- (UITableViewCell*) staffPortraitCell
{
    PersonStaffPortraitTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonStaffPortraitTableViewCell"];
    if (!cell)
    {
        cell = [[PersonStaffPortraitTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonStaffPortraitTableViewCell"];
    }
    [cell updateStaffInfo];
    return cell;
}

- (UITableViewCell*) staffBasesInfoCell:(NSInteger) row
{
    PersonStaffBaseInfoTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonStaffBaseInfoTableViewCell"];
    if (!cell)
    {
        cell = [[PersonStaffBaseInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonStaffBaseInfoTableViewCell"];
    }
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];

    switch (row)
    {
        case StaffBaseInfoNameIndex:
        {
            [cell setName:@"姓名:" Value:curStaff.staffName];
        }
            break;
        case StaffBaseInfoGenderIndex:
        {
            NSString* sGender = nil;
            switch (curStaff.sex)
            {
                case 1:
                {
                    sGender = @"男";
                }
                    break;
                case 2:
                {
                    sGender = @"女";
                }
                    break;
                default:
                    break;
            }
            [cell setName:@"性别:" Value:sGender];
        }
            break;

        default:
            break;
    }
    
    return cell;
}

- (UITableViewCell*) staffCertificateInfoCell:(NSInteger) row
{
    PersonStaffBaseInfoTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonStaffBaseInfoTableViewCell"];
    if (!cell)
    {
        cell = [[PersonStaffBaseInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonStaffBaseInfoTableViewCell"];
    }

    switch (row)
    {
        case StafffVerifiedIndex:
         {
             [cell setName:@"实名认证:" Value:nil];
         }
            break;

         case StaffLicenceIdIndex:
         {
             [cell setName:@"医师执照号:" Value:nil];
         }
            break;
        
        default:
            break;
    }
    
    return cell;
}

- (UITableViewCell*) staffHosptialInfoCell:(NSInteger) row
{
    PersonStaffHospitalInfoTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonStaffHospitalInfoTableViewCell"];
    if (!cell)
    {
        cell = [[PersonStaffHospitalInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonStaffHospitalInfoTableViewCell"];
    }
    
    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];

    switch (row)
    {
        case StaffHospitalIndex:
        {
            [cell setName:@"医院:" Value:curStaff.orgName];
        }
            break;
            
        case StaffDepartmentsIndex:
        {
            [cell setName:@"科室:" Value:curStaff.depName];
        }
            break;
            
        case StaffJobTitleIndex:
        {
            [cell setName:@"职称:" Value:curStaff.staffTypeName];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (UITableViewCell*) staffDescInfoCell:(NSInteger) row
{
    PersonStaffDescriptionTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonStaffDescriptionTableViewCell"];
    if (!cell)
    {
        cell = [[PersonStaffDescriptionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonStaffDescriptionTableViewCell"];
    }
//    StaffInfo* curStaff = [[UserInfoHelper defaultHelper] currentStaffInfo];
    switch (row)
    {
        case StaffGoodAtIndex:
        {
            [cell setName:@"擅长:" Value:nil];
        }
            break;
            
        case StaffDescIndex:
        {
            [cell setName:@"简介:" Value:nil];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case StaffPortraitSection:
        {
            UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机拍摄" otherButtonTitles:@"相册照片", nil];
            [actionSheet showInView:self.view];
        }
            break;
        case StaffDescInfoSection:
        {
            PersonStaffDescStyle descStyle;
            switch (indexPath.row) {
                case StaffGoodAtIndex:
                {
                    descStyle = PersonStaff_GoodAt;
                    break;
                }
                case StaffDescIndex:
                {
                    descStyle = PersonStaff_Summary;
                    break;
                }
                default:
                    break;
            }
            
            [HMViewControllerManager createViewControllerWithControllerName:@"PersonStaffDescriptionViewController" ControllerObject:@(descStyle)];
        }
        default:
            break;
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"actionSheet clickedButtonAtIndex %ld", buttonIndex);
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
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

    [[TaskManager shareInstance] createTaskWithTaskName:@"StaffPhotoUpdateTask" taskParam:nil extParam:imageData TaskObserver:self];
    
}


#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [[self.tableView superview] closeWaitView];
    if (StepError_None != taskError) {
        [self showAlertMessage:errorMessage];
        return;
    }
}

- (void) task:(NSString *)taskId Result:(id) taskResult
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
    
    if ([taskname isEqualToString:@"LoadStaffInfoTask"])
    {
        if ([taskname isEqualToString:@"LoadStaffInfoTask"])
        {
            if (taskResult && [taskResult isKindOfClass:[StaffInfo class]])
            {
                StaffInfo* staff = (StaffInfo*) taskResult;
                [[UserInfoHelper defaultHelper] saveStaffInfo:staff];
            }
        }
        [self.tableView reloadData];
    }
    
    if ([taskname isEqualToString:@"StaffPhotoUpdateTask"])
    {
        [self.tableView reloadData];
    }

}
@end
