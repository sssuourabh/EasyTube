//
//  ETubeAppDelegate.m
//  EasyTube
//
//  Created by Sourabh Shekhar Singh on 19/11/12.
//  Copyright (c) 2012 XCS Technologies. All rights reserved.
//

#import "ETubeAppDelegate.h"

@implementation ETubeAppDelegate
@synthesize TabBarController;
@synthesize ApplicationDidFinishLaunching;
@synthesize NetworkActivityCounter;
@synthesize TabBarItemDownloadsBadgeValue;


#pragma mark Utility methods

- (void)updateNetworkActivity {
	if (self.ApplicationDidFinishLaunching) {
		if (self.NetworkActivityCounter == 0) {
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		} else {
			[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		}
	}
}

- (void)updateTabBarItemDownloadsBadgeValue {
	static NSUInteger const TAB_BAR_ITEM_DOWNLOADS = 1;
    
	if (self.ApplicationDidFinishLaunching) {
		UITabBarItem *item = [self.TabBarController.tabBar.items objectAtIndex:TAB_BAR_ITEM_DOWNLOADS];
        
		if (item != nil) {
			item.badgeValue = TabBarItemDownloadsBadgeValue;
		}
	}
}

#pragma mark NSNotification methods

- (void)notificationsHandler:(NSNotification *)notification {
	if ([[notification name] isEqualToString:@"LoadTubeAppDelegate NetworkActivityStarted"]) {
		self.NetworkActivityCounter++;
        
		[self updateNetworkActivity];
	} else if ([[notification name] isEqualToString:@"LoadTubeAppDelegate NetworkActivityEnded"]) {
		self.NetworkActivityCounter--;
        
		[self updateNetworkActivity];
	} else if ([[notification name] isEqualToString:@"LoadTubeAppDelegate SetDownloadsCount"]) {
		if ([notification object] != nil) {
			self.TabBarItemDownloadsBadgeValue = [NSString stringWithString:[notification object]];
		} else {
			self.TabBarItemDownloadsBadgeValue = nil;
		}
        
		[self updateTabBarItemDownloadsBadgeValue];
	}
}

#pragma mark UIApplicationDelegate methods

- (id)init {
	if((self = [super init])) {
		ApplicationDidFinishLaunching = NO;
		NetworkActivityCounter        = 0;
		TabBarItemDownloadsBadgeValue = nil;
        
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationsHandler:) name:@"LoadTubeAppDelegate NetworkActivityStarted" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationsHandler:) name:@"LoadTubeAppDelegate NetworkActivityEnded"   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationsHandler:) name:@"LoadTubeAppDelegate SetDownloadsCount"      object:nil];
	}
	return self;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self updateNetworkActivity];
	[self updateTabBarItemDownloadsBadgeValue];

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
