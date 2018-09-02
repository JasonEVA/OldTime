                                 //
//  MessageMainViewController.m
//  launcher
//
//  Created by Tab Liu on 15/9/21.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MessageMainViewController.h"
#import "ImageCollectionViewCell.h"
#import "Masonry.h"
#import "FileTableViewCell.h"
#import "AppMessageTableViewCell.h"
#import "ChatEventScheduleTableViewCell.h"
#import "ChatEventMissionTableViewCell.h"
#import "ChatSearchResultViewController.h"
#import "ChatNewTaskView.h"

#import "ContactPersonDetailInformationModel.h"
#import "MyDefine.h"
#import "MWPhotoBrowser.h"
#import "Category.h"
#import "AtMeMessageTableViewCell.h"
#import <MintcodeIM/MintcodeIM.h>
#import "ChatIMConfigure.h"
#import "ChatSingleViewController.h"
#import "ChatGroupViewController.h"
#import "NewMissionGetMissionDetailRequest.h"
#import "NewDetailMissionViewController.h"
#import "AppTaskModel.h"
#import "TaskListModel.h"

#define BG_COLOR [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]
static NSString * collectionViewIdentifier = @"collectionViewCell";

typedef NS_ENUM(NSInteger, UISegmentedControlSelectedButtonType) {
    AtUser    = 0,
    Emphasis,
    File,
    Image,
    APP
};

@interface MessageMainViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,UIActionSheetDelegate,MWPhotoBrowserDelegate, BaseRequestDelegate>

@property (nonatomic) UISegmentedControlSelectedButtonType  segmentedControlSelectedButtonType ;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) UISegmentedControl * segentedControl;
@property (nonatomic, strong) UIActionSheet *actSheet;
@property (nonatomic, strong) NSMutableArray *messageArray;        // 标注重点
@property (nonatomic,strong) NSMutableArray * imgArray;            // 图片
@property (nonatomic,strong) NSIndexPath * selectedPath;
@property (nonatomic,strong) NSMutableArray * appMesssageArray;    //应用
@property (nonatomic,strong) NSMutableArray * fileMesssageArray;    //应用
/** @我的人员 */
@property (nonatomic,strong) NSMutableArray * atMeArray;

@property (nonatomic,strong) NSMutableArray * arrayPhotos;
@property (nonatomic,strong) NSMutableArray * arrayThumbs ;
@property (nonatomic,strong) MWPhotoBrowser * photoBrowser ;

@property (nonatomic, strong) UIView *emptyPageView;
@property (nonatomic, strong) UIImageView *emptyIcon;
@property (nonatomic, strong) UILabel *emptyTitel;
@property (nonatomic, strong) UILabel *emptyDetail;
@end

@implementation MessageMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self setExtendedLayoutIncludesOpaqueBars:NO];
    self.view.backgroundColor = [UIColor mtc_colorWithHex:0xebebeb];
    
    [self getData];
    [self initUI];

    [_segentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(16);
        make.left.equalTo(self.view).offset(12.5);
        make.right.equalTo(self.view).offset(-12.5);
        make.height.equalTo(@27);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_segentedControl.mas_bottom).offset(15);
        make.left.equalTo(_segentedControl.mas_left);
        make.right.equalTo(_segentedControl.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_segentedControl.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
    [_emptyPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView);
    }];
    
    [self.navigationItem setTitle:LOCAL(MESSAGE_LOGGING)];
}


- (void)getData
{
	//图片
    NSArray * array1 = [[MessageManager share] queryImportantImageMessageFromTarget:self.strUid msg_type:msg_personal_image];
	
	//重点
	NSArray * array3 = [self fileterSystemMsgWithArray:[[MessageManager share] queryImportantFileAndTextMessageFromTarget:self.strUid]];
	
    _appMesssageArray = [[NSMutableArray alloc] initWithArray:[[MessageManager share] queryAppMessageWithTarget:self.strUid]];
    _imgArray = [[NSMutableArray alloc] initWithArray:array1];
    self.messageArray = [[NSMutableArray alloc] initWithArray:array3];
	
	// 文件
    self.fileMesssageArray = [[NSMutableArray alloc] initWithArray:[[MessageManager share] queryImportantImageMessageFromTarget:self.strUid msg_type:msg_personal_file]];
	
	// @我的
    self.atMeArray = [NSMutableArray arrayWithArray:[[MessageManager share] queryAtMeMessageFromTarget:self.strUid]];
}

//过滤系统提示
- (NSArray *)fileterSystemMsgWithArray:(NSArray *)array
{
    NSMutableArray *arr = [NSMutableArray array];
    for (MessageBaseModel *model in array)
    {
        if (model._type != msg_personal_alert)
        {
            [arr addObject:model];
        }
    }
    NSArray *tempArray = [NSArray arrayWithArray:arr];
    return tempArray;
}

#pragma mark - Event Respond

- (void)pressGRRespond:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        self.selectedPath = nil;
        FileTableViewCell * cell = (FileTableViewCell *)longPress.view;
        self.selectedPath = [self.tableView indexPathForCell:cell];
        
        if (self.segmentedControlSelectedButtonType != Emphasis) {
            return;
        }
        
        MessageBaseModel *message = [self.messageArray objectAtIndex:self.selectedPath.row];
        if (message._type == msg_personal_text) {
            [self.actSheet showInView:self.view];
        }
    }
    
}
- (void)ImageMark:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateEnded) {
//        self.selectedPath = nil;
//        ImageCollectionViewCell * cell = (ImageCollectionViewCell *)longPress.view;
//        self.selectedPath = [self.collectionView indexPathForCell:cell];
//        [self.actSheet showInView:self.view];
    }
}

#pragma mark - 初始化设置
- (void)initUI
{
    [self.view addSubview:self.segentedControl];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.emptyPageView];
    self.segentedControl.selectedSegmentIndex = 0;
    [self segentedControlClick:self.segentedControl];
}

#pragma mark - creat segentedControl
- (UISegmentedControl *)segentedControl
{
    if (!_segentedControl) {
        if (self.isGroupChat) {
            _segentedControl = [[UISegmentedControl alloc] initWithItems:@[
                                                                           [LOCAL(CHAT_AT) substringWithRange:NSMakeRange(1, [LOCAL(CHAT_AT) length] - 2)],
                                                                           LOCAL(EMPHASIS),
                                                                           LOCAL(TITLE_BTN_FILE),
                                                                           LOCAL(TITLE_BTN_IMG),
                                                                           LOCAL(CHAT_APP_TITEL)
                                                                           ]];
        } else {
            _segentedControl = [[UISegmentedControl alloc] initWithItems:@[
                                                                           LOCAL(EMPHASIS),
                                                                           LOCAL(TITLE_BTN_FILE),
                                                                           LOCAL(TITLE_BTN_IMG),
                                                                           LOCAL(CHAT_APP_TITEL)
                                                                           ]];
        }
        
        [_segentedControl addTarget:self action:@selector(segentedControlClick:) forControlEvents:UIControlEventValueChanged];
        [_segentedControl setBackgroundColor:[UIColor whiteColor]];
        [_segentedControl setTintColor:[UIColor themeBlue]];
    }
    
    return _segentedControl;
}
#pragma mark - segentedControl -> addTarget :
- (void)segentedControlClick:(UISegmentedControl *)seg
{
    self.segmentedControlSelectedButtonType = seg.selectedSegmentIndex + (self.isGroupChat ? 0 : 1);
    [self setTableViewOrCollectionViewHidden];
    [self reloadData];
}
#pragma mark - 刷新数据
- (void)reloadData
{
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    [self.collectionView setContentOffset:CGPointMake(0,0) animated:NO];
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

#pragma mark - 根据枚举值 设置控件的展示和隐藏
- (void)setTableViewOrCollectionViewHidden {
    self.tableView.hidden = self.segmentedControlSelectedButtonType == Image;
    self.collectionView.hidden = self.segmentedControlSelectedButtonType != Image;
    NSArray *datalist = [NSArray array];
    NSString *imageName = [[NSString alloc] init];
    NSString *titel = [[NSString alloc] init];
    NSString *detail = [[NSString alloc] init];
    switch (self.segmentedControlSelectedButtonType) {
        case AtUser:
        {
            datalist = self.atMeArray;
            imageName = @"empty_at";
            titel = LOCAL(CHAT_ATME_TITEL);
            detail = LOCAL(CHAT_ATME_CONTENT);
        }
            break;
        case Emphasis:
        {
            [UIImage imageNamed:@"empty_app"];
            datalist = self.messageArray;
            imageName = @"empty_point";
            titel = LOCAL(CHAT_POINT_TITEL);
            detail = LOCAL(CHAT_POINT_CONTENT);
        }
            break;
        case File:
        {
            datalist = self.fileMesssageArray;
            imageName = @"empty_ducement";
            titel = LOCAL(CHAT_FILE_TITEL);
            detail = LOCAL(CHAT_FILE_CONTENT);
        }
            break;
        case Image:
        {
            datalist = self.imgArray;
            imageName = @"empty_picture";
            titel = LOCAL(CHAT_IMAGE_TITEL);
            detail = LOCAL(CHAT_IMAGE_CONTENT);
        }
            break;
        case APP:
        {
            datalist = self.appMesssageArray;
            imageName = @"empty_app";
            titel = LOCAL(CHAT_APP_TITEL);
            detail = LOCAL(CHAT_APP_CONTENT);
        }
            break;
            
        default:
            break;
    }
    if (datalist.count == 0) {
        [self.emptyPageView setHidden:NO];
        [self.emptyIcon setImage:[UIImage imageNamed:imageName]];
        [self.emptyTitel setText:titel];
        [self.emptyDetail setText:detail];
    } else {
        [self.emptyPageView setHidden:YES];
    }

}

#pragma mark - create tableView
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(13, 63, IOS_SCREEN_WIDTH, IOS_SCREEN_HEIGHT - 63) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BG_COLOR;
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushViewControllerWithPath:indexPath];
}
#pragma mark - 跳转页面
- (void)pushViewControllerWithPath:(NSIndexPath *)indexPath
{
    
    MessageBaseModel * model;
    switch (self.segmentedControlSelectedButtonType) {
        case Emphasis:
            model = self.messageArray[indexPath.row];
            break;
            
        case File:
            model = self.fileMesssageArray[indexPath.row];
            break;
            
        case Image:
            model = self.imgArray[indexPath.row];
            break;
  
        case APP:
            model = self.appMesssageArray[indexPath.row];
            break;
        case AtUser: {
            model = self.atMeArray[indexPath.row];
        }
            break;
        default:
            break;
    }
    
    //如果是应用的情况下进行跳转
    if (self.segmentedControlSelectedButtonType == APP)
    {
		AppTaskModel *taskModel = [AppTaskModel mj_objectWithKeyValues:model.appModel.applicationDetailDictionary];
		NewMissionGetMissionDetailRequest *request = [[NewMissionGetMissionDetailRequest alloc] initWithDelegate:self];
		[request getDetailTaskWithId:taskModel.id];
		
        return;
    }
    
    
    ChatSearchResultViewController *searchResultVC = [[ChatSearchResultViewController alloc] init];
    UserProfileModel * uesrmodel;
    
    if (self.isGroupChat) {
        [searchResultVC setStrUid:model._target];
        uesrmodel = [[MessageManager share] queryContactProfileWithUid:model._target];
        searchResultVC.IsGroup = YES;
    }
    else
    {
        searchResultVC.IsGroup = NO;
        [searchResultVC setStrUid:self.strUid];
        uesrmodel = [[MessageManager share] queryContactProfileWithUid:self.strUid];
    }
	
    [searchResultVC setStrName:uesrmodel.nickName];
    searchResultVC.sqlId = model._sqlId;
    searchResultVC.msgid = model._msgId;
	
	__weak typeof(self) weakSelf = self;
	searchResultVC.refreshEmphasisDataBlock = ^(BOOL didChange) {
		if (didChange) {
			__strong typeof(weakSelf) strongSelf = weakSelf;
			if (!strongSelf) return ;
			[strongSelf getData];
			NSLog(@"%@", strongSelf.messageArray);
			[strongSelf.tableView reloadData];
			
		}
		
	};
	
    [self.navigationController pushViewController:searchResultVC animated:YES];

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segmentedControlSelectedButtonType == Emphasis) {
        return self.messageArray.count;
    }
    
    if (self.segmentedControlSelectedButtonType == File) {
        return self.fileMesssageArray.count;
    }
    
    if (self.segmentedControlSelectedButtonType == APP) {
        return self.appMesssageArray.count;
    }
    
    if (self.segmentedControlSelectedButtonType == AtUser) {
        return self.atMeArray.count;
    }
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILongPressGestureRecognizer *pressDr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressGRRespond:)];
    [pressDr setDelegate:self];
    
    if (self.segmentedControlSelectedButtonType == Emphasis || self.segmentedControlSelectedButtonType == File) {
        static NSString * string = @"cell";
        FileTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (!cell) {
            cell = [[FileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            cell.uid = self.strUid;
            cell.isGroup = self.isGroupChat;
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (self.segmentedControlSelectedButtonType == Emphasis) {
            [cell setMessageData:self.messageArray[indexPath.row]];
        }
        else
        {
            [cell setMessageData:self.fileMesssageArray[indexPath.row]];
        }

        [cell addGestureRecognizer:pressDr];
        
        return cell;
    } else if (self.segmentedControlSelectedButtonType == APP) {
        
        static NSString * string = @"cell2";
        AppMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (!cell) {
            cell = [[AppMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            cell.uidStr = self.strUid;
            cell.isGroup = self.isGroupChat;
        }
        [cell setCellData:self.appMesssageArray[indexPath.row]];
        return cell;

    } else {
        AtMeMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[AtMeMessageTableViewCell identifer]];
        if (!cell) {
            cell = [[AtMeMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[AtMeMessageTableViewCell identifer]];
        }
        
        [cell setDataWithModel:self.atMeArray[indexPath.row]];
        return cell;
    }
    
}

#pragma mark - creat collectionView
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width - 26, self.view.frame.size.height - 200) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
         _collectionView.backgroundColor = BG_COLOR;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:collectionViewIdentifier];
    }
    return _collectionView;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewIdentifier forIndexPath:indexPath];
    UILongPressGestureRecognizer *pressDr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(ImageMark:)];
    [pressDr setDelegate:self];
    [cell addGestureRecognizer:pressDr];
    [cell setValue:self.imgArray[indexPath.row]];
    return cell;
}
#pragma mark - UICollectionViewDelegate
//定义每个UICollectionViewCell 的大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int  width = (collectionView.frame.size.width - 10)/3;
    return CGSizeMake(width,width);
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self clickImageView:indexPath.row];
}

- (UIActionSheet *)actSheet
{
    if (!_actSheet) {
        _actSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) destructiveButtonTitle:nil otherButtonTitles:LOCAL(MESSAGE_COPY),LOCAL(CANCLE_MARK_EMPHASIS),nil];//,LOCAL(TO_SCHEDULE),LOCAL(TO_TASK),LOCAL(FROWARDING)
        [_actSheet setActionSheetStyle:UIActionSheetStyleDefault];
    }
    return _actSheet;
}

#pragma mark - NewMissionGetMissionDetailRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
	NSLog(@"%@", response);
	
	if ([request isKindOfClass:[NewMissionGetMissionDetailRequest class]]) {
		TaskListModel *taskList = [TaskListModel new];
		taskList.showId = request.params[@"showId"];
		
		NewDetailMissionViewController *missionVC = [[NewDetailMissionViewController alloc] initWithMissionDetailModel: taskList];
		missionVC.isFirstVC = YES;
		[self.navigationController pushViewController:missionVC animated:YES];
	}
	
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
	[self postError:LOCAL(errorMessage)];	
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //复制
            [self copyMessage:nil];
            break;
           
        case 1:
            //取消标记重点
            [self markMessage:nil];
            break;

        case 2:
            //转为日程
            break;

        case 3:
            //转为任务
            //[self  creatTask];
            break;

        case 4:
            //转发
            break;

        case 5:
            //取消
            break;

        default:
            break;
    }
    
    
}

/* 复制消息*/
- (void)copyMessage:(id)sender
{
    if (!self.selectedPath) {
        return;
    }
    // 得到消息体
    MessageBaseModel *baseModel = [_messageArray objectAtIndex:self.selectedPath.row];
    
    // 复制消息
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    // 判断是文字还是图片
    if (baseModel._type == msg_personal_text)
    {
        [pasteboard setString:baseModel._content];
    }
    else if (baseModel._type == msg_personal_image)
    {
        // 判断是接收的消息还是发送的消息
        NSString *strImg;
        if (baseModel._markFromReceive)
        {
            strImg = baseModel._nativeOriginalUrl;
            // FK，太BT了 http起头的URL进去后，pasteborad.string也会被设置，而pasteborad.string一旦有值就不会触发外层的paste:方法，只能伪装下URL；By Remon，以后有更好的方法可以自行修改；
            strImg = [NSString stringWithFormat:@"//%@",strImg];
        }
        else
        {
            strImg = baseModel._content;
        }
        [pasteboard setURL:[NSURL URLWithString:strImg]];
    }
}
/* 标记为重点 */
- (void)markMessage:(id)sender
{
    // 得到消息体
    MessageBaseModel *baseModel = [_messageArray objectAtIndex:self.selectedPath.row];
    /* 在这里进行标记操作 */
    [[MessageManager share] markMessage:baseModel];
    [[MessageManager share] markMessageImportantWithModel:baseModel important:!baseModel._markImportant];
    baseModel._markImportant ^= 1;
    
    [_messageArray removeObjectAtIndex:self.selectedPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[self.selectedPath] withRowAnimation:UITableViewRowAnimationRight];
    
}

/*转为任务*/
- (void)creatTask
{
//    ChatNewTaskView *taskView = [[ChatNewTaskView alloc] initCreateNewTaskBlock:^(MessageAppModel *appModel,NSString * Show_ID) {
//        NSLog(@"--%@",appModel);
//    }];
//    
//    ContactPersonDetailInformationModel *infomodel = [[UnifiedSqlManager share] findPersonWithShowId:self.strUid];
//    taskView.arrPersons = [NSArray arrayWithObjects:infomodel, nil];
//    
//    [taskView show];

}

#pragma mark - 图片浏览器

- (void)clickImageView:(NSInteger)row
{
    // 封装图片数据
    MWPhoto *photo;
    NSInteger currentSelectIndex = 0;
    if (!self.arrayPhotos) {
        self.arrayPhotos = [[NSMutableArray alloc] init];
        self.arrayThumbs = [[NSMutableArray alloc] init];

    }
    [self.arrayPhotos removeAllObjects];
    [self.arrayThumbs removeAllObjects];
    for (NSInteger i = 0; i < self.imgArray.count; i ++)
    {
        MessageBaseModel *model = self.imgArray[i];
        
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
            currentSelectIndex = self.arrayPhotos.count - 1;
        }
        
    }
    
    // Modal
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self.photoBrowser reloadData];
    [self.photoBrowser setCurrentPhotoIndex:currentSelectIndex];
    
    [self presentViewController:nc animated:YES completion:nil];

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

- (UIView *)emptyPageView
{
    if (!_emptyPageView) {
        _emptyPageView = [[UIView alloc] init];
        [_emptyPageView addSubview:self.emptyIcon];
        [_emptyPageView addSubview:self.emptyTitel];
        [_emptyPageView addSubview:self.emptyDetail];
        [self.emptyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_emptyPageView);
            make.bottom.equalTo(_emptyPageView.mas_centerY).offset(-10);
        }];
        [self.emptyTitel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_emptyPageView);
            make.top.equalTo(_emptyPageView.mas_centerY).offset(10);
        }];
        
        [self.emptyDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_emptyPageView);
            make.width.equalTo(@250);
            make.top.equalTo(self.emptyTitel.mas_bottom).offset(20);
        }];
    }
    return _emptyPageView;
}

- (UIImageView *)emptyIcon
{
    if (!_emptyIcon) {
        _emptyIcon = [[UIImageView alloc] init];
    }
    return _emptyIcon;
}
- (UILabel *)emptyTitel
{
    if (!_emptyTitel) {
        _emptyTitel = [[UILabel alloc] init];
        [_emptyTitel setTextColor:[UIColor themeBlue]];
    }
    return _emptyTitel;
}

- (UILabel *)emptyDetail
{
    if (!_emptyDetail) {
        _emptyDetail = [[UILabel alloc] init];
        [_emptyDetail setTextColor:[UIColor themeGray]];
        [_emptyDetail setNumberOfLines:0];
        [_emptyDetail setFont:[UIFont systemFontOfSize:13]];
        [_emptyDetail setTextAlignment:NSTextAlignmentCenter];
    }
    return _emptyDetail;
}
@end
