//
//  SelectContactUtil.m
//  launcher
//
//  Created by williamzhang on 15/10/13.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "SelectContactUtil.h"
#import "ContactPersonDetailInformationModel.h"

@implementation SelectContactUtil

+ (NSMutableDictionary *)getShowIdDictionaryFromArray:(NSArray *)arrayPeople {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (ContactPersonDetailInformationModel *userModel in arrayPeople) {
        if (![userModel isKindOfClass:[ContactPersonDetailInformationModel class]]) {
            continue;
        }
        
        if (![userModel.show_id length]) {
            continue;
        }
        
        [dictionary setObject:@1 forKey:userModel.show_id];
    }
    
    return dictionary;
}

@end
