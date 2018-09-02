//
//  ImageCutViewController.h
//  PictureDemo
//
//  Created by yinqaun on 16/4/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageCutViewDelegate;

@interface ImageCutViewController : UIViewController
{
    
}

- (id) initWithImage:(UIImage*) image;

@property (nonatomic, retain) UIImage* image;
@property (nonatomic, assign) NSInteger scaleInPex;
@property (nonatomic, weak) id<ImageCutViewDelegate> delegate;
@end

@protocol ImageCutViewDelegate <NSObject>

- (void) imageCutViewController:(ImageCutViewController*) controller imageCutAndScaled:(UIImage*) image;

@end
