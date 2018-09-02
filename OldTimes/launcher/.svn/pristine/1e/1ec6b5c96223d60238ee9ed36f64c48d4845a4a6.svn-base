//
//  BaiDuMapSearchDAL.h
//  launcher
//
//  Created by jasonwang on 15/12/31.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  百度搜索地址

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Search/BMKSuggestionSearch.h>

@protocol BaiDuMapSearchDALDelegate <NSObject>

- (void)BaiDuMapSearchDALDelegateCallback_result:(BMKSuggestionResult *)result errorCode:(BMKSearchErrorCode)error;

@end

@interface BaiDuMapSearchDAL : NSObject

@property (nonatomic, strong) BMKSuggestionSearch *searcher;
@property (nonatomic, strong) BMKSuggestionSearchOption *option;
@property (nonatomic, weak) id <BaiDuMapSearchDALDelegate> delegate;
//不使用时将delegate设置为 nil
- (void)killSearch;
//查询数据
- (void)searchWithKeyword:(NSString *)keyword;
@end
