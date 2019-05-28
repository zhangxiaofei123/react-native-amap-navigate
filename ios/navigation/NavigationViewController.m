//
//  NavigationViewController.m
//  rubcoll
//
//  Created by 张孝飞 on 2019/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "NavigationViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "SpeechSynthesizer.h"

@interface NavigationViewController ()<AMapNaviCompositeManagerDelegate>{
    NSString *dateStr;
}
@property (nonatomic, strong) AMapNaviCompositeManager *compositeManager;
@property (nonatomic, strong) AMapNaviRoute *aMapNaviRoute;


@end

@implementation NavigationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *startDic = _addressList[0];
    NSString *startAddress = [NSString stringWithFormat:@"%@",[startDic objectForKey:@"address"]];
    NSString *startLatitude = [NSString stringWithFormat:@"%@",[startDic objectForKey:@"latitude"]];
    NSString *startLongitude = [NSString stringWithFormat:@"%@",[startDic objectForKey:@"longitude"]];
    CGFloat fStartLatitude = [startLatitude floatValue];
    CGFloat fStartLongitude = [startLongitude floatValue];
    
    NSDictionary *endDic = _addressList[1];
    NSString *endAddress = [NSString stringWithFormat:@"%@",[endDic objectForKey:@"address"]];
    NSString *endLatitude = [NSString stringWithFormat:@"%@",[endDic objectForKey:@"latitude"]];
    NSString *endLongitude = [NSString stringWithFormat:@"%@",[endDic objectForKey:@"longitude"]];
    CGFloat fEndLatitude = [endLatitude floatValue];
    CGFloat fEndLongitude = [endLongitude floatValue];
    AMapNaviCompositeUserConfig *config = [[AMapNaviCompositeUserConfig alloc] init];
    [config setShowDrivingStrategyPreferenceView:NO];
    [config setMapShowTraffic:NO];
    [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeStart location:[AMapNaviPoint locationWithLatitude:fStartLatitude longitude:fStartLongitude] name:startAddress POIId:nil];     //传入起点，并且带高德POIId
    
    [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeEnd location:[AMapNaviPoint locationWithLatitude:fEndLatitude longitude:fEndLongitude] name:endAddress POIId:nil];          //传入终点，并且带高德POIId
    
    
    [config setStartNaviDirectly:YES];
    
    [config setOnlineCarHailingType:AMapNaviOnlineCarHailingTypeTransport];
    
    [config setThemeType:AMapNaviCompositeThemeTypeLight];
    [config setNeedShowConfirmViewWhenStopGPSNavi:NO];
    [config setRemovePolylineAndVectorlineWhenArrivedDestination:YES];
    
    [self.compositeManager presentRoutePlanViewControllerWithOptions:config];
    _aMapNaviRoute = [[AMapNaviRoute alloc] init];
}



// init
- (AMapNaviCompositeManager *)compositeManager {
    if (!_compositeManager) {
        _compositeManager = [[AMapNaviCompositeManager alloc] init];  // 初始化
        _compositeManager.delegate = self;  // 如果需要使用AMapNaviCompositeManagerDelegate的相关回调（如自定义语音、获取实时位置等），需要设置delegate
    }
    return _compositeManager;
}

#pragma mark - AMapNaviCompositeManagerDelegate

// 发生错误时,会调用代理的此方法
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager error:(NSError *)error {
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

// 算路成功后的回调函数,路径规划页面的算路、导航页面的重算等成功后均会调用此方法
- (void)compositeManagerOnCalculateRouteSuccess:(AMapNaviCompositeManager *)compositeManager {
    NSLog(@"onCalculateRouteSuccess,%ld",(long)compositeManager.naviRouteID);
}

// 算路失败后的回调函数,路径规划页面的算路、导航页面的重算等失败后均会调用此方法
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager onCalculateRouteFailure:(NSError *)error {
    NSLog(@"onCalculateRouteFailure error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

// 开始导航的回调函数
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager didStartNavi:(AMapNaviMode)naviMode {
    NSLog(@"didStartNavi,%ld",(long)naviMode);
    
}

// 当前位置更新回调
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager updateNaviLocation:(AMapNaviLocation *)naviLocation {
    NSLog(@"updateNaviLocation,%@",naviLocation);
}

// 导航到达目的地后的回调函数
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager didArrivedDestination:(AMapNaviMode)naviMode {
    NSLog(@"didArrivedDestination,%ld",(long)naviMode);
    
    NSInteger routeLength = _aMapNaviRoute.routeLength;
    NSInteger routeTime = _aMapNaviRoute.routeTime;
    NSDate *date=[NSDate date];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateStr=[format stringFromDate:date];
    NSString *parameter = [NSString stringWithFormat:@"%ld,%@",(long)routeLength,dateStr];
    if (self.didArrivedBlock) {
        self.didArrivedBlock(parameter);
    }
}

/**
 * @brief 导航组件页面回退或者退出导航组件时会调用此函数 since 5.5.0
 * @param compositeManager 导航组件类
 * @param backwardActionType 导航组件页面回退的动作类型，参考 AMapNaviCompositeVCBackwardActionType .
 */
- (void)compositeManager:(AMapNaviCompositeManager *_Nonnull)compositeManager didBackwardAction:(AMapNaviCompositeVCBackwardActionType)backwardActionType{
    if (backwardActionType == AMapNaviCompositeVCBackwardActionTypeDismiss) {
        NSLog(@"页面dissmiss");
    } else if (backwardActionType == AMapNaviCompositeVCBackwardActionTypeNaviPop) {
        NSLog(@"导航界面回退");
    }
}

#pragma mark - AMapNaviCompositeManagerDelegate
- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager onArrivedWayPoint:(int)wayPointIndex {
    NSLog(@"途径点：%d",wayPointIndex);
}


- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager onCalculateRouteSuccessWithType:(AMapNaviRoutePlanType)type {
    NSLog(@"=====  算路成功 %ld",type);
}

- (BOOL)compositeManagerIsNaviSoundPlaying:(AMapNaviCompositeManager *)compositeManager {
    return [[SpeechSynthesizer sharedSpeechSynthesizer] isSpeaking];
}

- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType {
    //    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}

- (void)compositeManagerStopPlayNaviSound:(AMapNaviCompositeManager *)compositeManager {
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
}


- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager onDriveStrategyChanged:(AMapNaviDrivingStrategy)driveStrategy {
    NSLog(@"路径策略改变:%ld",driveStrategy);
}

- (void)compositeManager:(AMapNaviCompositeManager *)compositeManager didChangeDayNightType:(BOOL)showStandardNightType {
    NSLog(@"当前是否为夜间：%d",showStandardNightType);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end



