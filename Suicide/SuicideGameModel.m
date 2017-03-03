//
//  SuicideGameModel.m
//  Suicide
//
//  Created by Kasey Baughan on 3/19/14.
//  Copyright (c) 2014 Kasey Baughan. All rights reserved.
//

#define FIRST_SPRINT_LOWER_BOUND 35
#define FIRST_SPRINT_UPPER_BOUND 50

#define SECOND_SPRINT_LOWER_BOUND 75
#define SECOND_SPRINT_UPPER_BOUND 100

#define THIRD_SPRINT_LOWER_BOUND 125
#define THIRD_SPRINT_UPPER_BOUND 150

#define FOURTH_SPRINT_LOWER_BOUND 200
#define FOURTH_SPRINT_UPPER_BOUND 230

#import "SuicideGameModel.h"

@implementation SuicideGameModel

#pragma - Setters and Getters

- (NSString *)finalScoreString{
    
    if(!_finalScoreString){
        
        _finalScoreString = @"N/A";
        
    }
    
    return _finalScoreString;
    
}

- (NSTimer *)timer{
    
    if(!_timer){
        
        _timer = [NSTimer
                  scheduledTimerWithTimeInterval:1.0
                  target:self
                  selector:@selector(timerFireMethod:)
                  userInfo:nil
                  repeats:YES];
        
    }
    
    return _timer;
    
}

- (void) timerFireMethod:(NSTimer *) theTimer
{
        
    self.seconds++;
    
    if (self.seconds == 60) {
        
        self.minutes++;
        
        self.seconds = 0;
        
    }

}

- (void)resetGame{
    
    self.countPoints = YES;
    
    self.goodPoints = 0;
    
    self.penaltyPoints = 0;
    
    self.sprintNumber = 0;
    
    self.seconds = 0;
    
    self.minutes = 0;
    
    [self setSprintLengths];
    
}

- (void)setSprintLengths{
    
    self.firstSprintNumberOfCells = [self getRandomNumberBetween:FIRST_SPRINT_LOWER_BOUND maxNumber:FIRST_SPRINT_UPPER_BOUND];
    
    self.secondSprintNumberOfCells = [self getRandomNumberBetween:SECOND_SPRINT_LOWER_BOUND maxNumber:SECOND_SPRINT_UPPER_BOUND];
    
    self.thirdSprintNumberOfCells = [self getRandomNumberBetween:THIRD_SPRINT_LOWER_BOUND maxNumber:THIRD_SPRINT_UPPER_BOUND];
    
    self.fourthSprintNumberOfCells = [self getRandomNumberBetween:FOURTH_SPRINT_LOWER_BOUND maxNumber:FOURTH_SPRINT_UPPER_BOUND];
    
}

- (void)resetCurrentSprintLength{
    
    if(self.sprintNumber == 0){
        
        self.currentSprintLength = self.firstSprintNumberOfCells;
        
    } else if(self.sprintNumber == 1){
        
        self.currentSprintLength = self.secondSprintNumberOfCells;
        
    } else if(self.sprintNumber == 2){
        
        self.currentSprintLength = self.thirdSprintNumberOfCells;
        
    } else if(self.sprintNumber == 3){
        
        self.currentSprintLength = self.fourthSprintNumberOfCells;
        
    }
    
}

- (void)incrementSprintNumber{
    
    self.pointsEarnedThisSprint = 0;
    
    self.sprintNumber++;
    
}

- (void)addGoodPoints{
    
    //NSLog (@"Sprint Number: %d | Sprint Length: %d | Points This Sprint: %d", self.sprintNumber, self.currentSprintLength, self.pointsEarnedThisSprint);
    
    if(self.pointsEarnedThisSprint <= self.currentSprintLength){
        
        self.pointsEarnedThisSprint++;
        
        self.goodPoints++;
        
    }
    
}

- (void)calculateFinalScore{
    
    //converting this stuff to doubles so we can get fractions
    double seconds = self.seconds;
    
    double goodPoints = self.goodPoints;
    
    double penaltyPoints = self.penaltyPoints;
    
    self.finalScore = (goodPoints - penaltyPoints) / seconds;
    
    NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
    
    nf.positiveFormat = @"0.##";
    
    nf.roundingMode = NSNumberFormatterRoundFloor;
    
    self.finalScoreString = [self getTrimmedFloatAsString:self.finalScore];
    
}

- (NSString *)getTrimmedFloatAsString:(float)f{
    
    NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
    
    nf.positiveFormat = @"0.##";
    
    nf.roundingMode = NSNumberFormatterRoundFloor;
    
    return [nf stringFromNumber: [NSNumber numberWithDouble:f]];
    
}


#pragma mark - Helpers

- (NSInteger)getRandomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max{
    
    return min + arc4random() % (max - min + 1);
    
}




@end
