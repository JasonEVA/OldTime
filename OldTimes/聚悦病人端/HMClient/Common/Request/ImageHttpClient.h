//
//  ImageHttpClient.h
//  HMClient
//
//  Created by yinqaun on 16/4/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ImageHttpPostPrgressBlock)(NSInteger postUnit, NSInteger totalUnit);

@interface ImageHttpClient : NSObject
{
    id postParams;
}
@property (nonatomic, readonly) id respResult;
@property (nonatomic, readonly) BOOL httpSuccess;
@property (nonatomic, strong) ImageHttpPostPrgressBlock progressBlock;


- (void) startImagePost:(NSString*) sUrl Param:(id) param ImageData:(NSData*) imageData;
@end
