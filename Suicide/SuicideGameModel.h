//
//  SuicideGameModel.h
//  Suicide
//
//  Created by Kasey Baughan on 3/19/14.
//  Copyright (c) 2014 Kasey Baughan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuicideGameModel : NSObject

- (void)resetGame;

- (void)resetCurrentSprintLength;

- (void)addGoodPoints;

- (void)incrementSprintNumber;

- (void)calculateFinalScore;

- (NSString *)getTrimmedFloatAsString:(float)f;

@property (nonatomic) int goodPoints;
@property (nonatomic) int penaltyPoints;
@property (nonatomic) int sprintNumber;

@property (nonatomic) float finalScore;
@property (nonatomic, strong) NSString *finalScoreString;

@property (nonatomic) int seconds;
@property (nonatomic) int minutes;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic) BOOL countPoints;
@property (nonatomic) BOOL checkpointReached;
@property (nonatomic) BOOL baselineReached;
@property (nonatomic) BOOL firstCheckpointReached;//to prevent sprint increment at beginning of game

@property (nonatomic) int currentSprintLength;
@property (nonatomic) int pointsEarnedThisSprint;

@property (nonatomic) int firstSprintNumberOfCells;
@property (nonatomic) int secondSprintNumberOfCells;
@property (nonatomic) int thirdSprintNumberOfCells;
@property (nonatomic) int fourthSprintNumberOfCells;

@end
