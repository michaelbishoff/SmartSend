//
//  TimeViewController.m
//  SmartSend
//
//  Created by Michael Bishoff on 2/15/14.
//  Copyright (c) 2014 Michael Bishoff. All rights reserved.
//

// #import <RestKit/RestKit.h>
#import "TimeViewController.h"
#import "AppDelegate.h"

@interface TimeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *prompt;
@property (weak, nonatomic) IBOutlet UIDatePicker *time;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (strong, atomic) AppDelegate *appDelegate;


@end

@implementation TimeViewController

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

    
// Another attempt of trying to call an API using the RestKit framework but I'm pretty sure I removed
//  the framework from the project
//    RKURL *baseURL = [RKURL URLWithBaseURLString:@"https://api.Foursquare.com/v2"];
//    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
//    objectManager.client.baseURL = baseURL;
//    
//    RKObjectMapping *venueMapping = [RKObjectMapping mappingForClass:[Venue class]];
//    [venueMapping mapKeyPathsToAttributes:@"name", @"name", nil];
//    [objectManager.mappingProvider setMapping:venueMapping forKeyPath:@"response.venues"];
//    
//    [self sendRequest];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)send:(id)sender {
    
    NSDate *send_time = _time.date;
    NSString *message = _appDelegate.message;
    
    NSMutableArray *recipients = [self setRecipients];
    
    // Creates new Thread that waits util the send time
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self sendMessage:message to:recipients at:send_time];
    });
    
}

- (NSMutableArray *)setRecipients {

    NSString *text = _appDelegate.text_recipients;
    NSMutableArray *recipients = [[NSMutableArray alloc] init];//[NSMutableArray array];
    NSMutableString *number = [NSMutableString stringWithFormat:@""];
    
    for (int i = 1; i < [text length]; i++)
    {
        int ascii = [text characterAtIndex:i];
        
        if (isdigit(ascii)){
            NSMutableString * newString = [text substringWithRange:NSMakeRange(i, 1)];
            
            [number appendString:newString];
        }
        
        if (ascii == 10 || i == ([text length] - 1) ){
            
            [recipients addObject:number];
            number = [NSMutableString stringWithFormat:@""];
        }
        
    }
    
    for (int i = 0; i < [recipients count]; i++){
        
        // Replaces the String 3017871566 with 13017871566 so that the api works properly.
        if ([recipients[i] length] < 11){
            NSString *replace = [NSString stringWithFormat:@"1%@", recipients[i]];
            
            recipients[i] = replace;
        }
        
    }
    
    return recipients;
}


- (void)sendMessage: (NSString *)message to:(NSMutableArray *)recipients at:(NSDate *)send_time {
    
    NSString *key = @"6bcf5019";
    NSString *secret = @"af5073ab";
    NSString *from = @"15022193792";
    //    NSString *to = @"13017871566";
    NSString *text_message = message;
    
    NSLog(@"Waiting Until: %@", send_time);
    [NSThread sleepUntilDate:send_time];
    NSLog(@"Sending message");
    
    
//    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//    [outputFormatter setDateFormat:@"HH:mm"]; //24hr time format
//    NSString *now = [outputFormatter stringFromDate:[NSDate date]];
//    
//    [_appDelegate.message appendString:[NSString stringWithFormat:@"Message Created: @&%@", now]];
    
    // This is able to send 8 messages (possibly more) quickly one after another and then pause, then send 2 messages,
    //  and repeats the pause and 2 messages until it reaches the total number of messages.
    
    for (int i = 0; i < [recipients count]; i++){
        
        NSString *post=[NSString stringWithFormat:@"api_key=%@&api_secret=%@&from=%@&to=%@&text=%@", key, secret, from,recipients[i], text_message];
        NSLog(@"post string is :%@",post);
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];

        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];   // autorelease];
        [request setURL:[NSURL URLWithString:@"https://rest.nexmo.com/sms/json?"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSData *serverReply = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *replyString = [[NSString alloc] initWithBytes:[serverReply bytes] length:[serverReply length] encoding: NSASCIIStringEncoding];
        NSLog(@"reply string is :%@",replyString);
        
        
        
        
        
        if ([replyString rangeOfString:@"error"].location == NSNotFound) {
            _appDelegate.success = true;
        } else {
            _appDelegate.success = false;
        }
    }
    
    
    // My attempt to acutllly call our API
    
    //    NSString *to = @"['13017871566']";
    //
    //
    //    NSString *post=[NSString stringWithFormat:@"message=%@&to=%@", @"Test", to];
    //    NSLog(@"post string is :%@",post);
    //    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //
    //    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    //
    //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];   // autorelease];
    //    [request setURL:[NSURL URLWithString:@"http://myapp.ngrok.com/api/v1.0/smart_send"]];
    //    [request setHTTPMethod:@"POST"];
    //    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [request setHTTPBody:postData];
    //
    //    NSData *serverReply = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *replyString = [[NSString alloc] initWithBytes:[serverReply bytes] length:[serverReply length] encoding: NSASCIIStringEncoding];
    //    NSLog(@"reply string is :%@",replyString);

    
    
    //    curl -i -H "Content-Type: application/json" -X POST -d '{"message": "hello people", "to": ["13017871566", "19179453118"]}' http://localhost:5000/api/v1.0/smart_send <time>

}

// Random Date stuff
//    NSDate* date = [NSDate dateWithTimeIntervalSince1970:123456789];

//    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//    [outputFormatter setDateFormat:@"dd:HH:mm"]; //24hr time format
//    NSString *delivery_time = [outputFormatter stringFromDate:self.time.date];
//    NSString *now = [outputFormatter stringFromDate:[NSDate date]];

//    NSLog(@"\n\nToday's date is: %f", date.timeIntervalSince1970);





//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
//        // Clean up any unfinished task business by marking where you
//        // stopped or ending the task outright.
//        [application endBackgroundTask:bgTask];
////        bgTask = UIBackgroundTaskInvalid;
//    }];
//    
//    // Start the long-running task and return immediately.
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        // Do the work associated with the task, preferably in chunks.
//        
//        [application endBackgroundTask:bgTask];
//        bgTask = UIBackgroundTaskInvalid;
//    });
//}



@end
