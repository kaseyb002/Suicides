//
//  GameOverViewController.h
//  Suicide
//
//  Created by Kasey Baughan on 3/19/14.
//  Copyright (c) 2014 Kasey Baughan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "SuicideGameModel.h"

@interface GameOverViewController : UIViewController <ADBannerViewDelegate>

- (IBAction)playAgain:(UIButton *)sender;

- (IBAction)mainMenu:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *playAgainButton;

@property (weak, nonatomic) IBOutlet UIButton *mainMenuButton;

@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodPointsLabel;

@property (weak, nonatomic) IBOutlet UILabel *penaltyPointsLabel;

@property (weak, nonatomic) IBOutlet UILabel *finalScoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *bestScoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentLevelLabel;

@property (strong, nonatomic) ADBannerView *bannerView;

@property (strong, nonatomic) SuicideGameModel *gameResults;

@end
