//
//  AppDelegate.m
//  GBMap
//
//  Created by Даниил Мурыгин on 27.10.2020.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    CGRect frame = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:frame];
    
    UINavigationController *rootController = [[UINavigationController alloc] init];
    rootController.view.backgroundColor = [UIColor grayColor];
    
    self.window.rootViewController = rootController;
    
    ViewController *anotherController = [[ViewController alloc] init];
    anotherController.view.backgroundColor = [UIColor purpleColor];
    [rootController showViewController:anotherController sender:self];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
