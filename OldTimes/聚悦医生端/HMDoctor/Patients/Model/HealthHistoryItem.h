//
//  HealthHistoryItem.h
//  HMClient
//
//  Created by yinqaun on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthHistoryItem : NSObject
{
    
}

@property (nonatomic, retain) NSString* deptName;
@property (nonatomic, retain) NSString* visitOrgTitle;
@property (nonatomic, retain) NSString* docuNote;
@property (nonatomic, retain) NSString* visitTime;
@property (nonatomic, retain) NSString* visitType;

@property (nonatomic, retain) NSString* docuType;
@property (nonatomic, retain) NSString* docuRegID;
@property (nonatomic, retain) NSString* storageID;

@property (nonatomic, copy) NSString *StoragePath;  //PDF路径

- (NSString*) yearStr;
- (NSString*) dateStr;

@end

