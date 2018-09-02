//
//  GetAllCommentRequest.m
//  launcher
//
//  Created by williamzhang on 15/10/19.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "GetAllCommentRequest.h"
#import "NSDictionary+SafeManager.h"
#import "AttachmentUtil.h"

static NSString * const d_pageIndex = @"pageIndex";
static NSString * const d_appShowID = @"appShowID";

static NSString * const r_rmShowID  = @"rmShowID";
static NSString * const r_readStatus = @"readStatus";

@implementation GetAllCommentResponse
@end

@implementation GetAllCommentRequest

- (void)requestData {
    self.params[d_pageIndex] = @-1;
    self.params[d_appShowID] = [AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdTask];
    
    [super requestData];
}

- (NSString *)type { return @"GET";}
- (NSString *)api { return @"/Base-Module/Message/MessageList";}

- (BaseResponse *)prepareResponse:(id)data {
    GetAllCommentResponse *response = [GetAllCommentResponse new];
    
    NSMutableDictionary *dictonary = [NSMutableDictionary dictionary];
    
    for (NSDictionary *dictComment in data) {
        if (!dictComment) {
            continue;
        }
        
        NSString *rmShowId = [dictComment valueStringForKey:r_rmShowID];
        NSInteger readStatus = [[dictComment valueNumberForKey:r_readStatus] integerValue];
        
        NSInteger readed = [dictonary objectForKey:rmShowId] ? [[dictonary objectForKey:rmShowId] integerValue] : -1;
        if (readed == 0) {
            continue;
        }
        
        [dictonary setObject:@(readStatus) forKey:rmShowId];
    }
    
    response.dictionaryComments = dictonary;
    return response;
}

@end
