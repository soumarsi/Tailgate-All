//
//  ViewController.h
//  Tailgate-All
//
//  Created by Soumarsi Kundu on 24/06/15.
//  Copyright (c) 2015 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGGlobal.h"
#import "TGGlobalClass.h"

#import "UIColor+TGGlobalColor.h"
#import "UIFont+TGGlobalFont.h"
#import "UIImage+TGGlobalImage.h"
#import "NSString+TGGlobalString.h"

@interface TGLoginViewController : UIViewController<TGGlobal>
- (IBAction)Signin:(UIButton *)sender;
- (IBAction)Forgotpassword:(UIButton *)sender;
@property (nonatomic, strong)TGGlobalClass *GlobalClass;
@property (nonatomic, strong)UIAlertView *Alert;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@end

