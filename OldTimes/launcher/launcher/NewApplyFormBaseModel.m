//
//  NewApplyFormBaseModel.m
//  launcher
//
//  Created by williamzhang on 16/4/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyFormBaseModel.h"
#import "NSDictionary+SafeManager.h"

@implementation NewApplyFormBaseModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _labelText = [dict valueStringForKey:Form_Dict_labelText];
        _required  = [dict valueBoolForKey:Form_Dict_required];
        _selected  = [dict valueBoolForKey:Form_Dict_selected];
        _key       = [dict valueStringForKey:Form_Dict_key];
		_rule	   = [dict valueStringForKey:Form_Dict_rule];
        _originalDictionary = dict;
        
        [self handleInputType:dict];
    }
    return self;
}

- (void)removeTryAction {
    _try_inputDetail = nil;
}

- (NSString *)handleInputType:(NSDictionary *)dict {
    _inputType = Form_inputType_unknown;
    return [dict valueStringForKey:Form_Dict_inputType];
}

- (id)try_inputDetail {
    return _try_inputDetail ?: self.inputDetail;
}

- (id)formDataValue { return @""; }

- (NSDictionary *)formData {
    if (self.try_inputDetail == nil) {
        return nil;
    }
    
    if (!self.formDataValue) {
        return nil;
    }
    
    NSDictionary *dict = @{@"key":self.key,@"value":self.formDataValue};
    return dict;
}

@end
