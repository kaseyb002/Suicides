//
//  MainGameViewController.h
//  Suicide
//
//  Created by Kasey Baughan on 3/19/14.
//  Copyright (c) 2014 Kasey Baughan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import "SuicideGameModel.h"
#import "GameOverViewController.h"


@interface MainGameViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (IBAction)resetGame:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *directionImage;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *goodPointsLabel;

@property (weak, nonatomic) IBOutlet UILabel *penaltyPointsLabel;

@property (weak, nonatomic) IBOutlet UILabel *sprintNumberLabel;

@property (strong, nonatomic) SuicideGameModel *suicideGame;

@property (strong, nonatomic) NSTimer *timer;

@property (nonatomic) BOOL sound;

@end
