//
//  CoordinationSearchResultAdapter.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ATTableViewAdapter.h"

@interface CoordinationSearchResultAdapter : ATTableViewAdapter
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, copy) NSMutableArray *contactList; //搜索出来的联系人
@property (nonatomic, copy) NSMutableArray *chatList;    //搜索出来的聊天记录
@property (nonatomic, copy)  NSArray  *headerTitles; // <##>
@end
