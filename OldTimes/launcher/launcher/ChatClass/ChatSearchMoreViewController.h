//
//  ChatSearchMoreViewController.h
//  launcher
//
//  Created by Lars Chen on 16/1/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  搜索更多 (更多联系人等)

#import "BaseViewController.h"
#import "SelectContactTabbarView.h"

typedef enum : NSUInteger {
    searchResultType_contact = 0,       // 搜索联系人
    searchResultType_chatHistory,
    SearchResultType_department,       //搜索部门
} SearchResultType;

@interface ChatSearchMoreViewController : BaseViewController

- (instancetype)initWithSearchType:(SearchResultType)type SearchText:(NSString *)searchText;
@property (nonatomic) BOOL isShowPersonalInformation;  //是否显示个人信息。或者为会话
@property (nonatomic, strong) SelectContactTabbarView *tabbar;
@property (nonatomic) BOOL selfSelectable;
@property (nonatomic) BOOL singleSelectable;
@end
