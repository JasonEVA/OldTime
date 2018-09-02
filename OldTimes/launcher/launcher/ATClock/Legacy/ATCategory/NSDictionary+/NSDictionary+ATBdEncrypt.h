//
//  NSDictionary+ATBdEncrypt.h
//  Clock
//
//  Created by SimonMiao on 16/7/25.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ATBdEncrypt)

+ (NSDictionary *)at_bd_encryptWithGg_lat:(double)gg_lat gg_lon:(double)gg_lon;

+ (void)at_bd_decryptWithBd_lat:(double)bd_lat bd_lon:(double)bd_lon gg_lat:(double)gg_lat gg_lon:(double)gg_lon;

@end
