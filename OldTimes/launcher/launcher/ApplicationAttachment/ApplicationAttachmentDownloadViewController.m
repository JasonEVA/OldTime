//
//  ApplicationAttachmentDownloadViewController.m
//  launcher
//
//  Created by williamzhang on 15/11/19.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplicationAttachmentDownloadViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <Masonry/Masonry.h>
#import "UIImage+Manager.h"
#import "AttachmentUtil.h"
#import "UIColor+Hex.h"
#import "UIView+Util.h"
#import "MyDefine.h"

@interface ApplicationAttachmentDownloadViewController ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel     *fileNameLabel;
@property (nonatomic, strong) UILabel     *fileSizeLabel;
@property (nonatomic, strong) UILabel     *forbidDownloadLabel;

@property (nonatomic, strong) UIButton *downloadButton;

@property (nonatomic, readonly) NSString *fileTitle;
@property (nonatomic, readonly) NSString *fileURL;
@property (nonatomic, readonly) NSString *identifier;

@end

@implementation ApplicationAttachmentDownloadViewController

- (instancetype)initWithTitle:(NSString *)title urlString:(NSString *)url identifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        _fileTitle = title;
        _fileURL = url;
        _identifier = identifier;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = LOCAL(TITLE_BTN_FILE);
    
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.fileNameLabel];
    [self.view addSubview:self.fileSizeLabel];
    [self.view addSubview:self.downloadButton];
    
    UIImage *fileImage = [AttachmentUtil attachmentIconFromFileName:self.fileTitle];
    if (!fileImage) {
        fileImage = [UIImage imageNamed:@"file_icon_unknown"];
        self.downloadButton.enabled = NO;
        [self.view addSubview:self.forbidDownloadLabel];
    }
    
    self.iconImageView.image = fileImage;
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(50);
    }];
    
    [self.fileNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(30);
    }];
    
    [self.fileSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.fileNameLabel.mas_bottom).offset(10);
    }];
    
    if (_forbidDownloadLabel) {
        [self.forbidDownloadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.fileSizeLabel.mas_bottom).offset(10);
        }];
    }
    
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.fileSizeLabel.mas_bottom).offset(20);
    }];
    
//    [self getFileSize];
}

#pragma mark - Private Method


#pragma mark - Button Click
- (void)clickToDownload {
    
}

#pragma mark - Initializer
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}

- (UILabel *)fileNameLabel {
    if (!_fileNameLabel) {
        _fileNameLabel = [UILabel new];
        _fileNameLabel.font = [UIFont systemFontOfSize:16];
        _fileNameLabel.textColor = [UIColor blackColor];
        _fileNameLabel.text = self.fileTitle;
    }
    return _fileNameLabel;
}

- (UILabel *)fileSizeLabel {
    if (!_fileSizeLabel) {
        _fileSizeLabel = [UILabel new];
        _fileSizeLabel.font = [UIFont systemFontOfSize:14];
        _fileSizeLabel.textColor = [UIColor grayColor];
    }
    return _fileSizeLabel;
}

- (UILabel *)forbidDownloadLabel {
    if (!_forbidDownloadLabel) {
        _forbidDownloadLabel = [UILabel new];
        _forbidDownloadLabel.font = [UIFont systemFontOfSize:16];
        _forbidDownloadLabel.textColor = [UIColor lightGrayColor];
        _forbidDownloadLabel.text = LOCAL(FILE_BANDOWNLOAD);
    }
    return _forbidDownloadLabel;
}

- (UIButton *)downloadButton {
    if (!_downloadButton) {
        _downloadButton = [UIButton new];
        _downloadButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_downloadButton setTitle:LOCAL(FILE_CLICKDOWNLOAD) forState:UIControlStateNormal];
        [_downloadButton setBackgroundImage:[UIImage mtc_imageColor:[UIColor themeBlue]] forState:UIControlStateNormal];

        [_downloadButton setBackgroundImage:[UIImage mtc_imageColor:[UIColor mtc_colorWithW:242]] forState:UIControlStateDisabled];
        
        [_downloadButton addTarget:self action:@selector(clickToDownload) forControlEvents:UIControlEventTouchUpInside];
        
        _downloadButton.expandSize = CGSizeMake(20, 10);
    }
    return _downloadButton;
}

@end