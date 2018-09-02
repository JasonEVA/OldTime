//
//  MainStartWithoutServiceOperationCollectionViewController.h
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainStartOperationInfo : NSObject
{
    
}
@property (nonatomic, assign) NSInteger operateId;
@property (nonatomic, retain) NSString* operationName;
@property (nonatomic, retain) NSString* operationAlert;
@property (nonatomic, retain) NSString* imageUrl;

@end

@interface MainStartWithoutServiceOperationCollectionViewController : UICollectionViewController
{
    
}

@property (nonatomic, assign) CGFloat viewHeight;
@end
