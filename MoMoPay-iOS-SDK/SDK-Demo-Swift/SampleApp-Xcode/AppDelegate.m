//
//  AppDelegate.m
//  SampleApp-Xcode
//
//  Created by Luu Lanh on 11/11/15.
//  Copyright © 2015 LuuLanh. All rights reserved.
//

#import "AppDelegate.h"
#import "MoMoPaySDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Override point for customization after application launch.
    [MoMoPaySDK initializingAppBundleId:@"com.abcFoody.LuckyLuck" 
                           merchantCode:@"SCB01"
                           merchantName:@"CGV"
                      merchantNameLabel:@"Nhà cung cấp"
                      merchantPublicKey:@"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAip7E4c5ylxCsH+g/GMco4/6/nhc1rqZGhGzk0E3cT11OQUeQ9F1rRGML3mk9FAirzzwjsrndxdJaOZTj8xFsxPmBf8j46oac7PgbOL9i/veDDDjUIFITPa+BRzL6DIUXG0PasiU6CLgpCKPUHZLIi7ZedAruWUideIbRoaBuzpaqDuuMqFeLiIapJj6TaAwllS1EwcZyvAD+jRBDsiOnOMRz/KvJZxZ957TtaUVn+UzBDhrYsIMpt8rcFxIFkZBgpgfWbvVaP3nLyWuUrrJMSdNsslnUlOlmfCz2JtIAq3711hfXxYhkY5FjdJwTK5HJEVrUqtC3CPUJG1STNlo1IwIDAQAB"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [[MoMoPayment shareInstant] handleOpenUrl:url];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]){ // Check it's iOS 8 and above
        
        UIUserNotificationSettings *grantedSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
        if (grantedSettings.types == UIUserNotificationTypeNone) {
            NSLog(@"No permiossion granted");
        }
        else if (grantedSettings.types & UIUserNotificationTypeSound & UIUserNotificationTypeAlert ){
            NSLog(@"Sound and alert permissions ");
        }
        else if (grantedSettings.types  & UIUserNotificationTypeAlert){
            NSLog(@"Alert Permission Granted");
        }
    }
    
    
    
}

@end
