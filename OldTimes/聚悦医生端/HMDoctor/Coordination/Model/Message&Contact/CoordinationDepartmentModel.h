//
//  CoordinationDepartmentModel.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//  科室model

#import <Foundation/Foundation.h>

@interface CoordinationDepartmentModel : NSObject
/*
@property (nonatomic, <#strong#>)  <#class#>  depAddr;
@property (nonatomic, <#strong#>)  <#class#>  depCode;
@property (nonatomic, <#strong#>)  <#class#>  depIcon;
@property (nonatomic, <#strong#>)  <#class#>  depImage;
@property (nonatomic, <#strong#>)  <#class#>  depRemark;
@property (nonatomic, <#strong#>)  <#class#>  depTypeId;
@property (nonatomic, <#strong#>)  <#class#>  hasPeriod;
@property (nonatomic, <#strong#>)  <#class#>  isLeaf;
@property (nonatomic, <#strong#>)  <#class#>  isRecommend;
@property (nonatomic, <#strong#>)  <#class#>  listImage;
@property (nonatomic, <#strong#>)  <#class#>  nodeLevel;
@property (nonatomic, <#strong#>)  <#class#>  opTime;
@property (nonatomic, <#strong#>)  <#class#>  operator;
@property (nonatomic, <#strong#>)  <#class#>  operatorName;
@property (nonatomic, <#strong#>)  <#class#>  orgId;
@property (nonatomic, <#strong#>)  <#class#>  orgName;
@property (nonatomic, <#strong#>)  <#class#>  orgShortName;
@property (nonatomic, <#strong#>)  <#class#>  parentId;
@property (nonatomic, <#strong#>)  <#class#>  serialNo;
@property (nonatomic, <#strong#>)  <#class#>  sortRank;
@property (nonatomic, <#strong#>)  <#class#>  status;
*/
@property (nonatomic)  NSInteger  depId; // 科室ID
@property (nonatomic, strong)  NSString  *depName; // 科室名称

@end
