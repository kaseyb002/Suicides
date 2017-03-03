//
//  MainMenuViewController.m
//  Suicides
//
//  Created by Kasey Baughan on 3/26/14.
//  Copyright (c) 2014 Kasey Baughan. All rights reserved.
//

#import "MainMenuViewController.h"
#import "MainGameViewController.h"


@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    
    //iad stuff
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.bannerView = [[ADBannerView alloc]initWithFrame:
                  CGRectMake(0, screenRect.size.height - 50, 320, 50)];
    self.bannerView.delegate = self;
    // Optional to set background color to clear color
    [self.bannerView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview: self.bannerView];
    //end iad stuff
    
    [self.soundSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"sound"]];

}

- (IBAction)beginGame:(UIButton *)sender {
    [self performSegueWithIdentifier:@"BeginGame" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.destinationViewController isKindOfClass:[MainGameViewController class]]) {
        [[NSUserDefaults standardUserDefaults] setBool:self.soundSwitch.isOn forKey:@"sound"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
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
