//
//  DrugUseTemplateDetailModel.h
//  HMDoctor
//
//  Created by jasonwang on 16/9/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrugUseTemplateDetailModel : NSObject
@property (nonatomic, retain) NSString* drugCompany;
@property (nonatomic, retain) NSString* drugsUsageName;

@property (nonatomic, retain) NSString* drugOneSpec;
@property (nonatomic, retain) NSString* drugOneSpecUnit;
@property (nonatomic, retain) NSString* drugSpe;
@property (nonatomic, retain) NSString* drugUnit;
@property (nonatomic, retain) NSString* allUnit;
@property (nonatomic, retain) NSString* drugName;
@property (nonatomic, retain) NSString* drugId;
@property (nonatomic, retain) NSString* medicationDays;
@property (nonatomic, retain) NSString* allDosage;
@property (nonatomic, retain) NSString* drugsFrequencyName;
@property (nonatomic, retain) NSString* drugsFrequencyCode;
@property (nonatomic, retain) NSString* drugsUsageCode;
@property (nonatomic, retain) NSString* singleDosage;
@property (nonatomic, retain) NSString* drugSpecifications;
@property (nonatomic) NSInteger drugUseDay;
@property (nonatomic, copy) NSString* allDosageUnit;
@property (nonatomic, copy) NSString* createTime;
@property (nonatomic) NSInteger creator;
@property (nonatomic) NSNumber *drugDosage;
@property (nonatomic, copy) NSString* drugDosageUnit;
@property (nonatomic, copy) NSString* drugOrg;
@property (nonatomic) NSInteger medicinePlanTempId;
@property (nonatomic, copy) NSString* orgGroupCode;
@property (nonatomic, copy) NSString* remark;
@property (nonatomic, copy) NSString* status;
@property (nonatomic) NSInteger tempDetId;
@end
