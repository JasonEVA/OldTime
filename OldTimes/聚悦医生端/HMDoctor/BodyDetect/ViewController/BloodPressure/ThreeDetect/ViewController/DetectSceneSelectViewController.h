//
//  DetectSceneSelectViewController.h
//  HMDoctor
//
//  Created by yinquan on 2017/10/13.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetectSceneModel.h"

typedef void(^DetectSceneSelectHandle)(DetectSceneModel* sceneModel);

@interface DetectSceneSelectViewController : UIViewController

+ (void) showWithSelectHandle:(DetectSceneSelectHandle) handle;
@end
