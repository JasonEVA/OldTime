//
//  NutritionDietRecord.h
//  HMClient
//
//  Created by lkl on 2017/8/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NutritionDietRecord : NSObject

@end

@interface NutritionDietFoodModel : NSObject

@property (nonatomic, assign) NSInteger calory;
@property (nonatomic, copy) NSString *favorId;
//@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *foodDesc;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger weight;

@end

@interface NutritionDietBeanModel : NSObject

@property (nonatomic, copy) NSString *allKcal;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *createTimeStr;
@property (nonatomic, copy) NSString *dietDesc;
@property (nonatomic, copy) NSString *dietRemark;
@property (nonatomic, copy) NSString *dietTime;
@property (nonatomic, assign) NSInteger foodId;
@property (nonatomic, copy) NSString *foodName;
@property (nonatomic, assign) NSInteger foodNum;
@property (nonatomic, copy) NSArray *foodPicUrls;
@property (nonatomic, assign) NSInteger foodUnit;
@property (nonatomic, copy) NSString *foodUnitStr;
@property (nonatomic, copy) NSString *userDietId;

@end
