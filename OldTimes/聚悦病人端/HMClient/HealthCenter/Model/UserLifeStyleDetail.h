//
//  UserLifeStyleDetail.h
//  HMClient
//
//  Created by yinqaun on 16/6/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLifeStyleTarget : NSObject
{
    
}
@property (nonatomic, retain) NSString* planId;
@property (nonatomic, retain) NSString* suggest;
@property (nonatomic, retain) NSString* target;
@end

@interface UserLifeStyleDetail : NSObject

@property (nonatomic, retain) UserLifeStyleTarget* target;
@property (nonatomic, retain) NSArray* notes;
@end
