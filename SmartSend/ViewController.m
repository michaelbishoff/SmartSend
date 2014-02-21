//
//  ViewController.m
//  SmartSend
//
//  Created by Michael Bishoff on 2/15/14.
//  Copyright (c) 2014 Michael Bishoff. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextView *textBox;
//@property (strong, atomic) AppDelegate *app;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, atomic) AppDelegate *appDelegate;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    self.app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
//    [_textBox setText: @"Hey! Check out this cool app! https://appsto.re/us/qonDu.i"];

    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"]; //24hr time format
    NSString *now = [outputFormatter stringFromDate:[NSDate date]];
    
    [_textBox setText:[NSString stringWithFormat:@"Message Created: %@", now]];
    
    _appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _appDelegate.message = _textBox.text;
    _appDelegate.recipients = [[NSMutableArray alloc] init];
    _appDelegate.send_time = nil;
    
    _appDelegate.success = true;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)touchEvent:(id)sender {
//    [_appDelegate setMessage:_textBox.text];
    [_textBox resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_appDelegate setMessage:_textBox.text];
    [textField resignFirstResponder];
}


- (IBAction)sendPressed:(id)sender {
    _appDelegate.message = _textBox.text;
        
//    [_appDelegate setMessage:_textBox.text];
}

@end
