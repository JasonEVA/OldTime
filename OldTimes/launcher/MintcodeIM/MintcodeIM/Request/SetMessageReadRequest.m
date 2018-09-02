//
//  SetMessageReadRequest.m
//  launcher
//
//  Created by Lars Chen on 15/9/23.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "SetMessageReadRequest.h"
#import "MessageBaseModel.h"
#import "MsgDefine.h"

static NSString * const SetMsgRead_MsgId = @"msgId";
static NSString * const SetMsgRead_From  = @"from";

static NSString * const newSessionName = @"sessionName";
static NSString * const content        = @"content";

@interface SetMessageReadRequest()

@property (nonatomic, strong) NSArray *messages;

@property (nonatomic, copy) NSString *sessionName;

@end

@implementation SetMessageReadRequest

- (NSString *)action { return @"/readsession";}

- (void)readedMessage:(NSArray *)messages sessionName:(NSString *)sessionName {
    self.params[newSessionName] = sessionName;
    
    NSMutableArray *messageDictionaryArray = [NSMutableArray array];
    NSMutableArray *messageMsgIds = [NSMutableArray array];

    for (MessageBaseModel *message in messages) {
        [messageDictionaryArray addObject:@{SetMsgRead_MsgId : [[NSNumber alloc] initWithLongLong:message._msgId],
                                            SetMsgRead_From : message._fromLoginName
                                            }];
        [messageMsgIds addObject:[[NSNumber alloc] initWithLongLong:message._msgId]];
    }
    
    self.params[content] = messageDictionaryArray;
    self.messages = messageMsgIds;
    [self requestData];
}

- (IMBaseResponse *)prepareResponse:(NSDictionary *)data
{
    SetMessageReadResponse *response = [SetMessageReadResponse new];
    [response setValue:self.messages forKey:@"_readedMessages"];
    response.sessionName = self.sessionName;
    return response;
}

@end

@implementation SetMessageReadResponse

@end
