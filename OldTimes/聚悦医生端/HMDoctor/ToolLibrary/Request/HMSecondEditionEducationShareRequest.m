//
//  HMSecondEditionEducationShareRequest.m
//  HMDoctor
//
//  Created by jasonwang on 2017/1/11.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMSecondEditionEducationShareRequest.h"

@implementation HMSecondEditionEducationShareRequest

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postMcClassService:@"shareMcClass"];
    return postUrl;
}
@end
