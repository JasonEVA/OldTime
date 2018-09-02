//
//  ApplicationAppInfoModel.h
//  launcher
//
//  Created by 马晓波 on 16/3/24.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

@interface ApplicationAppInfoModel : NSObject
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSMutableArray *Fields;
@property (nonatomic, strong) NSString *SHOW_ID;
@property (nonatomic, strong) NSString *APP_CODE;
@property (nonatomic, strong) NSString *APP_NAME;
@property (nonatomic, assign) NSInteger APP_STATUS;
@property (nonatomic, strong) NSString *APP_DES;
@property (nonatomic, strong) NSString *APP_ICON_WEB;
@property (nonatomic, strong) NSString *APP_ICON_MOBILE;
@property (nonatomic, strong) NSString *CREATE_USER;
@property (nonatomic, strong) NSString *CREATE_USER_NAME;
@property (nonatomic, strong) NSString *CREATE_TIME;
@end
