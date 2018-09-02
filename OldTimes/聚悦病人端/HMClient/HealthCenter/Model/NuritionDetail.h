//
//  NuritionDetail.h
//  HMClient
//
//  Created by yinqaun on 16/6/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NuritionInfo : NSObject
{
    
}
@property (nonatomic, retain) NSString* planId;
@property (nonatomic, retain) NSString* suggest;
@property (nonatomic, retain) NSString* target;
@end

@interface NuritionDietInfo : NSObject
{
    
}

@property (nonatomic, retain) NSString* foodName;
@property (nonatomic, retain) NSArray* foodPicUrls;
@property (nonatomic, assign) NSInteger foodNum;
@property (nonatomic, retain) NSString* foodUnitStr;
@property (nonatomic, assign) NSInteger foodId;
@property (nonatomic, assign) NSInteger foodKcal;
@property (nonatomic, assign) NSInteger allKcal;
@property (nonatomic, assign) NSInteger userDietId;

@end

@interface NuritionDetail : NSObject
{
    
}

@property (nonatomic, retain) NuritionInfo* nutrition;
@property (nonatomic, retain) NSArray* userDiets;
@property (nonatomic, retain) NSArray* notes;
@end

@interface NuritionDietGroup : NSObject
{
    
}

@property (nonatomic, retain) NSString* dietName;
@property (nonatomic, retain) NSArray* userDiets;
@end

@interface NuritionDietAppendParam : NSObject
{
    
}

@property (nonatomic, assign) NSInteger dietType;
@property (nonatomic, retain) NSString* date;

@end
