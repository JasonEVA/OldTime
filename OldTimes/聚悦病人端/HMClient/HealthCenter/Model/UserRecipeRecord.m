//
//  UserRecipeRecord.m
//  HMClient
//
//  Created by yinqaun on 16/6/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserRecipeRecord.h"

@implementation UserRecipeDrugUsage


@end

@implementation UserRecipeRecord

+ (NSDictionary *)objectClassInArray{
    return @{
             @"useDrugList" : @"UserRecipeDrugUsage",
            
             };
}

- (NSString*) drugSpecString
{
    NSString* specStr = @"";
    if (0 == _drugOneSpec)
    {
        return specStr;
    }
    
    if ([CommonFuncs isInteger:_drugOneSpec])
    {
        specStr = [NSString stringWithFormat:@"(%ld%@)", (NSInteger)/*_drugOneSpec * */_singleDosage, _drugOneSpecUnit];
    }
    else
    {
        specStr = [NSString stringWithFormat:@"(%.2f%@)", /*_drugOneSpec */ _singleDosage, _drugOneSpecUnit];
    }
    return specStr;
}
@end
