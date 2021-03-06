//
//  ViewController.m
//  NotificationDemo
//
//  Created by LarryZhang on 2022/1/8.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
}

#pragma mark - Action Methods

- (IBAction)homeButtonPressed:(id)sender {
    [[UIApplication sharedApplication] performSelector:@selector(suspend)];
    
}

- (IBAction)foregroundButtonPressed:(id)sender {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            // Notifications allowed
            [self scheduleLocalNotifications:YES];
        } else {
           // Notifications not allowed
        }
    }];
}

- (IBAction)backgroundButtonPressed:(id)sender {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [[UIApplication sharedApplication] performSelector:@selector(suspend)];
    
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            // Notifications allowed
            [self scheduleLocalNotifications:NO];
        } else {
           // Notifications not allowed
        }
    }];
}

#pragma mark - Custom Methods

- (void)scheduleLocalNotifications:(BOOL)foregroundEnabled {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"Category.Identifier"
                                                                              actions:@[] intentIdentifiers:@[]
                                                                              options:UNNotificationCategoryOptionNone];
    
    if (foregroundEnabled) {
        UNNotificationAction *snoozeAction = [UNNotificationAction actionWithIdentifier:@"Action.Identifier.Snooze"
                                                                                  title:@"Snooze" options:UNNotificationActionOptionNone];
        UNNotificationAction *deleteAction = [UNNotificationAction actionWithIdentifier:@"Action.Identifier.Delete"
                                                                                  title:@"Delete" options:UNNotificationActionOptionDestructive];
        category = [UNNotificationCategory categoryWithIdentifier:@"Category.Identifier"
                                                          actions:@[snoozeAction, deleteAction] intentIdentifiers:@[]
                                                          options:UNNotificationCategoryOptionNone];
    }
    
    NSSet *categories = [NSSet setWithObject:category];
    
    [center setNotificationCategories:categories];
    
    
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = @"Don't forget";
    content.body = @"Buy some milk";
    content.categoryIdentifier = @"Category.Identifier";
    content.sound = [UNNotificationSound defaultSound];
    content.badge = @(0);
    if (foregroundEnabled) {
        content.title = @"Hey";
        content.body = @"Something you should do :)";
    }
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    
    NSString *identifier = @"UNNotificationRequest.Identifier.Background";
    if (foregroundEnabled) {
        identifier = @"UNNotificationRequest.Identifier.Foreground";
    }
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Something went wrong: %@", error);
        }
    }];
}



- (void)localNotification {
    
    // ????????????
    NSString *identifier = @"request41";
    // ?????????????????????????????????????????????
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    // ???????????????
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.badge = [NSNumber numberWithInt:1];
    content.title = @"??????";
    content.body = @"?????????";
    content.sound = [UNNotificationSound defaultSound];
    content.badge = @(0);
    // ????????????????????????

    //UNTimeIntervalNotificationTrigger   ????????????
    //UNCalendarNotificationTrigger       ????????????
    //UNLocationNotificationTrigger       ??????????????????
    // ?????????????????????10s???????????????(???????????????????????????????????????60s)
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
    // ????????????
    //NSDateComponents *dateCom = [[NSDateComponents alloc] init];
    // ????????????3???10?????????
    // dateCom.hour = 15;
    // dateCom.minute = 10;
    // UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateCom repeats:YES];

    // ??????????????????
    UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    // ?????????????????????????????????????????????
    [center addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {

        if (error) {
              NSLog(@"%@???????????? :( ?????? %@",identifier,error);
        }else{
              NSLog(@"????????????????????????????????? Success");
        }
    }];
}

@end
