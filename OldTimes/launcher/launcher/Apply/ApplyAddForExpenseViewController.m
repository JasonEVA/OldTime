//
//  ApplyAddForExpenseViewController.m
//  launcher
//
//  Created by Kyle He on 15/8/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyAddForExpenseViewController.h"
#import "NewApplyAddNewApplyV2ViewController.h"
#import "ApplyTextViewTableViewCell.h"
#import "ApplyTextFieldTableViewCell.h"
#import "ApplyDetailTableViewCell.h"
#import "ApplyAddExpendTxtFieldTableViewCell.h"
#import "ApplyDeadlineTableViewCell.h"
#import "MyDefine.h"
#import "Category.h"
#import "ApplyAddDeadlineActionSheetView.h"
#import "ApplyAddNewApplyRequest.h"
#import "ApplyNameRightTableViewCell.h"
#import "ContactPersonDetailInformationModel.h"
#import "WZPhotoPickerController.h"
#import "ApplicationAttachmentTableViewCell.h"
#import "ApplyEditApplyRequest.h"
#import <DateTools/DateTools.h>
#import "MWPhotoBrowser.h"
#import "AttachmentUploadRequest.h"
#import "AttachmentUtil.h"
#import "ApplyAcceptDetailViewController.h"
#import "SelectContactBookViewController.h"
#import "ApplicationAttachmentModel.h"
#import <Masonry/Masonry.h>
#import "MixpanelMananger.h"

#define EXPENSE       @"BB1xoKW53kCPW7OP"

static NSInteger const maxImageCount = 9;
static NSInteger const photoActionSheetTag = 111;

typedef  enum
{
    cellTitle = 0,
    cellAccept = 01,
    cellCC = 02,
    cellPriority = 10,
    cellDeadLine = 11,
    cellExpense = 20,
    cellAttachment = 30,
    cellDetil = 31
}CELLTYPE;

@interface ApplyAddForExpenseViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, ApplyAddDeadlineActionSheetViewDelegate, UITextViewDelegate, UITextFieldDelegate, WZPhotoPickerControllerDelegate, BaseRequestDelegate,UIActionSheetDelegate, MWPhotoBrowserDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(nonatomic, strong) UITextField  *txtField;
@property(nonatomic, strong) UISwitch  *levelSwitch;
@property(nonatomic, strong) UISwitch  *deadlineSwitch;
@property(nonatomic, strong) NSArray  *arrTitle;
@property(nonatomic, strong) UITableView  *tableView;
@property(nonatomic, copy) NSString  *deadLineTime;
@property(nonatomic, strong) ApplyAddDeadlineActionSheetView  *deadLineTimeView;
@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;

@property (nonatomic) BOOL needVisitRequest;   //判断是否附件上传成功
/**
 *  审批人姓名
 */
@property(nonatomic, strong) NSMutableArray  *approveNameArr;
/**
 *  抄送人姓名
 */
@property (nonatomic, copy) takebackImgArray takeimgarrback;

@property(nonatomic, strong) NSMutableArray  *CCApproveNameArr;

@property(nonatomic, assign) BOOL  apprpoveClicked;

@property(nonatomic, assign) BOOL  CCApproveClicked;

@property(nonatomic, assign)  double fee;

@property(nonatomic, assign) APPLYTYPE  applyType;
/**
 *  附件照片数组(image)
 */
@property( nonatomic, strong ) NSMutableArray  * imageArr;
@property(nonatomic, assign) BOOL  isDeadLineWholeday;

@property (nonatomic) CGFloat mustComeCellRowHieght; //审批人cell行高
@property (nonatomic) CGFloat canComeCellRowHieght;  //CC cell行高

@end

@implementation ApplyAddForExpenseViewController

-(instancetype)initWithFrom:(APPLYTYPE)comefrom_VC
{
    if (self = [super init])
    {
        self.applyType = comefrom_VC;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mustComeCellRowHieght = 47;
    self.canComeCellRowHieght = 47;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:LOCAL(APPLY_SEND) style:UIBarButtonItemStylePlain target:self action:@selector(clickToSend)];
    self.navigationItem.rightBarButtonItem = rightItem;

    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStylePlain target:self action:@selector(clickToBack)];
    self.navigationItem.leftBarButtonItem = item;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    self.needVisitRequest = NO;
    
    [self.model.attachMentArray removeAllObjects];
    [self.model.attachMentArray addObjectsFromArray:self.arrattachment];

    [self.model removeAllAction];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.needVisitRequest = NO;
}

- (void)takebackarray:(takebackImgArray)takebackImgblock
{
    self.takeimgarrback = takebackImgblock;
}

- (void)clickToBack {
    [MixpanelMananger track:@"approve/cancel"];
//    if (self.applyType == kEditApply) {
        [self.navigationController popViewControllerAnimated:YES];
//        return;
//    }
//    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - addActions
-(void)keyBoardWillShow:(NSNotification *)info
{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = [[info.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.view.transform  = CGAffineTransformMakeTranslation(0, -rect.origin.y*0.5);
    }];
}

-(void)keyBoardWillHide:(NSNotification *)info
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform  = CGAffineTransformIdentity;
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - logical part
- (void)valueChanged
{
    if ( self.deadlineSwitch.on)
    {
        [self.view addSubview:self.deadLineTimeView];
        [self.view endEditing:YES];
    }else
    {
        self.model.try_A_DEADLINE = 0;
        self.deadLineTime = @"";
        [self.tableView reloadData];
    }
}

#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 3;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 2;
            break;
        default:return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id cell = nil;
    NSInteger row = indexPath.row;
    NSInteger currentIndex = indexPath.section * 10 + indexPath.row;
    NSArray *arr = [self.arrTitle objectAtIndex:indexPath.section ];
    switch (currentIndex) {
        case cellTitle:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[ApplyTextFieldTableViewCell identifier]];
            [cell setDelegate:self];
            if (self.model) [cell setTitle:self.model.try_A_TITLE];
            break;
        }
        case  cellAccept:
        case  cellCC:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[ApplyNameRightTableViewCell identifier]];
            if (!cell)
            {
                cell = [[ApplyNameRightTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[ApplyNameRightTableViewCell identifier]];
                [cell setIsEdit:YES];
                [cell setSeparatorInset:UIEdgeInsetsZero];
//                if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//                    [cell setLayoutMargins:UIEdgeInsetsZero];
//                }

            }
            
            if (currentIndex == cellAccept && self.model.try_A_APPROVE_NAME)
            {
                [cell setNameField:self.model.try_A_APPROVE_NAME];
            }else if(currentIndex == cellCC && self.model.try_A_CC_NAME)
            {
                [cell setNameField:self.model.try_A_CC_NAME];
            }
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
            break;
        }
        case cellPriority:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[ApplyDetailTableViewCell identifier]];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }

            [cell setAccessoryView:self.levelSwitch];
             self.levelSwitch.on = (BOOL)self.model.try_A_IS_URGENT;
            break;
        }
        case cellDeadLine:
        {
             cell = [tableView dequeueReusableCellWithIdentifier:[ApplyDeadlineTableViewCell identifier]];
            [cell setAccessoryView:self.deadlineSwitch];
            [cell deadlineLbl].text = self.deadLineTime;
            if (self.model.try_A_DEADLINE)
            {
                NSDate *deadline = [NSDate dateWithTimeIntervalSince1970:self.model.try_A_DEADLINE/1000];
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"MM/dd HH:mm"];
                [cell deadlineLbl].text = [[format stringFromDate:deadline] hasPrefix:@"1970"]?@"":[format stringFromDate:deadline];
                if (self.model.try_IS_DEADLINE_ALL_DAY)
                {
                    NSString *dateStr = [format stringFromDate:deadline];
                    NSArray *strings = [dateStr componentsSeparatedByString: @" "];
                    [cell deadlineLbl].text = [NSString stringWithFormat:@"%@%@",strings[0],LOCAL(APPLY_ALLDAY)];
                }
                self.deadlineSwitch.on = [cell deadlineLbl].text;
            }
            break;
        }
        case cellExpense:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[ApplyAddExpendTxtFieldTableViewCell identifier]];
            [cell setDelegate:self];
            [((ApplyAddExpendTxtFieldTableViewCell *)cell).expendField addTarget:self action:@selector(TextfieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
             if (self.model.try_A_FEE)
             {
                 NSString *str = [[NSString stringWithFormat:@"%ld",(long)self.model.try_A_FEE] stringByReplacingOccurrencesOfString:@"¥" withString:@""];
                 [cell expendField].text = [NSString stringWithFormat:@"¥%@",str];
             }
            break;
        }
        case cellAttachment:
        {
            ApplicationAttachmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ApplicationAttachmentTableViewCell identifier]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            [cell clickToSeeImage:^(NSUInteger clickedIndex) {
                [self selectShowImageAtIndex:clickedIndex];
            }];
            [cell titleLabel].text = LOCAL(APPLY_ADD_ATTACHMENT_TITLE);
            [cell setImages:self.model.try_attachMentArray];
            return cell;
            break;
        }
        case cellDetil:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[ApplyTextViewTableViewCell identifier]];
            [cell setDelegate:self];
            [cell setTextWithModelStr:self.model.try_A_BACKUP];
            break;
        }
    }
    [cell textLabel].text = [arr objectAtIndex:row];
    [cell textLabel].font = [UIFont mtc_font_30];
    [cell textLabel].textColor  = [UIColor blackColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger currentIndex = indexPath.section * 10 + indexPath.row;
    
    switch (currentIndex)
    {
        case cellAccept:
        {
            SelectContactBookViewController *selectVc = [[SelectContactBookViewController alloc] initWithSelectedPeople:[self.self.model.try_A_APPROVE componentsSeparatedByString:@"●"] unableSelectPeople:[self.model.try_A_CC componentsSeparatedByString:@"●"]];
            
            [selectVc selectedPeople:^(NSArray *array) {
                [self selectPeople:array];
            }];
            self.apprpoveClicked = YES;
            [self presentViewController:selectVc animated:YES completion:nil];
            break;
        }
        case cellCC:
        {
            SelectContactBookViewController *selectVc = [[SelectContactBookViewController alloc] initWithSelectedPeople:[self.model.try_A_CC componentsSeparatedByString:@"●"] unableSelectPeople:[self.model.try_A_APPROVE componentsSeparatedByString:@"●" ]];
            
            [selectVc selectedPeople:^(NSArray *array) {
                [self selectPeople:array];
            }];
            
            self.CCApproveClicked = YES;
            [self presentViewController:selectVc animated:YES completion:nil];
            break;

        }
        case cellAttachment:
        {
            if ([self.model try_attachMentArray].count == maxImageCount) {
                return;
            }
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(CAMERA), LOCAL(GALLERY), nil];
            actionSheet.tag = photoActionSheetTag;
            [actionSheet showInView:self.view];
        }
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 5 & indexPath.row == 0)
    {
        return 104.0f;
    }
    if (indexPath.section == 3 && indexPath.row == 0)
    {
        return [ApplicationAttachmentTableViewCell heightForCellWithImageCount:[self.model try_attachMentArray].count accessoryMode:YES];
    }
    NSInteger currentIndex = indexPath.section * 10 + indexPath.row;
    switch (currentIndex) {
        case  cellAccept:
            return self.mustComeCellRowHieght;
            break;
        case  cellCC:
            return self.canComeCellRowHieght;
            break;
        default:
            break;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.1;}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 15;}

- (BOOL)checkInfo
{
    [self.view endEditing:YES];
    
    if ([self.model.try_A_TITLE isEqualToString:@""] || self.model.try_A_TITLE == nil)
    {
        [self postError:LOCAL(APPLY_INPUT_TITLE)];
        return NO;
    }
    
    if (self.model.try_A_FEE == 0)
    {
        [self postError:LOCAL(APPLY_INPUT_MONEY)];
        return NO;
    }
    
    if (self.model.try_A_APPROVE == nil)
    {
        [self postError:LOCAL(APPLY_INPUT_APPROLLER)];
        return NO;
    }
    return YES;
}

-(void)clickToSend {
    [self.view endEditing:YES];
    if (![self checkInfo]) {
        return;
    }
    
    if (self.isLoading) {
        return;
    }
    
    [MixpanelMananger track:@"approve/save"];
    
    [self postLoading];
    self.model.T_SHOW_ID = EXPENSE;
    
    BOOL attachUpload = NO;
    for (NSInteger i = 0; i < [self.model.try_attachMentArray count]; i ++) {
        ApplicationAttachmentModel *attachment = [self.model.try_attachMentArray objectAtIndex:i];
        if (attachment.showId) {
            continue;
        }
        
        [self postProgress:0];
        
        AttachmentUploadRequest *uploadRequest = [[AttachmentUploadRequest alloc] initWithDelegate:self identifier:i];
        [uploadRequest uploadImageData:UIImageJPEGRepresentation(attachment.originalImage, 1.0) appShowIdType:kAttachmentAppShowIdApprove];
        attachUpload = YES;
    }
    
    if (attachUpload) {
        return;
    }
    
    [self postLoading];
    switch (self.applyType) {
        case kEditApply: {
            ApplyEditApplyRequest *request = [[ApplyEditApplyRequest alloc] initWithDelegate:self];
//            [request editApplyWithModel:self.model];
        }
            break;
                
        case kNewApply: {
            ApplyAddNewApplyRequest * request = [[ApplyAddNewApplyRequest alloc] initWithDelegate:self];
            [request applyAddNewApplyWithModel:self.model];
        }
            break;
    }
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([response isKindOfClass:[AttachmentUploadResponse class]])
    {
        NSArray *arrayAttach = self.model.try_attachMentArray;
        ApplicationAttachmentModel *attachModel = [arrayAttach objectAtIndex:[(AttachmentUploadResponse *)response identifier]];
        attachModel.showId = [(id)response attachmentShowId];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"showId != nil && showId.length > 0"];
        NSArray *arrayUploaded = [arrayAttach filteredArrayUsingPredicate:predicate];
        
        BOOL isSuccess = [arrayUploaded count] == [arrayAttach count];
        [self postProgress:(1.0 * [arrayUploaded count] / [arrayAttach count])];
        
        if (!isSuccess) {
            return;
        }
        
        [self postLoading];
        if (self.applyType == kEditApply) {
            // 编辑
            ApplyEditApplyRequest *request = [[ApplyEditApplyRequest alloc] initWithDelegate:self];
//            [request editApplyWithModel:self.model];
        }
        
        else {
            // 新建
            ApplyAddNewApplyRequest * request = [[ApplyAddNewApplyRequest alloc] initWithDelegate:self];
            [request applyAddNewApplyWithModel:self.model];
        }
    }
    else if ([response isKindOfClass:[ApplyAddNewApplyResponse class]])
    {
        [self.model refreshAction];
        [self hideLoading];
        [self postSuccess:LOCAL(APPLY_APPLY_SUCCESS)];
        [[NSNotificationCenter defaultCenter] postNotificationName:MCApplyListDataDidRefreshNotification object:nil];
        NSNotification *notification = [NSNotification notificationWithName:@"turntosender" object:@(1)];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
//        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([request isKindOfClass:[ApplyEditApplyRequest class]])
    {
        [self.model refreshAction];
        [self hideLoading];
        [[NSNotificationCenter defaultCenter] postNotificationName:MCApplyListDataDidRefreshNotification object:nil];
        self.takeimgarrback(self.model.try_attachMentArray);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
}

#pragma mark - UITextFieldDelegate
-(void)TextfieldValueDidChanged:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""])
    {
        textField.text = @"";
        return;
    }else
    {
        if ([textField.text rangeOfString:@"¥"].location != NSNotFound)
        {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
            textField.text = [@"¥" stringByAppendingString:textField.text];
        }
        else
        {
           textField.text = [@"¥" stringByAppendingString:textField.text];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 11)
    {
        CGAffineTransform tramsform = CGAffineTransformMakeTranslation(0, -100);
        self.tableView.transform = tramsform;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 10)
    {
        self.model.try_A_TITLE =textField.text;
    }
    if (textField.tag == 11)
    {
        if (![self isValidateNum:textField.text])
        {
            [self postError:LOCAL(APPLY_INPUTMONEY) duration:1.0];
            textField.text = @"";
            self.tableView.transform = CGAffineTransformIdentity;
            return;
        }
        NSString *str = [textField.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
        self.model.try_A_FEE = [[NSString stringWithFormat:@"%ld",(long)[str integerValue]] integerValue];
        self.tableView.transform = CGAffineTransformIdentity;
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 10) self.model.try_A_TITLE =textField.text;
    if (textField.tag == 11) self.model.try_A_FEE = [textField.text integerValue];
    return YES;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateKeyframesWithDuration:0.2 delay:0.3 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -250);
            self.tableView.transform = transform;
        }];
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.model.try_A_BACKUP = textView.text;
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - deadlineViewDelegate
//设置截至时间
-(void)ApplyAddDeadlineActionSheetViewDelegateCallBack_date:(NSDate *)date
{
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    [dateFormate setDateFormat:@"MM/dd hh:mm"];
    NSString *deadline = [dateFormate stringFromDate:date];
    self.deadLineTime = deadline;
    self.model.try_A_DEADLINE = (long long)[date timeIntervalSince1970] *1000;
    self.model.try_IS_DEADLINE_ALL_DAY = self.isDeadLineWholeday;
    [self.tableView reloadData];
}

-(void)ApplyAddDeadlineActionSheetViewDelegateCallBack_closeDeadlineSwitch
{
    self.deadlineSwitch.on = NO;
}

-(void)ApplyAddDeadlineActionSheetViewDelegateCallBack_isWholeDay:(BOOL)isWholdDay
{
    self.isDeadLineWholeday = isWholdDay;
}

- (void)levelStatuChanged
{
    self.model.try_A_IS_URGENT = (NSInteger)self.levelSwitch.on;
}

#pragma mark - WZPhotoPickerController Delegate
- (void)wz_imagePickerController:(WZPhotoPickerController *)photoPickerController didSelectAssets:(NSArray *)assets {
    for (ALAsset *asset in assets) {
        UIImage *image = [ApplicationAttachmentModel originalImageFromAsset:asset];
        ApplicationAttachmentModel *model = [[ApplicationAttachmentModel alloc] initWithLocalImage:image];
        if (self.model.try_attachMentArray == self.model.attachMentArray) {
            self.model.try_attachMentArray = [NSMutableArray array];
        }
        
        [self.model.try_attachMentArray addObject:model];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image) {
        if (self.model.try_attachMentArray == self.model.attachMentArray) {
            self.model.try_attachMentArray = [NSMutableArray array];
        }
        [self.model.try_attachMentArray addObject:[[ApplicationAttachmentModel alloc] initWithLocalImage:image]];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MWPhotoBrowser Delegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [self.model try_attachMentArray].count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < [self.model try_attachMentArray].count) {
        ApplicationAttachmentModel *attachment = [self.model.try_attachMentArray objectAtIndex:index];
        if (attachment.localPath) {
            return [MWPhoto photoWithImage:[attachment originalImage]];
        }
        
        return [MWPhoto photoWithURL:[NSURL URLWithString:attachment.path]];
    }
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:LOCAL(APPLY_DELETE_PICTURE) delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:LOCAL(DELETE) otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

#pragma mark - private method

//根据取得选中人数，返回行数
- (NSInteger)getRowNumberWithData:(NSArray *)array {
    NSString *labelText = [[NSString alloc] init];;
    NSString *labelTextTest = [[NSString alloc] init];
    for (int i = 0; i < array.count; i++) {
        if (i == 0)
        {
            labelText = [labelText stringByAppendingString:array[i]];
            labelTextTest = labelText;
        } else {
            labelText = [labelText stringByAppendingString:@"、"];
            labelText = [labelText stringByAppendingString:array[i]];
            labelTextTest = labelText;
        }
    }
    if ((self.view.frame.size.width - 110) / 10 >= labelTextTest.length)
    {
        return 47;
    } else if ((self.view.frame.size.width - 110) / 15 < labelTextTest.length && (self.view.frame.size.width - 110) / 7 >= labelTextTest.length)
    {
        return 60;
        
    } else
    {
        return 80;
    }
}


- (BOOL)isValidateNum:(NSString *)Num
{
    NSString *regex = @"[1-9]*[0-9][0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",regex];
    
    NSString *str = [Num stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    return [predicate evaluateWithObject:str];
}

- (void)openPhotoLibrary
{
    WZPhotoPickerController *imagePicker = [[WZPhotoPickerController alloc] init];
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

/** 点击查看照片 */
- (void)selectShowImageAtIndex:(NSUInteger)selectedIndex {
    self.photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    self.photoBrowser.displayTrashButton = YES;
    self.photoBrowser.alwaysShowControls = YES;
    self.photoBrowser.zoomPhotosToFill = YES;
    self.photoBrowser.enableGrid = NO;
    self.photoBrowser.gridButton.hidden = YES;
    self.photoBrowser.enableSwipeToDismiss = NO;
    [self.photoBrowser showNextPhotoAnimated:YES];
    [self.photoBrowser showPreviousPhotoAnimated:YES];
    self.photoBrowser.showNavigationBar = YES;
    [self.navigationController pushViewController:self.photoBrowser animated:YES];
    [self.photoBrowser setCurrentPhotoIndex:selectedIndex];
}

- (void)selectPeople:(NSArray *)selectedList {
    if (self.apprpoveClicked)
    {
        NSString *approve = @"";
        NSString *apprpveName = @"";
        NSInteger i = 0;
        for (ContactPersonDetailInformationModel *model in selectedList)
        {
            [self.approveNameArr addObject:model.u_true_name];
            approve = [approve stringByAppendingString:model.u_name];
            apprpveName = [apprpveName stringByAppendingString:model.u_true_name];
            if (i != selectedList.count -1)
            {
                approve = [approve stringByAppendingString:@"●"];
                apprpveName = [apprpveName stringByAppendingString:@"●"];
            }
            i++;
        }
        self.model.try_A_APPROVE = approve;
        self.model.try_A_APPROVE_NAME = apprpveName;
        
        self.mustComeCellRowHieght = [self getRowNumberWithData:[apprpveName componentsSeparatedByString:@"●"]];
        self.apprpoveClicked = !self.apprpoveClicked;
        [self.tableView reloadData];
    }
    
    if (self.CCApproveClicked)
    {
        NSString *CCApprove = @"";
        NSString *CCApproveName = @"";
        NSInteger i = 0;
        for (ContactPersonDetailInformationModel *model in selectedList)
        {
            [self.CCApproveNameArr addObject:model.u_true_name];
            CCApprove = [CCApprove stringByAppendingString:model.u_name];
            CCApproveName = [CCApproveName stringByAppendingString:model.u_true_name];
            
            if (i != selectedList.count -1)
            {
                CCApprove = [CCApprove stringByAppendingString:@"●"];
                CCApproveName = [CCApproveName stringByAppendingString:@"●"];
            }
            i++;
        }
        self.model.try_A_CC = CCApprove;
        self.model.try_A_CC_NAME = CCApproveName;
        self.canComeCellRowHieght = [self getRowNumberWithData:[CCApproveName componentsSeparatedByString:@"●"]];
        self.CCApproveClicked  = !self.CCApproveClicked;
        [self.tableView reloadData];
    }
}


#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == photoActionSheetTag) {
        if (buttonIndex == 0) {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [self postError:LOCAL(ERROR_NOCAMERA)];
                return;
            }
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        
        else if (buttonIndex == 1) {
            WZPhotoPickerController *imagePicker = [[WZPhotoPickerController alloc] init];
            [imagePicker setDelegate:self];
            
            NSInteger count = maxImageCount - [self.model try_attachMentArray].count;
            [imagePicker setMaximumNumberOfSelection:count];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
        return;
    }
    
    if (buttonIndex == 1) {
        return;
    }
    
    [[self.model try_attachMentArray] removeObjectAtIndex:[self.photoBrowser currentIndex]];
    [self.photoBrowser reloadData];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    
    if (![self.model try_attachMentArray].count) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - Initializer
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        
        [_tableView registerClass:[ApplyTextViewTableViewCell           class] forCellReuseIdentifier:[ApplyTextViewTableViewCell identifier]];
        [_tableView registerClass:[ApplyTextFieldTableViewCell          class] forCellReuseIdentifier:[ApplyTextFieldTableViewCell identifier]];
        [_tableView registerClass:[ApplyDetailTableViewCell             class] forCellReuseIdentifier:[ApplyDetailTableViewCell identifier]];
        [_tableView registerClass:[ApplyAddExpendTxtFieldTableViewCell  class] forCellReuseIdentifier:[ApplyAddExpendTxtFieldTableViewCell identifier]];
        [_tableView registerClass:[ApplyDeadlineTableViewCell           class] forCellReuseIdentifier:[ApplyDeadlineTableViewCell identifier]];
        [_tableView registerClass:[ApplicationAttachmentTableViewCell   class] forCellReuseIdentifier:[ApplicationAttachmentTableViewCell identifier]];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }

    }

    return _tableView;
}
- (NSArray *)arrTitle
{
    if (!_arrTitle)
    {
        NSArray *arr0 = @[@"",LOCAL(APPLY_ADD_ACCEPT_TITLE),LOCAL(APPLY_ADD_ACCEPT_CC_TITLE)];
        NSArray *arr1 = @[LOCAL(APPLY_ADD_PRIORITY_TITLE),LOCAL(APPLY_ADD_DEADLINE_TITLE)];
        NSArray *arr2 = @[LOCAL(APPLY_ADD_EXPENSED_TITLE)];
        NSArray *arr3 = @[LOCAL(APPLY_ADD_ATTACHMENT_TITLE),@""];
        _arrTitle = @[arr0,arr1,arr2,arr3];
    }
    
    return _arrTitle;
}

- (UISwitch *)deadlineSwitch
{
    if (!_deadlineSwitch)
    {
        _deadlineSwitch = [[UISwitch   alloc] init];
        _deadlineSwitch.onTintColor = [UIColor themeBlue];
        [_deadlineSwitch addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _deadlineSwitch;
}

- (NSMutableArray *)imageArr
{
    if (!_imageArr) {
        _imageArr = [[NSMutableArray alloc] initWithCapacity:9];
    }
    return _imageArr;
}

- (UISwitch *)levelSwitch
{
    if (!_levelSwitch)
    {
        _levelSwitch = [[UISwitch alloc] init];
        _levelSwitch.onTintColor = [UIColor themeRed];
        [_levelSwitch addTarget:self action:@selector(levelStatuChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _levelSwitch;
}

- (ApplyAddDeadlineActionSheetView *)deadLineTimeView
{
    if (!_deadLineTimeView) {
        _deadLineTimeView = [[ApplyAddDeadlineActionSheetView alloc]init];
        _deadLineTimeView.delegate = self;
    }
    return _deadLineTimeView;
}

- (NSMutableArray *)approveNameArr
{
    if (!_approveNameArr)
    {
        _approveNameArr = [[NSMutableArray alloc] init];
    }
    return _approveNameArr;
}

- (NSMutableArray *)CCApproveNameArr
{
    if(!_CCApproveNameArr)
    {
        _CCApproveNameArr = [[NSMutableArray alloc] init];
    }
    return _CCApproveNameArr;
}

- (ApplyDetailInformationModel *)model
{
    if (!_model)
    {
        _model = [[ApplyDetailInformationModel alloc] init];
        self.applyType = kNewApply;
    }
    return _model;
}

@end
