//
//  ApplicationAttachmentGetRequest.m
//  launcher
//
//  Created by williamzhang on 15/10/27.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplicationAttachmentGetRequest.h"
#import "ApplicationAttachmentModel.h"

static NSString *const d_appShowId = @"appShowID";
static NSString *const d_showId    = @"ShowID";

@implementation ApplicationAttachmentGetResponse
@end

@implementation ApplicationAttachmentGetRequest

- (void)getAppShowId:(AttachmentAppShowIdType)appShowIdType mainShowId:(NSString *)showId {
    self.params[d_appShowId] = [AttachmentUtil attachmentShowIdFromType:appShowIdType];
    self.params[d_showId]    = showId;
    [self requestData];
}

- (NSString *)api  { return @"/Base-Module/Annex";}
- (NSString *)type { return @"GET";}

- (BaseResponse *)prepareResponse:(id)data {
    ApplicationAttachmentGetResponse *response = [ApplicationAttachmentGetResponse new];
    
    NSMutableArray *arrayTmp = [NSMutableArray array];
    for (NSDictionary *dict in data) {
        if (!dict) {
            continue;
        }
        
        ApplicationAttachmentModel *model = [[ApplicationAttachmentModel alloc] initWithDict:dict];
        [arrayTmp addObject:model];
    }
    
    response.arrayAttachments = arrayTmp;
    return response;
}

@end
