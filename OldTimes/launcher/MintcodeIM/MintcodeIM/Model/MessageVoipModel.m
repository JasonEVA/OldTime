//
//  MessageVoipModel.m
//  MintcodeIM
//
//  Created by williamzhang on 16/5/5.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "MessageVoipModel.h"

@implementation MessageVoipModel

// state为0时，为接收到通话请求，不用存数据库
- (MTVoipState)state {
    switch (self.audioLength) {
        case 0: break;
        case -1: return MTVoipStateAudioCancel;
        case -2: return MTVoipStateAudioRefuse;
        default: return MTVoipStateAudioFinish;
    }
    
    switch (self.videoLength) {
        case 0: break;
        case -1: return MTVoipStateVideoCancel;
        case -2: return MTVoipStateVideoRefuse;
        default: return MTVoipStateVideoFinish;
    }
    
    return 0;
}

@end
