//
//  ResourceLoader.h
//  Towers
//
//  Created by 雷 王 on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameAdView.h"

@protocol ResourceLoaderDelegate <NSObject>

- (void) loadingDone;

@end

@interface ResourceLoader : NSObject

@property (nonatomic, retain) id<ResourceLoaderDelegate> delegate;

@property (nonatomic, retain) NSMutableArray* GridSizeSpriteFrames;
@property (nonatomic, retain) NSMutableArray* GridSizeTickedSpriteFrames;

@property (nonatomic, retain) CCSpriteFrame* easyFrame;
@property (nonatomic, retain) CCSpriteFrame* easySelectedFrame;
@property (nonatomic, retain) CCSpriteFrame* hardFrame;
@property (nonatomic, retain) CCSpriteFrame* hardSelectedFrame;

@property (nonatomic, retain) CCSpriteFrame* crossFrame;
@property (nonatomic, retain) CCSpriteFrame* goFrame;

@property (nonatomic, retain) CCSprite* configureBackground;
@property (nonatomic, retain) CCSprite* configureTemplate;

@property (nonatomic, retain) CCSprite* statsTemplate;

@property (nonatomic, retain) GameAdView* adView;

- (id) init;
- (void) loadResources;

+ (ResourceLoader*) sharedLoader;

@end
