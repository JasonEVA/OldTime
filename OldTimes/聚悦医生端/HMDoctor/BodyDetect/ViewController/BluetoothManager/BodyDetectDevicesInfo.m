//
//  BodyDetectDevicesInfo.m
//  HMDoctor
//
//  Created by lkl on 2017/8/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "BodyDetectDevicesInfo.h"

@implementation DeviceDetectRecord

@end


@implementation BodyDetectDevicesInfo

+ (NSArray *)getDevicesInfo
{
    NSArray *array = @[
                        @{
                           @"kpiCode":@"XY",
                           @"kpiName":@"测血压",
                           @"deviceImg":@"health_icon_01_1",
                           },
                        
                        @{
                            @"kpiCode":@"XD",
                            @"kpiName":@"测心电",
                            @"deviceImg":@"health_icon_electrocardiogram_1",
                            },
                        
                        @{
                            @"kpiCode":@"XL",
                            @"kpiName":@"测心率",
                            @"deviceImg":@"health_icon_02_1",
                            },
                        
                        @{
                            @"kpiCode":@"OXY",
                            @"kpiName":@"测血氧",
                            @"deviceImg":@"health_icon_04_1",
                            },
                        
                        @{
                            @"kpiCode":@"XT",
                            @"kpiName":@"测血糖",
                            @"deviceImg":@"health_icon_09_1",
                            },
                       ];
    
    
    
    return array;
}

+ (NSArray *)getDevicesDetailInfo
{
    NSArray *array = @[
                       
                       //血压计
                       @{
                           @"type":@"XY",
                           @"typeName":@"血压计:",
                           @"defaultName":@"添加血压计",
                           @"defaultIcon":@"icon_xueyaji",
                           @"devices":@[
                                   @{
                                       @"deviceName":@"鱼跃(YE680A)",
                                       @"deviceIcon":@"img_xuyaji_yuyao",
                                       @"deviceNickName":@"Yuwell",
                                       @"deviceCode":@"XYJ_YY",
                                       },
                                   
                                   @{
                                       @"deviceName":@"优瑞恩(U80LH-BT-CN002)",
                                       @"deviceIcon":@"img_xuyaji_youruien",
                                       @"deviceNickName":@"U80LH",
                                       @"deviceCode":@"XYJ_YRN",
                                       },
                                   
                                   @{
                                       @"deviceName":@"脉搏波血压计",
                                       @"deviceIcon":@"icon_xueya_maibobo",
                                       @"deviceNickName":@"maibobo",
                                       @"deviceCode":@"XYJ_MBB",
                                       },
                                   
                                   ],
                           },
                       
                       //血糖仪
                       @{
                           @"type":@"XT",
                           @"typeName":@"血糖仪:",
                           @"defaultName":@"添加血糖仪",
                           @"defaultIcon":@"icon_xuetangyi",
                           @"devices":@[
                                   @{
                                       @"deviceName":@"百捷(PD-G001-1)",
                                       @"deviceIcon":@"img_baijie",
                                       @"deviceNickName":@"BeneCheck",
                                       @"deviceCode":@"XTY_BJ",
                                       },
                                   
                                   @{
                                       @"deviceName":@"强生(倍易型)",
                                       @"deviceIcon":@"img_qiangsheng",
                                       @"deviceNickName":@"OnetouchUItraEasy",
                                       @"deviceCode":@"XTY_QS",
                                       },
                                   @{
                                       @"deviceName":@"鱼跃血糖仪",
                                       @"deviceIcon":@"img_xuetang_yuwell",
                                       @"deviceNickName":@"Yuwell",
                                       @"deviceCode":@"XTY_YY",
                                       }
                                   
                                   ],
                           },
                       
                       //心电仪
                       @{
                           @"type":@"XD",
                           @"typeName":@"心电仪:",
                           @"defaultName":@"添加心电仪",
                           @"defaultIcon":@"icon_xidianyi",
                           @"devices":@[
                                   @{
                                       @"deviceName":@"Hellofit(HC-201B)",
                                       @"deviceIcon":@"pic_06",
                                       @"deviceNickName":@"Hellofit",
                                       @"deviceCode":@"XDY_HLF",
                                       },
                                   @{
                                       @"deviceName":@"好朋友",
                                       @"deviceIcon":@"pic_07",
                                       @"deviceNickName":@"GoodFriend",
                                       @"deviceCode":@"XDY_HPY",
                                       },
                                   
                                   ],
                           },
                       
                       //血氧仪
                       @{
                           @"type":@"OXY",
                           @"defaultName":@"血氧仪:贝瑞(BM1000C)",
                           @"defaultIcon":@"icon_xueyangyi",
                           @"devices":@"",
                           },
                       
                       //血脂计
                       @{
                           @"type":@"XZ",
                           @"defaultName":@"血脂计:Hellofit(HC-201B)",
                           @"defaultIcon":@"icon_xuezhiyi",
                           @"devices":@"",
                           },
                       
                       //体脂秤
                       @{
                           @"type":@"TZ",
                           @"defaultName":@"体脂秤:Holtek",
                           @"defaultIcon":@"health_icon_weight",
                           @"devices":@"",
                           },
                       
                       //耳温枪
                       @{
                           @"type":@"TW",
                           @"defaultName":@"耳温枪:飞思瑞克",
                           @"defaultIcon":@"health_icon_temperature2",
                           @"devices":@"",
                           },
                       ];
    return array;
}

@end
