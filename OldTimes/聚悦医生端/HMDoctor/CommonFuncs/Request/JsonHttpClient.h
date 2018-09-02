//
//  JsonHttpClient.h
//  weixiangmao
//
//  Created by yinqaun on 15/11/3.
//  Copyright © 2015年 绿天下. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonHttpClient : NSObject
{
    id postParams;
}
@property (nonatomic, readonly) id respResult;
@property (nonatomic, readonly) BOOL httpSuccess;

- (void) startJsonPost:(NSString*) sUrl Param:(id) param;

@end
