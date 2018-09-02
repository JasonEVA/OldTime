//
//  NSDictionary+ATBdEncrypt.m
//  Clock
//
//  Created by SimonMiao on 16/7/25.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "NSDictionary+ATBdEncrypt.h"

const double x_pi = M_PI * 3000.0 / 180.0;
@implementation NSDictionary (ATBdEncrypt)

+ (NSDictionary *)at_bd_encryptWithGg_lat:(double)gg_lat gg_lon:(double)gg_lon //bd_lat:(double)bd_lat bd_lon:(double)bd_lon
{
    double x = gg_lon, y = gg_lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    double bd_lon = z * cos(theta) + 0.0065;
    double bd_lat = z * sin(theta) + 0.006;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(bd_lon) forKey:@"lon"];
    [dict setValue:@(bd_lat) forKey:@"lat"];
    
    return dict;
}

+ (void)at_bd_decryptWithBd_lat:(double)bd_lat bd_lon:(double)bd_lon gg_lat:(double)gg_lat gg_lon:(double)gg_lon
{
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    gg_lon = z * cos(theta);
    gg_lat = z * sin(theta);
}

@end
