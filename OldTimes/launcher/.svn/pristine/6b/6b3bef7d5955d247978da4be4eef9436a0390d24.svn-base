//
//  BaiDuMapSearchDAL.m
//  launcher
//
//  Created by jasonwang on 15/12/31.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "BaiDuMapSearchDAL.h"

@interface BaiDuMapSearchDAL()<BMKSuggestionSearchDelegate>

@end

@implementation BaiDuMapSearchDAL

- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化检索对象
        self.searcher =[[BMKSuggestionSearch alloc]init];
        self.searcher.delegate = self;
        self.option = [[BMKSuggestionSearchOption alloc] init];
        //option.cityname = @"北京";
        
        //[option release];
        
    }
    return self;
}
//查询数据
- (void)searchWithKeyword:(NSString *)keyword
{
    self.option.keyword  = keyword;
    BOOL flag = [self.searcher suggestionSearch:self.option];
}

- (void)onGetSuggestionResult:(BMKSuggestionSearch *)searcher result:(BMKSuggestionResult *)result errorCode:(BMKSearchErrorCode)error
{
    if ([self.delegate respondsToSelector:@selector(BaiDuMapSearchDALDelegateCallback_result:errorCode:)]) {
        [self.delegate BaiDuMapSearchDALDelegateCallback_result:result errorCode:error];
    }
}
 //不使用时将delegate设置为 nil 
- (void)killSearch
{
    self.searcher.delegate = nil;
}
@end
