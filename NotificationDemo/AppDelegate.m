//
//  AppDelegate.m
//  NotificationDemo
//
//  Created by LarryZhang on 2022/1/8.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSLog(@"%s launchOptions:%@", __func__, launchOptions);
    
    [self configureLocalNotification];

    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

#pragma mark - UNUserNotificationCenterDelegate Methods

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        NSLog(@"");
    } else {
        //应用处于前台时的本地推送接受
        
        if ([notification.request.identifier isEqualToString:@"UNNotificationRequest.Identifier.Foreground"]) {
            // Play sound and show alert to the user
            completionHandler(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert);
        }
    }
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
    } else {
        //应用处于后台时的本地推送接受
        if ([response.notification.request.identifier isEqualToString:@"UNNotificationRequest.Identifier.Foreground"]) {
            
            if ([response.actionIdentifier isEqualToString:@"Action.Identifier.Snooze"]) {
                NSLog(@"Action.Identifier.Snooze");
            } else if ([response.actionIdentifier isEqualToString:@"Action.Identifier.Delete"]) {
                NSLog(@"Action.Identifier.Delete");
            } else {
                NSLog(@"response:%@", response);
            }
        }
        
    }
    
    
    completionHandler();
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(nullable UNNotification *)notification {
    NSLog(@"%s notification:%@", __func__, notification);
}

#pragma mark - Custom Methods

- (void)configureLocalNotification {
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        NSLog(@"granted:%d, error:%@", granted, error);
    }];
    
}
@end
