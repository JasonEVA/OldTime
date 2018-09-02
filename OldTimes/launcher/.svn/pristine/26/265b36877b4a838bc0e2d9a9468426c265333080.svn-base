//
//  QRCodeLoginRequest.m
//  launcher
//
//  Created by williamzhang on 15/11/12.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "QRCodeLoginRequest.h"
#import "QRLoginModel.h"

@implementation QRCodeLoginRequest

- (NSString *)api { return @"/Base-Module/CompanyUserLogin/QRcodeConnection";}

- (void)login:(QRLoginModel *)model action:(QRCodeType)type {
    self.params[@"connectionId"] = model.realId;
    self.params[@"connectionUrl"] = model.realURL;
    
    switch (type) {
        case QRCodeType_cancel:
            self.params[@"action"] = @"cancel";
            break;
        case QRCodeType_login:
            self.params[@"action"] = @"login";
            break;
        case QRCodeType_scan:
            self.params[@"action"] = @"scan";
            break;
        default:
            break;
    }
    
    [self requestData];
}

@end
