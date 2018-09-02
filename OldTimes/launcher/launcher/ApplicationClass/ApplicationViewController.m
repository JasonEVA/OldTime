//
//  ApplicationViewController.m
//  launcher
//
//  Created by William Zhang on 15/7/24.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplicationViewController.h"
#import "TestMaininterfaceViewControlViewController.h"
#import "CalendarViewController.h"
#import "ApplyTabBarController.h"
#import "ApplicationCollectionViewCell.h"
#import "MixpanelMananger.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "Images.h"
#import "NewApplyMainAllViewController.h"
#import "NewApplyMainV2ViewController.h"
#import "NewMissionContainViewController.h"
#import "NewCalendarViewController.h"
#import "ApplicationAppInfoModel.h"
#import "ApplicationGetAppInfoRequest.h"
#import "AttachmentUtil.h"
#import "AppBaseViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ATClockViewController.h"
typedef NS_ENUM(NSUInteger, ApplicationType) {
	ApplicationTypeApply					= 0,	//  申请
	ApplicationTypeSchedule					= 1,	//  日程
	ApplicationTypeMission					= 2,	//  任务
    ApplicationTypeAttandence               = 3,    //  考勤
};

@interface ApplicationViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BaseRequestDelegate>

@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSArray *arrTitleList;
@property (nonatomic, strong) NSArray *arrImgList;
@property (nonatomic, strong) NSMutableArray *arrUrlimgs;
@property (nonatomic, strong) NSMutableDictionary *dictUrlimgs;
@end

@implementation ApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:LOCAL(Application)];
    
    self.arrTitleList = @[LOCAL(Application_Apply), LOCAL(Application_Calendar),LOCAL(Application_Mission),LOCAL(Application_Attendance)];
    self.arrImgList = @[IMG_APPLICATION_LEAVE, IMG_APPLICATION_CALENDAR, IMG_APPLICATION_MISSION,IMG_APPLICATION_ATTENDANCE];
    
    [self.view addSubview:self.collection];
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginNewCalendar) name:MTWillBeginSkimCalendarNotification object:nil];
    
    ApplicationGetAppInfoRequest *request = [[ApplicationGetAppInfoRequest alloc] initWithDelegate:self];
    [request GetInfo];
    
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MTWillBeginSkimCalendarNotification object:nil
	 ];
}

#pragma mark - Notifacate Method
- (void)beginNewCalendar
{
    CalendarViewController *vc = [[CalendarViewController alloc] init];
    [MixpanelMananger track:@"app center/calendar"];
    [vc setHidesBottomBarWhenPushed:YES];
    [CATransaction begin];
    [self.navigationController pushViewController:vc animated:YES];
    [CATransaction setCompletionBlock:^{
        //        [vc newEvent];
    }];
    [CATransaction commit];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrTitleList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ApplicationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplicationCollectionViewCell" forIndexPath:indexPath];
    cell.lblTitle.text = [self.arrTitleList objectAtIndex:indexPath.row];
//    cell.imgView.image = [UIImage imageNamed:self.arrImgList[indexPath.row]];;
    
//    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.arrUrlimgs[indexPath.row]?:@""] placeholderImage:[UIImage imageNamed:self.arrImgList[indexPath.row]]];
//    self.dictUrlimgs = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"appImgs"]?:@{@"":@(0),@"": @(1),@"":@(2)}];
    NSString *Path =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"appImgs"];
    self.dictUrlimgs = [NSMutableDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:filename]?:@{@"":@(0),@"": @(1),@"":@(2),@"":@(3)}];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[self.dictUrlimgs objectForKey:@(indexPath.row)]?:@""] placeholderImage:[UIImage imageNamed:self.arrImgList[indexPath.row]]];
    return cell;
}

#pragma mark - UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
		case ApplicationTypeSchedule:  { // 日程界面
            [MixpanelMananger track:@"app center/calendar"];
			NewCalendarViewController *calendarVC = [[NewCalendarViewController alloc] init];
			[self.navigationController pushViewController:calendarVC animated:YES];
		}
			break;
		case ApplicationTypeApply: { // 请假界面
            [MixpanelMananger track:@"app center/approve"];
            NewApplyMainV2ViewController *applyVC = [[NewApplyMainV2ViewController alloc] init];
			[self.navigationController pushViewController:applyVC animated:YES];
		}
			break;
		case ApplicationTypeMission: { // 任务界面
            [MixpanelMananger track:@"app center/task"];
			NewMissionContainViewController * missionVC = [[NewMissionContainViewController alloc] init];
			[missionVC presentedByViewController:self];
		}
            break;
        case ApplicationTypeAttandence: { //考勤界面
            [MixpanelMananger track:@"app center/attend"];
            UnifiedUserInfoManager *infoManager = [UnifiedUserInfoManager share];
            
            NSString *orgID = infoManager.companyCode;
            NSString *userID = infoManager.userShowID;
            
            NSLog(@"%@", userID);
            
            ATClockViewController *ctr = [[ATClockViewController alloc] init];
            ctr.orgId = orgID;
            ctr.userId = userID;
              self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ctr animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
            break;
    }
}

#pragma mark - init
- (UICollectionView *)collection {
    if (!_collection) {
        UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        collectionViewFlowLayout.itemSize = CGSizeMake(80, 100);
        
        CGFloat mininum = (CGRectGetWidth(self.view.frame) - 240 - 65) / 2;
        
        collectionViewFlowLayout.minimumLineSpacing = mininum;
        collectionViewFlowLayout.minimumInteritemSpacing = mininum;
        
        mininum = 32.5;
        collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(mininum, mininum, mininum, mininum);
        
        _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout];
        _collection.backgroundColor = [UIColor whiteColor];
        
        _collection.delegate = self;
        _collection.dataSource = self;
        
        [_collection registerClass:[ApplicationCollectionViewCell class] forCellWithReuseIdentifier:@"ApplicationCollectionViewCell"];
    }
    return _collection;
}

- (void)compareWithimgs:(NSMutableArray *)arrModels;
{
    self.dictUrlimgs = nil;
    for (ApplicationAppInfoModel *model in arrModels)
    {
        NSString *stringurl = [NSString stringWithFormat:@"%@/Base-Module/Annex/AppIcon?annexType=APPIcon&width=150&height=150&fileName=%@",la_imgURLAddress,model.APP_ICON_MOBILE];
        
        if ([model.SHOW_ID isEqualToString:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdCalendar]])
        {
            [self.arrUrlimgs replaceObjectAtIndex:0 withObject:stringurl];
            [self.dictUrlimgs setObject:stringurl forKey:@(1)];
        }
        else if ([model.SHOW_ID isEqualToString:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdApprove]])
        {
            [self.arrUrlimgs replaceObjectAtIndex:1 withObject:stringurl];
            [self.dictUrlimgs setObject:stringurl forKey:@(0)];
        }
        else if ([model.SHOW_ID isEqualToString:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdNewTask]])
        {
            [self.arrUrlimgs replaceObjectAtIndex:2 withObject:stringurl];
            [self.dictUrlimgs setObject:stringurl forKey:@(2)];
        }else if ([model.SHOW_ID isEqualToString:[AttachmentUtil attachmentShowIdFromType:kAttachmentAppShowIdAttendance]])
        {
            [self.arrUrlimgs replaceObjectAtIndex:3 withObject:stringurl];
            [self.dictUrlimgs setObject:stringurl forKey:@(3)];
        }
    }
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:self.dictUrlimgs];
    NSString *Path =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"appImgs"];
    [NSKeyedArchiver archiveRootObject:dict toFile:filename];
}

#pragma mark - Private Method


#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([response isKindOfClass:[ApplicationGetAppInfoResponse class]])
    {
        [self compareWithimgs:((ApplicationGetAppInfoResponse *)response).arrAppModels];
        [self.collection reloadData];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

- (NSMutableArray *)arrUrlimgs
{
    if (!_arrUrlimgs)
    {
        _arrUrlimgs = [[NSMutableArray alloc] initWithArray:@[@"",@"",@"",@""]];
    }
    return _arrUrlimgs;
}

- (NSMutableDictionary *)dictUrlimgs
{
    if (!_dictUrlimgs)
    {
        _dictUrlimgs = [[NSMutableDictionary alloc] init];
    }
    return _dictUrlimgs;
}
@end
