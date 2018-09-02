//
//  HealthEducationItem.h
//  HMDoctor
//
//  Created by yinquan on 17/1/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@property (nonatomic, readonly) BOOL isFineClass;    //是否是精品
@property (nonatomic, readonly) BOOL isRecommand;
@property (nonatomic) BOOL isHideShareBtn;    // 是否隐藏分享按钮
@end

@interface HealthyEducationColumeModel : NSObject

@property (nonatomic, assign) NSInteger classProgramTypeId;
@property (nonatomic, retain) NSString* typeName;

@end
