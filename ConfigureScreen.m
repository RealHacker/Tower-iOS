//
//  ConfigureScreen.m
//  Towers
//
//  Created by 雷 王 on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ConfigureScreen.h"
#import "GameScreen.h"

@implementation ConfigureScreen

@synthesize gridCount;
@synthesize difficulty;

+ (CCScene *)scene
{
    static CCScene * singleton = nil;
    if (singleton == nil) {
        singleton = [CCScene node];
        [singleton retain];
        ConfigureScreen* screen = [[ConfigureScreen alloc] init];
        [singleton addChild:screen];
    }
    return singleton;
}

- (id) init
{
    if (self = [super init]) {
        self.gridCount = -1;
        CGSize winSize = [[CCDirector sharedDirector]winSize];
        
        CCSprite* background = [ResourceLoader sharedLoader].configureBackground;
        [background setPosition:ccp(0,0)];
        [background setAnchorPoint:ccp(0,0)];
        [self addChild:background];
        
        CCSprite* template = [ResourceLoader sharedLoader].configureTemplate;
        [template setPosition:ccp(0,0)];
        [template setAnchorPoint:ccp(0,0)];
        [self addChild:template];
        
        numberSprites = [NSMutableArray array];
        [numberSprites retain];
        numberTickedSprites = [NSMutableArray array];
        [numberTickedSprites retain];
        
        
        gridSizeMenu = [CCMenu menuWithItems: nil];
        for (int i=0; i<5; i++) {
            CCSpriteFrame* numberFrame = [[ResourceLoader sharedLoader].GridSizeSpriteFrames objectAtIndex:i];
            CCSpriteFrame* numberTickedFrame = [[ResourceLoader sharedLoader].GridSizeTickedSpriteFrames objectAtIndex:i];
            
            CCSprite* number = [CCSprite spriteWithSpriteFrame:numberFrame];
            [numberSprites addObject:number];
            CCSprite* numberTicked = [CCSprite spriteWithSpriteFrame:numberTickedFrame];
            [numberTickedSprites addObject:numberTicked];
            
            CCMenuItem* numberItem = [CCMenuItemSprite itemFromNormalSprite:number 
                                                             selectedSprite:numberTicked 
                                                                     target:self
                                                                   selector:@selector(gridSelected:)];
            numberItem.tag = i;
            [gridSizeMenu addChild:numberItem];
        }
        [gridSizeMenu alignItemsHorizontallyWithPadding: 20];
        [gridSizeMenu setAnchorPoint:ccp(0.5,0.5)];
        [gridSizeMenu setPosition:ccp(winSize.width/2, 340)];
        [self addChild:gridSizeMenu];
        
        
        easyLabel = [CCSprite spriteWithSpriteFrame:[ResourceLoader sharedLoader].easyFrame];
        [easyLabel retain];
        easySelectedLabel = [CCSprite spriteWithSpriteFrame:[ResourceLoader sharedLoader].easySelectedFrame];
        [easySelectedLabel retain];
        hardLabel = [CCSprite spriteWithSpriteFrame:[ResourceLoader sharedLoader].hardFrame];
        [hardLabel retain];
        hardSelectedLabel = [CCSprite spriteWithSpriteFrame:[ResourceLoader sharedLoader].hardSelectedFrame];
        [hardSelectedLabel retain];
        
        CCMenuItem* easyItem = [CCMenuItemSprite itemFromNormalSprite:easyLabel 
                                                       selectedSprite:easySelectedLabel 
                                                               target:self selector:@selector(levelSelected:)];
        easyItem.tag = 0;
        CCMenuItem* hardItem = [CCMenuItemSprite itemFromNormalSprite:hardLabel 
                                                       selectedSprite:hardSelectedLabel 
                                                               target:self selector:@selector(levelSelected:)];
        hardItem.tag = 1;
        levelMenu = [CCMenu menuWithItems: easyItem,hardItem, nil];
        [levelMenu alignItemsHorizontallyWithPadding:30.0];
        [levelMenu setAnchorPoint:ccp(0.5,0.5)];
        [levelMenu setPosition:ccp(winSize.width/2, 220)];
        levelMenu.isTouchEnabled = false;
        [self addChild:levelMenu];
        
        CCMenuItem* keyItem = [CCMenuItemImage itemFromNormalImage:@"Key.png" 
                                                     selectedImage:@"Key.png" 
                                                            target:self selector:@selector(buyKey:)];
        keyItem.tag = 0;
        CCMenuItem* powerkeyItem = [CCMenuItemImage itemFromNormalImage:@"PowerKey.png" 
                                                     selectedImage:@"PowerKey.png" 
                                                            target:self selector:@selector(buyKey:)];
        keyItem.tag = 1;
        storeMenu = [CCMenu menuWithItems:keyItem, powerkeyItem, nil];
        [storeMenu alignItemsHorizontallyWithPadding:30.0];
        [storeMenu setAnchorPoint:ccp(0.5,0.5)];
        [storeMenu setPosition:ccp(winSize.width/2, 100)];
        [self addChild:storeMenu];
        
        go = [CCSprite spriteWithSpriteFrame:[ResourceLoader sharedLoader].goFrame];
        //CCMenuItem* goItem = [CCMenuItemSprite itemFromNormalSprite:go 
          //                                           selectedSprite:nil
            //                                                 target:self selector:@selector(enterGame)];
        //goMenu = [CCMenu menuWithItems:goItem, nil];
        //[goMenu alignItemsHorizontally];
        [go setAnchorPoint:ccp(1,0)];
        [go setPosition:ccp(winSize.width, 0)];
        [self addChild:go];
        go.visible = false;
        
        self.isTouchEnabled = true;
    }
    return self;
}

- (void) goBounce
{
    CCJumpTo * action = [CCJumpTo actionWithDuration:2 position:go.position height:10 jumps:3];
    [go runAction:action];
}
- (void) gridSelected:(CCMenuItem*) item
{
    int tag = item.tag;
    //If the item is locked, flash the corresponding key 
    //First reset the menu item ticked states
    for (int i=0; i<5; i++) {
        if (i==tag) {
            CCSpriteFrame* tickedframe = [[ResourceLoader sharedLoader].GridSizeTickedSpriteFrames objectAtIndex:i];
            [[numberSprites objectAtIndex:i] setDisplayFrame:tickedframe];
        } else{
            CCSpriteFrame* frame = [[ResourceLoader sharedLoader].GridSizeSpriteFrames objectAtIndex:i];
            [[numberSprites objectAtIndex:i] setDisplayFrame:frame];
        }
    }
    if (tag ==0 || tag==1) { //No hard levels
        levelMenu.isTouchEnabled = false;
        
        CCSpriteFrame* easyFrame = [ResourceLoader sharedLoader].easySelectedFrame;
        [easyLabel setDisplayFrame:easyFrame];
        CCSpriteFrame* hardFrame = [ResourceLoader sharedLoader].crossFrame;
        [hardLabel setDisplayFrame:hardFrame];
        
        go.visible = true;
        [self goBounce];
        
        self.difficulty = @"EASY";
    }else{
        levelMenu.isTouchEnabled = true;
        
        CCSpriteFrame* easyFrame = [ResourceLoader sharedLoader].easyFrame;
        [easyLabel setDisplayFrame:easyFrame];
        CCSpriteFrame* hardFrame = [ResourceLoader sharedLoader].hardFrame;
        [hardLabel setDisplayFrame:hardFrame];
        
        go.visible = false;
        
    }
    self.gridCount = tag+4;
    
}

- (void) levelSelected: (CCMenuItem*) item
{
    if (self.gridCount == -1) {
        return;
    }
    if (item.tag ==0) {
        CCSpriteFrame* easySelectedFrame = [ResourceLoader sharedLoader].easySelectedFrame;
        [easyLabel setDisplayFrame:easySelectedFrame];
        CCSpriteFrame* hardFrame = [ResourceLoader sharedLoader].hardFrame;
        [hardLabel setDisplayFrame:hardFrame];
        
        self.difficulty = @"EASY";
    } else{
        CCSpriteFrame* easyFrame = [ResourceLoader sharedLoader].easyFrame;
        [easyLabel setDisplayFrame:easyFrame];
        CCSpriteFrame* hardSelectedFrame = [ResourceLoader sharedLoader].hardSelectedFrame;
        [hardLabel setDisplayFrame:hardSelectedFrame];
        
        self.difficulty = @"HARD";
    }
    //enable Go
    go.visible = true;
    [self goBounce];
}

-(void) buyKey:(CCMenuItem*) item
{
    
}
-(void) enterGame
{
    CCScene* gameScene = [GameScreen sceneWithCount:self.gridCount Difficulty:self.difficulty];
    CCTransitionPageTurn* pageTurn = [CCTransitionPageTurn transitionWithDuration:1 scene:gameScene backwards:NO];
    [[CCDirector sharedDirector] replaceScene:pageTurn];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector]convertToGL:location];
    
    //Pass down to children
    CGRect rightRect = CGRectMake(winSize.width - 60, 0 , 60, 60);
    
    if (go.visible && CGRectContainsPoint(rightRect, location)){
        [self enterGame];
    }
}

@end
