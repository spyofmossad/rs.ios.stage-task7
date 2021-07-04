//
//  AppDelegate.m
//  RsTask7
//
//  Created by Dzmitry Navitski on 01.07.2021.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen.mainScreen bounds]];
    window.rootViewController = [[LoginViewController alloc] init];
    self.window = window;
    [window makeKeyAndVisible];
    return YES;
}

@end
