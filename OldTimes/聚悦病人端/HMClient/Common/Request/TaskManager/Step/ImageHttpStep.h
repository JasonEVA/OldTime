//
//  ImageHttpStep.h
//  HMClient
//
//  Created by yinqaun on 16/4/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "Step.h"
#import "ImageHttpClient.h"

@interface ImageHttpStep : Step
{
    id postParams;
}

@property (nonatomic, assign) NSInteger errorCode;
- (id) initWithType:(NSString*) type Params:(id) aPostParams ImageData:(NSData*) imgData;

@end
