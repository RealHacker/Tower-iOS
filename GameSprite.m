//
//  GameSprite.m
//  Towers
//
//  Created by 雷 王 on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameSprite.h"
#import "GameState.h"

@implementation GameSprite

@synthesize game = _game;
@synthesize mode = _mode;
@synthesize matrix = _matrix;
@synthesize scratch = _scratch;
@synthesize gridSize = _gridSize;
@synthesize delegate = _delegate;
@synthesize focusX = _focusX;
@synthesize focusY = _focusY;
@synthesize hasFocus = _hasFocus;

- (void) setPositionForSprite: (CCSprite*) sprite AtX:(int) x Y:(int)y
{
    sprite.position = CGPointMake(x*cellSize + cellSize/2, y*cellSize + cellSize/2);
}
- (void) loadArrays
{
    spriteArray = [NSMutableArray arrayWithCapacity:self.gridSize];
    [spriteArray retain];
    for (int i =0; i< self.gridSize; i++) {
        NSMutableArray* array = [NSMutableArray arrayWithCapacity:self.gridSize];
        for (int j = 0; j< self.gridSize; j++) {
            [array addObject: [NSNull null]];
        }
        [spriteArray addObject:array];
    }
    
    //Initialize the matrix and scratch matrix
    self.matrix = [NSMutableArray arrayWithCapacity:self.gridSize];
    for (int i =0; i< self.gridSize; i++) {
        NSMutableArray* array = [NSMutableArray arrayWithCapacity:self.gridSize];
        for (int j = 0; j< self.gridSize; j++) {
            int n = [self.game getGameCellAtX:j Y:i];
            [array addObject: [NSNumber numberWithInt:n]];
            if (n !=0) {
                CCSprite* numberSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"number%d.png", n]];
                //Should change the sprite scale here
                [self setPositionForSprite:numberSprite AtX:(j+1) Y:(self.gridSize - i)];
                [self addChild:numberSprite];
                [[[spriteArray objectAtIndex:i] objectAtIndex:j] release];
                [[spriteArray objectAtIndex:i] setObject:numberSprite atIndex:j];
            }
        }
        [self.matrix addObject:array];
    }
    [GameState sharedState].matrix = self.matrix;
    
    self.scratch = [NSMutableArray arrayWithCapacity:self.gridSize];
    for (int i =0; i< self.gridSize; i++) {
        NSMutableArray* array = [NSMutableArray arrayWithCapacity:self.gridSize];
        for (int j = 0; j< self.gridSize; j++) {
            [array addObject: [NSMutableArray array]];
        }
        [self.scratch addObject:array];
    }
    [GameState sharedState].scratch = self.scratch;
}
- (void) loadArraysFromDisk
{
    spriteArray = [NSMutableArray arrayWithCapacity:self.gridSize];
    [spriteArray retain];
    for (int i =0; i< self.gridSize; i++) {
        NSMutableArray* array = [NSMutableArray arrayWithCapacity:self.gridSize];
        for (int j = 0; j< self.gridSize; j++) {
            [array addObject: [NSNull null]];
        }
        [spriteArray addObject:array];
    }
    
    //Initialize the matrix and scratch matrix
    self.matrix = [GameState sharedState].matrix;
    for (int i =0; i< self.gridSize; i++) {
        for (int j = 0; j< self.gridSize; j++) {
            int m = [[[self.matrix objectAtIndex:i] objectAtIndex:j] intValue];
            int n = [self.game getGameCellAtX:j Y:i];

            if (m!=0&&n==0) {
                CCSprite* numberSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"red%d.png", m]];
                //Should change the sprite scale here
                [self setPositionForSprite:numberSprite AtX:(j+1) Y:(self.gridSize - i)];
                [self addChild:numberSprite];
                [[[spriteArray objectAtIndex:i] objectAtIndex:j] release];
                [[spriteArray objectAtIndex:i] setObject:numberSprite atIndex:j];
            } else if(n!=0){
                CCSprite* numberSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"number%d.png", n]];
                //Should change the sprite scale here
                [self setPositionForSprite:numberSprite AtX:(j+1) Y:(self.gridSize - i)];
                [self addChild:numberSprite];
                [[[spriteArray objectAtIndex:i] objectAtIndex:j] release];
                [[spriteArray objectAtIndex:i] setObject:numberSprite atIndex:j];
            }
        }
    }
    self.scratch = [GameState sharedState].scratch;
    for (int i =0; i< self.gridSize; i++) {
        for (int j=0; j<self.gridSize; j++) {
            NSArray* array = [[self.scratch objectAtIndex:i] objectAtIndex:j];
            if ([array count]!=0 ) {
                ScratchSprite* scratch = [[ScratchSprite alloc]initWithNumbers:array Count:self.gridSize];
                [self setPositionForSprite:scratch AtX:(j+1) Y:(self.gridSize - i)];
                [self addChild:scratch];
                [[[spriteArray objectAtIndex:i] objectAtIndex:j] release];
                [[spriteArray objectAtIndex:i] setObject:scratch atIndex:j];
            }
        }
    }
}
- (UIImage*) convertToImage
{
    CGPoint p = self.anchorPoint;
    CGPoint pos = self.position;
    [self setAnchorPoint:ccp(0,0)];
    [self setPosition:ccp(0,0)];
    CCRenderTexture *renderer = [CCRenderTexture renderTextureWithWidth:GAMEWIDTH
                                                                 height:GAMEWIDTH];
    [renderer begin];
    [self visit];
    [renderer end];
    
    [self setAnchorPoint:p];
    [self setPosition:pos];
    return [UIImage imageWithData:[renderer getUIImageAsDataFromBuffer:kCCImageFormatPNG]];
}

- (id) initWithGameDifficulty:(GameDifficulty)difficulty size:(int)size
{
    return [self initWithGameDifficulty:difficulty size:size fromDisk:NO];
}
- (id) initWithGameDifficulty:(GameDifficulty)difficulty size:(int)size fromDisk:(BOOL)fromDisk
{
    if (self = [super initWithFile:@"frame.png"]) {
        [GameState sharedState].hasUnfinishedGame = YES;
        
        self.gridSize = size;
        cellSize = GAMEWIDTH / (size+2);
        
        NSString* difficultyString;
        if (difficulty == EASY) {
            difficultyString = @"EASY";
        } else {
            difficultyString = @"DIFFICULT";
        }
        
        if (fromDisk) {
            int index = [GameState sharedState].indexInFile;
            self.game = [[Game alloc] initGameWithSize:size Difficulty:difficultyString Index:index];
        } else{
            self.game = [[Game alloc] initGameWithSize:size Difficulty:difficultyString];
        }
        
        self.mode =     NORMAL;
        self.hasFocus = NO;
        
        //initialize the 4 sides of array
        spritesLeft = [NSMutableArray array];
        [spritesLeft retain];
        spritesRight = [NSMutableArray array];
        [spritesRight retain];
        spritesTop = [NSMutableArray array];
        [spritesTop retain];
        spritesBottom = [NSMutableArray array];
        [spritesBottom retain];
        
        for (int i =0;i<self.gridSize;i++) {
            int leftNumber = [self.game getLeftAt:i];
            if (leftNumber) {
                CCSprite* numberSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"number%d.png", leftNumber]];
                [self setPositionForSprite:numberSprite AtX:0 Y:(self.gridSize-i)];
                [self addChild:numberSprite];
                [spritesLeft addObject:numberSprite];
            }
            int rightNumber = [self.game getRightAt:i];
            if (rightNumber) {
                CCSprite* numberSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"number%d.png", rightNumber]];
                [self setPositionForSprite:numberSprite AtX:(self.gridSize +1) Y:(self.gridSize-i)];
                [self addChild:numberSprite];
                [spritesRight addObject:numberSprite];
            }
            int topNumber = [self.game getTopAt:i];
            if (topNumber) {
                CCSprite* numberSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"number%d.png", topNumber]];
                [self setPositionForSprite:numberSprite AtX:(i+1) Y:(self.gridSize+1)];
                [self addChild:numberSprite];
                [spritesTop addObject:numberSprite];
            }
            int bottomNumber = [self.game getBottomAt:i];
            if (bottomNumber) {
                CCSprite* numberSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"number%d.png", bottomNumber]];
                [self setPositionForSprite:numberSprite AtX:(i+1) Y:0];
                [self addChild:numberSprite];
                [spritesBottom addObject:numberSprite];
            }
        }
        if (fromDisk) {
            [self loadArraysFromDisk];
        } else{
            [self loadArrays];
        }
        //Create the highlight sprite and hide it
        highlightSprite = [CCSprite spriteWithFile:@"highlight.png"];
        [self addChild:highlightSprite];
        highlightSprite.visible = NO;
        highlightSprite.anchorPoint = CGPointMake(0, 0);
        highlightSprite.scale = cellSize/HIGHLIGHTSIZE;
    }
    return self;
}

- (void) restart
{
    for (NSArray* row in spriteArray) {
        for (int i=0; i<self.gridSize;i++) {
            NSObject* obj = [row objectAtIndex:i]; 
            if (obj != [NSNull null]) {
                CCSprite* sprite = (CCSprite*) obj;
                [self removeChild:sprite cleanup:YES];
            }
        }
    }
    
    self.mode = NORMAL;
    [self loadArrays];
}

- (void) flickerSprite: (CCSprite*) sprite
{
    //Temporary, check which effect is better
    CCFadeOut* fadeout = [CCFadeOut actionWithDuration:0.5];
    CCFadeIn* fadeIn = [CCFadeIn actionWithDuration:0.5];
    
    CCSequence* sequence = [CCSequence actionOne:fadeout two:fadeIn];
    [sprite runAction:sequence];
}
- (void) showAlertAtX:(int)x Y:(int) y
{
    CCSprite* sprite = [[spriteArray objectAtIndex:y]objectAtIndex:x];
    [self flickerSprite: sprite];
}
- (void) showAlertLeftAt: (int) index
{
    CCSprite* sprite = [spritesLeft objectAtIndex:index];
    [self flickerSprite: sprite];
}
- (void) showAlertRightAt: (int) index
{
    CCSprite* sprite = [spritesRight objectAtIndex:index];
    [self flickerSprite: sprite];
}
- (void) showAlertTopAt:(int) index
{
    CCSprite* sprite = [spritesTop objectAtIndex:index];
    [self flickerSprite: sprite];
}
- (void) showAlertBottomAt:(int) index
{
    CCSprite* sprite = [spritesBottom objectAtIndex:index];
    [self flickerSprite: sprite];
}
- (BOOL) checkNumber:(int)number AtX:(int)x Y:(int)y
{
    //First check the same row
    NSMutableArray* sameRow =[self.matrix objectAtIndex:y];
    [sameRow replaceObjectAtIndex:x withObject:[NSNumber numberWithInt:number]];
    int highest = 0;
    int leftCount = 0;
    BOOL overBlankCell = NO;
    for (int i = 0; i<self.gridSize; i++) {
        int v = [[sameRow objectAtIndex:i] intValue];
        if (v == 0) {
            overBlankCell = YES;
            continue;
        }else if (i!= x&&v == number){
            //set the cell to show alert
            [self showAlertAtX:i Y:y];
            [sameRow replaceObjectAtIndex:x withObject: [NSNumber numberWithInt:0]];
            return NO;
        } else if (!overBlankCell && v> highest){
            highest = v;
            leftCount++;
        }
    }
    if (leftCount > [self.game getLeftAt:y]) {
        [self showAlertLeftAt: y];
        [sameRow replaceObjectAtIndex:x withObject:[NSNumber numberWithInt:0]];
        return NO;
    }
    highest =0;
    int rightCount =0;
    overBlankCell = NO;
    for (int i = self.gridSize-1; i>=0; i--) {
        int v = [[sameRow objectAtIndex:i] intValue];
        if (v == 0) {
            overBlankCell = YES;
        }else if(!overBlankCell && v>highest){
            highest = v;
            rightCount++;
        }
    }
    if (rightCount > [self.game getRightAt:y]) {
        [self showAlertRightAt: y];
        [sameRow replaceObjectAtIndex:x withObject: [NSNumber numberWithInt:0]];
        return NO;
    }
    //Check the same column
    highest = 0;
    int topCount = 0;
    overBlankCell = NO;
    for (int j=0; j<self.gridSize; j++) {
        int v = [[[self.matrix objectAtIndex:j] objectAtIndex:x] intValue];
        if (v == 0) {
            overBlankCell = YES;
        }else if(j!=y && v==number){
            [self showAlertAtX:x Y:j];
            [sameRow replaceObjectAtIndex:x withObject:[NSNumber numberWithInt:0]];
            return NO;
        } else if (!overBlankCell && v > highest){
            highest = v;
            topCount++;
        }
    }
    if (topCount > [self.game getTopAt:x]) {
        [self showAlertTopAt:x];
        [sameRow replaceObjectAtIndex:x withObject:[NSNumber numberWithInt:0]];
        return NO;
    }
    highest =0;
    int bottomCount =0;
    overBlankCell = NO;
    for (int j = self.gridSize-1; j>=0; j--) {
        int v = [[[self.matrix objectAtIndex:j] objectAtIndex:x] intValue];
        if (v == 0) {
            overBlankCell = YES;
        }else if(!overBlankCell && v>highest){
            highest = v;
            bottomCount++;
        }
    }
    if (bottomCount > [self.game getBottomAt:x]) {
        [self showAlertBottomAt:x];
        [sameRow replaceObjectAtIndex:x withObject:[NSNumber numberWithInt:0]];
        return NO;
    }
    //all checking passed
    return YES;
}

- (BOOL)checkAll
{
    for (int i = 0; i< self. gridSize; i++) {
        for (int j =0; j< self.gridSize; j++) {
            int v1 = [[[self.matrix objectAtIndex:j]objectAtIndex:i] intValue];
            int v2 = [self.game getSolutionCellAtX:i Y:j];
            if (v1!= v2) 
                return NO;
        }
    }
    return YES;
}
- (void) enterNumberAtX:(int)x Y:(int)y
{
    //First remove the original sprite from the cell
    NSObject* obj = [[spriteArray objectAtIndex:y]objectAtIndex:x];
    if (obj != [NSNull null]) {
        CCSprite* sprite = (CCSprite*) obj;
        [self removeChild:sprite cleanup:YES];
        [sprite release];
    }
    //Remove the scratch numbers
    //[[[self.scratch objectAtIndex:y] objectAtIndex:x] release];
    [[self.scratch objectAtIndex:y]setObject:[NSMutableArray array] atIndex:x];
    
    //Create the new sprite
    int n = [[[self.matrix objectAtIndex:y]objectAtIndex:x] intValue];
    CCSprite* numberSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"red%d.png", n]];
    //Should change the sprite scale here
    [self setPositionForSprite:numberSprite AtX:(x+1) Y:(self.gridSize - y)];
    [self addChild:numberSprite];
    [[spriteArray objectAtIndex:y] setObject:numberSprite atIndex:x];

    //flicker the number just entered
    CCSprite* sprite = [[spriteArray objectAtIndex:y]objectAtIndex:x];
    [self flickerSprite: sprite];
    
    //Finally check if the game is done
    if ([self checkAll])
    {
        [self.delegate gameSucceeded];
        NSLog(@"SUCCESS");
    }
}
- (void) clearNumberAtX:(int)x Y:(int)y
{
    //First remove the original sprite from the cell
    NSObject* obj = [[spriteArray objectAtIndex:y]objectAtIndex:x];
    if (obj != [NSNull null]) {
        CCSprite* sprite = (CCSprite*) obj;
        [self removeChild:sprite cleanup:YES];
        [sprite release];
    }
    //Remove the scratch numbers
    //[[[self.scratch objectAtIndex:y]objectAtIndex:x] release];
    [[self.scratch objectAtIndex:y]setObject:[NSMutableArray array] atIndex:x];
    //Remove the matrix number
    //[[[self.matrix objectAtIndex:y] objectAtIndex:x] release];
    [[self.matrix objectAtIndex:y] setObject:[NSNumber numberWithInt:0] atIndex:x];
}
- (void) scratchNumbers:(NSArray *)numbers AtX:(int)x Y:(int)y
{
    //if the position has something, remove it first
    NSObject* obj = [[spriteArray objectAtIndex:y]objectAtIndex:x];
    if (obj != [NSNull null]) {
        CCSprite* sprite = (CCSprite*) obj;
        [self removeChild:sprite cleanup:YES];
        [sprite release];
    }
    //Remove the entered number
    [[[self.matrix objectAtIndex:y]objectAtIndex:x] release];
    [[self.matrix objectAtIndex:y] setObject:[NSNumber numberWithInt:0] atIndex:x];
    
    //Then create a scratchSprite
    //[[[self.scratch objectAtIndex:y] objectAtIndex:x] release];
    [[self.scratch objectAtIndex:y] setObject:numbers atIndex:x];
    ScratchSprite* scratch = [[ScratchSprite alloc]initWithNumbers:numbers Count:self.gridSize];
    [self setPositionForSprite:scratch AtX:(x+1) Y:(self.gridSize - y)];
    [self addChild:scratch];
    [[spriteArray objectAtIndex:y] setObject:scratch atIndex:x];
    
}

- (void) touchGameAtX: (float) x Y: (float) y
{
    //Calculate the grid position 
    int xx = floorf( x/cellSize)-1;
    int yy = self.gridSize - floorf(y/cellSize);
    
    if (xx < 0 || xx >=self.gridSize||yy<0 ||yy>= self.gridSize) return;
    //If tapped inside a cell with pre-filled number
    if ([self.game getGameCellAtX:xx Y:yy] != 0) {
        //TODO:Should add some warning that it is not editable
        return; 
    }
    //Depending on mode
    if (!self.hasFocus) {
        self.hasFocus = YES;
    }
    //If in normal mode, just record the position
    //If in scratch mode, record the position, also update the picker
    self.focusX = xx;
    self.focusY = yy;
    if (self.mode == SCRATCH) {
        NSMutableArray* set = [[self.scratch objectAtIndex:yy] objectAtIndex:xx];
        [self.delegate setPickerValues: set];
        
    }
    highlightSprite.position = CGPointMake((xx +1) * cellSize, (self.gridSize - yy)* cellSize);
    highlightSprite.visible = YES;
    
}

- (void)draw
{
    [super draw];
    
    //Draw the focus
    //Draw the gridlines
    glLineWidth(4.0f);
    glEnable(GL_LINE_SMOOTH);
    glColor4ub(128, 128, 128, 255);
    for (int i=0; i<=self.gridSize; i++) {
        float y = (i+1)* cellSize;
        CGPoint from = CGPointMake(cellSize, y);
        CGPoint to = CGPointMake(cellSize*(self.gridSize+1), y);
        ccDrawLine(from,to);
        /*
        if (self.hasFocus && (self.focusY == self.gridSize - i ||self.focusY== self.gridSize-1 - i)) {
                glColor4ub(255, 0, 0, 255);
                ccDrawLine(from,to);
                glColor4ub(255, 255, 0, 255);
        }
         */
    }
    for (int i=0; i<=self.gridSize; i++) {
        float x = (i+1)* cellSize;
        CGPoint from = CGPointMake(x, cellSize);
        CGPoint to = CGPointMake(x,cellSize*(self.gridSize+1));
        ccDrawLine(from,to);
        /*
        if (self.hasFocus && (self.focusX == i ||self.focusX+1 == i)) {
            glColor4ub(255, 0, 0, 255);
            ccDrawLine(from,to);
            glColor4ub(255, 255, 0, 255);
        }
         */
    }
    glLineWidth(1.0f);
    glColor4ub(255, 255, 255, 255);
    glDisable(GL_LINE_SMOOTH);
}
    




@end
