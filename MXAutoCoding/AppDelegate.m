//
//  AppDelegate.m
//  MXAutoCoding
//
//  Created by Max on 2017/4/27.
//  Copyright © 2017年 maxzhang. All rights reserved.
//

#import "AppDelegate.h"
#import "MXViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    MXViewController *vc = [[MXViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
