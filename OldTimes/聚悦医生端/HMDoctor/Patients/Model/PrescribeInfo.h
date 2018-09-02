//
//  PrescribeInfo.h
//  HMDoctor
//
//  Created by lkl on 16/6/18.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>


//处方列表
@interface PrescribeInfo : NSObject

@property (nonatomic, retain) NSString* createTime;

@property (nonatomic, retain) NSString* createDate4View;
@property (nonatomic, retain) NSString* staffDesc;
@property (nonatomic, retain) NSString* recipeCode;
@property (nonatomic, retain) NSString* userRecipeId;  //处方ID
@property (nonatomic, retain) NSString* userId;
@property (nonatomic, retain) NSString* status;

@end

//处方详情
@interface PrescribeDetailDrugsInfo : NSObject

@property (nonatomic, retain) NSString* drugCompany;
@property (nonatomic, retain) NSString* drugsUsageName;

@property (nonatomic, retain) NSString* drugOneSpec;
@property (nonatomic, retain) NSString* drugOneSpecUnit;
@property (nonatomic, retain) NSString* drugSpec;
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
@property (nonatomic, strong) NSString *remarks;
@end


@interface PrescribeDetailInfo : NSObject

@property (nonatomic, retain) NSString* createTime;

@property (nonatomic, retain) NSString* createDate4View;

@property (nonatomic, retain) NSString* recipeCode;
@property (nonatomic, retain) NSString* userRecipeId;  //处方ID
@property (nonatomic, retain) NSString* userId;
@property (nonatomic, retain) NSString* status;

@property (nonatomic, retain) NSArray* recipeDets;
@end

@interface PrescribeTempInfo : NSObject

@property (nonatomic, retain) NSString* drugBagSpec;
@property (nonatomic, retain) NSString* drugCompany;
@property (nonatomic, retain) NSString* drugsUsageName;

@property (nonatomic, retain) NSString* drugOneSpec;
@property (nonatomic, retain) NSString* drugOneSpecUnit;
@property (nonatomic, retain) NSString* drugSpec;
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
@property (nonatomic) NSInteger drugDosage;
@property (nonatomic, copy) NSString* drugDosageUnit;
@property (nonatomic, copy) NSString* drugOrg;
@property (nonatomic) NSInteger medicinePlanTempId;
@property (nonatomic, copy) NSString* orgGroupCode;
@property (nonatomic, copy) NSString* remark;
@property (nonatomic, copy) NSString* status;
@property (nonatomic) NSInteger tempDetId;
@property (nonatomic, strong) NSString *remarks;




@end
