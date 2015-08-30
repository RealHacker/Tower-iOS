//
//  GameAdView.m
//  Towers
//
//  Created by 雷 王 on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameAdView.h"

@implementation GameAdView

@synthesize currentGameScreen;
@synthesize iAdView;
@synthesize isAdReady;
@synthesize isAdVisible;
@synthesize inGame;

+ (GameAdView *)sharedAdView
{
    static GameAdView* singleton = nil;
    if (singleton == nil) {
        singleton = [[GameAdView alloc] init];
        [singleton retain];
    }
    return singleton;
}

- (id) init
{
    if(self = [super init])
    {
        [self createBanner];
        self.inGame = NO;
        self.currentGameScreen = nil;
    }
    return self;
}
- (void)dealloc
{
    [self removeBanner];
    [super dealloc];
}
- (void) showBanner
{
    if (!self.isAdVisible) {

    [UIView beginAnimations:@"showBanner" context:nil];
    //Move the ad up
    self.iAdView.frame = CGRectOffset(self.iAdView.frame, 0, - self.iAdView.frame.size.height);
    [UIView commitAnimations];
    self.isAdVisible = YES;
    }
}
- (void) hideBanner
{
    if (self.isAdVisible) {

    [UIView beginAnimations:@"hideBanner" context:nil];
    //Move the ad up
    self.iAdView.frame = CGRectOffset(self.iAdView.frame, 0, self.iAdView.frame.size.height);
    [UIView commitAnimations];
    self.isAdVisible = NO;
    }
}
- (void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    //show the banner view
    self.isAdReady = YES;
    if (self.inGame) {
        [self showBanner];
    }
}
- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    //hide the banner view
    self.isAdReady = NO;
    if (self.isAdVisible) {
        [self hideBanner];
    }
    //or use Admob
}
- (BOOL) bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    //When touched, pause the game, if leave game, save the game
    if (!self.currentGameScreen) {
        return YES;
    }
    [self.currentGameScreen.timer pause];
    if (willLeave) {
        [self.currentGameScreen saveGame];
    }
    return YES;
}
- (void) bannerViewActionDidFinish:(ADBannerView *)banner
{
    if (!self.currentGameScreen) {
        return ;
    }
    //resume the game
    [self.currentGameScreen.timer run];
}


- (void) createBanner
{
    if (!self.iAdView) {
        self.iAdView = [[ADBannerView alloc] initWithFrame:CGRectZero];
        self.iAdView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        //move the iAdView below the bottom
        CGRect rect = self.iAdView.frame;
        rect.origin.y = [[CCDirector sharedDirector] openGLView].frame.size.height;
        self.iAdView.frame = rect;
        [[[CCDirector sharedDirector] openGLView] addSubview:self.iAdView];
        self.iAdView.delegate = self;
        self.isAdReady = NO;
        self.isAdVisible = NO;
    }
}
- (void) removeBanner
{
    if(self.iAdView){
        [self.iAdView removeFromSuperview];
        self.iAdView.delegate = nil;
        [self.iAdView release];
        self.isAdReady = NO;
        self.isAdVisible = NO;
    }
}


@end
