//
//  AppDelegate.h
//  Towers
//
//  Created by 雷 王 on 12-2-23.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate, FBSessionDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) Facebook* facebook;


@end
