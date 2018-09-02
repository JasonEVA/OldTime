//
//  PersonDevicesInfo.m
//  HMClient
//
//  Created by lkl on 2017/4/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "PersonDevicesInfo.h"

@implementation PersonDevicesInfo

+ (NSArray *)getDevicesInfo
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
                       
                       //绑定手环
                       @{
                           @"type":@"SH",
                           @"typeName":@"手环:",
                           @"defaultName":@"绑定手环",
                           @"defaultIcon":@"health_icon_bracelet",
                           @"devices":@[
                                   @{
                                       @"deviceName":@"埃微手环",
                                       @"deviceIcon":@"icon_bracelet",
                                       @"deviceNickName":@"埃微手环",
                                       @"deviceCode":@"SH_AW",
                                       },
                                   ],
                           },
                       
                       ];
    return array;
}

@end
