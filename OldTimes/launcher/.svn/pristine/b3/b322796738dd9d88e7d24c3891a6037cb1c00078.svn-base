//
//  SendForgetPwdEmailRequest.m
//  launcher
//
//  Created by williamzhang on 16/4/13.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "SendForgetPwdEmailRequest.h"
#import <MJExtension/MJExtension.h>
#import "JSONKitUtil.h"
#import "MyDefine.h"

@implementation SendForgetPwdEmailRequest

- (NSString *)api { return @"/Base-Module/EmailValidator/SendEmail"; }

- (void)requestWithEmail:(NSString *)email validateToken:(NSString *)token validateCode:(NSString *)code {
    [self.params setDictionary:[self emailModelsWithToken:token code:code email:email]];
    self.params[@"emailServiceName"] = @"SMTP";
    self.params[@"emailSubject"] = @"WorkHub邮件验证";
#ifdef JAPANMODE
    self.params[@"fromEmail"] = @"support@workhub.jp";
    self.params[@"emailServiceData"] = @"{'fromPassword':'TGF1bmNocjIwMTUh','host':'smtp.gmail.com','port':587,'useSSL':1}";
#else
    self.params[@"fromEmail"] = @"supportlaunchr@163.com";
    self.params[@"emailServiceData"] = @"{'fromPassword':'Z2VteXFqZGl3dXNpemZyYw==','host':'smtp.163.com','port':25,'useSSL':0}";
#endif
    
    self.params[@"templateName"] = @"forgetpassword";
    
    [self requestData];
}

- (NSDictionary *)emailModelsWithToken:(NSString *)token code:(NSString *)code email:(NSString *)email {
    NSDictionary *emailContentDict = @{@"Url":la_URLWeb,
                                       @"GoalLink":[la_URLWeb stringByAppendingFormat:@"/companyuser/setpassword?key=%@_%@&type=forgetpassword",token, code]};
    NSString *emailContentString = [NSString stringWithFormat:@"{\"Url\":\"%@\",\"GoalLink\":\"%@\"}",la_URLWeb, [la_URLWeb stringByAppendingFormat:@"/companyuser/setpassword?key=%@_%@&type=forgetpassword",token, code]];
    return @{
             @"emailModels":
                 @[@{
                     @"uEmailContent":emailContentString,
                     @"uEmail":email,
                     @"isHtml":@1
                     }
                   ]
              };
}

@end
