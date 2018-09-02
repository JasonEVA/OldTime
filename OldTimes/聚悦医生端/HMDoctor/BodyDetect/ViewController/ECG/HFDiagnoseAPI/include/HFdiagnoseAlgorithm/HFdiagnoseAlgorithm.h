//
//  HFdiagnoseAlgorithm.h
//  HFdiagnoseAlgorithm
//
//  Created by Finger on 15/11/21.
//  Copyright © 2015年 Finger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFdiagnoseAlgorithm : NSObject


/**
 *  疾病诊断算法
 *
 *  @param HfCollectData 30秒心电数据
 *  @param ecgInfo       显示信息 （[0]:心率 [1]:RR间期/ms [2]:QRS宽度/ms ）
 *  @param diseaseInfo   返回疾病种类： diseaseInfo[16]
 *
 *  @return true or false
 */
-(int)diagnoseAlgorithm:(NSData *)hfCollectData withecgInfo:(NSData **) ecgInfo withdiseaseInfo:(NSData **)diseaseInfo;


/**
 *  调用完diagnoseAlgorithm方法，停止测量后，一定要执行该方法
 */
-(void) clearMemory;



@end
