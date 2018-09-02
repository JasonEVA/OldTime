//
//  CalendarAndMeetingPlaceSelectViewController.m
//  launcher
//
//  Created by William Zhang on 15/8/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarAndMeetingPlaceSelectViewController.h"
#import "CalendarAndMeetingTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "GooglePlaceFinderDAL.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
#import "PlaceModel.h"
#import "MyDefine.h"
#import "Category.h"
#import "BaiDuMapSearchDAL.h"
#import "BaiduAddressModel.h"

static CGFloat const textFieldHeight = 40;
static NSString * const cellIdentifier = @"CalendarAndMeetingCellIdentifier";

@interface CalendarAndMeetingPlaceSelectViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate, UITextFieldDelegate, GooglePlaceFinderDALDelegate,BaiDuMapSearchDALDelegate>

@property (nonatomic, strong) UITextField   *searchTextField;
@property (nonatomic, strong) UITableView   *tableView;

@property (nonatomic, strong) CLLocationManager *locationManager;

/** Google搜索地址DAL */
@property (nonatomic, strong) GooglePlaceFinderDAL *placeFinderDAL;

/** 百度搜索地址DAL */
@property (nonatomic, strong) BaiDuMapSearchDAL *baiduPlaceFinderDAL;
/** 选中回调 */
@property (nonatomic, copy) CalendarAndMeetingSelectBlock selectedBlock;

// Data
@property (nonatomic, strong) NSMutableArray *resultArray;
/** 获取来的location */
@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

/** 已经选择地点 */
@property (nonatomic, getter=isSelectPlace) BOOL selectPlace;

@end

@implementation CalendarAndMeetingPlaceSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCAL(CALENDAR_ADD_PLACE);
    [self initComponents];

    [self startLocation];
}

- (void)initComponents {
    [self.view addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(textFieldHeight));
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.searchTextField.mas_bottom);
    }];
    
    [self.searchTextField becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.isSelectPlace)
    {
        return;
    }
    
    // 没有搜出结果，返回输入结果
    if (self.selectedBlock)
    {
        NSString *text =self.searchTextField.text;
        if (![text length])
        {
            return;
        }
        
        PlaceModel *placeModel = [[PlaceModel alloc] initWithName:text];
        self.selectedBlock(placeModel);
    }
    
    if (!isUseGoogel) {
        [self.baiduPlaceFinderDAL killSearch];
    }
}

#pragma mark - Interface Method
- (void)getSelectedPlace:(void (^)(PlaceModel *))selected
{
    self.selectedBlock = selected;
}

#pragma mark - Private Method
/** 获取定位信息 */
- (void)startLocation
{
    if (![self locationServicesEnabled])
    {
        return;
    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    if (IOS_VERSION_8_OR_ABOVE)
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

/** 判定是否启动定位系统 */
- (BOOL)locationServicesEnabled
{
    BOOL enable = [CLLocationManager locationServicesEnabled];
    if (enable)
    {
        return YES;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCAL(MEETING_OPEN_LOCATION) message:@"" delegate:nil cancelButtonTitle:LOCAL(CERTAIN) otherButtonTitles: nil];
    alertView.delegate = self;
    [alertView show];
    
    return NO;
}

- (void)loadMoreData {
    if (![self.searchTextField.text length] || !self.currentLocation)
    {
        [self.tableView.footer endRefreshing];
        if (!self.currentLocation)
        {
            [self startLocation];
        }
        return;
    }
    if (isUseGoogel) {
        [self.placeFinderDAL findMore];
    } else {
        
    }
}

/** tableView 刷新状态 */
- (void)footerStatus:(BOOL)remain {
    self.tableView.footer.hidden = remain;
    if (remain) {
        [self.tableView.footer resetNoMoreData];
    } else {
        [self.tableView.footer noticeNoMoreData];
    }
}

#pragma mark - CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // TODO:处理❌信息
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [manager stopUpdatingLocation];

    if ([locations count]) {
        self.currentLocation = [locations firstObject];
    }
}

#pragma mark - GooglePlaceFinderDAL Delegate
- (void)GooglePlaceFinderDALDelegateCallBack_FindPlaces:(NSArray *)places remain:(BOOL)remain{
    [self.resultArray removeAllObjects];
    [self.resultArray addObjectsFromArray:places];
    
    [self.tableView reloadData];
    self.tableView.footer.hidden = NO;
    if ([self.tableView.footer isRefreshing]) {
        [self.tableView.footer endRefreshing];
    }
    [self footerStatus:remain];
    [self hideLoading];
    [self.activityView stopAnimating];
}

- (void)GooglePlaceFinderDALDelegateCallBack_FindMorePlaces:(NSArray *)places remain:(BOOL)remain {
    [self.resultArray addObjectsFromArray:places];
    
    [self.tableView reloadData];
    self.tableView.footer.hidden = NO;
    if ([self.tableView.footer isRefreshing]) {
        [self.tableView.footer endRefreshing];
    }
    [self footerStatus:remain];
}

- (void)GooglePlaceFinderDALDelegateCallBack_FailWithError:(NSError *)error {
    [self hideLoading];
    if ([self.tableView.footer isRefreshing]) {
        [self.tableView.footer endRefreshing];
    }
    [self.activityView stopAnimating];
}

#pragma mark - BaiDuMapSearchDALDelegate

- (void)BaiDuMapSearchDALDelegateCallback_result:(BMKSuggestionResult *)result errorCode:(BMKSearchErrorCode)error
{
    [self.resultArray removeAllObjects];
    for (NSInteger i = 0; i < result.keyList.count ; i++) {
        BaiduAddressModel *model = [[BaiduAddressModel alloc] init];
        model.keyword = result.keyList[i];
        model.cityNmae = result.cityList[i];
        model.district = result.districtList[i];
        model.poiId = result.poiIdList[i];
        model.pt = result.ptList[i];
        [self.resultArray addObject:model];
    }
    [self.activityView stopAnimating];
    [self.tableView reloadData];
}

#pragma mark - UITextFeild Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (isUseGoogel) {
        if (!self.currentLocation) {
            [self startLocation];
            return YES;
        }
        [self.placeFinderDAL findPlacesNamed:self.searchTextField.text near:self.currentLocation.coordinate];
    } else {
        [self.baiduPlaceFinderDAL searchWithKeyword:self.searchTextField.text];
    }
    
    [self.activityView startAnimating];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSString *text = textField.text;
    
    if (![text length]) {
        [self.resultArray removeAllObjects];
        [self.tableView reloadData];
        [self.activityView stopAnimating];
        return;
    }
    
    [self.tableView reloadData];
    
    if (isUseGoogel) {
        [self.placeFinderDAL findPlacesNamed:text near:self.currentLocation.coordinate];
    } else {
        [self.baiduPlaceFinderDAL searchWithKeyword:text];
    }
    
    [self.activityView startAnimating];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![self.searchTextField.text length]) {
        return 0;
    }
    return [self.resultArray count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CalendarAndMeetingTableViewCell height];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    UIImage *googleImage = [[UIImage alloc] init];
   if (isUseGoogel) {
        googleImage = [UIImage imageNamed:@"powered-by-google-on-white"];
    } else {
        googleImage = [UIImage imageNamed:@"baidumap_logo"];
    }
    UIImageView *googleImageView = [[UIImageView alloc] initWithImage:googleImage];
    [footerView addSubview:googleImageView];
    
    [googleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(footerView);
    }];
    
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;
    NSInteger row = indexPath.row;

    cell = [tableView dequeueReusableCellWithIdentifier:[CalendarAndMeetingTableViewCell identifier]];
    
    NSString *title = self.searchTextField.text;
    NSString *subTitle = @"";
    if (row != 0) {
        if (isUseGoogel) {
            PlaceModel *foundPlace = [self.resultArray objectAtIndex:row - 1];
            title = foundPlace.name;
            subTitle = foundPlace.fullAddress;
        } else {
            if (self.resultArray.count > 0) {
                BaiduAddressModel *model = [self.resultArray objectAtIndex:row - 1];
                title = model.keyword;
                subTitle = [NSString stringWithFormat:@"%@%@%@",model.cityNmae,model.district,model.keyword];
            }
        }
        
    }
    
    [cell setTitle:title subTitle:subTitle selected:(row == 0)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView reloadData];
   
    self.selectPlace = YES;
    
    PlaceModel *selectedPlace = [[PlaceModel alloc] initWithName:self.searchTextField.text];
    
    if (indexPath.row != 0) {
        if (isUseGoogel) {
            selectedPlace = [self.resultArray objectAtIndex:indexPath.row - 1];
        } else {
            if (self.resultArray.count > 0) {
                BaiduAddressModel *model = [self.resultArray objectAtIndex:indexPath.row - 1];
                selectedPlace.name = model.keyword;
                NSValue *a = model.pt;
                CLLocationCoordinate2D coor;
                [a getValue:&coor];
                selectedPlace.coordinate = coor;
                selectedPlace.fullAddress = [NSString stringWithFormat:@"%@%@%@",model.cityNmae,model.district,model.keyword];
            }
            
        }
        
    }
    
    if (self.selectedBlock) {
        self.selectedBlock(selectedPlace);
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 无法定位，退回上一层
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Initializer
- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.delegate = self;
        
        _searchTextField.returnKeyType = UIReturnKeyDone;
        _searchTextField.font = [UIFont systemFontOfSize:18];
        _searchTextField.placeholder = LOCAL(CALENDAR_SCHEDULEBYMONTH_SEARCH);
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _searchTextField.leftView = leftView;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        
        
        _searchTextField.rightView = self.activityView;
        _searchTextField.rightViewMode = UITextFieldViewModeAlways;
        
        [_searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchTextField;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor grayBackground];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView setFooter:[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)]];
        [_tableView.footer setHidden:YES];
        
        [_tableView registerClass:[CalendarAndMeetingTableViewCell class] forCellReuseIdentifier:[CalendarAndMeetingTableViewCell identifier]];
    }
    return _tableView;
}

- (NSMutableArray *)resultArray {
    if (!_resultArray) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}

- (GooglePlaceFinderDAL *)placeFinderDAL {
    if (!_placeFinderDAL) {
        _placeFinderDAL = [[GooglePlaceFinderDAL alloc] init];
        _placeFinderDAL.delegate = self;
    }
    return _placeFinderDAL;
}
- (BaiDuMapSearchDAL *)baiduPlaceFinderDAL
{
    if (!_baiduPlaceFinderDAL) {
        _baiduPlaceFinderDAL = [[BaiDuMapSearchDAL alloc] init];
        [_baiduPlaceFinderDAL setDelegate:self];
    }
    return _baiduPlaceFinderDAL;
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityView setHidesWhenStopped:YES];
    }
    return _activityView;
}

@end
