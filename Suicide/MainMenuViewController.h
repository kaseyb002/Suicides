//
//  MainMenuViewController.h
//  Suicides
//
//  Created by Kasey Baughan on 3/26/14.
//  Copyright (c) 2014 Kasey Baughan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface MainMenuViewController : UIViewController <ADBannerViewDelegate>

- (IBAction)beginGame:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;

@property (strong, nonatomic) ADBannerView *bannerView;

@end
