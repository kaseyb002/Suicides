//
//  GameOverViewController.m
//  Suicide
//
//  Created by Kasey Baughan on 3/19/14.
//  Copyright (c) 2014 Kasey Baughan. All rights reserved.
//

#import "GameOverViewController.h"

@interface GameOverViewController ()

@end

@implementation GameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.userInteractionEnabled = NO;
    self.mainMenuButton.hidden = YES;
    self.playAgainButton.hidden = YES;
    
    //iad stuff
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.bannerView = [[ADBannerView alloc]initWithFrame:
                       CGRectMake(0, screenRect.size.height - 50, 320, 50)];
    self.bannerView.delegate = self;
    // Optional to set background color to clear color
    [self.bannerView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview: self.bannerView];
    //end iad stuff
    
    float previousBest = [[NSUserDefaults standardUserDefaults] floatForKey:@"bestScore"];
    
    if(previousBest < self.gameResults.finalScore){
        self.bestScoreLabel.text = [NSString stringWithFormat:@"Previous High: %@", [self.gameResults getTrimmedFloatAsString:previousBest]];
        [[NSUserDefaults standardUserDefaults] setFloat:self.gameResults.finalScore forKey:@"bestScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        self.bestScoreLabel.text = [NSString stringWithFormat:@"High Score: %@", [self.gameResults getTrimmedFloatAsString:previousBest]];
    }
    
    self.currentLevelLabel.text = [NSString stringWithFormat:@"Current Level: %@",[self getCurrentLevel:[[NSUserDefaults standardUserDefaults] floatForKey:@"bestScore"]]];
    self.goodPointsLabel.text = [NSString stringWithFormat:@"%d good points", self.gameResults.goodPoints];
    self.penaltyPointsLabel.text = [NSString stringWithFormat:@"➖ %d penalty points", self.gameResults.penaltyPoints];
    self.secondsLabel.text = [NSString stringWithFormat:@"➗ %d seconds", self.gameResults.seconds];
    self.finalScoreLabel.text = [NSString stringWithFormat:@"your final score is %@", self.gameResults.finalScoreString];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [NSThread sleepForTimeInterval:1.5];
    
    self.mainMenuButton.hidden = NO;
    
    self.playAgainButton.hidden = NO;
    
    self.view.userInteractionEnabled = YES;
    
}

- (NSString *)getCurrentLevel:(float)bestScore{
    if(bestScore < 0){
        return @"Learn How to Play";
    } else if (bestScore >= 0 && bestScore < 5){
        return @"Slowpoke";
    } else if (bestScore >= 5 && bestScore < 10){
        return @"Weiner";
    } else if (bestScore >= 10 && bestScore < 12){
        return @"Competent";
    } else if (bestScore >= 12 && bestScore < 15){
        return @"Master";
    } else if (bestScore >= 15 && bestScore < 18){
        return @"Addict";
    } else if (bestScore >= 18){
        return @"Cheater";
    }
    return @"Hard to Say";
}

/*
[[NSUserDefaults standardUserDefaults] setFloat:self.suicideGame.finalScore forKey:@"currentFinalScore"];


 #pragma mark - Load & Save NSUserDefaults
 
 - (void)loadNSUserDefaults{
 
 //this is to check to see if there are any user settings for this device. If not, we will load our own defaults.
 if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isNotFirstLoad"]){//double negative
 
 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNotFirstLoad"];
 
 [self setDefaultUserDefaultsForFirstAppLoad];//this will save these settings
 
 } else {
 
 self.restaurantListManager.autoRadius = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoRadius"];
 
 */

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)playAgain:(UIButton *)sender {
    [self performSegueWithIdentifier:@"PlayAgain" sender:nil];
}

- (IBAction)mainMenu:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"MainMenu" sender:nil];
    
}

#pragma mark - Helpers

+ (NSInteger)getRandomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max{
    
    return min + arc4random() % (max - min + 1);
    
}

#pragma mark - AdViewDelegates

-(void)bannerView:(ADBannerView *)banner
didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"Error loading");
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad loaded");
}
-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad will load");
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    NSLog(@"Ad did finish");
    
}

@end
