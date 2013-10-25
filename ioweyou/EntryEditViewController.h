//
//  EntryEditViewController.h
//  ioweyou
//
//  Created by Piotr Kowalczuk on 19.09.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntryEditViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) NSNumber *entryId;
@property (nonatomic, strong) NSMutableDictionary *entry;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *value;
@property (weak, nonatomic) IBOutlet UITextView *description;

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

@end
