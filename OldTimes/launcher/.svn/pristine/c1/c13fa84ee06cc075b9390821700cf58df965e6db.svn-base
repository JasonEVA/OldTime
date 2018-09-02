//
//  ApplicationMessageSearchListViewController.h
//  launcher
//
//  Created by TabLiu on 15/10/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "BaseViewController.h"
#import "IMApplicationEnum.h"

@interface ApplicationMessageSearchListViewController : BaseViewController

/*  msgid  */
@property (nonatomic,assign) long long msgid;

//消息对应在数据库中的id
@property (nonatomic) long long sqlId;
@property (nonatomic,strong) NSString * uidStr;
//title
@property (nonatomic,strong) NSString * titleString;
/** 联系人姓名 */
@property (nonatomic, copy) NSString *strName;
@property (nonatomic,assign) long long   creatDate;

// 根据应用类型不同区分
- (instancetype)initWithAppType:(IM_Applicaion_Type)type;

@end
