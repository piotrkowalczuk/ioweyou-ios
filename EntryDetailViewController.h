//
//  EntryDetailViewController.h
//  ioweyou
//
//  Created by Piotr Kowalczuk on 14.09.2013.
//  Copyright (c) 2013 Piotr Kowalczuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntryDetailViewController : UIViewController <UIActionSheetDelegate>

@property(nonatomic, strong) NSMutableDictionary *entry;
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (weak, nonatomic) IBOutlet UILabel *debtor_name;
@property (weak, nonatomic) IBOutlet UILabel *lender_name;
@property (weak, nonatomic) IBOutlet UIImageView *debtor_avatar;
@property (weak, nonatomic) IBOutlet UIImageView *lender_avatar;
@property (weak, nonatomic) IBOutlet UILabel *value;
@property (weak, nonatomic) IBOutlet UILabel *status;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionSheetButton;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@end
