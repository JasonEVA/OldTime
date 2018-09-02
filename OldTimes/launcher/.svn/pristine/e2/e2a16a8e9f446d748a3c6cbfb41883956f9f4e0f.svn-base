//
//  ApplyGetReceiveListModel.h
//  launcher
//
//  Created by Dee on 15/9/6.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    applytype_in,
    applytype_out,
    applytype_cc,
}applytype;

@interface ApplyGetReceiveListModel : NSObject

@property(nonatomic, copy) NSString  *A_TITLE;             //标题
@property(nonatomic, copy) NSString  *SHOW_ID;             //审批id
@property (nonatomic, strong) NSString *T_SHOW_ID;         //审批类型id
@property (nonatomic, strong) NSString *T_NAME;            //审批类型
@property (nonatomic, strong) NSString *A_APPROVE;         //审批人，以通用分隔符分隔
@property(nonatomic, copy) NSString  *A_APPROVE_NAME;      //审批人姓名，以通用分隔符分隔
@property(nonatomic, copy) NSString* A_CC;                 //抄送人，以通用分隔符分隔
@property(nonatomic, copy) NSString* A_CC_NAME;            //抄送人姓名，以通用分隔符分隔
@property(nonatomic, copy) NSString* C;
@property(nonatomic, copy) NSString* A_APPROVE_PATH;       //审批人路径，以通用分隔符分隔，前后代表顺序
@property(nonatomic, copy) NSString* A_APPROVE_PATH_NAME;  //审批人姓名路径，以通用分隔符分隔，前后代表顺序
@property(nonatomic) NSInteger A_IS_URGENT;                //审批是否紧急，0=不紧急，1=紧急
@property(nonatomic, copy) NSString* A_BACKUP;             //备注
@property(nonatomic, copy) NSString* A_STATUS;             //审批状态，APPROVE=通过,WAITING=待审批,IN_PROGRESS=进行中,DENY=不通过,CALL_BACK=打回
@property(nonatomic) long long LAST_UPDATE_TIME;           //上次更新时间
@property(nonatomic) long long A_START_TIME;               //审批开始时间
@property(nonatomic) long long A_END_TIME;                 //审批结束时间
@property(nonatomic) long long A_DEADLINE;                 //审批期限
@property(nonatomic) double A_FEE;                         //审批金额
@property(nonatomic, copy) NSString* CREATE_USER;          //创建人
@property(nonatomic, copy) NSString* CREATE_USER_NAME;     //创建人姓名
@property(nonatomic) long long CREATE_TIME;                //创建时间
@property(nonatomic) NSInteger IS_PROCESS;                 //审批状态码，0=待处理，1=已处理
@property (nonatomic) NSInteger IS_TIMESLOT_ALL_DAY;        //时间段是否全天
@property (nonatomic) NSInteger IS_DEADLINE_ALL_DAY;        //审批期限是否全天
@property (nonatomic) BOOL IS_CAN_APPROVE;                  //是否可以审批，0=否，1=是（只有当审批记录处于待审批或者进行中状态，且你为审批人之一时为1)
@property (nonatomic) BOOL IS_CAN_MODIFY;                   //是否可以修改，0=否，1=是（只有当审批记录处于待审批或者被打回状态，且你为发起人时为1)
@property (nonatomic) BOOL IS_CAN_DELETE;                   //是否可以删除，0=否，1=是（只有当审批记录处于待审批状态且审批路径为空，且你为发起人时为1)
@property (nonatomic) BOOL IS_HAVEFILE;                     //是否有附件
@property (nonatomic) BOOL IS_HAVECOMMENT;                   //是否有评论

@property (nonatomic) BOOL HAS_COMMENT;                     //是否有评论

@property (nonatomic) BOOL Unreadmsg;                       //标记已读未读
@property (nonatomic) BOOL UnreadComment;                   //标记消息已读未读

@property (nonatomic, strong) NSString *T_WORKFLOW_ID;
@property (nonatomic, strong) NSString *A_FORM_DATA;
@property (nonatomic, strong) NSArray *A_APPROVE_TRIGGERS;

@property (nonatomic) BOOL isInSearchView;                  //是否用于搜索界面
@property(nonatomic, copy) NSString  *searchKey;            //检索的关键字
@property (nonatomic) BOOL ShowRightbtns;                   //是否显示左滑

@property (nonatomic)applytype apply_type;

- (instancetype)initWithDict:(NSDictionary *)dict;
- (NSString *)getFormattedCreatTime;
- (NSString *)getFormattedDeadLineTime;
@end
