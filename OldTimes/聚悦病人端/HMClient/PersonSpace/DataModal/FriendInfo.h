//
//  FriendInfo.h
//  HMClient
//
//  Created by yinqaun on 16/6/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface FriendInfo : NSObject
{
    
}

@property (nonatomic, retain) UserInfo* relationUserDet;

@property (nonatomic, retain) NSString* relativeFriendId;
@property (nonatomic, retain) NSString* relativeFriendName;
@property (nonatomic, retain) NSString* relativeName;

@property (nonatomic, readonly) NSString* mobile;
@property (nonatomic, readonly) NSInteger userId;

@end
