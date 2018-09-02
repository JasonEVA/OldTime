//
//  MeGetUserInfoModel.h
//  Shape
//
//  Created by jasonwang on 15/10/23.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MeGetUserInfoModel : NSObject

@property (nonatomic, copy)  NSString  *headIcon;	//头像文件名	String
@property (nonatomic, copy)  NSString  *location;	//所在地	String
@property (nonatomic)  NSInteger  birthYear;	//出生_年	Int
@property (nonatomic)  NSInteger  birthMonth;	//出生_月	Int
@property (nonatomic)  NSInteger  height;	//身高	Int	单位：CM
@property (nonatomic)   CGFloat weight;	//体重	Double	单位：KG
@property (nonatomic, copy) NSString *headIconUrl;   //头像文件Url
@property (nonatomic, copy) NSString *userName;
@property (nonatomic) NSInteger gender;         //性别

@property (nonatomic, copy)  NSString  *sexString; // <##>
@end
