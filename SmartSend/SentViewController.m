//
//  SentViewController.m
//  SmartSend
//
//  Created by Michael Bishoff on 2/15/14.
//  Copyright (c) 2014 Michael Bishoff. All rights reserved.
//

#import "SentViewController.h"
#import "AppDelegate.h"
@interface SentViewController ()

@property (weak, nonatomic) IBOutlet UILabel *prompt;
@property (strong, atomic) AppDelegate *appDelegate;

@end

@implementation SentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (_appDelegate.success){
        [_prompt setText:@"Error! :("];
    }

    
//    _appDelegate.message = nil;
//    _appDelegate.recipients = nil;
//    _appDelegate.send_time = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
