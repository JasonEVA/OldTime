//
//  ChatForwardDetailViewController.m
//  launcher
//
//  Created by williamzhang on 16/4/5.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ChatForwardDetailViewController.h"
#import "ForwardBaseTableViewCell.h"
#import "ForwardAttachmentTableViewCell.h"
#import "ForwardTextTableViewCell.h"
#import "LookAttachmentViewController.h"
#import "ChatAttachMgrViewController.h"
#import "MWPhotoBrowser.h"
#import "UnifiedFilePathManager.h"
#import <UIAlertView+Blocks/UIAlertView+Blocks.h>
#import <SDWebImage/SDImageCache.h>
#import <Masonry/Masonry.h>
#import "ChatIMConfigure.h"
#import "MyDefine.h"
#import "Category.h"

@interface ChatForwardDetailViewController () <UITableViewDelegate, UITableViewDataSource, ChatAttachMgrViewControllerDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *messages;

@property (nonatomic, strong) NSMutableArray *photosArray;
@property (nonatomic, strong) NSMutableArray *thumbnailsArray;

@end

@implementation ChatForwardDetailViewController

- (instancetype)initWithForwardMessage:(MessageBaseModel *)forwardMessage {
    self = [super init];
    if (self) {
        [forwardMessage getForwardMessagesCompletion:^(NSArray<MessageBaseModel *> *messages, NSString *title) {
            self.title = title;
            self.messages = messages;
        }];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Private Method
- (void)lookAttachmentWithFileURL:(NSString *)fileURL {
    // 获取附件类型
    Extentsion_kind extentsion = [[UnifiedFilePathManager share] takeFileExtensionWithString:fileURL];
    if (extentsion == extension_office || extentsion == extension_txt || extentsion == extension_htm)
    {
        // 获得全部路径
        NSString *fullPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:fileURL];
        LookAttachmentViewController *lookVC = [[LookAttachmentViewController alloc] initWithFilePath:fullPath];
        [self.navigationController pushViewController:lookVC animated:YES];
    }
    else
    {
        [self postError:LOCAL(UNSUPPORT)];
    }
}

- (void)imageClickedAtIndexPath:(NSIndexPath *)clickedIndexPath {
    self.photosArray     = [NSMutableArray array];
    self.thumbnailsArray = [NSMutableArray array];
    
    NSInteger index = 0; // 图片位置
    NSInteger currentIndex = 0; // 图片位置
    for (NSInteger i = 0; i < [self.messages count]; i ++)
    {
        MessageBaseModel *model = [self.messages objectAtIndex:i];
        if (model._type != msg_personal_image) {
            continue;
        }
        
        if (model._nativeThumbnailUrl.length == 0) {
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", im_IP_http, model.attachModel.fileUrl]]];
            [self.photosArray addObject:photo];
            
            MWPhoto *thumbnail = [MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", im_IP_http, model.attachModel.thumbnail]]];
            [self.thumbnailsArray addObject:thumbnail];
        }
        else {
            // 本地图片
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[MsgFilePathMgr share] getAllPathWithRelativePath:model._nativeOriginalUrl]]];
            [self.photosArray addObject:photo];
            
            MWPhoto *thumbnail = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[MsgFilePathMgr share] getAllPathWithRelativePath:model._nativeThumbnailUrl]]];
            [self.thumbnailsArray addObject:thumbnail];
        }
        
        if (clickedIndexPath.row == i ) {
            currentIndex = i + 1 - index;
        }
        
        index ++;
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [browser reloadData];
    [browser setCurrentPhotoIndex:currentIndex];
    
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 15; }
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01; }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageBaseModel *model = [self.messages objectAtIndex:indexPath.row];
    if (model._type == msg_personal_text) {
        return [ForwardTextTableViewCell heightForMessage:model._content];
	} else if (model._type == msg_personal_voice) {
		return [ForwardTextTableViewCell heightForMessage:LOCAL(CHAT_FORWARD_MERGE_UNSUPPORT_CONTENT)];
	} else {
		return [ForwardBaseTableViewCell height];
		
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;
    MessageBaseModel *model = [self.messages objectAtIndex:indexPath.row];
    
	if (model._type == msg_personal_file ||
             model._type == msg_personal_image)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:[ForwardAttachmentTableViewCell identifier]];
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:[ForwardTextTableViewCell identifier]];

	}

    [cell setMessageModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageBaseModel *model = [self.messages objectAtIndex:indexPath.row];
    
    if (model._type == msg_personal_file) {
        if ([model isFileDownloaded]) {
            [self lookAttachmentWithFileURL:model._nativeOriginalUrl];
        }
        else {
            ChatAttachMgrViewController *chatAttachVC = [[ChatAttachMgrViewController alloc] initWithBaseModel:model ContactModel:nil];
            chatAttachVC.delegate = self;
            [self.navigationController pushViewController:chatAttachVC animated:YES];
        }
    }
    
    else if (model._type == msg_personal_image) {
        [self imageClickedAtIndexPath:indexPath];
    }
}

#pragma mark - ChatAttachMgrViewController Delegate
- (void)ChatAttachMgrViewControllerDelegateCallBack_finishDownloadAndLookAttachWithFileUrl:(NSString *)fileUrl {
    [self lookAttachmentWithFileURL:fileUrl];
}

#pragma mark - MWPhotoBrowser Delegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [self.thumbnailsArray count];
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < [self.thumbnailsArray count]) {
        return [self.thumbnailsArray objectAtIndex:index];
    }
    return nil;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < [self.photosArray count]) {
        return [self.photosArray objectAtIndex:index];
    }
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
    [UIAlertView showWithTitle:LOCAL(SAVE_PHOTO)
                       message:nil
             cancelButtonTitle:LOCAL(NO_SAVE)
             otherButtonTitles:@[LOCAL(SAVE)]
                      tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex)
    {
        if (buttonIndex == 0) {
            return;
        }
        
        MWPhoto *photo = [self.photosArray objectAtIndex:index];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[photo.photoURL absoluteString]];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Handle the end of the image write process
    if (!error)
    {
        [self postSuccess:LOCAL(SUCCESS_SAVE)];
    }
    else
    {
        [self postError:[error localizedDescription]];
    }
}

#pragma mark - Initializer
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor grayBackground];
        
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[ForwardBaseTableViewCell class] forCellReuseIdentifier:[ForwardBaseTableViewCell identifier]];
        [_tableView registerClass:[ForwardTextTableViewCell class] forCellReuseIdentifier:[ForwardTextTableViewCell identifier]];
        [_tableView registerClass:[ForwardAttachmentTableViewCell class] forCellReuseIdentifier:[ForwardAttachmentTableViewCell identifier]];
    }
    return _tableView;
}

@end
