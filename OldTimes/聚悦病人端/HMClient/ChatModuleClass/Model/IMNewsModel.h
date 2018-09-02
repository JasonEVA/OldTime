//
//  IMNewsModel.h
//  HMDoctor
//
//  Created by jasonwang on 2016/10/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//  IM图文消息model

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NewsType) {
    News_Normal,
    News_EdcuationClassroom,    //健康课堂
    News_Notice,                 //公告

};

@interface IMNewsModel : NSObject
@property (nonatomic, copy) NSString *newsTitle;           //图文标题
@property (nonatomic, copy) NSString *newsDescription;     //正文摘要
@property (nonatomic, copy) NSString *newsUrl;             //对应详情H5地址
@property (nonatomic, copy) NSString *newsPicUrl;          //图片地址
@property (nonatomic, copy) NSString *notesID;             //宣教ID

@property (nonatomic, assign) NewsType newsType;

- (void) conmfirmNewsType;
@end
