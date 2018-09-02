//
//  AppointmentInfo.m
//  HMClient
//
//  Created by yinqaun on 16/5/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AppointmentInfo.h"

@implementation AppointmentInfo

- (NSString*) statusString
{
    NSString* statusString = nil;
    switch (_status) {
        case 1:
        {
            statusString = @"申请中";
        }
            break;
        case 2:
        {
            statusString = @"待就诊";
        }
            break;
        case 3:
        {
            statusString = @"约诊失败";
        }
            break;
        case 4:
        {
            statusString = @"已就诊";
        }
            break;
        case 5:
        {
            statusString = @"已爽约";
        }
            break;
        case 6:
        {
            statusString = @"已取消";
        }
            break;
        case 7:
        {
            statusString = @"已拒绝";
        }
            break;
        default:
            break;
    }
    return statusString;
}

- (NSString*) staffExpendString
{
    NSString* expendString = nil;
    
    if (self.orgShortName && 0 < self.orgShortName.length)
    {
        expendString = self.orgShortName;
    }
    
    if (self.depName && 0 < self.depName.length)
    {
        if (!expendString)
        {
            expendString = self.depName;
        }
        else
        {
            expendString = [expendString stringByAppendingFormat:@"/%@", self.depName];
        }
    }
    
    if (self.staffTypeName && 0 < self.staffTypeName.length)
    {
        if (!expendString)
        {
            expendString = self.staffTypeName;
        }
        else
        {
            expendString = [expendString stringByAppendingFormat:@"/%@", self.staffTypeName];
        }
    }
    
    if (expendString && 0 < expendString.length)
    {
        expendString = [NSString stringWithFormat:@"(%@)", expendString];
    }
    return expendString;
}
@end

@implementation AppointmentDetail



@end
