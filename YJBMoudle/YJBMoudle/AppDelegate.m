//
//  AppDelegate.m
//  YJBMoudle
//
//  Created by YUJIABO on 2019/4/3.
//  Copyright © 2019 YUJIABO. All rights reserved.
//

#import "AppDelegate.h"
#import "ShopProtocol.h"
#import "MeProtocol.h"
#import "HomeModuleProtocol.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Home组件
    id <HomeModuleProtocol> homeMoudle = [PWRouter interfaceForProtocol:@protocol(HomeModuleProtocol)];
    homeMoudle.paramterForHome = @"MoudleHome";
    UIViewController *homeViewController = [homeMoudle interfaceViewController];
    UINavigationController *homeNavi = [[UINavigationController alloc]initWithRootViewController:homeViewController];
    homeViewController.title = @"protrocol-class调用示例";
    homeNavi.tabBarItem.title = @"首页";
    homeNavi.tabBarItem.image = [UIImage imageNamed:@"office"];
    homeNavi.tabBarItem.selectedImage = [UIImage imageNamed:@"officeS"];
    
    //Shop组件
    id <ShopProtocol>shopMoudle = [PWRouter interfaceForProtocol:@protocol(ShopProtocol)];
    UIViewController *shopViewConterller = [shopMoudle interfaceViewController];
    UINavigationController *shopNavi = [[UINavigationController alloc]initWithRootViewController:shopViewConterller];
    shopViewConterller.title = @"url-protocol调用示例";
    shopNavi.tabBarItem.title = @"商店";
    shopNavi.tabBarItem.image = [UIImage imageNamed:@"imessage"];
    shopNavi.tabBarItem.selectedImage = [UIImage imageNamed:@"imessageS"];
    
    // Me组件
    id <MeProtocol>meMoudle = [PWRouter interfaceForProtocol:@protocol(MeProtocol)];
    UIViewController *meViewConterller = [meMoudle interfaceViewController];
    UINavigationController *meNavi = [[UINavigationController alloc]initWithRootViewController:meViewConterller];
    meViewConterller.title = @"url-action调用示例";
    meNavi.tabBarItem.title = @"个人";
    meNavi.tabBarItem.image = [UIImage imageNamed:@"me"];
    meNavi.tabBarItem.selectedImage = [UIImage imageNamed:@"meS"];
    // tabbr和window
    UITabBarController *tabbarController = [[UITabBarController alloc]init];
    tabbarController.hidesBottomBarWhenPushed = YES;
    tabbarController.viewControllers = @[homeNavi,shopNavi,meNavi];
    self.window.rootViewController = tabbarController;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
