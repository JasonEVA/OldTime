//
//  NewApplyDetailInfoModel.h
//  launcher
//
//  Created by 马晓波 on 16/3/31.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface NewApplyDetailInfoModel : NSObject
#pragma mark - common
@property (nonatomic, strong) NSString *A_TITLE;                   //标题
@property (nonatomic, strong) NSString *T_SHOW_ID;                 //审批类型id
@property (nonatomic, strong) NSString *T_WORKFLOW_ID;             //工作流id
@property (nonatomic, strong) NSString *A_APPROVE;                 //审批人id字符串以“●”隔开
@property (nonatomic, strong) NSString *A_APPROVE_NAME;            //审批人姓名字符串以“●”隔开
@property (nonatomic, strong) NSString *A_CC;                      //抄送人人id字符串以“●”隔开
@property (nonatomic, strong) NSString *A_CC_NAME;                 //抄送人姓名字符串以“●”隔开
@property (nonatomic, assign) BOOL A_IS_URGENT;                    //是否紧急

#pragma mark - create used for Create
@property (nonatomic, strong) NSMutableArray *Send_FORM_DATA;      //数据数组(新建／获取详情专用)
@property (nonatomic, strong) NSMutableArray *fileShowIds;         //附件数组

#pragma mark - detail user for get info
@property (nonatomic, strong) NSString *SHOW_ID;                   //审批showid
@property (nonatomic, strong) NSString *T_NAME;                    //审批类型名
@property (nonatomic, strong) NSString *A_APPROVE_PATH;            //审批流程中的人id字符串以“●”隔开
@property (nonatomic, strong) NSString *A_APPROVE_PATH_NAME;       //审批流程中的人姓名字符串以“●”隔开
@property (nonatomic, assign) BOOL HAS_FILE;                       //是否有文件
@property (nonatomic, assign) BOOL HAS_COMMENT;                    //是否有评论
@property (nonatomic, strong) NSString *A_STATUS;                  //审批状态
@property (nonatomic, assign) long long LAST_UPDATE_TIME;          //上次更新时间时间戳
@property (nonatomic, strong) NSString *CREATE_USER;               //创建人id
@property (nonatomic, strong) NSString *CREATE_USER_NAME;          //创建人姓名
@property (nonatomic, strong) NSString *CREATE_TIME;               //创建时间
@property (nonatomic, strong) NSMutableArray *A_APPROVE_TRIGGERS;  //可数组
@property (nonatomic, strong) NSString *Get_FORM_DATA;             //数据json字符串(获取列表专用)
@property (nonatomic, strong) NSString *A_FORM_INSTANCE_ID;        //审批表单id
@end
