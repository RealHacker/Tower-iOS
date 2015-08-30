//
//  GameAdView.h
//  Towers
//
//  Created by 雷 王 on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/ADBannerView.h>
#import "GameScreen.h"

@interface GameAdView : NSObject<ADBannerViewDelegate>

@property (nonatomic, retain) ADBannerView* iAdView;
@property (nonatomic) BOOL isAdReady;
@property (nonatomic) BOOL isAdVisible;
@property (nonatomic) BOOL inGame;
@property (nonatomic, retain) GameScreen* currentGameScreen;

+ (GameAdView*) sharedAdView;

- (void) createBanner;
- (void) removeBanner;
- (void) showBanner;
- (void) hideBanner;

@end
