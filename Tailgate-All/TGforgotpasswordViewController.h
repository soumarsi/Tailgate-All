//
//  TGforgotpasswordViewController.h
//  Tailgate-All
//
//  Created by Soumarsi Kundu on 25/06/15.
//  Copyright (c) 2015 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TGforgotpasswordViewController : UIViewController
- (IBAction)signinButton:(UIButton *)sender;
- (IBAction)forgotPasswordButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *emailText;

@end
