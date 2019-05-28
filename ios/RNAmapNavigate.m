
#import "RNAmapNavigate.h"
#import "NavigationViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface RNAmapNavigate ()
/**
 保存回调的callback
 */
@property (nonatomic, copy) RCTResponseSenderBlock callback;
@end

@implementation RNAmapNavigate

RCT_EXPORT_METHOD(showNavigation:(NSArray *)addressList callback:(RCTResponseSenderBlock)callback)
{
    //务必在主线程中执行跳转操作
    dispatch_async(dispatch_get_main_queue(), ^{
        [AMapServices sharedServices].apiKey = @"e7b5d79e0d2c0fd44cc56e92c7a173e1";
        
        NavigationViewController *vc = [[NavigationViewController alloc] init];
        vc.addressList = addressList;
        
        vc.didArrivedBlock = ^(NSString *navigationString){
            NSArray *array = @[navigationString];
            callback(array);
        };
        
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        UIViewController *mainViewController = keyWindow.rootViewController;
        [mainViewController presentViewController:vc animated:YES completion:nil];
        NSLog(@"来自RN的数据：%@",addressList);
    });
    
    
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

@end

