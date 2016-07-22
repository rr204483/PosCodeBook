//
//  CustomCell.m
//  PosCodBook
//
//  Created by Ramesh on 29/10/2013.
//  Copyright (c) 2013 Ramesh. All rights reserved.
//

#import "CustomCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
    self.selectionStyle=UITableViewCellEditingStyleNone;
    //self.label= [[UILabel alloc] initWithFrame:CGRectMake(12.0, 15.0, 67.0, 15.0)];
    self.label= [[[UILabel alloc] initWithFrame:CGRectMake(20.0, 8.0, 125.0, 30.0)]autorelease];
    self.label.font= [UIFont fontWithName:@"Noteworthy-Light" size:18];
    self.label.backgroundColor=[UIColor clearColor];
    self.label.textColor=[UIColor blackColor];
    //self.label.textColor=[UIColor colorWithRed:41/255.0 green:36/255.0 blue:33/255.0 alpha:1.0];

    //self.label.font= [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    self.label.textAlignment=NSTextAlignmentLeft;
    self.label.text =@""   ;
    [self.contentView addSubview:self.label];
    
    
//    self.textField= [[UITextField alloc] initWithFrame:CGRectMake(93.0, 13.0, 170.0, 19.0)];
    self.textField= [[[UITextField alloc] initWithFrame:CGRectMake(140, 6.0, 160.0, 35.0)]autorelease];
    self.textField.backgroundColor=[UIColor  clearColor];
    self.textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.textField.enabled=NO;
    //self.textField.font= [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    self.textField.font=  [UIFont fontWithName:@"Noteworthy-Bold" size:20];
    self.textField.textAlignment=NSTextAlignmentLeft;
    self.textField.text =@""   ;
    self.textField.delegate=self;
    self.textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    //self.textField.textColor=[UIColor colorWithRed:255/255.0 green:127/255.0 blue:33/255.0 alpha:1.0];
    self.textField.textColor= [UIColor brownColor];
    [self.contentView addSubview:self.textField];
    
    self.textView= [[[UITextView alloc] initWithFrame:CGRectMake(85, 1.0, 205.0, 140)] autorelease];
    self.textView.backgroundColor=[UIColor  clearColor];
    self.textView.editable=NO;
    //self.textField.font= [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    self.textView.font=  [UIFont fontWithName:@"Noteworthy-Bold" size:20];
    self.textView.textAlignment=NSTextAlignmentLeft;
    self.textView.text =@"";
    self.textView.hidden=YES;
    self.textView.delegate=self;
    self.textView.textColor= [UIColor brownColor];
    [self.contentView addSubview:self.textView];
    

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    self.textField.enabled=editing;
    self.textView.editable=editing;
    
    if (editing) {
        self.textField.textColor= [UIColor lightGrayColor];
        self.textView.textColor=[UIColor lightGrayColor];
        
//        self.textField.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
//        self.textField.borderStyle = UITextBorderStyleLine;
//        self.textField.layer.cornerRadius = 1.0f;
//        self.textField.layer.borderColor = [[UIColor redColor] CGColor];
//        self.textField.layer.borderWidth = 1.0f;

    } else {
        self.textField.textColor= [UIColor brownColor];
        self.textView.textColor=[UIColor brownColor];
    }
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    //NSLog(@"customeCell:textFieldShouldReturn");
    [self.textField resignFirstResponder];
    return YES;
}

-(BOOL) textViewShouldReturn:(UITextView*) textView {
    [self.textView resignFirstResponder];
    return YES ;
}

//-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    
////    if ( [text isEqualToString:@"\n"]) {
////        [textView resignFirstResponder];
////    }
//    return YES;
//}

- (void) textViewDidEndEditing:(UITextView*)textView{
    [textView resignFirstResponder];
}

//ToDo : Don't know why it is not getting called ? 
//-(void) textFieldDidBeginEditing:(UITextField *)textField   {
//    [self.textField setTextColor:[UIColor darkGrayColor]];
//}


//#pragma mark - Property Overrides
//- (id)value
//{
//    return self.textField.text;
//}
//- (void)setValue:(id)aValue
//{
//    self.textField.text = aValue;
//}

-(void) dealloc {
    [super dealloc];
}

@end
