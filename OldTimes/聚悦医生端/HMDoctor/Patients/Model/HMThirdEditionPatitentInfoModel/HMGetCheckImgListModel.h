//
//  HMGetCheckImgListModel.h
//  HMDoctor
//
//  Created by lkl on 2017/3/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMImgListModel : NSObject

@property (nonatomic, copy) NSString *samllImg;
@property (nonatomic, copy) NSString *bigImg;

@end

@interface HMGetCheckImgListModel : NSObject

@property (nonatomic, copy) NSString *checkId;
@property (nonatomic, copy) NSArray *imgList;      //图片
@property (nonatomic, copy) NSString *indicesName;
@property (nonatomic, copy) NSString *checkTime;
@property (nonatomic, copy) NSString *orgName;

@end


//辅助检查项目类型列表
@interface CheckItemTypeModel : NSObject

@property (nonatomic, copy) NSString *itemTypeCode;
@property (nonatomic, copy) NSString *itemTypeName;

@end

//辅助检查详情

@interface CheckItemIndexDetailModel : NSObject

@property (nonatomic, copy) NSString *flag;
@property (nonatomic, copy) NSString *indexRfrDlgIndex;
@property (nonatomic, copy) NSString *applyDepName;
@property (nonatomic, copy) NSString *inspectionCode;
@property (nonatomic, copy) NSString *referenceValue;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *unit;

@end

@interface CheckIteminsepecJsonDetailModel : NSObject

@property (nonatomic, copy) NSString *appOrgId;
@property (nonatomic, copy) NSString *appOrgName;
@property (nonatomic, copy) NSString *illRemark;
@property (nonatomic, copy) NSArray *checkIndexList;  //表格
@property (nonatomic, copy) NSString *checkTime;
@property (nonatomic, copy) NSString *examine;
@property (nonatomic, copy) NSString *isAbnormal;
@property (nonatomic, copy) NSString *results;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *depName;

@end

@interface CheckItemDetailModel : NSObject

@property (nonatomic, copy) NSString *checkId;
@property (nonatomic, copy) NSString *checkTime;
@property (nonatomic, copy) NSString *fillType;     //1 图片   2 电子表格
@property (nonatomic, copy) NSArray *imgList;       //图片

@property (nonatomic, copy) NSString *indicesName;
@property (nonatomic, copy) NSString *indicesType;  //2表格类型，1和3项目显示
@property (nonatomic, strong) NSDictionary *insepecCheckJsonObject;
@property (nonatomic, copy) NSString *orgAllName;
@property (nonatomic, copy) NSString *orgName;


@end



