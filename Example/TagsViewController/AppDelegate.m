//
//  AppDelegate.m
//  TagsViewController
//
//  Created by Mingenesis on 16/6/24.
//
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[MainViewController alloc] initWithNibName:nil bundle:nil];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
