//
//  RecordExtendTitleModel.h
//  HMDoctor
//
//  Created by lkl on 2017/7/10.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordExtendTitleModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *isShow;

@end


@interface AsthmaDiaryValueModel : NSObject

@property (nonatomic, copy) NSString *symptomName;
@property (nonatomic, copy) NSString *symptomId;
@property (nonatomic, copy) NSString *isRecord;
@property (nonatomic, copy) NSString *symptomCode;

@end

@interface AsthmaDiaryModel : NSObject

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSArray *value;

@end
