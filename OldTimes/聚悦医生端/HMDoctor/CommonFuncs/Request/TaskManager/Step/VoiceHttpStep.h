//
//  VoiceHttpStep.h
//  HMDoctor
//
//  Created by lkl on 16/6/23.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "Step.h"

@interface VoiceHttpStep : Step
{
    id postParams;
}
@property (nonatomic, assign) NSInteger errorCode;

- (id) initWithType:(NSString *)type Params:(id)aPostParams VoiceData:(NSData *)voiData;

@end
