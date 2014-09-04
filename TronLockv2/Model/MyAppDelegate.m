//
//  MyAppDelegate.m
//  TronLockv2
//
//  Created by Hanlon Miller on 8/14/14.
//  Copyright (c) 2014 Hanlon Miller Inc. All rights reserved.
//

#import "MyAppDelegate.h"
#import "Model/HMLockitron/HMLockitronAccount.h"

@implementation MyAppDelegate
- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    /* Each byte in the data will be translated to its hex value like 0x01 or
     0xAB excluding the 0x part, so for 1 byte, we will need 2 characters to
     represent that byte, hence the * 2 */
    NSMutableString *tokenAsString = [[NSMutableString alloc]
                                      initWithCapacity:deviceToken.length * 2];
    
    char *bytes = malloc(deviceToken.length);
    [deviceToken getBytes:bytes];
    
    for (NSUInteger byteCounter = 0;
         byteCounter < deviceToken.length;
         byteCounter++){
        
        char byte = bytes[byteCounter];
        [tokenAsString appendFormat:@"%02hhX", byte];
    }
    
    free(bytes);
    
    NSLog(@"Token = %@", tokenAsString);
    //[[[UIAlertView alloc] initWithTitle:@"Token" message:[NSString stringWithFormat:@"%@", tokenAsString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//     UIRemoteNotificationTypeAlert |
//     UIRemoteNotificationTypeBadge |
//     UIRemoteNotificationTypeSound];
//    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([url.scheme isEqualToString:@"tronlockv2"]) {
        [HMLockitronAccount handleOpenURL:url];
    }
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
