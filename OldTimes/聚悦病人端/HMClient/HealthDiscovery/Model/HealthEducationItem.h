//
//  HealthEducationItem.h
//  HMClient
//
//  Created by lkl on 16/6/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthNotesItem : NSObject

@property (nonatomic, assign) NSInteger notesId;
@property (nonatomic, strong) NSString* publishDate;
@property (nonatomic, copy) NSString* notesTitle;
@property (nonatomic, copy) NSString* notesPic;
@property (nonatomic, copy) NSString* notesSrc;
@property (nonatomic, copy) NSString* viewCount;
@property (nonatomic, copy) NSString* image;
@property (nonatomic, copy) NSString* notesSummary;
@end

@interface HealthEducationItem : NSObject

@property (nonatomic, assign) NSInteger classId;
@property (nonatomic, assign) NSInteger notesId;
@property (nonatomic, retain) NSString* classPic;
//@property (nonatomic, retain) NSString* isFine;
@property (nonatomic, assign) NSInteger contentType;  //1普通课堂 2精品课堂
@property (nonatomic, retain) NSString* topFlag;
@property (nonatomic, retain) NSString* paper;
@property (nonatomic, retain) NSString* publishDate;
@property (nonatomic, retain) NSString* title;
@property (nonatomic) NSInteger readTotal;        // 阅读量

@property (nonatomic, readonly) BOOL isFineClass;    //是否是精品
@property (nonatomic, readonly) BOOL isRecommand;
@end

@interface HealthEducationPathHelper : NSObject

+ (NSString*) healthEducationColumeCachePath;
@end

