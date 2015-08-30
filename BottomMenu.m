//
//  BottomMenu.m
//  Towers
//
//  Created by 雷 王 on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BottomMenu.h"
#import "GameScreen.h"
#import "ScoreBoard.h"


@implementation BottomMenu

@synthesize pageType = _pageType;
@synthesize menu = _menu;

- (id)init
{
    if (self = [super init]) {
        gameLabel = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Game" fontName:@"Marker Felt" fontSize:25] target:self selector:@selector(enterGame)];
        helpLabel = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Help" fontName:@"Marker Felt" fontSize:25] target:self selector:@selector(enterHelp)];
        shareLabel = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Share" fontName:@"Marker Felt" fontSize:25] target:self selector:@selector(enterShare)];
        scoreLabel = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Score" fontName:@"Marker Felt" fontSize:25] target:self selector:@selector(enterScore)];
        self.menu = [CCMenu menuWithItems:gameLabel, helpLabel, shareLabel,scoreLabel, nil];
        [self.menu alignItemsHorizontallyWithPadding:20.0];
        
        WeiboImagePosted = false;
    }
    return self;
}

- (void) enterGame
{
     
    if (self.pageType == GAMEPAGE) {
        NSLog(@"SWITCH TO GAME SCENE");
        return;
    }
   
    [[CCDirector sharedDirector] replaceScene:[GameScreen scene]];
    self.pageType = GAMEPAGE;
}
- (void) enterHelp
{
    self.pageType = HELPPAGE;
}
- (void) enterShare
{
    UIImage* gameImage = [[[[[[CCDirector sharedDirector] runningScene] children] 
                            objectAtIndex:0] game] convertToImage];
    //If unfinished
    NSString* shareString = @"Help me with this Towers puzzle, it is hard.";
    
    fb = [[[UIApplication sharedApplication] delegate] facebook];
    
    NSMutableDictionary* photoParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        gameImage,@"source",
                                        shareString,@"message", nil];
    //[fb logout];
    if(![fb isSessionValid]){
        NSLog(@"auth");
        [fb authorize:[NSArray arrayWithObjects:@"publish_actions",@"publish_stream", @"user_photos", nil]];
    } else {
        //[fb dialog:@"feed" andDelegate:self];
        NSLog(@"here");
        [fb requestWithGraphPath:@"me/photos" 
                       andParams:photoParams 
                   andHttpMethod:@"POST" 
                     andDelegate:self];
    }
}
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"received");
}
- (void)request:(FBRequest *)request didLoad:(id)result {
    
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

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"error");
}

-(void) enterScore
{
    if(self.pageType == SCOREPAGE)
        return;
    [[CCDirector sharedDirector] replaceScene:[ScoreBoard scene]];
    self.pageType = SCOREPAGE;
}
@end
