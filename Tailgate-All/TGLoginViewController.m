//
//  ViewController.m
//  Tailgate-All
//
//  Created by Soumarsi Kundu on 24/06/15.
//  Copyright (c) 2015 esolz. All rights reserved.
//

#import "TGLoginViewController.h"
#ifdef DEBUG

#define DebugLog(...) NSLog(__VA_ARGS__)

#else

#define DebugLog(...) while(0)

#endif
@interface TGLoginViewController ()

@end

@implementation TGLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.GlobalClass = [[TGGlobalClass alloc]init];
//    self.userName.text = @"Admin";
//    self.passWord.text = @"admin";

    // Do any additional setup after loading the view, typically from a nib.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.view.frame.size.height <= 568)
    {

    if (textField.tag == 1)
    {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0.0f, -90.0f, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
    else if (textField.tag == 2)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0.0f, -90.0f, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.view.frame.size.height <= 568)
    {
    if (textField.tag == 1)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
    else if (textField.tag == 2)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}
}
#pragma forgotPasswordButton

- (IBAction)Forgotpassword:(UIButton *)sender {
    TGLoginViewController *forgot = [self.storyboard instantiateViewControllerWithIdentifier:@"TGforgotpasswordViewController"];
    [self.navigationController pushViewController:forgot animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma signInButton
- (IBAction)Signin:(UIButton *)sender {
    
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
    
    if (self.userName.tag == 1)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
    else if (self.passWord.tag == 2)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
    
    if (self.GlobalClass.connectedToNetwork == YES)
    {
        if ([self.userName.text isEqualToString:@""])
        {
            self.userName.text = @"";
            self.userName.placeholder = [NSString check_username];
            [self.userName setValue:[UIColor redColor]forKeyPath:@"_placeholderLabel.textColor"];
            [self.userName setValue:[UIFont LoginLabel] forKeyPath:@"_placeholderLabel.font"];
        }
        else if ([self.passWord.text isEqualToString:@""])
        {
            self.passWord.text = @"";
            self.passWord.placeholder = [NSString check_password];
            [self.passWord setValue:[UIColor redColor]forKeyPath:@"_placeholderLabel.textColor"];
            [self.passWord setValue:[UIFont LoginLabel] forKeyPath:@"_placeholderLabel.font"];
        }
        else if ([self.userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ].length <1)
        {
            self.userName.text = @"";
            self.userName.placeholder = [NSString check_username];
            [self.userName setValue:[UIColor redColor]forKeyPath:@"_placeholderLabel.textColor"];
            [self.userName setValue:[UIFont LoginLabel] forKeyPath:@"_placeholderLabel.font"];
        }
        else
        {
            
            [self.GlobalClass GlobalDict:[NSString stringWithFormat:@"action.php?mode=adminLogin&email=%@&password=%@",[self.userName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],self.passWord.text] Withblock:^(id result, NSError *error) {
                
                if (result)
                {
                    DebugLog(@"result-- %@",result);
                    
                    if ([[result objectForKey:@"message"] isEqualToString:[NSString success]])
                    {
                        
                        [self.GlobalClass Userdict:[result objectForKey:@"userdata"]];
                        
                        
                        
                        TGLoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"TGselectVenueViewController"];
                        [self.navigationController pushViewController:login animated:YES];
                        
                    }
                    else if ([[result objectForKey:@"message"] isEqualToString:[NSString Login_Failed]])
                    {
                        self.Alert = [[UIAlertView alloc]initWithTitle:[NSString check_internet_title] message:[NSString Login_Failed] delegate:self cancelButtonTitle:[NSString Ok] otherButtonTitles: nil];
                        [self.Alert show];
                        
                        self.userName.text = @"";
                        self.passWord.text = @"";
                    }
                }
                else if (error)
                {
                    NSLog(@"error  %@", error);
                }
                
            }];
            
        }
    }
    else
    {
        self.Alert = [[UIAlertView alloc]initWithTitle:[NSString check_internet_title] message:[NSString check_internet] delegate:self cancelButtonTitle:[NSString Ok] otherButtonTitles:nil];
        [self.Alert show];
    }

}


@end
