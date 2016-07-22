//
//  CustomCell.h
//  PosCodBook
//
//  Created by Ramesh on 29/10/2013.
//  Copyright (c) 2013 Ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell<UITextFieldDelegate, UITextViewDelegate>

@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UITextView *textView;

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) id value;


@end
