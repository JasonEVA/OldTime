//
//  UserRecipeRecord.h
//  HMClient
//
//  Created by yinqaun on 16/6/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRecipeDrugUsage: NSObject

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, retain) NSString* frequencyType;
@property (nonatomic, retain) NSString* usePeriod;
@property (nonatomic, retain) NSString* userDrugsId;
@end

@interface UserRecipeRecord : NSObject

@property (nonatomic, retain) NSString* drugName;
@property (nonatomic, retain) NSString* drugCompany;
@property (nonatomic, retain) NSString* drugUnit;
@property (nonatomic, retain) NSString* recipeDetId;
@property (nonatomic, assign) float drugOneSpec;        //单片剂量
@property (nonatomic, retain) NSString* drugOneSpecUnit;

@property (nonatomic, retain) NSString* userRecipeId;
@property (nonatomic, assign) float singleDosage;       //单次计量
@property (nonatomic, retain) NSString* drugsUsageCode;
@property (nonatomic, retain) NSString* drugsUsageName;
@property (nonatomic, retain) NSString* drugsFrequencyName;
@property (nonatomic, retain) NSString* remarks;
@property (nonatomic, retain) NSArray* useDrugList;
@property (nonatomic, retain) NSString* drugSpecifications; //

- (NSString*) drugSpecString;
@end
