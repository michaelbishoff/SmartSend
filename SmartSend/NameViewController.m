//
//  NameViewController.m
//  SmartSend
//
//  Created by Michael Bishoff on 2/15/14.
//  Copyright (c) 2014 Michael Bishoff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "NameViewController.h"
#import "AppDelegate.h"

@interface NameViewController ()
@property (weak, nonatomic) IBOutlet UIButton *tap;
@property (weak, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSMutableArray *phoneNumbers;
@property (weak, nonatomic) IBOutlet UITextView *displayNumbers;
@property (weak, nonatomic) IBOutlet UIButton *addNumberButton;

@property (strong, nonatomic) NSMutableString *temp;
@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UILabel *recipentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (strong, atomic) AppDelegate *appDelegate;

- (IBAction)showPicker:(id)sender;

@end

@implementation NameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _phoneNumbers = [NSMutableArray alloc];
        [_displayNumbers setText:@""];
        _phone = @"";
        _name = @"";
        
        [_textField setFont:[UIFont systemFontOfSize:25]];
        [_displayNumbers setFont:[UIFont systemFontOfSize:25]];

        _textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [_textField setFont:[UIFont systemFontOfSize:25]];
    [_displayNumbers setFont:[UIFont systemFontOfSize:25]];

    _phone = @"";
        
//    [[_addNumberButton titleLabel] setText:@"Enter a Number"];
    [_addNumberButton setTitle:@"Enter a Number" forState:UIControlStateNormal];

    _appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPicker:(id)sender
{
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];

    picker.peoplePickerDelegate = self;
    
    [self presentModalViewController:picker animated:YES];
}
- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
//    [_phoneNumbers addObject:];
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self displayPerson:person];
    [self dismissModalViewControllerAnimated:YES];
//    [self transitionToViewController:vc withOptions:UIViewAnimationOptionTransitionFlipFromRight];

    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)displayPerson:(ABRecordRef)person
{
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
    self.name = name;
    
    NSString* phone = @"";
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    self.phone = phone;
    
    [_phoneNumbers addObject:self.phone];
    
    [self updateNumbers:self];
    
    CFRelease(phoneNumbers);
}

- (IBAction)next:(id)sender {
    
    _appDelegate.text_recipients = _displayNumbers.text;
    
}

- (void) updateNumbers: (id) self
{
    NSString *temp = [_displayNumbers text];
    
    temp = [temp stringByAppendingString:@"\n"];
    
    if (![_name isEqualToString:@""]){
        temp = [temp stringByAppendingFormat: @"%@ ", _name];
    }
    
    temp = [temp stringByAppendingString: _phone];
    
    [_displayNumbers setText: temp ];
    
//    [_displayNumbers setText: [_displayNumbers.text stringByAppendingFormat:@", %@", [_phone text]]];
    
    [_textField resignFirstResponder];
}


- (IBAction)addNumber:(id)sender {
    
    if ([[_addNumberButton.titleLabel text] isEqualToString:@"Enter a Number"]){
        
//        [_addNumberButton.titleLabel setText:@"Add Number"];
        [_addNumberButton setTitle:@"Add Number" forState:UIControlStateNormal];
        
        [self.textField becomeFirstResponder];
    }
    else{
        _name = @"";
        _phone = [_textField text];
        
        if (![_phone isEqualToString:@""]){
            [_textField setText:@""];

            [self updateNumbers:self];
        }
        [_addNumberButton setTitle:@"Enter a Number" forState:UIControlStateNormal];
    }
    
}

// I don't think that this ever gets executed
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self addNumber:self];
}



@end
