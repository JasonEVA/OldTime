//
//  AddressBookInfo.h
//  HMDoctor
//
//  Created by lkl on 16/6/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressBookInfo : NSObject

@property (nonatomic, copy) NSString *staffName;
@property (nonatomic, copy) NSString *depName;
@property (nonatomic, copy) NSString *homeTel;

@end


@interface AddressBookDepNameInfo : NSObject

//@property (nonatomic, copy) NSString *depCode;
@property (nonatomic, copy) NSString *depName;
@property (nonatomic, copy) NSString *depId;

@end