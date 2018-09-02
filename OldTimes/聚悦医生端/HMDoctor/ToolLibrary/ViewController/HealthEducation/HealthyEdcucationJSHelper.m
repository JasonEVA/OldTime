//
//  HealthyEdcucationJSHelper.m
//  HMDoctor
//
//  Created by yinquan on 17/1/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthyEdcucationJSHelper.h"
#import "MWPhotoBrowser.h"

@implementation HealthyEdcucationJSHelper

- (void) imageClicked:(NSString*) imageUrl
{
    if (!self.controller) {
        return;
    }
    if (!imageUrl)
    {
        return;
    }
    MWPhoto* photo = [MWPhoto photoWithURL:[NSURL URLWithString:imageUrl]];
    MWPhotoBrowser* browser = [[MWPhotoBrowser alloc]initWithPhotos:@[photo]];
    browser.displayActionButton = NO;
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [browser reloadData];
    //    [self.photoBrowser setCurrentPhotoIndex:currentSelectIndex];
    
    [self.controller presentViewController:nc animated:YES completion:nil];
}

@end
