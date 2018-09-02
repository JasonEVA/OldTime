//
//  QRCodeLoginRequest.h
//  launcher
//
//  Created by williamzhang on 15/11/12.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  二维码扫描登录

#import "BaseRequest.h"

@class QRLoginModel;

typedef NS_ENUM(NSUInteger, QRCodeType) {
    QRCodeType_scan,
    QRCodeType_login,
    QRCodeType_cancel,
};

@interface QRCodeLoginRequest : BaseRequest

- (void)login:(QRLoginModel *)model action:(QRCodeType)type;

@end
