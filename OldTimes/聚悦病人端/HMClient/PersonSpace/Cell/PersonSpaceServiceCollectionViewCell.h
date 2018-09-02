//
//  PersonSpaceServiceCollectionViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserServiceInfo.h"

@interface PersonSpaceServiceCollectionViewCell : UICollectionViewCell
{
    
}

//- (void) setuserService:(UserServiceInfo*) userService;
- (void) createUserServiceDets:(NSDictionary*) dicService;

@end

@interface PersonSpaceNoneServiceCollectionViewCell : UICollectionViewCell

@end

//只有增值服务
@interface PersonSpaceAddedServiceCollectionViewCell : UICollectionViewCell

- (void) createUserServiceDets:(NSDictionary*) dicService;

@end
