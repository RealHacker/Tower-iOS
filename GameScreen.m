//
//  GameScreen.m
//  Towers
//
//  Created by 雷 王 on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameScreen.h"
#import "HelpScreen.h"
#import "ScoreBoard.h"
#import "GameAdView.h"
#import "MainScreen.h"
#import "GameState.h"

@implementation GameScreen

@synthesize game = _game;
@synthesize picker = _picker;
@synthesize difficulty = _difficulty;
@synthesize gridSize = _gridSize;
@synthesize mode = _mode;
@synthesize selector = _selector;
@synthesize timer = _timer;
@synthesize refreshButton = _refreshButton;
@synthesize backButton = _backButton;
@synthesize bottomMenu = _bottomMenu;
@synthesize resumed = _resumed;

+(CCScene *) sceneWithCount:(int)count Difficulty:(NSString *)difficulty
{
    CCScene* scene = [CCScene node];
        
    GameDifficulty diff;
        if ([difficulty isEqualToString: @"EASY"]) {
            diff = EASY;
        } else {
            diff = HARD;
        }
	
    GameScreen *layer = [[GameScreen alloc] initWithDifficulty:diff Size:count];
        
    [scene addChild:layer];
    
	return scene;
}


- (id) initWithDifficulty:(GameDifficulty) diff Size:(int)gridSize
{
    //use gridSize -1 to mark resumed game

    if (self = [super init]) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        if (gridSize == -1) {
            self.resumed = YES;
            self.gridSize = [GameState sharedState].gameGridSize;
            NSString* level = [GameState sharedState].gameLevel;
            if ([level isEqualToString:@"EASY"]) {
                self.difficulty = EASY;
            } else {
                self.difficulty = HARD;
            }
        } else {
            self.resumed = NO;
            self.gridSize = gridSize;
            self.difficulty = diff;
        }
        //First add the background image
        CCSprite* background = [CCSprite spriteWithFile:@"bg.png"];
        background.position = CGPointMake(0, 0);
        background.anchorPoint = CGPointMake(0, 0);
        [self addChild:background];
                
        self.backButton = [CCSprite spriteWithSpriteFrameName:@"arrow.png"];
        self.backButton.scale = 0.6;
        self.backButton.anchorPoint = CGPointMake(0, 1);
        self.backButton.position = CGPointMake(0, SCREENHEIGHT);
        [self addChild:self.backButton];
        
        if (self.resumed) {
            int min = [GameState sharedState].timerMinutes;
            int sec = [GameState sharedState].timerSeconds;
            self.timer = [[TimerSprite alloc] initWithMinute:min Second:sec];
        } else{
            self.timer = [[TimerSprite alloc] initWithMinute:0 Second:0];
        }
        self.timer.position = CGPointMake(winSize.width/2, SCREENHEIGHT);
        self.timer.anchorPoint = CGPointMake(0.5, 1);
        [self addChild:self.timer];
        [self.timer run];
        
        self.refreshButton = [CCSprite spriteWithSpriteFrameName:@"refresh.png"];
        self.refreshButton.scale = 0.6;
        self.refreshButton.position = CGPointMake(SCREENWIDTH, SCREENHEIGHT);
        self.refreshButton.anchorPoint = CGPointMake(1, 1);
        [self addChild:self.refreshButton];
        
        if (self.resumed) {
            self.game = [[GameSprite alloc] initWithGameDifficulty:self.difficulty size:self.gridSize fromDisk:YES];
        } else{
            self.game = [[GameSprite alloc] initWithGameDifficulty:diff size:gridSize];
        }
        self.game.position = CGPointMake(GAMEMARGIN, SCREENHEIGHT - TITLEBARHEIGHT - GAMEWIDTH);
        self.game.anchorPoint = CGPointMake(0, 0);
        self.game.delegate = self;
        [self addChild:self.game];
        
        self.picker = [[PickerSprite alloc] initWithGridSize:self.gridSize];
        self.picker.position = CGPointMake(GAMEMARGIN+MODEWIDTH, SCREENHEIGHT -TITLEBARHEIGHT- GAMEWIDTH - GAMEMARGIN - PICKERHEIGHT);
        self.picker.anchorPoint = CGPointMake(0, 0);
        self.picker.delegate = self;
        [self addChild:self.picker];
        
        self.selector = [[ModeSprite alloc] initWithMode:NORMAL];
        self.selector.position = CGPointMake(GAMEMARGIN, SCREENHEIGHT -TITLEBARHEIGHT- GAMEWIDTH - GAMEMARGIN/2- PICKERHEIGHT);
        self.selector.anchorPoint = CGPointMake(0, 0);
        self.selector.delegate = self;
        [self addChild:self.selector];
        
        CCSprite* helpSprite = [CCSprite spriteWithSpriteFrameName:@"helpItem.png"];
        CCSprite* helpSpritePressed = [CCSprite spriteWithSpriteFrameName:@"helpItem.png"];
        helpSpritePressed.scale = 0.8;
        CCMenuItem* helpItem = [CCMenuItemSprite itemFromNormalSprite:helpSprite 
                                                       selectedSprite:helpSpritePressed 
                                                               target:self selector:@selector(goToHelp)];
        CCSprite* shareSprite = [CCSprite spriteWithSpriteFrameName:@"shareItem.png"];
        CCSprite* shareSpritePressed = [CCSprite spriteWithSpriteFrameName:@"shareItem.png"];
        shareSpritePressed.scale = 0.8;
        CCMenuItem* shareItem = [CCMenuItemSprite itemFromNormalSprite:shareSprite 
                                                       selectedSprite:shareSpritePressed 
                                                               target:self selector:@selector(shareOnFacebook)];
        CCSprite* statsSprite = [CCSprite spriteWithSpriteFrameName:@"statsItem.png"];
        CCSprite* statsSpritePressed = [CCSprite spriteWithSpriteFrameName:@"statsItem.png"];
        statsSpritePressed.scale = 0.8;
        CCMenuItem* statsItem = [CCMenuItemSprite itemFromNormalSprite:statsSprite 
                                                        selectedSprite:statsSpritePressed 
                                                                target:self selector:@selector(goToStats)];
        self.bottomMenu = [CCMenu menuWithItems:helpItem, shareItem, statsItem, nil];
        [self.bottomMenu alignItemsHorizontallyWithPadding:40.0];
        [self.bottomMenu setAnchorPoint:CGPointMake(0.5, 0.5)];
        [self.bottomMenu setPosition:CGPointMake(SCREENWIDTH/2, 
                                                 SCREENHEIGHT -TITLEBARHEIGHT- GAMEWIDTH - GAMEMARGIN - PICKERHEIGHT - MENUHEIGHT/2)];
        [self addChild:self.bottomMenu];

        self.mode = NORMAL;
        self.isTouchEnabled = YES;
        
        GameAdView* ad = [GameAdView sharedAdView];
        ad.inGame = YES;
        ad.currentGameScreen = self;
        if (ad.isAdReady) {
            [ad showBanner];
        }
        [self schedule:@selector(timeUpdate:) interval:10.0];
    }
    return self;
}
- (void)dealloc
{
    GameAdView* ad = [GameAdView sharedAdView];
    ad.inGame = NO;
    ad.currentGameScreen = nil;
    if (ad.isAdVisible) {
        [ad hideBanner];
    }

    [super dealloc];
}
- (void) timeUpdate: (ccTime) delta
{
    [self saveGame];
}
- (void) goToHelp
{    
    HelpScreen* screen = [[[HelpScreen scene] children] objectAtIndex:0];
    screen.fromGame = YES;
    CCScene* helpScene = [HelpScreen scene];
    CCTransitionPageTurn* pageTurn = [CCTransitionPageTurn transitionWithDuration:1 scene:helpScene backwards:YES];
    [[CCDirector sharedDirector]pushScene:pageTurn];
}
- (void) goToStats
{
    CCScene* statsScene = [ScoreBoard scene];
    CCTransitionPageTurn* pageTurn = [CCTransitionPageTurn transitionWithDuration:1 scene:statsScene backwards:NO];
    [[CCDirector sharedDirector] pushScene:pageTurn];
}
- (void) shareOnFacebook
{
    UIImage* gameImage = [self.game convertToImage];
    //If unfinished
    NSString* shareString = @"Help me with this Towers puzzle, it is hard.";
    
    Facebook* fb = [[[UIApplication sharedApplication] delegate] facebook];
    
    NSMutableDictionary* photoParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        gameImage,@"source",
                                        shareString,@"message", nil];
    if(![fb isSessionValid]){
        [fb authorize:[NSArray arrayWithObjects:@"publish_actions",@"publish_stream", @"user_photos", nil]];
    } else {
        [fb requestWithGraphPath:@"me/photos" 
                       andParams:photoParams 
                   andHttpMethod:@"POST" 
                     andDelegate:self];
    }

}
- (void)fbDialogLogin:(NSString*)token expirationDate:(NSDate*)expirationDate
{
    
}
- (void)request:(FBRequest *)request didLoad:(id)result {
    
    static BOOL WeiboImagePosted = false;
    Facebook* fb = [[[UIApplication sharedApplication] delegate] facebook];
    
    if ([result isKindOfClass:[NSArray class]] && ([result count] > 0)) {
        result = [result objectAtIndex:0];
    }
    
    if(WeiboImagePosted)
    {
        NSString *imageLink = [NSString stringWithFormat:[result objectForKey:@"link"]];    
        NSLog(imageLink);
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Towers", @"name",
                                       @"It's challenging.", @"caption",
                                       @"Help me with this Towers puzzle", @"description",
                                       @"http://itunes.apple.com", @"link",
                                       //imageLink, @"picture",
                                       imageLink, @"link",
                                       nil];
        WeiboImagePosted = false;
        [fb dialog:@"feed" andParams:params andDelegate:self];
    }else{
        NSString *imageID = [NSString stringWithFormat:[result objectForKey:@"id"]];            
        NSLog(@"id of uploaded screen image %@",imageID);
        [fb requestWithGraphPath:imageID andDelegate:self];
        WeiboImagePosted = true;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.game restart];
        [self.timer resetTimer];
    }
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}
- (void) saveGame
{
    [GameState sharedState].timerMinutes = self.timer.minutes;
    [GameState sharedState].timerSeconds = self.timer.seconds;
        
    [[GameState sharedState] saveToDisk];
}
- (void) refreshGame
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"Refresh Game" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Restart" otherButtonTitles: nil];
    [sheet showInView:[[CCDirector sharedDirector] openGLView]];
    
}
- (void) goBack
{
    [self saveGame];
    
    GameAdView* ad = [GameAdView sharedAdView];
    ad.inGame = NO;
    ad.currentGameScreen = nil;
    if (ad.isAdVisible) {
        [ad hideBanner];
    }
    [[[[MainScreen scene] children] objectAtIndex:0] reset];
    [[CCDirector sharedDirector] popScene];
}
- (void) setMode:(GameMode)mode
{
    _mode = mode;
    self.game.mode = mode;
    if (mode==NORMAL) {
        self.picker.mode = SINGLE;
    } else {
        self.picker.mode = MULTIPLE;
    }
}
- (void) gameSucceeded
{
    [GameState sharedState].hasUnfinishedGame = NO;
    NSLog(@"YOU WIN!");
    //Stop the timer
    [self.timer pause];
    //Get the current timer value
    int minute = self.timer.minutes;
    int second = self.timer.seconds;
    //compare it with score board value
    NSString* gameDiff;
    if(self.difficulty == EASY) {
            gameDiff = @"EASY";
    } else {
        gameDiff = @"DIFFICULT";
    }
            
    NSArray* pair = [[GameScores sharedGameScores] readScoreForDifficulty: gameDiff grid:self.gridSize];
    int oldMinute = [[pair objectAtIndex:0] intValue];
    int oldSecond = [[pair objectAtIndex:1] intValue];
    
    BOOL recordBroken = NO;
    if (oldMinute == 0 && oldSecond == 0) {
        recordBroken = YES;
    }else if (minute < oldMinute || (minute== oldMinute && second <oldSecond)) {
        recordBroken = YES;
    }
    //if it is better, show congratulations, and overwrite score
    if (recordBroken) {
        [[GameScores sharedGameScores] writeScoreMinutes:minute Seconds:second ForDifficulty:gameDiff grid:self.gridSize];
        //Show the congratulations
        NSLog(@"Congratulations, break record!");
    } else{
        //else just show the score
        NSLog(@"Yeah... OK");
    }
    
}
- (void) setPickerValues:(NSMutableArray *)set
{
    self.picker.selected = set;
}

-(void) onPickingNumber:(int)number
{
    if (!self.game.hasFocus) {
        return;
    }
    if (self.mode == NORMAL) {
        if (number==0) {
            [self.game clearNumberAtX:self.game.focusX Y:self.game.focusY];
        }else if ([self.game checkNumber:number AtX:self.game.focusX Y:self.game.focusY]) {
            [self.game enterNumberAtX:self.game.focusX Y:self.game.focusY];
        } 
    } else {
        NSArray* picked = [self.picker.selected allObjects];
        [self.game scratchNumbers:picked AtX:self.game.focusX Y:self.game.focusY];
    }
}
- (void) modeChangedTo:(GameMode)mode
{
    self.mode = mode;
}
- (NSSet*) getCurrentScratchNumbers
{
    return [[self.game.scratch objectAtIndex:self.game.focusY] objectAtIndex:self.game.focusX];
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector]convertToGL:location];
    
    //Pass down to children
    CGRect gameRect = CGRectMake(self.game.position.x, self.game.position.y, GAMEWIDTH, GAMEWIDTH);
    CGRect pickerRect = CGRectMake(self.picker.position.x, self.picker.position.y, PICKERWIDTH, PICKERHEIGHT);
    CGRect modeRect = CGRectMake(self.selector.position.x, self.selector.position.y, MODEWIDTH, MODEWIDTH);
    CGRect topLeftRect = CGRectMake(0, SCREENHEIGHT-TITLEBARHEIGHT, TITLEBARHEIGHT, TITLEBARHEIGHT);
    CGRect topRightRect = CGRectMake(SCREENWIDTH-TITLEBARHEIGHT, SCREENHEIGHT-TITLEBARHEIGHT, TITLEBARHEIGHT, TITLEBARHEIGHT);
    
    if (CGRectContainsPoint(gameRect, location)) {
        [self.game touchGameAtX:(location.x - self.game.position.x) Y:(location.y - self.game.position.y)];
    }else if (CGRectContainsPoint(pickerRect, location)){
        [self.picker touchPickerAtX:(location.x - self.picker.position.x) Y:(location.y - self.picker.position.y)];
    } else if (CGRectContainsPoint(modeRect, location)){
        [self.selector touchSpriteAtX:(location.x - self.selector.position.x) Y:(location.y - self.selector.position.y)];
    } else if( CGRectContainsPoint(topLeftRect, location)){
        [self goBack];
    } else if (CGRectContainsPoint(topRightRect, location)){
        [self refreshGame];
    }
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
- (void) ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
@end
