//
//  IMPatientContactExtensionModel.m
//  HMDoctor
//
//  Created by Andrew Shen on 2017/1/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "IMPatientContactExtensionModel.h"

@implementation IMPatientContactExtensionModel

- (instancetype)initWithExtensionJsonString:(NSString *)jsonString {
    self = [super init];
    if (self) {
        NSDictionary *dict = [jsonString mj_JSONObject];
        IMPatientContactExtensionModel *model = [IMPatientContactExtensionModel mj_objectWithKeyValues:dict];
        self.ver = model.ver ?: @"";
        self.pId = model.pId ?: @"";
        self.pName = model.pName ?: @"";
        self.isPay = model.isPay;
        self.canChat = model.canChat;
    }
    return self;
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (property.type.typeClass == [NSString class]) {
        if (oldValue == nil || oldValue == [NSNull null] || oldValue == NULL) {
            return @"";
        }
    }
    return oldValue;
}

@end
