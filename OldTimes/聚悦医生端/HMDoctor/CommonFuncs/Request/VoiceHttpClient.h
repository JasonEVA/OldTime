//
//  VoiceHttpClient.h
//  HMDoctor
//
//  Created by lkl on 16/6/23.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceHttpClient : NSObject
{
    id postParams;
}
@property (nonatomic, readonly) id respResult;
@property (nonatomic, readonly) BOOL httpSuccess;


- (void) startVoicePost:(NSString*) sUrl Param:(id) param VoiceData:(NSData*) voiceData;
@end
