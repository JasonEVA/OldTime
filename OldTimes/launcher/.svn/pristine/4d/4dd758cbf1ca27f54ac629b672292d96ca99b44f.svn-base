//
//  ChatAttachMgrViewController.m
//  Titans
//
//  Created by Remon Lv on 15/1/13.
//  Copyright (c) 2015年 Remon Lv. All rights reserved.
//

#import "ChatAttachMgrViewController.h"
#import "MyDefine.h"
#import "Slacker.h"
#import "QuickCreateManager.h"
#import "NSString+Manager.h"
#import "IMUtility.h"
#import "UIImage+Manager.h"
#import "UIColor+Hex.h"
#import "UnifiedFilePathManager.h"
#import <Masonry/Masonry.h>

#define MARGE 20
#define W_BTN  100
#define H_BTN  30

#define IMG_THEMEBLUE_NORMAL [UIImage imageNamed:@"btn_blue_normal"]
#define IMG_TRANSPARENT      [UIImage imageNamed:@"img_transparent"]

#define COLOR_THEME_GRAY [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]        // 主题灰

@interface ChatAttachMgrViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ChatAttachMgrViewController

- (id)initWithBaseModel:(MessageBaseModel *)baseModel ContactModel:(ContactDetailModel *)contactModel
{
    if (self = [super init])
    {
        _baseModel = baseModel;
        _contactModel = contactModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS_VERSION_7_OR_ABOVE)
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setExtendedLayoutIncludesOpaqueBars:NO];
    }
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    [backItem setTitle:@""];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    // 初始化一堆控件和变量
    [self initComponents];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[MessageManager share] setDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[MessageManager share] setDelegate:nil];
}

#pragma mark - Private Method
// 初始化一堆控件
- (void)initComponents
{
    [self.navigationItem setTitle:LOCAL(TITLE_BTN_FILE)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // 获取附件类型
    Extentsion_kind extentsion = [[UnifiedFilePathManager share] takeFileExtensionWithString:_baseModel.attachModel.fileName];
    BOOL canDownload = (extentsion != extension_nil);
    
    // 生成附件图片
    UIImage *imgIcon = [IMUtility fileIconFromFileName:_baseModel.attachModel.fileName];
    CGSize sizeIcon = imgIcon.size;
    _imgViewIcon = [QuickCreateManager creatImageViewWithFrame:CGRectMake((self.view.frame.size.width - sizeIcon.width) / 2, 50, sizeIcon.width, sizeIcon.height) Image:imgIcon];
    [self.view addSubview:_imgViewIcon];
    
    _lbTitle = [QuickCreateManager creatLableWithFrame:CGRectZero Text:_baseModel.attachModel.fileName Font:[UIFont systemFontOfSize:16] Alignment:NSTextAlignmentCenter Color:[UIColor blackColor]];
    [_lbTitle setNumberOfLines:0];
    CGSize sizeTitle = [_baseModel._fileName getBoundingRectWithSize:CGSizeMake(self.view.frame.size.width - 2 * MARGE, 10000) Font:_lbTitle.font IsForMultiRow:YES];
    
    [_lbTitle setFrame:CGRectMake(MARGE, [Slacker getValueWithFrame:_imgViewIcon.frame WithX:NO] + 30, self.view.frame.size.width - 2 * MARGE, sizeTitle.height)];
    
    [self.view addSubview:_lbTitle];
    
    _lbSize = [QuickCreateManager creatLableWithFrame:CGRectMake(0, [Slacker getValueWithFrame:_lbTitle.frame WithX:NO] + 10, self.view.frame.size.width, 30) Text:_baseModel.attachModel.fileSizeString Font:[UIFont systemFontOfSize:14] Alignment:NSTextAlignmentCenter Color:[UIColor grayColor]];
    [self.view addSubview:_lbSize];
    
    _lbText = [QuickCreateManager creatLableWithFrame:CGRectMake(0, [Slacker getValueWithFrame:_lbSize.frame WithX:NO] + 10, self.view.frame.size.width, 30) Text:LOCAL(FILE_BANDOWNLOAD) Font:[UIFont systemFontOfSize:16] Alignment:NSTextAlignmentCenter Color:[UIColor lightGrayColor]];
    [_lbText setHidden:YES];
    [self.view addSubview:_lbText];
    
    _viewProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [_viewProgress setTrackTintColor:[UIColor clearColor]];
    [_viewProgress setFrame:_lbText.frame];
    [self.view addSubview:_viewProgress];
    
    _btnDownload = [QuickCreateManager creatButtonWithFrame:CGRectMake((self.view.frame.size.width - W_BTN) / 2, [Slacker getValueWithFrame:_lbText.frame WithX:NO] + 10, W_BTN, H_BTN) Title:LOCAL(FILE_CLICKDOWNLOAD) TitleFont:[UIFont systemFontOfSize:16] TitleColor:[UIColor whiteColor] BgImage:[UIImage mtc_imageColor:[UIColor themeBlue] size:CGSizeMake(1.0,1.0)] HighImage:nil BgColor:nil Tag:0];
    
    [_btnDownload addTarget:self action:@selector(downloadAttach) forControlEvents:UIControlEventTouchUpInside];
    [_btnDownload setImage:IMG_TRANSPARENT forState:UIControlStateDisabled];
    [self.view addSubview:_btnDownload];
    
    if (!canDownload)
    {
        [_btnDownload setBackgroundColor:COLOR_THEME_GRAY];
        [_btnDownload setEnabled:NO];
        [_lbText setHidden:NO];
        [_btnDownload setHidden:YES];
        [_viewProgress setHidden:YES];
    }
}

// 下载附件
- (void)downloadAttach
{
    [[MessageManager share] getAttachmentWithBaseModel:_baseModel];
    
    [_viewProgress setProgress:0.0];
    [_btnDownload setEnabled:NO];
}

#pragma mark - MessageManager Delegate

- (void)MessageManagerDelegateCallBack_DataWithProgress:(float)progress Percentage:(float)percentage
{
    [_viewProgress setProgress:progress animated:YES];
}

- (void)MessageManagerDelegateCallBack_AttachDownloadFinishWithFileUrl:(NSString *)filePath
{
    [_btnDownload setEnabled:YES];
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSString *fullPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:filePath];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:fullPath]]];
}

- (void)MessageManagerDelegateCallBack_AttachDownloadFailWithMessage:(NSString *)message
{
    [self postError:message];
    [_btnDownload setEnabled:YES];
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

@end
