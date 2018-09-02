//
//  ChatSingleViewController.m
//  Titans
//
//  Created by Remon Lv on 14-9-11.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "ChatSingleViewController.h"
#import <Masonry.h>
#import "MyDefine.h"
#import "CalculateHeightManager.h"
#import "Slacker.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import "ChatAttachPickView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NSDate+MsgManager.h"
#import "UIColor+Hex.h"
#import "AppDelegate.h"
#import "ContactPersonDetailInformationModel.h"
#import "CoordinationFilterView.h"
//#import "ATModuleInteractor+CoordinationInteractor.h"
//#import "ForwardSelectRecentContactViewController.h"
#import "HMBaseNavigationViewController.h"
//#import "JKGWModel.h"
#import "DateUtil.h"
typedef NS_ENUM(NSUInteger, ChatMenuType) {
    ChatMenuHistoryList,
    ChatMenuGroupInfo,
};
#define W_MAX_IMAGE (225 + [Slacker getXMarginFrom320ToNowScreen] * 2)     // 照片最大宽度

@interface ChatSingleViewController () <CoordinationFilterViewDelegate>

@property (nonatomic, strong)  CoordinationFilterView  *filterView; // <##>
// 工作时间提醒view=-=Jason
@property (nonatomic, strong)  UILabel  *workTimePrompt; // <##>
@end

@implementation ChatSingleViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configCellSenderNameHide:YES];
    
    [self initCompnents];
    [self.chatInputView configAttachPickViewType:ChatAttachPickTypeBase];
    [self.navigationItem setTitle:self.strName];
    UIBarButtonItem *btnSet = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"c_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(btnDropListClicked)];
    if (self.isLittleHelper) {
        [self.navigationItem setRightBarButtonItems:@[btnSet]];//,btnSearch]];
    }

    self.viewInputHeight = 50;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationItem setTitle:self.strName];
    
    
    if (self.keyboardHeight > 0)
    {
        [self.chatInputView popupKeyboard];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)nil;
}



#pragma mark - Private Method

- (void)btnDropListClicked
{
    
    if (![self.view.subviews containsObject:self.filterView]) {
        [self.view addSubview:self.filterView];
        [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    else {
        [self.filterView removeFromSuperview];
        _filterView = nil;
    }
}

- (void)updateViewConstraints
{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.chatInputView.mas_top);
    }];

    [self.chatInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-self.keyboardHeight);
        make.top.equalTo(self.tableView.mas_bottom);
        make.height.equalTo(@(MAX(self.viewInputHeight, self.chatInputView._viewCommon.frame.size.height)));
    }];
    [super updateViewConstraints];
}

- (void)initCompnents
{
    [self configNonworkdayPrompt];

}
// 设置非工作时间提醒
- (void)configNonworkdayPrompt {
    NSDateComponents *components = [DateUtil dateComponentsForDate:[NSDate date]];
    if (!(components.weekday > 1 && components.weekday < 7 && components.hour >= 9 && components.hour <=17)) {
        // 工作时间
        self.chatInputView.hidden = YES;
        [self.view addSubview:self.workTimePrompt];
        [self.workTimePrompt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(50);
        }];
        
    }
}

// 视频截图
- (NSString *)videoScreenShotWithURL:(NSString *)videoUrl
{
    // 缩略图
    //创建URL
    NSURL *url= [[NSURL alloc] initFileURLWithPath:videoUrl];    //根据url创建AVURLAsset
    AVURLAsset *urlAsset=[AVURLAsset assetWithURL:url];
    //根据AVURLAsset创建AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    // 保证截图方向
    imageGenerator.appliesPreferredTrackTransform = YES;
    /*截图
     * requestTime:缩略图创建时间
     * actualTime:缩略图实际生成的时间
     */
    NSError *error = nil;
    CMTime time = CMTimeMakeWithSeconds(0.0, 1);//CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actualTime;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    CGRect rect =CGRectMake(0, 0, IOS_SCREEN_WIDTH, IOS_SCREEN_HEIGHT - 100);
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(cgImage, rect);
    if(error){
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
    }
    CMTimeShow(actualTime);
    UIImage *image=[UIImage imageWithCGImage:imageRefRect];//转化为UIImage
    
    // 得到路径
    long long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *strDate = [NSString stringWithFormat:@"%lld",timeStamp];
    NSString *strFileNameThumb = [NSString stringWithFormat:@"%@thumb.jpg",strDate];
    NSString *strPath = [[MsgFilePathMgr share] getMessageDirNamePathWithUid:self.strUid];
    NSString *strThumbPath = [strPath stringByAppendingPathComponent:strFileNameThumb];
    PRINT_STRING(strThumbPath);
    [UIImageJPEGRepresentation(image, 0.3) writeToFile:strThumbPath atomically:YES];
    // 转换成相对路径
    NSString *strRelativeThumb = [[MsgFilePathMgr share] getRelativePathWithAllPath:strThumbPath];
    
    return strRelativeThumb;
}

#pragma mark - CoordinationFilterViewDelegate
- (void)CoordinationFilterViewDelegateCallBack_ClickWithTag:(NSInteger)tag
{
    if (self.isLittleHelper) {
//        ContactDetailModel *tempModel = [ContactDetailModel new];
//        JKGWModel *JModel = self.helperList[tag];
//        tempModel._target = [NSString stringWithFormat:@"%ld",JModel.USER_ID];
//        tempModel._nickName = JModel.STAFF_NAME;
//        self.strUid        = tempModel._target;
//        self.strName       = tempModel._nickName;
//        self.avatarPath    = tempModel._headPic;
//        self.module.sessionModel = tempModel;
//        self.ifScrollBottom = YES;
//        [self refreshTargetInfo];
//        [self initModule];
//        
//        
//        [self.module setReadMessages];
    }
    
//    ChatMenuType type = (ChatMenuType)tag;
//    switch (type) {
//        case ChatMenuHistoryList: {
//            //[self.interactor goHistoryList];
//            break;
//        }
//        case ChatMenuGroupInfo: {
//            //[self.interactor goGroupInfo];
//            break;
//        }
//    }
    
}

#pragma mark - getter & setter

- (CoordinationFilterView *)filterView {
    if (!_filterView) {
        NSMutableArray *imageArr = [NSMutableArray new];
        NSMutableArray *titelsArr = [NSMutableArray new];
        NSMutableArray *tagArr = [NSMutableArray new];
//        for (JKGWModel *model in self.helperList) {
//            [imageArr addObject:@"c_historyList"];
//            [titelsArr addObject:model.STAFF_NAME];
//            [tagArr addObject:[NSString stringWithFormat:@"%d",i++]];
//        }
        _filterView = [[CoordinationFilterView alloc] initWithImageNames:imageArr titles:titelsArr tags:tagArr];
        _filterView.delegate = self;
    }
    return _filterView;
}

- (UILabel *)workTimePrompt {
    if (!_workTimePrompt) {
        _workTimePrompt = [UILabel new];
        _workTimePrompt.textAlignment = NSTextAlignmentCenter;
        _workTimePrompt.backgroundColor = [UIColor colorWithRed:253.0 / 255.0 green:255.0 / 255.0 blue:228.0 / 255.0 alpha:1.0];
        _workTimePrompt.font = [UIFont font_30];
        _workTimePrompt.text = @"*客服工作时间为工作日上午9:00~下午17:00";
    }
    return _workTimePrompt;
}
@end
