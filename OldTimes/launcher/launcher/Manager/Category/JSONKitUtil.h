//
//  JSONKitUtil.h
//  launcher
//
//  Created by williamzhang on 16/3/16.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ASJSONKitDeserializing)
// default NSString will be UTF8 encoded, readingOption is NSJSONReadingAllowFragments
- (id)mtc_objectFromJSONString;
- (id)mtc_objectFromJSONStringWithReadingOptions:(NSJSONReadingOptions)readingOption;
- (id)mtc_objectFromJSONStringWithReadingOptions:(NSJSONReadingOptions)readingOption error:(NSError **)error;
@end

@interface NSData (ASJSONKitDeserializing)
// default readingOption is NSJSONReadingAllowFragments
- (id)mtc_objectFromJSONData;
- (id)mtc_objectFromJSONDataWithReadingOptions:(NSJSONReadingOptions)readingOption;
- (id)mtc_objectFromJSONDataWithReadingOptions:(NSJSONReadingOptions)readingOption error:(NSError **)error;
@end