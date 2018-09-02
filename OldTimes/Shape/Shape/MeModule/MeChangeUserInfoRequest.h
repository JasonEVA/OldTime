//
//  MeChangeUserInfoRequest.h
//  Shape
//
//  Created by jasonwang on 15/10/23.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "BaseRequest.h"
#import "MeGetUserInfoModel.h"

@interface MeChangeUserInfoRequest : BaseRequest

@property (nonatomic, strong) MeGetUserInfoModel *model;
//@property (nonatomic, copy)  NSString  *location;	//所在地	String
//@property (nonatomic)  NSInteger  birthYear;	//出生_年	Int
//@property (nonatomic)  NSInteger  birthMonth;	//出生_月	Int
//@property (nonatomic)  NSInteger  height;	//身高	Int	单位：CM
//@property (nonatomic)   double weight;	//体重	Double	单位：KG
//@property (nonatomic) NSInteger sex;  //1 (man):男 0 (woman):女

@end

@interface MeChangeUserInfoResponse : BaseResponse

@end