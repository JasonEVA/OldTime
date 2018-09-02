//
//  ECGDataTests.m
//  HMClient
//
//  Created by lkl on 2017/3/27.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TaskManager.h"
#import "UserInfo.h"
#import "DetectRecord.h"
#import "HeartRateDetectRecord.h"
#import "HFdiagnoseAlgorithm.h"

//waitForExpectationsWithTimeout是等待时间，超过了就不再等待往下执行。
#define WAIT do {\
[self expectationForNotification:@"RSBaseTest" object:nil handler:nil];\
[self waitForExpectationsWithTimeout:30 handler:nil];\
} while (0);

#define NOTIFY \
[[NSNotificationCenter defaultCenter]postNotificationName:@"RSBaseTest" object:nil];

@interface ECGDataTests : XCTestCase <TaskObserver>

@end

@implementation ECGDataTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

//上传心率数据
- (void)testUploadData
{
    int HfData[]={-859,-855,-832,-841,-837,-784,-355,274,48,-655,-981,-764,-817,-858,-762,-755,-723,-657,-607,-553,-541,-504,-450,-427,-425,-407,-369,-343,-328,-311,-296,-284,-283,-274,-278,-294,-310,-331,-338,-356,-381,-411,-432,-442,-455,-472,-485,-492,-505,-530,-546,-564,-558,-559,-566,-572,-574,-565,-556,-552,-545,-520,-503,-485,-476,-485,-484,-470,-460,-454,-434,-416,-407,-391,-371,-356,-350,-342,-323,-308,-300,-284,-252,-239,-239,-231,-218,-210,-188,-172,-179,-167,-155,-139,-120,-89,-47,19,41,66,77,88,105,120,140,163,192,214,230,242,263,287,308,326,350,365,373,375,378,394,387,375,414,828,1445,1359,617,143,315,286,241,285,282,281,323,311,396,501,565,597,613,632,646,660,665,673,695,742,820,885,904,972,1077,1162,1230,1293,1322,1311,1314,1306,1274,1270,1248,1205,1166,1133,1092,1056,1032,1006,1002,984,956,942,912,882,865,846,828,805,783,777,762,732,719,769,835,867,867,871,907,909,888,870,863,847,834,841,837,833,844,859,874,897,914,924,935,931,935,934,930,920,918,916,907,904,887,883,879,867,860,836,827,802,787,769,756,738,718,696,679,666,648,642,645,619,600,594,829,1313,1561,886,324,453,392,316,362,362,355,375,355,369,363,372,379,383,378,385,382,389,382,373,373,366,364,358,367,377,402,452,486,487,501,519,524,515,513,516,513,504,496,488,487,482,475,487,500,504,507,506,505,498,498,503,508,533,568,592,596,601,589,568,549,544,543,542,542,542,549,566,574,577,586,606,613,631,657,665,688,706,717,731,738,731,730,747,755,757,760,764,773,772,771,769,770,777,776,765,755,762,766,764,772,769,746,722,697,682,670,665,658,641,632,634,615,580,625,1052,1674,1530,753,281,462,367,324,380,376,415,422,439,475,496,522,531,544,561,586,603,611,607,614,614,611,612,612,602,597,597,586,584,579,571,565,560,554,554,552,556,566,589,595,594,589,583,642,734,792,728,714,709,680,660,660,637,623,622,622,612,597,587,593,597,598,602,608,607,606,614,613,604,602,602,593,591,594,589,581,581,569,560,551,539,531,518,505,496,492,485,483,471,477,477,469,466,457,448,437,435,437,439,437,436,451,459,467,478,477,487,511,532,553,587,631,667,708,749,742,757,857,1486,2014,1464,765,626,724,648,622,676,636,675,670,693,707,706,709,709,711,711,713,716,721,723,718,713,709,700,697,699,698,692,689,682,669,663,657,659,662,661,651,651,651,647,649,653,655,655,660,667,682,717,782,834,866,896,929,964,998,1053,1100,1129,1169,1203,1226,1257,1283,1317,1340,1350,1359,1387,1423,1453,1474,1492,1518,1528,1526,1527,1531,1532,1518,1502,1492,1482,1464,1453,1445,1434,1416,1411,1414,1417,1416,1424,1421,1413,1396,1381,1367,1360,1357,1358,1359,1362,1365,1371,1372,1355,1331,1325,1308,1273,1263,1257,1242,1235,1238,1238,1248,1427,1655,2102,2717,2908,2233,1688,1856,1844,1763,1785,1803,1790,1824,1809,1822,1809,1810,1806,1793,1779,1772,1763,1749,1737,1718,1715,1701,1686,1672,1661,1653,1639,1624,1607,1606,1600,1591,1580,1566,1551,1539,1524,1509,1486,1479,1475,1466,1455,1453,1453,1469,1484,1475,1468,1459,1464,1459,1455,1444,1425,1407,1409,1419,1399,1369,1659,1805,1756,1601,1553,1516,1424,1381,1309,1293,1247,1215,1195,1177,1166,1163,1209,1335,1432,1459,1444,1450,1465,1457,1426,1411,1379,1352,1335,1343,1331,1328,1342,1344,1314,1284,1274,1261,1241,1223,1217,1198,1171,1153,1153,1130,1113,1123,1453,1999,1949,1251,873,1023,937,865,905,880,861,870,851,870,875,867,867,863,867,866,865,861,847,836,829,821,809,806,858,914,940,968,982,987,997,997,988,983,971,957,946,942,929,905,903,896,877,878,882,881,879,878,869,874,874,859,857,857,855,849,847,836,833,834,819,815,810,799,791,778,782,777,765,762,758,754,754,745,732,742,744,730,721,720,712,710,706,709,710,706,699,693,690,683,679,672,673,665,665,649,648,648,660,665,656,651,646,636,630,626,625,628,634,631,633,613,605,687,1314,1841,1282,579,432,522,430,385,458,426,461,471,498,503,521,532,548,555,562,566,573,577,582,591,588,585,584,584,585,587,588,586,592,592,581,585,591,586,586,589,577,578,576,572,581,582,585,590,588,593,599,594,603,611,609,611,622,621,623,630,623,620,618,618,615,611,603,613,615,609,620,638,644,647,647,641,636,649,646,644,641,636,641,641,648,660,715,779,807,826,837,841,849,858,849,850,852,842,841,837,823,816,810,802,795,787,778,764,749,741,724,711,708,716,706,698,691,690,689,644,629,912,1477,1833,1134,482,451,549,451,434,481,453,498,499,524,577,666,755,791,814,844,863,874,886,898,903,899,909,908,909,907,906,910,904,893,887,886,884,876,864,857,846,828,817,812,803,788,789,781,774,764,763,768,770,779,811,852,895,946,1010,1070,1142,1202,1274,1357,1455,1535,1617,1690,1757,1834,1901,1965,2013,2062,2105,2148,2191,2220,2251,2277,2300,2317,2321,2332,2342,2336,2338,2343,2350,2355,2348,2329,2309,2303,2306,2283,2266,2246,2223,2203,2179,2157,2137,2118,2114,2101,2067,2044,2014,1984,1963,1954,1937,1921,1915,1907,1913,1883,1857,1844,2330,2906,2615,1907,1581,1739,1661,1590,1642,1628,1635,1669,1654,1665,1660,1671,1671,1668,1672,1671,1673,1686,1685,1681,1676,1676,1666,1654,1650,1641,1628,1617,1610,1597,1578,1580,1574,1558,1544,1540,1525,1525,1509,1493,1492,1484,1474,1465,1455,1447,1442,1433,1432,1423,1406,1408,1394,1383,1378,1371,1357,1348,1331,1317,1304,1293,1284,1267,1257,1261,1272,1262,1249,1238,1226,1212,1205,1196,1181,1167,1162,1149,1141,1137,1127,1124,1117,1105,1106,1105,1090,1082,1081,1082,1084,1085,1095,1098,1094,1085,1088,1084,1076,1080,1073,1059,1056,1059,1056,1038,1008,1006,1100,1881,2089,1365,777,904,894,787,806,852,808,850,854,883,890,904,916,921,939,949,955,957,961,965,974,979,975,980,977,981,982,984,976,965,961,958,965,949,922,921,913,902,892,891,881,886,887,879,873,882,891,887,891,897,905,907,910,915};
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < sizeof(HfData)/4; i++) {
        [array addObject:[NSString stringWithFormat:@"%d",HfData[i]]];
    }
    
    HFdiagnoseAlgorithm *demo = [[HFdiagnoseAlgorithm alloc]init];
    
    NSData *data1 = [[NSData alloc]init];
    NSData *data2 = [[NSData alloc]init];
    NSData *data3 = [[NSData alloc]init];
    
    data1 = [NSData dataWithBytes:HfData length:sizeof(HfData)];
    
    int res = [demo diagnoseAlgorithm:data1 withecgInfo:&data2 withdiseaseInfo:&data3];
    
    NSArray *resultArray;
    int *rate;
    if ( res )
    {
        rate = (int *)[data2 bytes];
        int len_rate = (int)data2.length / 4;
        
        NSLog(@"返回的ECG信息数据长度%d：",len_rate);
        NSLog(@"输入数据心率为：%d",rate[0]);
        NSLog(@"RR间期/ms：%d",rate[1]);
        NSLog(@"QRS宽度/ms：%d",rate[2]);
        
       resultArray = [self diseaseLog:data3];
        
        //诊断结束，清除内存
        [demo clearMemory];
    }
    else
    {
        //诊断结束，清除内存
        [demo clearMemory];
        
        NSLog(@"数据干扰太大，无法分析！");
        return;
    }
    
    NSString *symptom = [resultArray componentsJoinedByString:@"|"];
    
    NSString *bitmap = [array componentsJoinedByString:@","];
    
    NSMutableArray *bitmapArray;
    if (!bitmapArray)
    {
        bitmapArray = [[NSMutableArray alloc] init];
    }
    [bitmapArray addObject:bitmap];
    
    //上传数据
    NSMutableDictionary *dicValue = [NSMutableDictionary dictionary];
    
    [dicValue setValue:[NSString stringWithFormat:@"%d",rate[0]] forKey:@"XL_OF_XD"];
    [dicValue setValue:[NSString stringWithFormat:@"%d",rate[1]] forKey:@"RR"];
    [dicValue setValue:[NSString stringWithFormat:@"%d",rate[2]] forKey:@"QRS"];
    [dicValue setValue:bitmapArray forKey:@"BITMAP"];
    [dicValue setValue:[NSString stringWithFormat:@"125"] forKey:@"rate"];
    
    NSMutableDictionary *dicDetectResult = [NSMutableDictionary dictionary];
    [dicDetectResult setValue:@"XD" forKey:@"kpiCode"];
    [dicDetectResult setValue:dicValue forKey:@"testValue"];
    [dicDetectResult setValue:symptom forKey:@"symptom"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dicDetectResult setValue:[formatter stringFromDate:[NSDate date]] forKey:@"testTime"];
    
    [dicDetectResult setValue:@"2" forKey:@"inputMode"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"PostBodyDetectResultTask" taskParam:dicDetectResult TaskObserver:self];
    
    WAIT
}

- (NSArray *)diseaseLog:(NSData *)dis
{
    NSMutableArray *diseaseArray = [[NSMutableArray alloc] init];
    
    int *disease = (int *)[dis bytes];
    int len_disease = (int)dis.length / 4;
    
    for (int i = 0; i < len_disease; i++)
    {
        if ( disease[i] != -1 )
        {
            switch (i)
            {
                case 0:
                    [diseaseArray addObject:@"单发室性早搏"];
                    break;
                    
                case 1:
                    [diseaseArray addObject:@"成对室性早搏"];
                    break;
                    
                case 2:
                    [diseaseArray addObject:@"加速性室性逸搏心律"];
                    break;
                    
                case 3:
                    [diseaseArray addObject:@"室性心动过速"];
                    break;
                    
                case 4:
                    [diseaseArray addObject:@"室性二联律"];
                    break;
                    
                case 5:
                    [diseaseArray addObject:@"室性三联律"];
                    break;
                    
                case 6:
                    [diseaseArray addObject:@"单发室上性早搏"];
                    break;
                    
                case 7:
                    [diseaseArray addObject:@"成对室上性早搏"];
                    break;
                    
                case 8:
                    [diseaseArray addObject:@"加速性室上性逸搏心律"];
                    break;
                    
                case 9:
                    [diseaseArray addObject:@"室上性心动过速"];
                    break;
                    
                case 10:
                    [diseaseArray addObject:@"室上性二联律"];
                    break;
                    
                case 11:
                    [diseaseArray addObject:@"室上性三联律"];
                    break;
                    
                case 12:
                    [diseaseArray addObject:@"长间期"];
                    break;
                    
                case 13:
                    [diseaseArray addObject:@"窦性心动过速"];
                    break;
                    
                case 14:
                    [diseaseArray addObject:@"窦性心动过缓"];
                    break;
                    
                case 15:
                    [diseaseArray addObject:@"窦性心率不齐"];
                    break;
                    
                default:
                    break;
            }
        }
    }
    if (0 == diseaseArray.count)
    {
        [diseaseArray addObject:@"心电正常"];
    }
    return diseaseArray;
}


//获取上传的心率数据
- (void)testGetDevicesData
{
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    NSInteger startRow = 0;
    NSInteger rows = 20;
    [dicPost setValue:[NSNumber numberWithInteger:startRow] forKey:@"startRow"];
    [dicPost setValue:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    [dicPost setValue:[NSString stringWithFormat:@"%ld",curUser.userId] forKey:@"userId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"HeartRateRecordsTask" taskParam:dicPost TaskObserver:self];
    
    WAIT
}

//获取上传的心率数据详情
- (void)testDataDetail
{
    NSString *recordId = @"MB_76751F51AF284364A14382B578CA1B91";
    
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:recordId forKey:@"testDataId"];
    
    [[TaskManager shareInstance] createTaskWithTaskName:@"HeartRateDetectResultTask" taskParam:dicPost TaskObserver:self];
    
    WAIT
}

#pragma mark - TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    NSLog(@"--%@",errorMessage);
    XCTAssertTrue(taskError == StepError_None);
    
    NOTIFY
}

- (void) task:(NSString *)taskId Result:(id) taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    
    if ([taskname isEqualToString:@"HeartRateRecordsTask"]) {
        
        XCTAssertNotNil(taskResult);
        XCTAssertTrue([taskResult isKindOfClass:[NSDictionary class]]);
    }
    
    if ([taskname isEqualToString:@"HeartRateDetectResultTask"])
    {
        XCTAssertNotNil(taskResult);
        XCTAssert([taskResult isKindOfClass:[DetectResult class]],@"数据错误");
        
        HeartRateDetectResult* bpResult = (HeartRateDetectResult*)taskResult;
        XCTAssert([bpResult.dataDets.RR isEqualToString:@"696"],@"查询结果不一致");
        XCTAssert(bpResult.dataDets.XL_OF_XD == 86,@"查询结果不一致");
        XCTAssert([bpResult.dataDets.QRS isEqualToString:@"120"],@"查询结果不一致");
        //NSLog(@"-----%@ %@ %@",bpResult.dataDets.RR,bpResult.dataDets.PR,bpResult.dataDets.QRS);
    }
}


@end
