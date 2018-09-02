//
//  SettingModel.h
//  launcher
//
//  Created by William Zhang on 15/7/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SettingModel : NSManagedObject

@property (nonatomic, copy) NSString * graphicPassword;
@property (nonatomic, retain) NSString * headPicture;
@property (nonatomic, retain) NSString * loginName;
@property (nonatomic, retain) NSNumber * isLogin;

@end
