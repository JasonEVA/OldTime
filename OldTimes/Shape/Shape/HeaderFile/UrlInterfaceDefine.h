//
//  UrlInterfaceDefine.h
//  Shape
//
//  Created by Andrew Shen on 15/10/14.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#ifndef UrlInterfaceDefine_h
#define UrlInterfaceDefine_h

//#define INTERLINE  // 内外网切换

#ifdef INTERLINE
/********************内网************************/
static NSString *const kURLAddress = @"http://192.168.4.144:3000"; // 内网接口

#else
/********************外网************************/
static NSString *const kURLAddress =@"http://121.42.165.52:1003"; // 外网接口

#endif
#define VAR_DATA            @"data"


// 错误码
#define ERROR1300		@"请重试，仅提示"
#define ERROR1301		@"操作失败"
#define ERROR1302		@"内部网络错误"
#define ERROR1303		@"用户不可用"
#define ERROR1304		@"用户名或密码错误"
#define ERROR1305		@"用户已存在"
#define ERROR1306		@"手机已存在"
#define ERROR1307		@"微信账号已存在"
#define ERROR1308		@"邀请码不存在"
#define ERROR1309		@"微信openid不存在"
#define ERROR1310		@"自定义页面超出上限"
#define ERROR1311		@"错误的文件格式"
#define ERROR1312		@"文件已存在"
#define ERROR1313		@"图片超出上限"
#define ERROR1314		@"含有非法字符"
#define ERROR1315		@"库存不足"
#define ERROR1316		@"邮箱已存在"
#define ERROR1317		@"错误的邮箱格式"
#define ERROR1318		@"邮箱已激活"
#define ERROR1319		@"验证码超时"
#define ERROR1320		@"链接失效"
#define ERROR1321		@"密码错误"
#define ERROR1322		@"验证码错误"
#define ERROR1323		@"token失效"
#define ERROR1324		@"用户不存在"
#define ERROR1325		@"商品编码重复"
#define ERROR1326		@"商品条码重复"
#define ERROR1327		@"商品分类不存在或该分类下不能有商品"
#define ERROR1328		@"批处理未完全成功"
#define ERROR1329		@"供应商被停用"
#define ERROR1330		@"商品库存不足"
#define ERROR1331		@"低于最少起送量"
#define ERROR1332		@"商品被停用"
#define ERROR1333		@"添加订单时商品不存在"
#define ERROR1334		@"商品价格超过正常浮动范围"
#define ERROR1335		@"供应商已有该商品，不能重复添加"
#define ERROR1336		@"订单支付失败"
#define ERROR1337		@"订单支付异常"
#define ERROR1338		@"商品不在购物车中"
#define ERROR1339		@"没有权限"
#define ERROR1400		@"超时，跳转到登陆页面"
#define ERROR1401		@"登陆超时"
#define ERROR1500		@"错误，跳转到首页"
#define ERROR1501		@"商品不存在"
#define ERROROTHER		@"ErrorOther"


#define VAR_DATA            @"data"
#define VAR_CODETOKEN       @"verificationToken"
#endif /* UrlInterfaceDefine_h */
