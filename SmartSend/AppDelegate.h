//
//  AppDelegate.h
//  SmartSend
//
//  Created by Michael Bishoff on 2/15/14.
//  Copyright (c) 2014 Michael Bishoff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (weak, nonatomic) IBOutlet UITextView *textBox;
//@property (strong, atomic) AppDelegate *app;

//                    copy
@property (nonatomic, retain) NSMutableString *message;
@property (nonatomic, retain) NSMutableArray *recipients;
@property (nonatomic, retain) NSDate *send_time;
@property (nonatomic,retain) NSString *text_recipients;
@property (nonatomic, assign) BOOL success;


@end
