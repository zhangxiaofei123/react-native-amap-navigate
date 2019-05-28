//
//  NavigationViewController.h
//  rubcoll
//
//  Created by 张孝飞 on 2019/4/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NavigationViewController : UIViewController
@property(nonatomic,strong)NSArray *addressList;
@property (nonatomic,copy) void (^didArrivedBlock)(NSString *navigationString);

@end

NS_ASSUME_NONNULL_END
