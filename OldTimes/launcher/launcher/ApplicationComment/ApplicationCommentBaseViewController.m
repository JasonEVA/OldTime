//
//  ApplicationCommentBaseViewController.m
//  launcher
//
//  Created by williamzhang on 15/11/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplicationCommentBaseViewController.h"
#import "ApplicationAttachmentDownloadViewController.h"
#import "ApplicationCommentImageTableViewCell.h"
#import "ApplicationCommentTableViewCell.h"
#import "ApplicationCommentDeleteRequest.h"
#import "ApplicationRemainTableViewCell.h"
#import "MWPhotoBrowser.h"
#import "ApplicationCommentNewRequest.h"
#import "ApplicationCommentListRequest.h"
#import "ApplicationAttachmentModel.h"
#import "ApplicationCommentModel.h"
#import "AttachmentUploadRequest.h"
#import "UnifiedUserInfoManager.h"
#import "ApplicationInputView.h"
#import "WebViewController.h"
#import <Masonry/Masonry.h>
#import "AttachmentUtil.h"


#pragma mark - new
#import "NewApplyCommentTableViewCell.h"
#import "NewApplycommentbtnsView.h"
#import "NewApplyCommentImgTableViewCell.h"
#import "ChatGroupSelectAtUserViewController.h"
#import "UITextView+AtUser.h"
#import <MJExtension.h>
#import "ApplicationCommentFileCell.h"

@interface ApplicationCommentBaseViewController ()<ApplicationInputViewDelegate>

@property (nonatomic, strong) ApplicationInputView *inputView;

@property (nonatomic, strong) ApplicationCommentListRequest *commentRequest;
@property (nonatomic, strong) NSMutableArray *arrayComments;
@property (nonatomic, strong) NSMutableArray *arrTextComments;
@property (nonatomic, strong) NSMutableArray *arrAttachmentsComments;
@property (nonatomic, strong) NSMutableArray *arrSystemComments;
@property (nonatomic, strong) NSArray *AtUserMemberIDs;
@property (nonatomic, strong) NSArray *AtUserMemberNames;

/** 默认YES */
@property (nonatomic, assign) BOOL remain;
@property (nonatomic, strong) NewApplycommentbtnsView *btnview;
@property (nonatomic, strong) UIView *subview;
@property (nonatomic, strong) NSString *strUrl;
@end

@implementation ApplicationCommentBaseViewController

- (instancetype)initWithAppShowIdType:(AttachmentAppShowIdType)type rmShowID:(NSString *)rmShowID {
    self = [super init];
    if (self) {
        _appShowId = [AttachmentUtil attachmentShowIdFromType:type];
        _rmShowId  = rmShowID;
        _remain    = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inputView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.inputView.mas_top);
    }];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
    }];
	
	__weak typeof(self) weakSelf = self;
    [self.inputView sendText:^(NSString *text) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return ;
        }
        [strongSelf configCreateComment];
		NSString* commentText = [strongSelf configureCommentAtWhoWithText:text];
        [strongSelf postLoading];
        [strongSelf.createRequest comment:commentText];
    }];
	
    [self.inputView selectImage:^(UIImage *selectedImage) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return ;
        }
        [strongSelf configCreateComment];
        [strongSelf postLoading];
        AttachmentUploadRequest *uploadRequest = [[AttachmentUploadRequest alloc] initWithDelegate:strongSelf];
        [uploadRequest uploadImageData:UIImageJPEGRepresentation(selectedImage, 1.0) appShowId:strongSelf.appShowId];
    }];
    
    
    self.commentRequest = [[ApplicationCommentListRequest alloc] initWithDelegate:self];
    [self.commentRequest setAppShowId:self.appShowId];
    [self.commentRequest newCommentWithShowId:self.rmShowId];
}

#pragma mark - Interface Method
- (void)configCreateComment {}
- (void)changeCommentParameter{}
- (void)reloadComments {
    [self.arrayComments removeAllObjects];
    [self.arrAttachmentsComments removeAllObjects];
    [self.arrTextComments removeAllObjects];
    [self.arrSystemComments removeAllObjects];
    [self.commentRequest newCommentWithShowId:self.rmShowId];
    [self postLoading];
}
- (NSString *)configureCommentAtWhoWithText:(NSString *)text {
	if ([text rangeOfString:@"@"].location == NSNotFound) {
		[self.createRequest setAtWho:[[NSArray new] mj_JSONString]];
		return text;
	}
	
	
	__block NSString *finalText = [text copy];
	NSMutableArray *members = [NSMutableArray arrayWithCapacity:self.AtUserMemberNames.count];
	[self.AtUserMemberNames enumerateObjectsUsingBlock:^(NSString*  _Nonnull name, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([name isEqualToString:@""]) {
			return ;
		}
		NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:name options:0 error:nil];
		NSArray *results = [regex matchesInString:text options:0 range: NSMakeRange(0, text.length)];
		for (NSTextCheckingResult *result in results) {
			if (result.range.location != NSNotFound) {
				NSDictionary *memeberDict = @{@"name":[NSString stringWithFormat:@"@%@",name], @"id": self.AtUserMemberIDs[idx]};
				[members addObject:memeberDict];
			}
		}
		
		finalText = [finalText stringByReplacingOccurrencesOfString:name withString:[NSString stringWithFormat:@"%@ %@", name,self.AtUserMemberIDs[idx]]];
		
	}];
	
	NSString *membersString = [members mj_JSONString];
	if (!membersString && [membersString isEqualToString:@""]) {
		[self.createRequest setAtWho:[[NSArray new] mj_JSONString]];
	} else {
		[self.createRequest setAtWho:membersString];
	}
	
	return finalText;
}

- (void)setAllowAtUserMemberIDs:(NSArray *)memberIDs memeberNames:(NSArray *)memberNames {
	
	self.AtUserMemberIDs = [memberIDs copy];
	self.AtUserMemberNames = [memberNames copy];
}

#pragma mark - Private Method
- (void)delayMethod
{
    [self.inputView resignfirstResponder];
}

- (BOOL)commentIsText:(ApplicationCommentModel *)model {
    return !model.filePath || ![model.filePath length] || model.isDelete;
}

- (BOOL)commentIsFile:(ApplicationCommentModel *)model {
	return model.filePath && ![AttachmentUtil isImage:model.content] && !model.isDelete;
}

- (NSInteger)remainSection {
    return [self numberOfSectionsInTableView:self.tableView] - 2;
}

- (NSInteger)realSection:(NSInteger)section {
    return section - ([self numberOfSectionsInTableView:self.tableView] - 2);
}

- (NSIndexPath *)realIndexPath:(NSIndexPath *)indexPath {
    return [NSIndexPath indexPathForRow:indexPath.row inSection:[self realSection:indexPath.section]];
}

- (void)clickToSeeCommentAtIndex:(NSInteger)index {
    ApplicationCommentModel *clickedModel;
    if (self.commentstyle == commentSelect_all)
    {
       clickedModel = self.arrayComments[index];
    }
    else
    {
        clickedModel = self.arrAttachmentsComments[index];
    }
    
    if (![AttachmentUtil isImage:clickedModel.content]) {
        WebViewController *webVC = [[WebViewController alloc] initWithURL:clickedModel.filePath shouldDownload:YES];
		webVC.title = clickedModel.content;
        [self.navigationController pushViewController:webVC animated:YES];
        return;
    }
    
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    photoBrowser.zoomPhotosToFill = YES;
    photoBrowser.enableSwipeToDismiss = NO;
    photoBrowser.gridButton.hidden = YES;

    [photoBrowser setCurrentPhotoIndex:[self fileInFilterFileIndex:clickedModel]];
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:photoBrowser];
	navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentViewController:navigationController animated:YES completion:nil];
}

/** 评论中的照片 */
- (NSArray *)filterFile {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@""
                              @"filePath != nil &&"
                              @"filePath.length > 0 &&"
                              @"isDelete != true &&"
                              @"(content LIKE[cd] '*.png' ||"
                              @"content LIKE[cd] '*.jpg' ||"
                              @"content LIKE[cd] '*.jpeg')"];
    return [self.arrayComments filteredArrayUsingPredicate:predicate];
}

- (NSInteger)fileInFilterFileIndex:(ApplicationCommentModel *)commentModel {
    NSArray *filterFile = [self filterFile];
    for (NSInteger i = 0; i < filterFile.count; i ++) {
        if (commentModel == [filterFile objectAtIndex:i]) {
            return i;
        }
    }
    return 0;
}



#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    
    if ([request isKindOfClass:[ApplicationCommentListRequest class]]) {
        // 评论列表
        NSArray *arrayComment = [(id)response arrayComments];
        [self.arrayComments insertObjects:arrayComment atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [arrayComment count])]];
        for (NSInteger i = 0; i<arrayComment.count; i++)
        {
            ApplicationCommentModel *model = [self.arrayComments objectAtIndex:i];
            if (model.filePath.length > 0)
            {
                [self.arrAttachmentsComments addObject:model];
            }
            else if (model.isComment)
            {
                [self.arrTextComments addObject:model];
            }
            else
            {
                [self.arrSystemComments addObject:model];
            }
        }
        self.remain = [(id)response remain];
        
        NSMutableArray *insertedIndexPaths = [NSMutableArray array];
        for (NSInteger i = 0; i < [arrayComment count]; i ++) {
            [insertedIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:[self remainSection] + 1]];
        }
        [self.tableView reloadData];
    }
    
    else if ([request isKindOfClass:[ApplicationCommentDeleteRequest class]]) {
        [self hideLoading];
        // 删除评论
        ApplicationCommentModel *deletedModel;
        NSInteger deletedRow = request.identifier;
        switch (self.commentstyle)
        {
            case commentSelect_all:
                deletedModel = [self.arrayComments objectAtIndex:deletedRow];
                break;
            case commentSelect_Text:
                deletedModel = [self.arrTextComments objectAtIndex:deletedRow];
                break;
            case commentSelect_Attachment:
                deletedModel = [self.arrAttachmentsComments objectAtIndex:deletedRow];
                break;
            case commentSelect_System:
                deletedModel = [self.arrSystemComments objectAtIndex:deletedRow];
                break;
            default:
                break;
        }
        
        
//        ApplicationCommentModel *deletedModel = [self.arrayComments objectAtIndex:deletedRow];
        deletedModel.isDelete = YES;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:deletedRow inSection:[self remainSection] + 1]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    else if ([request isKindOfClass:[AttachmentUploadRequest class]]) {
        // 上传附件
        [self postLoading];
        ApplicationAttachmentModel *attachModel = [(id)response appAttachmentModel];
        [self.createRequest fileShowId:attachModel.showId filePath:attachModel.path];
        self.strUrl = attachModel.pathURL;
    }
    
    else if ([request isKindOfClass:[ApplicationCommentNewRequest class]]) {
        [self hideLoading];
        // 新增评论
        ApplicationCommentModel *commentModel = [(id)response commentModel];
        if (commentModel.filePath.length > 0)
        {
            commentModel.filePath = self.strUrl;
            self.strUrl = @"";
        }
        [self.arrayComments addObject:commentModel];
        
        commentSelect increasedStyle = commentSelect_all;
        if (commentModel.filePath.length> 0)
        {
            increasedStyle = commentSelect_Attachment;
            [self.arrAttachmentsComments addObject:commentModel];
        }
        else if (commentModel.isComment)
        {
            increasedStyle = commentSelect_Text;
            [self.arrTextComments addObject:commentModel];
        }
        else
        {
            increasedStyle = commentSelect_System;
            [self.arrSystemComments addObject:commentModel];
        }
        
        [self.inputView clearText];
        NSIndexPath *insertedIndexPath;
        switch (self.commentstyle)
        {
            case commentSelect_all:
                insertedIndexPath = [NSIndexPath indexPathForRow:[self.arrayComments count] - 1 inSection:[self remainSection] + 1];
                break;
            case commentSelect_Text:
                insertedIndexPath = [NSIndexPath indexPathForRow:[self.arrTextComments count] - 1 inSection:[self remainSection] + 1];
                break;
            case commentSelect_Attachment:
                insertedIndexPath = [NSIndexPath indexPathForRow:[self.arrAttachmentsComments count] - 1 inSection:[self remainSection] + 1];
                break;
            case commentSelect_System:
                insertedIndexPath = [NSIndexPath indexPathForRow:[self.arrSystemComments count] - 1 inSection:[self remainSection] + 1];
                break;
            default:
                break;
        }
        //        NSIndexPath *insertedIndexPath = [NSIndexPath indexPathForRow:[self.arrayComments count] - 1 inSection:[self remainSection] + 1];
        if (self.commentstyle == commentSelect_all || self.commentstyle == increasedStyle) {
            [self.tableView insertRowsAtIndexPaths:@[insertedIndexPath] withRowAnimation:UITableViewRowAnimationRight];
            [self.tableView scrollToRowAtIndexPath:insertedIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
        [self changeCommentParameter];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSInteger realSection = [self realSection:section];
//    if (realSection == 0) {
//        return 1;
//    }
    switch (self.commentstyle)
    {
        case commentSelect_all:
            return [self.arrayComments count];
            break;
        case commentSelect_Text:
            return [self.arrTextComments count];
            break;
        case commentSelect_Attachment:
            return [self.arrAttachmentsComments count];
            break;
        case commentSelect_System:
            return [self.arrSystemComments count];
            break;
        default:return 0;
            break;
    }
//    return [self.arrayComments count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01;}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *realIndexPath = [self realIndexPath:indexPath];
//    if (realIndexPath.section == 0) {
//        return 44;
//    }
    ApplicationCommentModel *commentModel;
    switch (self.commentstyle)
    {
        case commentSelect_all:
            commentModel = [self.arrayComments objectAtIndex:realIndexPath.row];
            break;
        case commentSelect_Text:
            commentModel = [self.arrTextComments objectAtIndex:realIndexPath.row];
            break;
        case commentSelect_Attachment:
            commentModel = [self.arrAttachmentsComments objectAtIndex:realIndexPath.row];
            break;
        case commentSelect_System:
            commentModel = [self.arrSystemComments objectAtIndex:realIndexPath.row];
            break;
        default:
            break;
    }
    
//    ApplicationCommentModel *model = [self.arrayComments objectAtIndex:realIndexPath.row];
    if ([self commentIsText:commentModel])
    {
        NewApplyCommentTableViewCell *cell = [[NewApplyCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewApplyCommentTableViewCellID" CellKind:CellKind_Comment];
        [cell dataWithModel:commentModel];
        return [cell getHeight];
	} else if ([self commentIsFile:commentModel]) {
		return [ApplicationCommentFileCell getHeight];
	}

    
    // 图片模式
    return [NewApplyCommentImgTableViewCell getHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

        return self.subview;

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;
    NSIndexPath *realIndexPath = [self realIndexPath:indexPath];
    

    ApplicationCommentModel *commentModel;
    switch (self.commentstyle)
    {
        case commentSelect_all:
            commentModel = [self.arrayComments objectAtIndex:realIndexPath.row];
            break;
        case commentSelect_Text:
            commentModel = [self.arrTextComments objectAtIndex:realIndexPath.row];
            break;
        case commentSelect_Attachment:
            commentModel = [self.arrAttachmentsComments objectAtIndex:realIndexPath.row];
            break;
        case commentSelect_System:
            commentModel = [self.arrSystemComments objectAtIndex:realIndexPath.row];
            break;
        default:
            break;
    }
    
    
    
    if ([self commentIsText:commentModel]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"NewApplyCommentTableViewCellID"];
        if (!cell)
        {
           cell = [[NewApplyCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewApplyCommentTableViewCellID" CellKind:commentModel.filePath.length>0? CellKind_Attachement:CellKind_Comment];
        }
	}else if ([self commentIsFile:commentModel]) {
		
		cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([ApplicationCommentFileCell class])];
		if (!cell) {

			cell = [[ApplicationCommentFileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ApplicationCommentFileCell class])];
		}
		
		__weak typeof(self) weakSelf = self;
		[cell clickToSee:^(id clickedCell) {
			__strong typeof(self) strongSelf = weakSelf;
			if (!strongSelf) {
				return ;
			}
			
			NSIndexPath *indexPath = [tableView indexPathForCell:clickedCell];
			[strongSelf clickToSeeCommentAtIndex:indexPath.row];
			
		}];
		
	
	} else {

        cell = [tableView dequeueReusableCellWithIdentifier:@"NewApplyCommentImgTableViewCellID"];
        if (!cell)
        {
            cell = [[NewApplyCommentImgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewApplyCommentImgTableViewCellID"];
        }
        __weak typeof(self) weakSelf = self;
        [cell clickToSee:^(id clickedCell) {
            __strong typeof(self) strongSelf = weakSelf;
			if (!strongSelf) {
				return ;
			}
			
            NSIndexPath *indexPath = [tableView indexPathForCell:clickedCell];
            [strongSelf clickToSeeCommentAtIndex:indexPath.row];
        }];
    }
	
    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    NSString *myShowId = [[UnifiedUserInfoManager share] userShowID];
    if (![myShowId isEqualToString:commentModel.createUser] || !commentModel.isComment || commentModel.isDelete) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell dataWithModel:commentModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSIndexPath *realIndexPath = [self realIndexPath:indexPath];

        ApplicationCommentModel *model;
        switch (self.commentstyle)
        {
            case commentSelect_all:
                model = [self.arrayComments objectAtIndex:realIndexPath.row];
                break;
            case commentSelect_Text:
                model = [self.arrTextComments objectAtIndex:realIndexPath.row];
                break;
            case commentSelect_Attachment:
                model = [self.arrAttachmentsComments objectAtIndex:realIndexPath.row];
                break;
            case commentSelect_System:
                model = [self.arrSystemComments objectAtIndex:realIndexPath.row];
                break;
            default:
                break;
        }
        NSString *userShowId = [[UnifiedUserInfoManager share] userShowID];
        if (![userShowId isEqualToString:model.createUser] || !model.isComment || model.isDelete) {
            return;
        }
    
        // 删除评论
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:LOCAL(MISSION_COMFIRMDELETE) delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(CONFIRM), nil];
        actionSheet.tag = realIndexPath.row;
        [actionSheet showInView:self.view];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
#pragma mark - ApplicationInputViewDelegate
- (void)ApplicationInputViewDelegateCallBack_didStartEdit
{
    NSArray *showingArray = nil;
    switch (self.commentstyle) {
        case commentSelect_Text:
            showingArray = self.arrTextComments;
            break;
        case commentSelect_Attachment:
            showingArray = self.arrAttachmentsComments;
            break;
        case commentSelect_System:
            showingArray = self.arrSystemComments;
            break;
        case commentSelect_all:
        default:
            showingArray = self.arrayComments;
            break;
    }
    
    if ([showingArray count] == 0) {
        return;
    }
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[showingArray count] - 1 inSection:[self remainSection] + 1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)ApplicationInputViewDelegateCallBack_atUser:(UITextView *)textView {

	if (!self.AtUserMemberIDs || self.AtUserMemberIDs.count == 0) {
		return;
	}
	
	NSMutableArray *members = [NSMutableArray arrayWithCapacity:self.AtUserMemberIDs.count];
	if (self.AtUserMemberIDs.count == 0) {
		return;
	}
	[self.AtUserMemberIDs enumerateObjectsUsingBlock:^(NSString *  _Nonnull userId, NSUInteger idx, BOOL * _Nonnull stop) {
		NSDictionary *memberDic = [NSDictionary dictionaryWithObject:self.AtUserMemberNames[idx] forKey:userId];
		[members addObject:memberDic];
	}];
	
	ChatGroupSelectAtUserNavigationViewController *selectAtUserVC = [[ChatGroupSelectAtUserNavigationViewController alloc] initWithCanSelectedMembers: members];	
	
	[selectAtUserVC selectedPeople:^(ContactPersonDetailInformationModel *selectedPerson) {
		
		if ([textView canBecomeFirstResponder]) {
			[textView becomeFirstResponder];
		}
		
		if (!selectedPerson) {
			// 点击取消返回
			return;
		}
		
		[textView addAtUser:selectedPerson deleteFrontAt:YES];
		
	}];
	
	[self presentViewController:selectAtUserVC animated:YES completion:nil];
}

#pragma mark - MWPhotoBrowser Delegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [self filterFile].count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSArray *array = [self filterFile];
    if (index >= [array count]) {
        return nil;
    }
    
    ApplicationCommentModel *commentModel = [array objectAtIndex:index];
    return [[MWPhoto alloc] initWithURL:[NSURL URLWithString:commentModel.filePath]];
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        return;
    }
    
    [self postLoading];
    ApplicationCommentModel *deleteModel;
    switch (self.commentstyle)
    {
        case commentSelect_all:
            deleteModel = [self.arrayComments objectAtIndex:actionSheet.tag];
            break;
        case commentSelect_Text:
            deleteModel = [self.arrTextComments objectAtIndex:actionSheet.tag];
            break;
        case commentSelect_Attachment:
            deleteModel = [self.arrAttachmentsComments objectAtIndex:actionSheet.tag];
            break;
        case commentSelect_System:
            deleteModel = [self.arrSystemComments objectAtIndex:actionSheet.tag];
            break;
        default:
            break;
    }
    
//    ApplicationCommentModel *deleteModel = [self.arrayComments objectAtIndex:actionSheet.tag];
    ApplicationCommentDeleteRequest *deleteRequest = [[ApplicationCommentDeleteRequest alloc] initWithDelegate:self identifier:actionSheet.tag];
    [deleteRequest deleteShowId:deleteModel.showID];
}

#pragma mark - Intializer
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
//        [_tableView registerClass:[ApplicationCommentImageTableViewCell class]  forCellReuseIdentifier:[ApplicationCommentImageTableViewCell identifier]];
//        [_tableView registerClass:[ApplicationCommentTableViewCell class]       forCellReuseIdentifier:[ApplicationCommentTableViewCell identifier]];
//        [_tableView registerClass:[ApplicationRemainTableViewCell class]        forCellReuseIdentifier:[ApplicationRemainTableViewCell identifier]];
//        [_tableView registerClass:[NewApplyCommentTableViewCell class] forCellReuseIdentifier:@"NewApplyCommentTableViewCellID"];
    }
    return _tableView;
}

- (ApplicationInputView *)inputView {
    if (!_inputView) {
        _inputView = [[ApplicationInputView alloc] initWithViewController:self];
        [_inputView setDalegate:self];
    }
    return _inputView;
}

- (NSMutableArray *)arrayComments {
    if (!_arrayComments) {
        _arrayComments = [NSMutableArray array];
    }
    return _arrayComments;
}

- (NSMutableArray *)arrTextComments
{
    if (!_arrTextComments)
    {
        _arrTextComments = [[NSMutableArray alloc] init];
    }
    return _arrTextComments;
}

- (NSMutableArray *)arrAttachmentsComments
{
    if (!_arrAttachmentsComments)
    {
        _arrAttachmentsComments = [[NSMutableArray alloc] init];
    }
    return _arrAttachmentsComments;
}

- (NSMutableArray *)arrSystemComments
{
    if (!_arrSystemComments)
    {
        _arrSystemComments = [[NSMutableArray alloc] init];
    }
    return _arrSystemComments;
}

- (NewApplycommentbtnsView *)btnview
{
    if (!_btnview)
    {
        _btnview = [[NewApplycommentbtnsView alloc] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 40)];
		__weak typeof(self) weakSelf = self;
        [_btnview setblock:^(NSInteger index) {
            weakSelf.commentstyle = (commentSelect)index;
            [weakSelf.tableView reloadData];
        }];
    }
    return _btnview;
}

- (UIView *)subview
{
    if (!_subview)
    {
        _subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
        [_subview addSubview:self.btnview];
    }
    return _subview;
}

- (NSString *)strUrl
{
    if (!_strUrl)
    {
        _strUrl = [[NSString alloc] init];
        _strUrl = @"";
    }
    return _strUrl;
}
@end
