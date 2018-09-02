
//
//  IMNewsModel.m
//  HMDoctor
//
//  Created by jasonwang on 2016/10/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "IMNewsModel.h"
#import "NSString+URLEncod.h"

@implementation IMNewsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"newsTitle"  : @"title",
             @"newsDescription" : @"description",
             @"newsPicUrl" : @"picUrl",
             @"newsUrl" : @"url"
             };
}

- (void) conmfirmNewsType
{
    //健康课堂 "http://182.92.8.118:10009/jy/newc/jkkt/jkktDetail.htm?classId=163"
    //健康宣教 "http://182.92.8.118:10009/jy/jkxjDetail.htm?notesId=349"
    
    NSDictionary *dict= [self.newsUrl analysisParameter];
    NSURL* newsUrl = [NSURL URLWithString:self.newsUrl];
    if (!newsUrl) {
        return;
    }
    NSString* lastPathComponent = [newsUrl pathComponents].lastObject;
    if (lastPathComponent && [lastPathComponent isEqualToString:@"jkktDetail.htm"])
    {
        //健康课堂
        self.newsType = News_EdcuationClassroom;
        self.notesID = dict[@"classId"];
    }
    else if (lastPathComponent && [lastPathComponent isEqualToString:@"jkxjDetail.htm"]) {
        // 健康宣教
        self.newsType = News_Normal;
        self.notesID = dict[@"notesId"];
    }
    else if (lastPathComponent && [lastPathComponent isEqualToString:@"ggc_details.htm"]) {
        // 公告
        self.newsType = News_Notice;
        self.notesID = dict[@"ggId"];
    }
    
}
@end
