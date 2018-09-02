//
//  ASJSONKitManager.h
//  ASJSONKit
//
//  Created by Andrew Shen on 15/9/18.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark Deserializing methods
@interface NSString (ASJSONKitDeserializing)
// default NSString will be UTF8 encoded, readingOption is NSJSONReadingAllowFragments
- (id)mt_im_objectFromJSONString;
- (id)mt_im_objectFromJSONStringWithReadingOptions:(NSJSONReadingOptions)readingOption;
- (id)mt_im_objectFromJSONStringWithReadingOptions:(NSJSONReadingOptions)readingOption error:(NSError **)error;
@end

@interface NSData (ASJSONKitDeserializing)
// default readingOption is NSJSONReadingAllowFragments
- (id)mt_im_objectFromJSONData;
- (id)mt_im_objectFromJSONDataWithReadingOptions:(NSJSONReadingOptions)readingOption;
- (id)mt_im_objectFromJSONDataWithReadingOptions:(NSJSONReadingOptions)readingOption error:(NSError **)error;
@end


