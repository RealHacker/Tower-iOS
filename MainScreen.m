//
//  MainScreen.m
//  Towers
//
//  Created by 雷 王 on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainScreen.h"
#import "ConfigureScreen.h"
#import "HelpScreen.h"
#import "GameState.h"

@implementation MainScreen


+ (CCScene*) scene
{

        static CCScene* singleton = nil;
        
        if(singleton == nil)
        {
            singleton = [CCScene node];
            [singleton retain];
            MainScreen* main = [[MainScreen alloc] init];
            [singleton addChild:main];
        } 
        return singleton;
}

-(id) init
{
    if(self=[super init])
    {
        [ResourceLoader sharedLoader].delegate = self;
        [[ResourceLoader sharedLoader] loadResources];
        winSize = [[CCDirector sharedDirector] winSize];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"loading.plist"];
        
        CCSprite* bg = [CCSprite spriteWithFile:@"main.png"];
        [bg setPosition:ccp(0,0)];
        [bg setAnchorPoint:ccp(0,0)];
        [self addChild:bg];
        
        logos = [CCSprite spriteWithFile:@"logos2.png"];
        [self addChild:logos];
        [logos setAnchorPoint:ccp(0,0)];
        [logos setPosition:ccp(0, 0)];
        
        NSMutableArray* loadingFrames = [NSMutableArray array];
        [loadingFrames retain];
        for (int i=1; i<=3; i++) {
            NSString* loadingFileName = [NSString stringWithFormat:@"loading%d.png",i];
            CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:loadingFileName];
            [loadingFrames addObject:frame];
        }
        
        loadingSprite = [CCSprite spriteWithSpriteFrameName:@"loading1.png"];
        [loadingSprite setPosition:ccp(winSize.width/2, 100)];
        [loadingSprite setAnchorPoint:ccp(0.5,0.5)];
        [self addChild:loadingSprite];
        
        CCAnimation* ani = [CCAnimation animationWithFrames:loadingFrames delay:0.5];
        CCAnimate* loadingAnimation = [CCAnimate actionWithAnimation:ani];
        [loadingSprite runAction:[CCRepeatForever actionWithAction:loadingAnimation]];
        
        CCSprite* startButton = [CCSprite spriteWithSpriteFrameName: @"Play.png"];
        CCSprite* helpButton = [CCSprite spriteWithSpriteFrameName:@"how.png"];
        CCSprite* startPressed = [CCSprite spriteWithSpriteFrameName:@"Play.png"];
        startPressed.scale = 0.8;
        CCSprite* helpPressed = [CCSprite spriteWithSpriteFrameName:@"how.png"];
        helpPressed.scale = 0.8;
        
        CCMenuItem* item1 = [CCMenuItemImage itemFromNormalSprite:startButton selectedSprite:startPressed target:self selector:@selector(startGame)];
        CCMenuItem* item2 = [CCMenuItemImage itemFromNormalSprite:helpButton selectedSprite:helpPressed target:self selector:@selector(startHelp)];
        menu = [CCMenu menuWithItems:item1, item2, nil];
        [menu alignItemsVerticallyWithPadding:10];
        //[menu setAnchorPoint:ccp(0,0)];
        [menu setPosition:ccp(winSize.width/2, 80)];
        [self addChild:menu];
        menu.visible = false;
       
        CCScaleTo* grow1 = [CCScaleTo actionWithDuration:1 scale:0.9];
        CCScaleTo* shrink1 = [CCScaleTo actionWithDuration:1 scale:1];
        CCSequence* seq1 = [CCSequence actionOne:grow1 two:shrink1];
        CCRepeatForever* repeat1 = [CCRepeatForever actionWithAction:seq1];
        
        CCScaleTo* grow2 = [CCScaleTo actionWithDuration:1 scale:0.9];
        CCScaleTo* shrink2 = [CCScaleTo actionWithDuration:1 scale:1];
        CCSequence* seq2 = [CCSequence actionOne:grow2 two:shrink2];
        CCRepeatForever* repeat2 = [CCRepeatForever actionWithAction:seq2];
        
        [startButton runAction:repeat1];
        [helpButton runAction:repeat2];
        
        CCSprite* newGame = [CCSprite spriteWithSpriteFrameName:@"newGame.png"];
        CCSprite* newGamePressed = [CCSprite spriteWithSpriteFrameName:@"newGame.png"];
        newGamePressed.scale = 0.8;
        CCSprite* resume = [CCSprite spriteWithSpriteFrameName:@"resume.png"];
        CCSprite* resumePressed = [CCSprite spriteWithSpriteFrameName:@"resume.png"];
        resumePressed.scale = 0.8;
        
        CCScaleTo* grow3 = [CCScaleTo actionWithDuration:1 scale:0.9];
        CCScaleTo* shrink3 = [CCScaleTo actionWithDuration:1 scale:1];
        CCSequence* seq3 = [CCSequence actionOne:grow3 two:shrink3];
        CCRepeatForever* repeat3 = [CCRepeatForever actionWithAction:seq3];
        [newGame runAction:repeat3];
        
        CCScaleTo* grow4 = [CCScaleTo actionWithDuration:1 scale:0.9];
        CCScaleTo* shrink4 = [CCScaleTo actionWithDuration:1 scale:1];
        CCSequence* seq4 = [CCSequence actionOne:grow4 two:shrink4];
        CCRepeatForever* repeat4 = [CCRepeatForever actionWithAction:seq4];
        [resume runAction:repeat4];
        
        CCMenuItem* newItem = [CCMenuItemSprite itemFromNormalSprite:newGame 
                                                      selectedSprite:newGamePressed 
                                                              target:self selector:@selector(startNewGame)];
        CCMenuItem* resumeItem = [CCMenuItemSprite itemFromNormalSprite:resume 
                                                         selectedSprite:resumePressed 
                                                                 target:self selector:@selector(resumeGame)];
        subMenu = [CCMenu menuWithItems:newItem, resumeItem, nil];
        [subMenu alignItemsVerticallyWithPadding:10.0];
        subMenu.position = ccp(winSize.width/2, 80);
        subMenu.anchorPoint = ccp(0.5,0.5);
        [self addChild:subMenu];
        subMenu.visible = false;

       
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(loadingDone) userInfo:nil repeats:NO];
    }
    return self;
}

- (void) loadingDone
{
    CCMoveTo* logoMove = [CCMoveTo actionWithDuration:1 position:ccp(0,-45)];
    [logos runAction:logoMove];
    
    [loadingSprite stopAllActions];
    loadingSprite.visible = false;
    
    /*
    CCAction * action = [CCMoveTo actionWithDuration:3 position:ccp(winSize.width/2,80)];
    CCEaseBounceOut* bounce = [CCEaseBounceOut actionWithAction:action];
    [menu runAction:bounce];
     */
    menu.visible = true;

}
- (void) startGame
{
    BOOL hasGame = [GameState sharedState].hasUnfinishedGame;
    
    if (!hasGame) {
        [self startNewGame];
    }else{
        subMenu.visible = true;
        menu.visible = false;
    }
}
- (void) startNewGame
{
    CCScene* next = [CCTransitionPageTurn transitionWithDuration:1 scene: [ConfigureScreen scene] backwards:NO];
    [[CCDirector sharedDirector] pushScene: next];
}
- (void) resumeGame
{
    CCScene* gameScene = [GameScreen sceneWithCount:-1 Difficulty:@""];
    CCTransitionPageTurn* pageTurn = [CCTransitionPageTurn transitionWithDuration:1 scene:gameScene backwards:NO];
    [[CCDirector sharedDirector] pushScene:pageTurn];
}
-(void) startHelp
{
    HelpScreen* screen = [[[HelpScreen scene] children] objectAtIndex:0];
    screen.fromGame = NO;
    CCScene* help = [CCTransitionPageTurn transitionWithDuration:1 scene: [HelpScreen scene] backwards:NO];
    [[CCDirector sharedDirector] pushScene: help];
}

- (void) reset
{
    menu.visible = true;
    subMenu.visible  = false;
}
@end

