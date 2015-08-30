//
//  ModeSprite.h
//  Towers
//
//  Created by 雷 王 on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"
#import "GameSprite.h"

#import "Dimensions.h"


@protocol ModeChangeProtocol <NSObject>

- (void) modeChangedTo: (GameMode) mode;

@end

@interface ModeSprite : CCSprite

@property (nonatomic) GameMode mode;
@property (nonatomic,retain) id<ModeChangeProtocol> delegate;

- (id) initWithMode: (GameMode) mode;
- (void) touchSpriteAtX: (float) x Y: (float) y;

@end
