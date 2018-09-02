//
//  DrugInfo.h
//  HMDoctor
//
//  Created by lkl on 16/6/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//  用药模板详情

#import <Foundation/Foundation.h>

@interface DrugInfo : NSObject

@property (nonatomic, retain) NSString* drugId;

@property (nonatomic, retain) NSString* drugBagSpec;
@property (nonatomic, retain) NSString* drugBagUnit;

@property (nonatomic, retain) NSString* drugName;
@property (nonatomic, retain) NSString* drugOneSpec;
@property (nonatomic, retain) NSString* drugOneSpecUnit;
@property (nonatomic, retain) NSString* drugOrg;
@property (nonatomic, retain) NSString* drugPrice;
@property (nonatomic, retain) NSString* drugSpec;   //规格
@property (nonatomic, retain) NSString* productName;

@property (nonatomic, copy) NSString* allDosage;
@property (nonatomic, copy) NSString* allDosageUnit;
@property (nonatomic, copy) NSString* createTime;
@property (nonatomic) NSInteger creator;
@property (nonatomic) NSInteger drugDosage;
@property (nonatomic, copy) NSString* drugDosageUnit;
@property (nonatomic) NSInteger drugUseDay;

@property (nonatomic, copy) NSString* drugsFrequencyName;
@property (nonatomic, copy) NSString* drugsFrequencyCode;
@property (nonatomic, copy) NSString* medicinePlanTempId;
@property (nonatomic, copy) NSString* orgGroupCode;
@property (nonatomic, copy) NSString* remark;
@property (nonatomic, copy) NSString* status;
@property (nonatomic) NSInteger tempDetId;

@end

