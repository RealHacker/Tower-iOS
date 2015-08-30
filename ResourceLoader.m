//
//  ResourceLoader.m
//  Towers
//
//  Created by 雷 王 on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ResourceLoader.h"
#import "GameState.h"

@implementation ResourceLoader

@synthesize delegate;
@synthesize GridSizeSpriteFrames;
@synthesize GridSizeTickedSpriteFrames;
@synthesize easyFrame;
@synthesize easySelectedFrame;
@synthesize hardFrame;
@synthesize hardSelectedFrame;
@synthesize crossFrame;
@synthesize goFrame;
@synthesize configureTemplate;
@synthesize configureBackground;
@synthesize statsTemplate;
@synthesize adView;


+(ResourceLoader *)sharedLoader
{
    static ResourceLoader* shared = nil;
    if (!shared) {
        shared = [[ResourceLoader alloc] init];
    }
    return shared;
}

-(id) init
{
    return [super init];
}

- (void)loadResources
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"config.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"numbers.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"arrows.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"mainbuttons.plist"];
    
    self.GridSizeSpriteFrames = [NSMutableArray array];
    self.GridSizeTickedSpriteFrames = [NSMutableArray array];
    
    //grid size sprites
    for (int i=0;i<5; i++) {
        CCSpriteFrame* number = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                                 spriteFrameByName:[NSString stringWithFormat:@"grid%d.png",i+4]];
        CCSpriteFrame* numberTicked = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                                       spriteFrameByName:[NSString stringWithFormat:@"grid%d-ticked.png",i+4]];
        [self.GridSizeSpriteFrames addObject:number];
        [self.GridSizeTickedSpriteFrames  addObject:numberTicked];
    }
    //easy/hard
    self.easyFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                      spriteFrameByName:@"easy.png"];
    self.easySelectedFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                      spriteFrameByName:@"easy-chosen.png"];
    self.hardFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                      spriteFrameByName:@"hard.png"];
    self.hardSelectedFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                              spriteFrameByName:@"hard-chosen.png"];
    
    //Cross and go
    self.goFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Go.png"];
    self.crossFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Cross.png"];
    
    self.configureBackground  = [CCSprite spriteWithFile:@"bg.png"];
    self.configureTemplate = [CCSprite spriteWithFile:@"ConfigureTitles.png"];
    
    self.statsTemplate = [CCSprite spriteWithFile:@"statsTemplate.png"];
    
    [[GameState sharedState] loadFromDisk];
    
    self.adView = [GameAdView sharedAdView];
    //[self.delegate loadingDone];
    
}
@end
