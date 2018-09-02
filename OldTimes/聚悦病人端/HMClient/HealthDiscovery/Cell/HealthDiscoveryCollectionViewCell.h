//
//  HealthDiscoveryCollectionViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/4/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthDiscoveryGirdInfo : NSObject
{
    
}
@property (nonatomic, retain) NSString* girdName;
@property (nonatomic, retain) NSString* iconName;

@end

@interface HealthDiscoveryCollectionViewCell : UICollectionViewCell
{
    
}

- (void) setDiscoveryInfo:(HealthDiscoveryGirdInfo*) gird;

- (void) setNoOpenImage;
@end
