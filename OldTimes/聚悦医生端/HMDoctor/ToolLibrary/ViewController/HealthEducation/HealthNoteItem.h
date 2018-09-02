//
//  HealthNoteItem.h
//  HMClient
//
//  Created by lkl on 16/6/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthNoteItem : NSObject

@property (nonatomic, assign) NSInteger notesId;
@property (nonatomic, strong) NSString* publishDate;
@property (nonatomic, copy) NSString* notesTitle;
@property (nonatomic, copy) NSString* notesPic;
@property (nonatomic, copy) NSString* notesSrc;
@property (nonatomic, copy) NSString* viewCount;
@property (nonatomic, copy) NSString* image;
@property (nonatomic, copy) NSString* notesSummary;
@end
