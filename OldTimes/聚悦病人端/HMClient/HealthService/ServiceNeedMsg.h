//
//  ServiceNeedMsg.h
//  HMClient
//
//  Created by yinqaun on 16/5/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceNeedMsg : NSObject
{
    
}

@property (nonatomic, assign) NSInteger msgItemId;
@property (nonatomic, retain) NSString* msgItemCode; //信息项编码
@property (nonatomic, retain) NSString* msgItemColumn; //信息项对应的字段
@property (nonatomic, retain) NSString*  msgItemName;  //信息项名称
@property (nonatomic, assign) NSInteger msgItemDataType; //信息项内容的数据类型(1.INTEGER2.NUMBER3.Date4.VARCHAR)
@property (nonatomic, assign) NSInteger isRequired;  //是否必填项（0不是必填 1必填）
@property (nonatomic, retain) NSString*  unitCode;  //计量单位id
@property (nonatomic, retain) NSString*  unitName;  //计量单位名称
@property (nonatomic, assign) NSInteger upDetId;   //上架明细id
@property (nonatomic, assign) NSInteger msgItemFont;  //信息项的格式(1文本2时间)
@property (nonatomic, retain) NSString* msgValue;


@end
