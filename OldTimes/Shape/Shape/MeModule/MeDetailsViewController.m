//
//  MeDetailsViewController.m
//  Shape
//
//  Created by jasonwang on 15/10/21.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeDetailsViewController.h"
#import "UIColor+Hex.h"
#import <Masonry.h>
#import "MeChangeIconTableViewCell.h"
#import "MeChangeInfoCell.h"
#import "MeChangeNameViewController.h"
#import "BaseNavigationViewController.h"
#import "MeGetUserInfoRequest.h"
#import "MeGetUserInfoModel.h"
#import "MeUploadHeadIconRequest.h"
#import "MeChangeUserInfoRequest.h"
#import "UIImageView+WebCache.h"
#import "MyDefine.h"
#import "PersonalDataViewController.h"
#import "NSString+Manager.h"



@interface MeDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,MeChangNameDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BaseRequestDelegate,InputCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, copy) NSArray *titelArr;
@property (nonatomic, strong) UIImage *myImage;
@property (nonatomic, strong) MeGetUserInfoModel *model;

@property (nonatomic) keyboardType keyboardType;
@end

@implementation MeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];

    [self.navigationItem setTitle:@"个人资料"];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"login_back"] style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    [self.navigationItem setLeftBarButtonItem:cancelBtn];
    [self initComponent];
    [self.view needsUpdateConstraints];
    self.titelArr = [NSArray arrayWithObjects:@"用户名",@"性别",@"所在地",@"出生年月",@"身高",@"体重", nil];
    //self.myImage = [UIImage imageNamed:@"me_icon"];
    //发起请求
    [self startRequest];
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method
// 设置头像
- (void)pickImageisFromCamera:(BOOL)isFromCamera
{
    NSInteger sourceType;
    // 拍照
    if (isFromCamera)
    {
        // 判断是否有摄像头
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            [self postError:@"没有发现摄像头"];
            return;
        }
    }
    // 相册
    else
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setAllowsEditing:YES];
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

//网络请求
- (void)startRequest
{
    MeGetUserInfoRequest *request = [[MeGetUserInfoRequest alloc]init];
    [request prepareRequest];
    [request requestWithDelegate:self];
    
    [self postLoading];
}

//压缩图片
- (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
#pragma mark - event Response

- (void)logoutClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:n_logout object:nil];
//    PersonalDataViewController *vc = [[PersonalDataViewController alloc]init];
//    [self presentViewController:vc animated:YES completion:nil];
}
//网络请求，上传数据
- (void)saveClick
{
    
    //上传个人信息
    
    MeChangeUserInfoRequest *request = [[MeChangeUserInfoRequest alloc]init];
    request.model = self.model;
    [request requestWithDelegate:self];
    [self postLoading];
    
}

#pragma mark - InputCellDelegate

- (void)InputCellDelegateCallBack_endEditWithIndexPath:(NSIndexPath *)indexPath
{
    MeChangeInfoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            if ([cell.txtFd.text isEqualToString:@"男"]) {
                self.model.gender = 1;
            }else if ([cell.txtFd.text isEqualToString:@"女"])
                       {
                           self.model.gender = 0;
                       }
        }
        else if (indexPath.row == 2)
        {
            self.model.location = cell.txtFd.text;
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) {
            self.model.birthYear = cell.model.birthYear;
            self.model.birthMonth = cell.model.birthMonth;
        }
    }
    
}


- (void)InputCellDelegateCallBack_startEditWithIndexPath:(NSIndexPath *)indexPath
{
    MeChangeInfoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell updatePickerView:self.model];
}
#pragma mark - MeChangeName Delegate

- (void)MeChangeNameDelegateCallBack_update:(NSString *)content
{
    self.model.userName = content;
    NSIndexPath *indexPath = nil;
   
    indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - UIActSheet Dalegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self pickImageisFromCamera:NO];
    }
    else if(buttonIndex == 0)
    {
        [self pickImageisFromCamera:YES];
    }
}

#pragma mark - UIImagePickerController Dalegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
  
    self.myImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(60, 60)];
    if (self.myImage) {
        //上传头像
        MeUploadHeadIconRequest *requestIcon = [[MeUploadHeadIconRequest alloc]init];
        [requestIcon prepareRequest];
        NSData *data = UIImagePNGRepresentation(self.myImage);
        [requestIcon requestWithDelegate:self data:data];
        [self postLoading];
    }

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
    if (picker) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }

}
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNum = 3;
    if (section == 0) {
        rowNum = 1;
    }
    return rowNum;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 90;
    }
    else
    {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 100;
    }
    else
    {
        return 12;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString *ID = @"Cell";
        MeChangeIconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[MeChangeIconTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            
            [cell setSeparatorInset:UIEdgeInsetsZero];
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
        if (self.myImage) {
            [cell.myImageView setImage:self.myImage];
        }
        else
        {
            [cell.myImageView sd_setImageWithURL:[NSString fullURLWithFileString:self.model.headIconUrl] placeholderImage:[UIImage imageNamed:@"me_icon"]];

        }
         return cell;

    }
    else
    {
        static NSString *ID = @"myCell";
        MeChangeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[MeChangeInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
                [cell setDelegate:self];
            }

        }
        cell.indexPath = indexPath;
        [cell.textLabel setText:self.titelArr[indexPath.row + (indexPath.section - 1) * 3]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        if(!(indexPath.section == 2 && (indexPath.row == 1 || indexPath.row == 2)))
        {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        if (indexPath.section == 1) {
            switch (indexPath.row) {
                    case 0:
                {
                     [cell.txtFd setEnabled:NO];
                    [cell setTextFieldText:self.model.userName editing:NO];
                }
                   
                    break;
                    case 1:
                {
                    if (self.model.gender == 1) {
                        [cell setTextFieldText:@"男" editing:YES];
                    }else if (self.model.gender == 0)
                    {
                        [cell setTextFieldText:@"女" editing:YES];
                    }

                    
                }
                    break;
                case 2:
                {
                    if (self.model.location) {
                        [cell setTextFieldText:self.model.location editing:YES];
                    }
                    else
                    {
                        [cell setTextFieldText:@"未填写" editing:YES];
                    }
                    
                }
                   
                    break;
                    
                default:
                    break;
            }
        }
        else if (indexPath.section == 2)
        {
            switch (indexPath.row) {
                case 0:
                {
                    if (self.model.birthYear == 0 || self.model.birthMonth == 0) {
                        [cell setTextFieldText:@"未填写" editing:YES];
                    }
                    else
                    {
                        NSString *string = [NSString stringWithFormat:@"%ld年%ld月",self.model.birthYear,self.model.birthMonth];
                        [cell setTextFieldText:string editing:YES];
                    }
                    
                }
                break;
                    
                case 1:
                {
                    [cell setTextFieldText:[NSString stringWithFormat:@"%ld",self.model.height] editing:YES];
                    [cell.txtFd setEnabled:NO];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                    break;

                case 2:
                {
                    [cell setTextFieldText:[NSString stringWithFormat:@"%.1f",self.model.weight] editing:YES];
                    [cell.txtFd setEnabled:NO];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                    break;

                default:
                    break;
            }
        }
        
        return cell;

    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"图库选择", nil];
        [sheet showInView:self.view];
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
            {
                MeChangeNameViewController *nameVC = [[MeChangeNameViewController alloc]init];
                [nameVC setDelegate:self];
                nameVC.nameStr = self.model.userName;
                BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:nameVC];
                [self presentViewController:nav animated:YES completion:nil];
            }
                break;
                
            case 1:
                self.keyboardType = sexType;
                break;
                
            case 2:
                self.keyboardType = localionType;
                break;
                
            default:
                break;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return self.backView;
    }
    else
    {
        return nil;
    }
}

#pragma mark - initComponent
- (void)initComponent
{
    [self.view addSubview:self.tableView];
    [self.backView addSubview:self.button];
    [self.tableView addSubview:self.backView];
}

#pragma mark - updateViewConstraints

- (void)updateViewConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.backView).offset(18);
//        make.left.equalTo(self.view).offset(40);
//        make.right.equalTo(self.view).offset(-40);
//        make.height.equalTo(@44);
//    }];
    [super updateViewConstraints];
}

#pragma mark - init UI

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
            [_tableView setSeparatorColor:[UIColor lineDarkGray_4e4e4e]];
        }
        [_tableView setShowsHorizontalScrollIndicator:NO];
        [_tableView setShowsVerticalScrollIndicator:NO];
    }
    return _tableView;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc]initWithFrame:CGRectMake(40, 20, self.view.frame.size.width - 40 * 2, 44)];
        [_button setBackgroundImage:[UIColor switchToImageWithColor:[UIColor themeBackground_373737] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_button setTitle:@"退出" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        [_backView setBackgroundColor:[UIColor clearColor]];
    }
    return _backView;
}

- (MeGetUserInfoModel *)model
{
    if (!_model) {
        _model = [[MeGetUserInfoModel alloc]init];
    }
    return _model;
}


#pragma mark - request Delegate

- (void)requestSucceed:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    NSLog(@"请求成功");
    [self hideLoading];
    if ([response isKindOfClass:[MeGetUserInfoResponse class]]) {
        MeGetUserInfoResponse *result = (MeGetUserInfoResponse *)response;
        self.model = result.userInfoMogdel;
        [self.tableView reloadData];
    }
    else if ([response isKindOfClass:[MeChangeUserInfoResponse class]])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

- (void)requestFail:(BaseRequest *)request withResponse:(BaseResponse *)response
{
    [self hideLoading];
    [self postError:response.message];
    NSLog(@"请求失败");
}
@end
