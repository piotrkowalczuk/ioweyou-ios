//
//  AddEntryViewController.h
//  ioweyou
//
//  Created by Piotr Kowalczuk on 12.09.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntryAddViewController : UIViewController <UITextFieldDelegate>

@property(nonatomic, strong) NSMutableDictionary *entry;
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UITextField *valueInput;
@property (weak, nonatomic) IBOutlet UITextView *descriptionInput;
@property (weak, nonatomic) IBOutlet UISegmentedControl *includeMeInput;
@property (weak, nonatomic) IBOutlet UIButton *pickContractorsButton;

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
@property (weak, nonatomic) IBOutlet UIButton *pickContractorss;

@end
