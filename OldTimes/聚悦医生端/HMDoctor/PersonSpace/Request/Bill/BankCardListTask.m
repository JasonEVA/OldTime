//
//  BankCardListTask.m
//  HMDoctor
//
//  Created by lkl on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "BankCardListTask.h"
#import "BankCardInfo.h"

@implementation BankCardListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUser2ServiceUrl:@"getUserBankCardList"];
    return postUrl;
}

@end

@implementation AddBankCardTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUser2ServiceUrl:@"addUserBankCard"];
    return postUrl;
}

@end

@implementation GetBankListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUser2ServiceUrl:@"getBankList"];
    return postUrl;
}

@end
