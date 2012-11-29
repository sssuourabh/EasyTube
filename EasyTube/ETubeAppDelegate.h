//
//  ETubeAppDelegate.h
//  EasyTube
//
//  Created by Sourabh Shekhar Singh on 19/11/12.
//  Copyright (c) 2012 XCS Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETubeAppDelegate : UIResponder <UIApplicationDelegate>
{
@private
    UITabBarController *TabBarController;
    
    BOOL               ApplicationDidFinishLaunching;
	NSUInteger         NetworkActivityCounter;
	NSString           *TabBarItemDownloadsBadgeValue;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UITabBarController *TabBarController;
@property (nonatomic, assign)          BOOL               ApplicationDidFinishLaunching;
@property (nonatomic, assign)          NSUInteger         NetworkActivityCounter;
@property (nonatomic, strong)          NSString           *TabBarItemDownloadsBadgeValue;

@end
