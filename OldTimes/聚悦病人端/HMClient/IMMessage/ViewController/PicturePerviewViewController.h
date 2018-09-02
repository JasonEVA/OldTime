//
//  PicturePerviewViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/26.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMBasePageViewController.h"

@interface PicturePerviewViewController : UIViewController
{
    
}

@property (nonatomic, assign) CGRect thumbframe;

- (id) initWithThumbPath:(NSString*) thumbPath
               ImagePath:(NSString*) imagePath;


@end
