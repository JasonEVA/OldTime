//
//  ATAESConfig.h
//  Clock
//
//  Created by SimonMiao on 16/7/19.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#ifndef ATAESConfig_h
#define ATAESConfig_h


/* ——————————————————————————AES256加解密———————————————————————————————————————-—— */
#pragma mark -- AES256
#define PASSWORD_IV  @"roshan2015client"      // 客户端密钥
#define PASSWORD_OV  @"roshan2015server"      // 服务端密钥
#define PASSWORD_USR @"roshan-2015-user"      // 用户名、密码等参数的密钥

static Byte saltBuff[] = {0,1,2,3,4,5,6,7,8,9,0xA,0xB,0xC,0xD,0xE,0xF};                                                     // (暂时未用到)
static Byte ivBuff[] = {0x38, 0x31, 0x37, 0x34, 0x36, 0x33, 0x35, 0x33, 0x32, 0x31, 0x34, 0x38, 0x37, 0x36, 0x35, 0x32};    // 客户端AuthToken加密向量
static Byte ovBuff[] = {0xC, 1, 0xB, 3, 0x5B, 0xD, 5, 4, 0xF, 7, 9, 0x17, 1, 0xA, 6, 8};                                    // 客户端解密向量
static Byte userBuff[] = {5, 4, 0xF, 7, 9, 0xC, 1, 0xB, 3, 0x5B, 0xD, 0x17, 1, 0xA, 6, 8};                                  // 客户端用户名密码加密向量

#endif /* ATAESConfig_h */
