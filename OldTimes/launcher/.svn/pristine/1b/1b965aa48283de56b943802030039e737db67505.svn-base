//
//  MeMainViewController.m
//  launcher
//
//  Created by Conan Ma on 15/9/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeMainViewController.h"
#import "Category.h"
#import <Masonry.h>
#import "MyDefine.h"
#import "MeShareViewController.h"
#import "MeRevisedPassWordViewController.h"
#import "MeReviseMailViewController.h"
#import "MeReviseMobileNoViewController.h"
#import "GraphicSetViewController.h"
#import "MeCodeView.h"
#import "MeSettingViewController.h"
#import "MeEditTextViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UnifiedSqlManager.h"
#import "ContactPersonDetailInformationModel.h"
#import "AvatarUtil.h"
#import "ContactGetUserInformationRequest.h"
#import "AttachmentUploadRequest.h"
#import "UIImage+Manager.h"
#import "CompanySelectViewController.h"
#import "QRLoginViewController.h"
#import "WebViewController.h"
#import "QRCodeReaderViewController.h"
#import "UIView+Util.h"
#import <MintcodeIM/MintcodeIM.h>
#import "NewMePassWordViewController.h"
#import "NewMePassWordViewController.h"
#import "JapanCompanySelectViewController.h"

typedef enum{
    tableviewcell_launchrId = 00,
    tableviewcell_Name,
    tableviewcell_MobileNo,
    tableviewcell_Mail,
    tableviewcell_OfficeNo,
    
    tableviewcell_team = 10,
    tableviewcell_Code,
    tableviewcell_Share,
    
    tableviewcell_ReviseCode = 20,
    tableviewcell_ReviseTap,
    
    tableviewcell_Set = 30,
}tableviewcellStyle;

@interface MeMainViewController () <UITableViewDataSource,UITableViewDelegate,BaseRequestDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *viewPersonalInfo;          //蓝色背景
@property (nonatomic, strong) UIImageView *imgViewPic;           //头像
@property (nonatomic, strong) UIView * viewPic;                  //头像背景
@property (nonatomic, strong) UIButton *btnCamera;               //相机
@property (nonatomic, strong) UILabel *lblName;                  //姓名
@property (nonatomic, strong) UILabel *lblID;                    //ID
//@property (nonatomic, strong) UIButton *btnCode;                 //二维码扫描
@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) ContactPersonDetailInformationModel *myInfoModel;

@end

@implementation MeMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor grayBackground];
    [self.viewPersonalInfo addSubview:self.viewPic];
    [self.viewPersonalInfo addSubview:self.imgViewPic];
    [self.viewPersonalInfo addSubview:self.btnCamera];
    [self.viewPersonalInfo addSubview:self.lblName];
  
    [self initComponents];
    ContactGetUserInformationRequest *request = [[ContactGetUserInformationRequest alloc] initWithDelegate:self];
    [request userShowID:[[UnifiedUserInfoManager share] userShowID]];
//    self.myInfoModel = [[UnifiedSqlManager share] findPersonWithShowId:[[UnifiedUserInfoManager share] userShowID]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickToQR) name:MTWillBeginScanQCCodeNotification object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    ContactGetUserInformationRequest *request = [[ContactGetUserInformationRequest alloc] initWithDelegate:self];
    [request userShowID:[[UnifiedUserInfoManager share] userShowID]];
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor themeBlue],
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:18]}];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.viewPersonalInfo layoutSubviews];
    self.viewPic.layer.cornerRadius = self.viewPic.frame.size.width / 2;
    self.imgViewPic.layer.cornerRadius = self.imgViewPic.frame.size.width / 2;
    self.btnCamera.layer.cornerRadius = self.btnCamera.frame.size.width / 2;
}

- (void)initComponents
{
    
    [self.viewPersonalInfo addSubview:self.lblID];
    [self.lblID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblName.mas_bottom).offset(5);
        make.centerX.equalTo(self.viewPersonalInfo);
    }];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.viewPersonalInfo.mas_bottom);
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - Button Click 
- (void)clickToChangeAvatar {
    //按钮暴力点击防御
    [self.btnCamera mtc_deterClickedRepeatedly];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(CAMERA), LOCAL(GALLERY), nil];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}


- (void)clickToQR {
    //按钮暴力点击防御
    
    QRCodeReaderViewController *QRVC = [[QRCodeReaderViewController alloc] init];
    [QRVC setCompletionWithBlock:^(NSString * _Nullable resultAsString) {
        [self QRResult:resultAsString];
    }];
    QRVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:QRVC animated:YES];
}

#pragma mark - Private Method

- (void)QRResult:(NSString *)string {
    [self.navigationController popViewControllerAnimated:NO];
    if ([string hasPrefix:@"{\"id\":"]) {
        QRLoginViewController *VC = [[QRLoginViewController alloc] initWithId:string];
        
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    
    WebViewController *webVC = [[WebViewController alloc] initWithURL:string];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    
}

- (void)pickImageisFromCamera:(BOOL)isFromCamera {
    UIImagePickerControllerSourceType sourceType;
    if (isFromCamera && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self postError:ERROR_NOCAMERA];
        [self RecordToDiary:ERROR_NOCAMERA];
        return;
    }
    
    sourceType = isFromCamera ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = sourceType;
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)uploadAvatar:(UIImage *)image {
    CGSize sizeImage = image.size;
    if (sizeImage.width > 200 && sizeImage.height > 200) {
        image = [UIImage mtc_compressImage:image ScaledToSize:CGSizeMake(200, 200)];
    }
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    [self performSelector:@selector(postLoading) withObject:nil afterDelay:0.5];
    AttachmentUploadRequest *uploadRequest = [[AttachmentUploadRequest alloc] initWithDelegate:self];
    [uploadRequest uploadImageData:data];
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: // 📷
            [self pickImageisFromCamera:YES];
            break;
        case 1: // 照片
            [self pickImageisFromCamera:NO];
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image) {
        [self uploadAvatar:image];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 230 + 15;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 230, self.view.frame.size.width, 15)];
        view.backgroundColor = [UIColor grayBackground];
        [self.viewPersonalInfo addSubview:view];
        return self.viewPersonalInfo;
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 20)];
        view.backgroundColor = [UIColor grayBackground];
        return view;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:     return 5;
        case 1:     return 1;
        case 2:     return 2;
        case 3:     return 1;
        default:    return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.section * 10 + indexPath.row;
  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeTableViewCellWithOriginalID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MeTableViewCellWithOriginalID"];
        cell.textLabel.font = [UIFont mtc_font_30];
        cell.detailTextLabel.font = [UIFont mtc_font_30];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *textLabelText = @"";
    NSString *detailTextLabelText = @"";
    UnifiedUserInfoManager *infoManager = [UnifiedUserInfoManager share];
    
    switch (index) {
            case tableviewcell_launchrId:
#if defined(JAPANMODE) || defined(JAPANTESTMODE)
            textLabelText = @"WorkHub ID";
#else
            textLabelText = @"Launchr ID";
#endif
            detailTextLabelText = [NSString stringWithFormat:@"%ld", self.myInfoModel.launchrId];
            break;
        case tableviewcell_Name:
            textLabelText = LOCAL(ME_NAME);
            detailTextLabelText = [infoManager userName];
            break;
        case tableviewcell_MobileNo:
            textLabelText = LOCAL(ME_MOBILE);
            detailTextLabelText = self.myInfoModel.u_mobile;
            break;
        case tableviewcell_Mail:
            textLabelText = LOCAL(ME_MAIL);
            detailTextLabelText = self.myInfoModel.u_mail;
            break;
        case tableviewcell_OfficeNo:
            textLabelText = LOCAL(ME_OFFICE);
            detailTextLabelText = self.myInfoModel.u_telephone;
            break;
        case tableviewcell_team:
            textLabelText = LOCAL(ME_TEAM);
            detailTextLabelText = [infoManager companyName];
            break;
        case tableviewcell_Share:
            textLabelText = LOCAL(ME_SHARE);
            break;
        case tableviewcell_ReviseCode:
            textLabelText = LOCAL(ME_REVISE_CODE);
            break;
        case tableviewcell_ReviseTap:
            textLabelText = LOCAL(ME_REVISE_TAP);
            break;
        case tableviewcell_Set:
            textLabelText = LOCAL(USERINFO_SETTING);
            break;
    }
    
    [cell textLabel].text = textLabelText;
    [cell detailTextLabel].text = detailTextLabelText;
    if (index == tableviewcell_Mail || index == tableviewcell_Name)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSInteger index = indexPath.section *10 + indexPath.row;
    
    UnifiedUserInfoManager *infoManager = [UnifiedUserInfoManager share];
    UnifiedSqlManager *sqlManager = [UnifiedSqlManager share];
    
    switch (index)
    {
        case tableviewcell_launchrId:
        {
            [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%ld",self.myInfoModel.launchrId];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCAL(CALENDAR_COPY) message:nil delegate:nil cancelButtonTitle:LOCAL(CANCEL) otherButtonTitles:nil];
            [alertView show];
        }
            break;
        case tableviewcell_team:
        {
#if defined(JAPANMODE) || defined(JAPANTESTMODE)
            JapanCompanySelectViewController *VC = [[JapanCompanySelectViewController alloc] initWithChangeCompany:YES];
#else
            CompanySelectViewController *VC = [[CompanySelectViewController alloc] initWithChangeCompany:YES];
#endif
            [VC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:VC animated:NO];
        }
            break;
        case tableviewcell_Name:
        {
//            MeEditTextViewController *nameVc = [[MeEditTextViewController alloc] init];
//           [nameVc getContextWithBlock:^(NSString *text) {
//               self.myInfoModel.u_true_name = text;
//               infoManager.userName = text;
//               [sqlManager insertContactDetail:@[self.myInfoModel]];
//           }];
//            nameVc.cellTitle = LOCAL(ME_NAME);
//            [nameVc setData:[infoManager userName]];
//            nameVc.myInfoModel = self.myInfoModel;
//            [nameVc setHidesBottomBarWhenPushed:YES];
//            [self.navigationController pushViewController:nameVc animated:YES];
        }
            break;
        case tableviewcell_Share: 
        {
            MeShareViewController *VC = [[MeShareViewController alloc] init];
            [VC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case tableviewcell_ReviseCode:
        {
            NewMePassWordViewController *VC = [[NewMePassWordViewController alloc] init];
            [VC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:VC animated:YES];
        }
             break;
        case tableviewcell_Mail:
        {
            return;
//            MeReviseMailViewController *VC = [[MeReviseMailViewController alloc] init];
//            [VC setHidesBottomBarWhenPushed:YES];
//            [VC setBlock:^(NSString *mail) {
//                self.myInfoModel.u_mail = mail;
//                [sqlManager insertContactDetail:@[self.myInfoModel]];
//            }];
//            VC.myInfoModel = self.myInfoModel;
//            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case tableviewcell_OfficeNo:
        {
            MeEditTextViewController *VC = [[MeEditTextViewController alloc] init];
            [VC getContextWithBlock:^(NSString *text) {
                self.myInfoModel.u_telephone = text;
                [sqlManager insertContactDetail:@[self.myInfoModel]];
            }];
            VC.cellTitle = LOCAL(ME_OFFICE);
            VC.myInfoModel = self.myInfoModel;
            [VC setData:self.myInfoModel.u_telephone];
            [VC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case tableviewcell_Set:
        {
            MeSettingViewController *VC  = [[MeSettingViewController alloc] init];
            [VC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case tableviewcell_MobileNo:
        {
            MeReviseMobileNoViewController *VC = [[MeReviseMobileNoViewController alloc] init];
            [VC setHidesBottomBarWhenPushed:YES];
            [VC setBlock:^(NSString *text) {
                self.myInfoModel.u_mobile = text;
                [sqlManager insertContactDetail:@[self.myInfoModel]];
            }];
            VC.myInfoModel = self.myInfoModel;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case tableviewcell_ReviseTap:
        {
            GraphicSetViewController *VC =[[GraphicSetViewController alloc] init];
            VC.isChangeKey = YES;
            [VC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case tableviewcell_Code:
        {
//            MeWithImageTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
            MeCodeView *view = [[MeCodeView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//            [view GetInformation:@"要请我吃饭的請联系我：15157121662 速度要快 姿势要帅"];
            [view GetModel:self.myInfoModel];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:view];
        }
            break;
        default:nil;
            break;
    }
}

- (void)setLblNameText:(NSString *)text
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,text.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont  boldSystemFontOfSize:17.0] range:NSMakeRange(0,text.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,text.length)];
    self.lblName.attributedText = str;
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([request isKindOfClass:[ContactGetUserInformationRequest class]])
    {
        [self RecordToDiary:@"获取个人信息成功"];
        self.myInfoModel = ((ContactGetUserInformationResponse *)response).personModel;
        UnifiedSqlManager *sqlManager = [UnifiedSqlManager share];
        [sqlManager insertContactDetail:@[self.myInfoModel]];
        
        UnifiedUserInfoManager *infoManager = [UnifiedUserInfoManager share];
        [infoManager saveUserInfoWithContactPersonDetailInformationModel:self.myInfoModel];
		
		[self setLblNameText:[infoManager userName]];
		avatarRemoveCache([UnifiedUserInfoManager share].userShowID);
		
		UIImage *originImage = self.imgViewPic.image;
		[self.imgViewPic sd_setImageWithURL:avatarURL(avatarType_150, infoManager.userShowID) placeholderImage:originImage];
//#if defined(JAPANMODE) || defined(JAPANTESTMODE)
//        self.lblID.text = [NSString stringWithFormat:@"WorkHub ID:%ld", self.myInfoModel.launchrId];
//#else
//        self.lblID.text = [NSString stringWithFormat:@"Launchr ID:%ld", self.myInfoModel.launchrId];
//#endif
        [self.tableview reloadData];
    }
    
    else if ([request isKindOfClass:[AttachmentUploadRequest class]]) {
        [self hideLoading];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(postLoading) object:nil];
        avatarRemoveCache([UnifiedUserInfoManager share].userShowID);
        [self.imgViewPic sd_setImageWithURL:avatarURL(avatarType_150, [[UnifiedUserInfoManager share] userShowID]) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			if (image && imageURL) {
				self.imgViewPic.image = image;
			}
		}];
        [[MessageManager share] sendUserModifiedWithModified:[[NSDate date] timeIntervalSince1970] * 1000];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
}

#pragma mark - Initializer
- (ContactPersonDetailInformationModel *)myInfoModel
{
    if (!_myInfoModel)
    {
        _myInfoModel = [[ContactPersonDetailInformationModel alloc] init];
    }
    return _myInfoModel;
}


- (UIView *)viewPersonalInfo
{
    if (!_viewPersonalInfo)
    {
        _viewPersonalInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 245)];
        _viewPersonalInfo.backgroundColor = [UIColor colorWithRed:0 green:153.0/255 blue:255.0/255 alpha:1];
    }
    return _viewPersonalInfo;
}
- (UIView *)viewPic
{
    if (!_viewPic)
    {
        _viewPic = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100)/2, 45, 100, 100)];
        [_viewPic setBackgroundColor:[UIColor whiteColor]];
        _viewPic.clipsToBounds = YES;
    }
    return _viewPic;
}

- (UIImageView *)imgViewPic
{
    if (!_imgViewPic)
    {
        _imgViewPic = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 95)/2, 48, 95, 95)];
        [_imgViewPic sd_setImageWithURL:avatarURL(avatarType_150, [UnifiedUserInfoManager share].userShowID) placeholderImage:[UIImage imageNamed:@"contact_default_headPic"] options:0];
        _imgViewPic.clipsToBounds = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToChangeAvatar)];
        [_imgViewPic addGestureRecognizer:tapGesture];
        _imgViewPic.userInteractionEnabled = YES;
    }
    return _imgViewPic;
}

- (UIButton *)btnCamera
{
    if (!_btnCamera)
    {
        _btnCamera = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 95)/2 + 95 - 3 - 16, 48 + 95 - 16, 16, 16)];
        [_btnCamera setBackgroundColor:[UIColor whiteColor]];
        [_btnCamera setBackgroundImage:[UIImage imageNamed:@"Me_camera"] forState:UIControlStateNormal];
        [_btnCamera addTarget:self action:@selector(clickToChangeAvatar) forControlEvents:UIControlEventTouchUpInside];
        _btnCamera.clipsToBounds = YES;
    }
    return _btnCamera;
}

//- (UIButton *)btnCode
//{
//    if (!_btnCode)
//    {
//        _btnCode = [[UIButton alloc] init];
//        [_btnCode setBackgroundColor:[UIColor clearColor]];
//        _btnCode.expandSize = CGSizeMake(5, 5);
//        [_btnCode setBackgroundImage:[UIImage imageNamed:@"Me_QRcode_btn_bg"] forState:UIControlStateNormal];
//        [_btnCode addTarget:self action:@selector(clickToQR) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _btnCode;
//}

- (UILabel *)lblName
{
    if (!_lblName)
    {
        _lblName = [[UILabel alloc] initWithFrame:CGRectMake(0, 45+ 100 + 10, self.view.frame.size.width, 30)];
    }
    return _lblName;
}

- (UILabel *)lblID
{
    if (!_lblID)
    {
        _lblID = [[UILabel alloc] init];
        _lblID.textAlignment = NSTextAlignmentCenter;
        _lblID.textColor = [UIColor colorWithRed:166.0/255 green:219.0/255 blue:1 alpha:1];
        _lblID.font = [UIFont systemFontOfSize:10];
    }
    return _lblID;
}

- (UITableView *)tableview
{
    if (!_tableview)
    {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.backgroundColor = [UIColor grayBackground];
    }
    return _tableview;
}
@end
