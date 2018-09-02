//
//  GroupMessageHistoryViewController.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/27.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "GroupMessageHistoryViewController.h"
#import "GroupMessageHistoryAdapter.h"
#import "ImageCollectionViewCell.h"
#import "ATModuleInteractor+MissionInteractor.h"
#import "MessageListCell.h"
#import "AtMeMessageTableViewCell.h"
#import <MWPhotoBrowser-ADS/MWPhotoBrowser.h>
#import "ChatIMConfigure.h"
#import "ChatSearchResultViewController.h"
#import "RMAudioManager.h"
#import "HMGroupMemberHistoryViewController.h"

static NSString * collectionViewIdentifier = @"collectionViewCell";

@interface GroupMessageHistoryViewController()<ATTableViewAdapterDelegate,UICollectionViewDelegate,UICollectionViewDataSource,MWPhotoBrowserDelegate,RMAudioManagerDelegate,GroupMessageHistoryAdapterDelegate>
@property(nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) MWPhotoBrowser * photoBrowser ;

@property (nonatomic, strong) GroupMessageHistoryAdapter *adapter;

@property (nonatomic,strong) NSMutableArray * arrayPhotos;
@property (nonatomic,strong) NSMutableArray * arrayThumbs;

@property (nonatomic, copy) NSArray *arrayImgMsgData;     //图片数据源
@property (nonatomic, copy)  NSArray  *arrayAtMe; // <##>    //@我数据源
@property (nonatomic, copy)  NSArray  *arrayCollect; // <##> //收藏数据源
@property (nonatomic, copy)  NSArray  *arrayGroupMember; // <##> //群成员数据源

@property (nonatomic, copy)  NSString  *groupUid; // <##>

@property (nonatomic, strong)  RMAudioManager  *audioManager; // 录音manager
@property (nonatomic, copy)  NSString  *patientUid; // <##>

@property (nonatomic, strong)  UserProfileModel  *groupInfoModel; // 录音manager

@end

@implementation GroupMessageHistoryViewController

- (instancetype)initWithGroupId:(NSString *)groupId {
    if (self = [super init]) {
        self.groupUid = groupId;
    }
    return self;
}

- (instancetype)initWithGroupId:(NSString *)groupId patientUid:(NSString *)patientUid {
    if (self = [super init]) {
        self.groupUid = groupId;
        self.patientUid = patientUid;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
    [self setTitle:@"历史记录"];
    
    if (self.paramObject && [self.paramObject isKindOfClass:[NSArray class]]) {
        self.groupUid = [self.paramObject firstObject];
        self.patientUid = [self.paramObject lastObject];
    }
    
    [self configElements];
    [self acquireRequestGroupInfo];
}

#pragma mark -private method

- (void)configElements {
//    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.segment];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
    
//    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.left.equalTo(self.view);
//    }];
    
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segment.mas_bottom).offset(15);
        make.bottom.right.left.equalTo(self.view);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView);
    }];
    
}


- (void)setTableViewOrCollectionViewHidden {
    self.tableView.hidden = self.adapter.segmentedControlSelectedButtonType == Image;
    self.collectionView.hidden = self.adapter.segmentedControlSelectedButtonType != Image;
        switch (self.adapter.segmentedControlSelectedButtonType) {
            case GroupMember:
            {
                [self acquireRequestGroupInfo];
                
                break;
            }
            case AtUser:
            {
                self.arrayAtMe = [self filtrationResendMessage:[[MessageManager share] queryAtMeMessageFromTarget:self.groupUid]];
                self.adapter.adapterArray = [self.arrayAtMe mutableCopy];
                [self.tableView reloadData];

                break;
                
            }
            case Collect:
            {
                __weak typeof(self) weakSelf = self;
                [self at_postLoading];
                // 暂不分页
                [[MessageManager share] MTGetSessionMarkListWithSessionName:self.groupUid limit:100 endTimestamp:-1 completion:^(NSArray<MessageBaseModel *> *modelArray) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf at_hideLoading];
                    __block NSMutableArray *tempArr = [NSMutableArray array];
                    
                    if (modelArray && modelArray.count) {
                        [modelArray enumerateObjectsUsingBlock:^(MessageBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            obj._markImportant = YES;
                        }];
                        strongSelf.arrayCollect = modelArray;
                        [strongSelf.arrayCollect enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [tempArr addObject:@[obj]];
                        }];
                    }
                    strongSelf.adapter.adapterArray = tempArr;
                    [strongSelf.tableView reloadData];
                }];
                break;
            }
                case Image:
            {
                self.arrayImgMsgData = [self filtrationResendMessage:[[MessageManager share] queryBatchImageMessageWithUid:self.groupUid]];
                self.adapter.adapterArray = [self.arrayImgMsgData mutableCopy];
                [self.collectionView reloadData];
                break;
            }
                
            default:
                break;
        }
    
    
}
// 播放音频管理
- (void)voicePlayOrStopWithVoicePath:(NSString *)voicePath playVoiceMsgId:(long long)voiceMsgId {
    
    if (self.audioManager.isPlaying) {
        if (self.adapter.currentPlayingVoiceMsgId == voiceMsgId) {
            // 同一个气泡，停止播放
            [self stopVoicePlay];
            return;
        }
    }
    
    [self.audioManager playAudioWithPath:voicePath];
    //
    self.adapter.currentPlayingVoiceMsgId = voiceMsgId;
}

- (void)stopVoicePlay {
    [self.audioManager stopPlayAudio];
    self.adapter.currentPlayingVoiceMsgId = -1;
}

//过滤已撤回消息
- (NSMutableArray *)filtrationResendMessage:(NSArray *)array {
    __block NSMutableArray *tempArr = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MessageBaseModel *model = (MessageBaseModel *)obj;
        if (model._type != msg_personal_alert) {
            [tempArr addObject:obj];
        }
    }];
    return tempArr;
}

- (void)acquireRequestGroupInfo {
    [self at_postLoading];
__weak typeof(self) weakSelf = self;
    [[MessageManager share] MTRequestGroupInfoWirhGroupId:self.groupUid completion:^(UserProfileModel *model) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf at_hideLoading];
        strongSelf.groupInfoModel = model;
        if (model) {
            [strongSelf reloadGroupMember:model];
        }
    }];

}

- (void)reloadGroupMember:(UserProfileModel *)model {
    if (self.patientUid && self.patientUid.length) {
        // 有患者
        __block UserProfileModel *patientInfoModel;
        __weak typeof(self) weakSelf = self;
        [model.memberList enumerateObjectsUsingBlock:^(UserProfileModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([obj.userName isEqualToString:strongSelf.patientUid]) {
                patientInfoModel = obj;
            }
        }];
        if (patientInfoModel) {
            self.adapter.patientInfo = patientInfoModel;
            [model.memberList removeObject:patientInfoModel];
            self.arrayGroupMember =  @[@[patientInfoModel],model.memberList];
        }
        else {
            self.arrayGroupMember =  model.memberList;
        }
        
    }
    else {
        // 无患者
        self.arrayGroupMember =  model.memberList;
    }
    
     self.adapter.adapterArray = [self.arrayGroupMember mutableCopy];
     [self.tableView reloadData];
}

#pragma mark - 图片浏览器

- (void)clickImageView:(NSInteger)row sourceArr:(NSArray *)sourceArr
{
    // 封装图片数据
    MWPhoto *photo;
    NSInteger currentSelectIndex = 0;
    [self.arrayPhotos removeAllObjects];
    [self.arrayThumbs removeAllObjects];
    for (NSInteger i = 0; i < sourceArr.count; i ++)
    {
        MessageBaseModel *model = sourceArr[i];
        
        if (![model._nativeOriginalUrl length])
        {
            // 网络下载图片
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",im_IP_http,model.attachModel.fileUrl]]];
            [self.arrayPhotos addObject:photo];
            
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",im_IP_http,model.attachModel.thumbnail]]];
            [self.arrayThumbs addObject:photo];
            
        }
        else
        {
            // 本地图片
            photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[MsgFilePathMgr share] getAllPathWithRelativePath:model._nativeOriginalUrl]]];
            [self.arrayPhotos addObject:photo];
            
            photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[MsgFilePathMgr share] getAllPathWithRelativePath:model._nativeOriginalUrl]]];
            [self.arrayThumbs addObject:photo];
            
        }
        if (row == i)
        {
            currentSelectIndex =  row;
        }
        
    }
    
    // Modal
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [self.photoBrowser reloadData];
    [self.photoBrowser setCurrentPhotoIndex:currentSelectIndex];
    [self presentViewController:nc animated:YES completion:nil];
    
}


#pragma mark - event Response
- (void)segentedControlClick:(UISegmentedControl *)seg
{
    self.adapter.segmentedControlSelectedButtonType = seg.selectedSegmentIndex;
    [self setTableViewOrCollectionViewHidden];
    //停止语音播放
    [self stopVoicePlay];

}
#pragma mark - ATTableViewAdapterDelegate

- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath
{
    if (self.adapter.segmentedControlSelectedButtonType == GroupMember) {
        // 群成员数据结构不一样
        UserProfileModel *model = (UserProfileModel *)cellData;
        HMGroupMemberHistoryViewController *memberVC = [[HMGroupMemberHistoryViewController alloc] initWithUserProfileModel:model groupId:self.groupUid];
        [self.navigationController pushViewController:memberVC animated:YES];
    }
    else {
        // 其他都是MessageBaseModel
        MessageBaseModel *model = (MessageBaseModel *)cellData;
        
        if (self.adapter.segmentedControlSelectedButtonType == Collect) {
            //收藏
            switch (model._type) {
                case msg_personal_image:
                {
                    [self stopVoicePlay];
                    
                    //图片点击
                    __block NSMutableArray *tempArr = [NSMutableArray array];
                    __block NSInteger row = 0;
                    [self.arrayCollect enumerateObjectsUsingBlock:^(MessageBaseModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj._type == msg_personal_image) {
                            [tempArr addObject:obj];
                        }
                        if (model._msgId == obj._msgId) {
                            row = tempArr.count - 1;
                        }
                    }];
                    [self clickImageView:row sourceArr:tempArr];
                    
                    break;
                }
                case msg_personal_voice:
                {
                    //语音点击
                    if ([model isFileDownloaded] == YES)
                    {
                        // 直接播放
                        // 播放音频管理
                        [self voicePlayOrStopWithVoicePath:[[MsgFilePathMgr share] getAllPathWithRelativePath:model._nativeOriginalUrl] playVoiceMsgId:model._msgId];
                    }
                    else
                    {
                        //                    self.module.currentNeedPlayVoiceMsgId = baseModel._msgId;
                        // 下载后再播放
                        [[MessageManager share] downloadAudioSourceWithModel:model];
                    }
                    
                    break;
                }
                    
                default:
                    [self stopVoicePlay];
                    break;
            }
        }
        else {
            // @我
            ChatSearchResultViewController *searchResultVC = [[ChatSearchResultViewController alloc] init];
            searchResultVC.IsGroup = [ContactDetailModel isGroupWithTarget:model._target];
            // if (self.isquerySearch) {
            [searchResultVC setStrUid:model._target];
            UserProfileModel *userModel = [[MessageManager share] queryContactProfileWithUid:model._target];
            // }
            //        else
            //        {
            //            [searchResultVC setStrUid:self.uidStr];
            //            self.userModel = [[MessageManager share] queryContactProfileWithUid:self.uidStr];
            //
            //
            //        }
            [searchResultVC setStrName:userModel.nickName];
            searchResultVC.sqlId = model._sqlId;
            searchResultVC.msgid = model._msgId;
            [self.navigationController pushViewController:searchResultVC animated:YES];
        }

    }
   
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayImgMsgData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewIdentifier forIndexPath:indexPath];
    [cell setValue:self.arrayImgMsgData[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self clickImageView:indexPath.row sourceArr:self.arrayImgMsgData];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    NSLog(@"%ld",self.arrayThumbs.count);
    return self.arrayThumbs.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.arrayPhotos.count)
        return [self.arrayPhotos objectAtIndex:index];
    return nil;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    if (index < self.arrayThumbs.count)
        return [self.arrayThumbs objectAtIndex:index];
    return nil;
}

// 完成播放音频
- (void)RMAudioManagerDelegateCallBack_AudioDidFinishPlaying
{
    // 标记
    self.adapter.currentPlayingVoiceMsgId = -1;
}

#pragma mark - GroupMessageHistoryAdepterDelegate

// 删除收藏消息
- (void)GroupMessageHistoryAdapterDelegateCallBack_deleteCell:(NSIndexPath *)indexPath {
    // 得到消息体
    MessageBaseModel *baseModel = self.adapter.adapterArray[indexPath.section][0];
    /* 在这里进行标记操作 */
    __weak typeof(self) weakSelf = self;
    [[MessageManager share] markMessage:baseModel completion:^(BOOL success) {  //从服务器删除
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!success) {
        }
        else {
            [[MessageManager share] markMessageImportantWithModel:baseModel important:!baseModel._markImportant]; //本地数据库删除
            [strongSelf setTableViewOrCollectionViewHidden];
        }
    }];
}

#pragma mark - Interface

#pragma mark - init UI

- (GroupMessageHistoryAdapter *)adapter
{
    if (!_adapter) {
        _adapter = [GroupMessageHistoryAdapter new];
        _adapter.adapterDelegate = self;
        _adapter.tableView = self.tableView;
        _adapter.adapterArray = [self.arrayGroupMember mutableCopy];
        [_adapter setGroupMessageHistoryAdapterDelegate:self];
    }
    return _adapter;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.adapter;
        _tableView.dataSource = self.adapter;
        _tableView.estimatedRowHeight = 150;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView setBackgroundColor:[UIColor colorWithHexString:@"f0f0f0"]];
        [_tableView registerClass:[AtMeMessageTableViewCell class] forCellReuseIdentifier:[AtMeMessageTableViewCell at_identifier]];
        [_tableView registerClass:[HMHistoryCollectImageTableViewCell class] forCellReuseIdentifier:[HMHistoryCollectImageTableViewCell at_identifier]];
        [_tableView registerClass:[HMHistoryCollectTextTableViewCell class] forCellReuseIdentifier:[HMHistoryCollectTextTableViewCell at_identifier]];
        [_tableView registerClass:[HMHistoryCollectVoiceTableViewCell class] forCellReuseIdentifier:[HMHistoryCollectVoiceTableViewCell at_identifier]];
        [_tableView registerClass:[HMGroupMemberHistoryTableViewCell class] forCellReuseIdentifier:[HMGroupMemberHistoryTableViewCell at_identifier]];


    }
    return _tableView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.itemSize = CGSizeMake((ScreenWidth - 35) / 3.0, (ScreenWidth - 35) / 3.0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:collectionViewIdentifier];
        [_collectionView setHidden:YES];
    }
    return _collectionView;
}
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [UISearchBar new];
        [_searchBar setPlaceholder:@"搜索"];
    }
    return _searchBar;
}

- (UISegmentedControl *)segment
{
    if (!_segment) {
        _segment = [[UISegmentedControl alloc]initWithItems:@[@"群成员",@"@我",@"图片",@"收藏"]];
        [_segment addTarget:self action:@selector(segentedControlClick:) forControlEvents:UIControlEventValueChanged];
        [_segment setSelectedSegmentIndex:0];
        [_segment setTintColor:[UIColor mainThemeColor]];
        self.adapter.segmentedControlSelectedButtonType = 0;
    }
    return _segment;
}

- (NSArray *)arrayImgMsgData
{
    if (!_arrayImgMsgData) {
        _arrayImgMsgData = [self filtrationResendMessage:[[MessageManager share] queryBatchImageMessageWithUid:self.groupUid]];
    }
    return _arrayImgMsgData;
}

- (NSArray *)arrayAtMe {
    if (!_arrayAtMe) {
        _arrayAtMe = [self filtrationResendMessage:[[MessageManager share] queryAtMeMessageFromTarget:self.groupUid]];
    }
    return _arrayAtMe;
}

- (NSArray *)arrayCollect
{
    if (!_arrayCollect) {
        _arrayCollect = [self filtrationResendMessage:[[MessageManager share] queryImportantFileAndTextMessageFromTarget:self.groupUid]];
    }
    return _arrayCollect;
}

- (NSArray *)arrayGroupMember
{
    if (!_arrayGroupMember) {
        _arrayGroupMember = [NSArray array];
    }
    return _arrayGroupMember;
}

- (MWPhotoBrowser *)photoBrowser
{
    if (!_photoBrowser)
    {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = YES; // 分享按钮，默认是
        _photoBrowser.displayNavArrows = NO;     // 左右分页切换，默认否
        _photoBrowser.displaySelectionButtons = NO; // 是否显示选择按钮
        _photoBrowser.alwaysShowControls = YES;  // 控制条件控件
        _photoBrowser.zoomPhotosToFill = NO;    // 是否全屏
        _photoBrowser.enableGrid = YES;//是否允许用网格查看所有图片,默认是
        _photoBrowser.startOnGrid = NO;//是否第一张,默认否
        _photoBrowser.enableSwipeToDismiss = YES;
        [_photoBrowser showNextPhotoAnimated:YES];
        [_photoBrowser showPreviousPhotoAnimated:YES];
        [_photoBrowser setCurrentPhotoIndex:1];
    }
    return _photoBrowser;
}

- (NSMutableArray *)arrayPhotos {
    if (!_arrayPhotos) {
        _arrayPhotos = [NSMutableArray array];
    }
    return _arrayPhotos;
}

- (NSMutableArray *)arrayThumbs {
    if (!_arrayThumbs) {
        _arrayThumbs = [NSMutableArray array];
    }
    return _arrayThumbs;
}

- (RMAudioManager *)audioManager
{
    if (!_audioManager)
    {
        _audioManager = [[RMAudioManager alloc] init];
        [_audioManager setDelegate:self];
    }
    return _audioManager;
}
@end
