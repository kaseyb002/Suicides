//
//  MainGameViewController.m
//  Suicide
//
//  Created by Kasey Baughan on 3/19/14.
//  Copyright (c) 2014 Kasey Baughan. All rights reserved.
//

#define PENALTY_BOUNDS 100

#import "MainGameViewController.h"

@interface MainGameViewController () {
    
    SystemSoundID sounds[9];
    
}

@property (nonatomic) dispatch_queue_t runTimer;

@property (nonatomic) dispatch_queue_t imageLoader;

@property (nonatomic) BOOL fillInWithArrows;

@property (nonatomic) int soundFileNameIncrementer;

@property (nonatomic, strong) UIImage *downImage;

@property (nonatomic, strong) UIImage *upImage;

@end

@implementation MainGameViewController

- (SuicideGameModel *)suicideGame{
    
    if(!_suicideGame){
        
        _suicideGame = [[SuicideGameModel alloc] init];
        
        [_suicideGame resetGame];
        
    }
    
    return _suicideGame;
    
}

- (dispatch_queue_t)runTimer {
    
    if (!_runTimer) {
        
        _runTimer = dispatch_queue_create("runTimer", NULL);
        
    }
    
    return _runTimer;
}

- (dispatch_queue_t)imageLoader{
    
    if (!_imageLoader) {
        
        _imageLoader = dispatch_queue_create("imageLoader", NULL);
        
    }
    
    return _imageLoader;
    
}

+ (NSString *)downArrows{
    
    return @"▽                  ▽                 ▽                 ▽";
    
}


+ (NSString *)upArrows{
    
    return @"△                  △                 △                 △";
    
}

+ (UIColor *)goodCellColor{
    
    return [UIColor colorWithRed:0.0/255.0 green:107.0/255.0 blue:84.0/255.0 alpha:1];//traffic sign green
    //return [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:0.0/255.0 alpha:1];//little bit stronger green
    
}

+ (UIColor *)penaltyCellColor{
    
    return [UIColor colorWithRed:175.0/255.0 green:30.0/255.0 blue:45.0/255.0 alpha:1];//stop sign red
    
}

+ (NSArray *)soundFilesNames{
    
    NSArray *soundFileNames = @[@"Sprint_1_Begin",
                                @"Sprint_1_halfway",
                                @"Sprint_1_complete",
                                @"Sprint_2_halfway",
                                @"Sprint_2_complete",
                                @"Sprint_3_halfway",
                                @"Sprint_3_complete",
                                @"Sprint_4_halfway",
                                @"Sprint_4_complete"];
    
    return soundFileNames;
    
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.sound = [[NSUserDefaults standardUserDefaults] boolForKey:@"sound"];
    
    [self loadAssets];
    
    [self playDingSound:0];//just to get things kicked off

    self.directionImage.image = self.downImage;
    
    [self showDirectionImage];

    //go to beginning of good cells
    [self prepareGame:NO plusPadding:13];

}

- (void)viewDidAppear:(BOOL)animated{
    
    self.sound = [[NSUserDefaults standardUserDefaults] boolForKey:@"sound"];
    
    [self prepareGame:NO plusPadding:13];
    
}

- (void)prepareGame:(BOOL)willAnimate plusPadding:(int)padding{
    
    [self.suicideGame resetGame];
    
    self.soundFileNameIncrementer = 1;
    
    [self.tableView reloadData];
    
    NSIndexPath *indexPathGood = [NSIndexPath indexPathForRow:PENALTY_BOUNDS + padding inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:indexPathGood atScrollPosition:0 animated:willAnimate];
    
    [self.suicideGame resetGame];
    
    self.goodPointsLabel.text = [NSString stringWithFormat:@"%d", self.suicideGame.goodPoints];
    
    self.penaltyPointsLabel.text = [NSString stringWithFormat:@"%d", self.suicideGame.penaltyPoints];
    
    [self startTimer];
    
}

- (void)startTimer{//maybe the model should handle this, but we are going to let the controller do it for now

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(fireMethod:)
                                                userInfo:nil
                                                 repeats:YES];

    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

- (void)fireMethod:(NSTimer *)theTimer{
    
    self.suicideGame.seconds++;
    
}

- (IBAction)resetGame:(UIButton *)sender{
    
    [self performSegueWithIdentifier:@"StartOver" sender:nil];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.suicideGame resetCurrentSprintLength];
    
    if(indexPath.row <= PENALTY_BOUNDS){//behind the baseline\
        
        cell.backgroundColor = [MainGameViewController penaltyCellColor];
        
        if(self.fillInWithArrows){
            
            cell.textLabel.text = [MainGameViewController downArrows];
            
        } else {
            
            cell.textLabel.text = @"";
            
        }
        
        if(!self.suicideGame.baselineReached && self.suicideGame.firstCheckpointReached){
            
            [self playDingSound:self.soundFileNameIncrementer];
            
            self.soundFileNameIncrementer++;
            
            self.suicideGame.checkpointReached = NO;
            
            self.suicideGame.baselineReached = YES;
            
            self.suicideGame.countPoints = YES;
            
            [self.suicideGame incrementSprintNumber];
            
            self.sprintNumberLabel.text = [NSString stringWithFormat:@"Sprint %d", self.suicideGame.sprintNumber + 1];
            
            self.directionImage.image = self.downImage;
            
            [self showDirectionImage];
            
            if(self.suicideGame.sprintNumber >= 4) {//game over
                
                [self.timer invalidate];
                
                [self wrapUpGame];
                
                [self performSegueWithIdentifier:@"GameOver" sender:nil];
                
            }
            
        }
        
        [self addPenaltyPoints];
        
    } else if(indexPath.row > PENALTY_BOUNDS && indexPath.row <= self.suicideGame.currentSprintLength + PENALTY_BOUNDS){//between baseline and checkpoint
        
        //NSLog (@"Row: %d Tag: %d Cell Text: %@", indexPath.row, cell.tag, cell.textLabel.text);
        
        cell.backgroundColor = [MainGameViewController goodCellColor];
        
        if(self.suicideGame.countPoints){
            
            if(self.fillInWithArrows){
                
                cell.textLabel.text = [MainGameViewController downArrows];
                
            } else {
                
                cell.textLabel.text = @"";
                
            }
            
            [self addGoodPoints];
            
        } else {
            
            if(self.fillInWithArrows){
                
                cell.textLabel.text = [MainGameViewController upArrows];
                
            } else {
                
                cell.textLabel.text = @"";
                
            }
            
        }
        
    } else {//beyond checkpoint
        
        cell.backgroundColor = [MainGameViewController penaltyCellColor];
        
        if(self.fillInWithArrows){
            
            cell.textLabel.text = [MainGameViewController upArrows];
            
        } else {
            
            cell.textLabel.text = @"";
            
        }
        
        if(!self.suicideGame.checkpointReached){
            
            [self playDingSound:self.soundFileNameIncrementer];
            
            self.soundFileNameIncrementer++;
            
            self.suicideGame.firstCheckpointReached = YES;
            
            self.suicideGame.checkpointReached = YES;
            
            self.suicideGame.baselineReached = NO;
            
            self.suicideGame.countPoints = NO;
            
            self.directionImage.image = self.upImage;
            
            [self showDirectionImage];
            
        }
        
        [self addPenaltyPoints];
        
    }
    
    self.fillInWithArrows = !self.fillInWithArrows;
    
}

- (void)addGoodPoints{
    
    self.goodPointsLabel.textColor = [UIColor greenColor];
    
    [self.suicideGame addGoodPoints];
    
    self.goodPointsLabel.text = [NSString stringWithFormat:@"%d", self.suicideGame.goodPoints];
    
}

- (void)addPenaltyPoints{
    
    self.penaltyPointsLabel.textColor = [UIColor redColor];
    
    self.suicideGame.penaltyPoints++;
    
    self.penaltyPointsLabel.text = [NSString stringWithFormat:@"%d", self.suicideGame.penaltyPoints];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    //three sections: upper third = penalty, middle third = good, bottom third = penalty
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //adding up our penalty bounds behind the baseline, our longest sprint, and beyond the checkpoint
    return PENALTY_BOUNDS + self.suicideGame.fourthSprintNumberOfCells + PENALTY_BOUNDS;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell.textLabel setFont:[UIFont fontWithName:@"AvenirNextCondensed-Heavy" size:20]];
    
    //willDisplayCell takes care of the rest of the formatting
    return cell;
    
}

#pragma mark - Wrap Up Methods

/*
 #pragma mark - Load & Save NSUserDefaults
 
 - (void)loadNSUserDefaults{
 
 //this is to check to see if there are any user settings for this device. If not, we will load our own defaults.
 if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isNotFirstLoad"]){//double negative
 
 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNotFirstLoad"];
 
 [self setDefaultUserDefaultsForFirstAppLoad];//this will save these settings
 
 } else {
 
 self.restaurantListManager.autoRadius = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoRadius"];
 
 */

- (void)wrapUpGame{
    
    [self.suicideGame calculateFinalScore];

}

#pragma mark - Image and Sound Stuff

- (void)showDirectionImage{
        
        self.directionImage.alpha = 0.5;
        
        [UIView beginAnimations:@"fade in" context:nil];
        
        [UIView setAnimationDuration:2.0];
        
        self.directionImage.alpha = 0.0;
        
        [UIView commitAnimations];
    
}

- (void)playDingSound:(int)soundNumber{
    
    if(self.sound){
        
        AudioServicesPlaySystemSound(sounds[soundNumber]);
        
    }
    
}

- (void)loadAssets{
    
    self.downImage = [UIImage imageNamed:@"go_down.png"];
    
    self.upImage = [UIImage imageNamed:@"go_up.png"];
    
    for(int i = 0; i < 9; i++) {
        
        SystemSoundID sound1;
        
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:[MainGameViewController soundFilesNames][i]
                                                  withExtension:@"aif"];
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &sound1);
        
        sounds[i] = sound1;
        
    }
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.destinationViewController isKindOfClass:[GameOverViewController class]]) {
        
        GameOverViewController *vc = (GameOverViewController *)segue.destinationViewController;
        
        vc.gameResults = self.suicideGame;
        
    }
    
}

@end
