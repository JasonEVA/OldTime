//
//  LookAttachmentViewController.h
//  launcher
//
//  Created by Lars Chen on 15/10/27.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  查看附件

#import "BaseViewController.h"

@interface LookAttachmentViewController : BaseViewController

- (instancetype)initWithFilePath:(NSString *)filePath;

- (instancetype)initWithWebUrl:(NSString *)urlString;

@end
