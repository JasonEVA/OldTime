//
//  CoordinationSearchResultViewController.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//  工作组搜索界面

#import "HMBaseViewController.h"

typedef NS_ENUM(NSUInteger, searchType) {
    
    searchType_searchAll,   //聊天和联系人都搜（工作组）
    
    searchType_onlySearchChat,  //只搜工作组聊天记录
    
    searchType_onlySearchContact, //只搜工作组联系人
    
    searchType_onlySearchPatientChat, //只搜病患聊天记录
    searchType_searchPatientChatAndPatients, // 搜索病患聊天记录和患者
    searchType_searchPatients               // 搜索病人
};
@interface CoordinationSearchResultViewController : HMBaseViewController
@property (nonatomic) searchType searchType;
@end

@interface moreModel : NSObject
@property (nonatomic, copy) NSString *contentStr;
@end
