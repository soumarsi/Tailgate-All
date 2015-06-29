//
//  TGforgotpasswordViewController.m
//  Tailgate-All
//
//  Created by Soumarsi Kundu on 25/06/15.
//  Copyright (c) 2015 esolz. All rights reserved.
//

#import "TGforgotpasswordViewController.h"
#import "TGGlobal.h"
#import "TGGlobalClass.h"
#import "UIColor+TGGlobalColor.h"
#import "UIFont+TGGlobalFont.h"
#import "UIImage+TGGlobalImage.h"
#import "NSString+TGGlobalString.h"

@interface TGforgotpasswordViewController ()<UITextFieldDelegate>
@property(nonatomic, strong)TGGlobalClass *GlobalClass;
@end

@implementation TGforgotpasswordViewController
- (void)viewDidLoad {
    [super viewDidLoad];
     self.GlobalClass = [[TGGlobalClass alloc]init];
    self.emailText.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signinButton:(UIButton *)sender {
    TGforgotpasswordViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"TGLoginViewController"];
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)forgotPasswordButton:(UIButton *)sender {
    
    [self.emailText resignFirstResponder];
    
    if (self.GlobalClass.connectedToNetwork == YES)
    {

        if ([self.emailText.text isEqualToString:@""])
        {
            self.emailText.text = @"";
            self.emailText.placeholder = [NSString check_Email];
            [self.emailText setValue:[UIColor redColor]forKeyPath:@"_placeholderLabel.textColor"];
            [self.emailText setValue:[UIFont LoginLabel] forKeyPath:@"_placeholderLabel.font"];

        }
        else if ([self.emailText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ].length <1)
        {
            self.emailText.text = @"";
            self.emailText.placeholder = [NSString check_Email];
            [self.emailText setValue:[UIColor redColor]forKeyPath:@"_placeholderLabel.textColor"];
            [self.emailText setValue:[UIFont LoginLabel] forKeyPath:@"_placeholderLabel.font"];
        }
       else if (![self NSStringIsValidEmail:self.emailText.text])
        {
            self.emailText.text = @"";
           self.emailText.placeholder = [NSString check_Email];
           [self.emailText setValue:[UIColor redColor]forKeyPath:@"_placeholderLabel.textColor"];
           [self.emailText setValue:[UIFont LoginLabel] forKeyPath:@"_placeholderLabel.font"];
        }
       else
       {
           
           [self.GlobalClass GlobalDict:[NSString stringWithFormat:@"action.php?mode=forgot_password&email_address=%@",[self.emailText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] Withblock:^(id result, NSError *error) {
              
               if (result)
               {
                   
                   if ([[result objectForKey:@"message"] isEqualToString:[NSString usernotfound]])
                   {
                       self.emailText.text = @"";
                       self.emailText.placeholder = @"";
                       self.alertShow = [[UIAlertView alloc]initWithTitle:@"Failed!" message:[NSString usernotfound] delegate:self cancelButtonTitle:[NSString Ok] otherButtonTitles: nil];
                       
                       [self.alertShow show];
                   }
                   else if ([[result objectForKey:@"message"] isEqualToString:[NSString resetPassword]])
                   {
                       self.alertShow = [[UIAlertView alloc]initWithTitle:[NSString success] message:[NSString resetPassword] delegate:self cancelButtonTitle:[NSString Ok] otherButtonTitles: nil];
                       self.alertShow.tag = 1;
                       [self.alertShow show];
                   }
               }
               
               
           }];
       }

    }
    else
    {
        self.alertShow = [[UIAlertView alloc]initWithTitle:[NSString check_internet_title] message:[NSString check_internet] delegate:self cancelButtonTitle:[NSString Ok] otherButtonTitles:nil];
        [self.alertShow show];
    }

    
}

//email validation function...........
-(BOOL) NSStringIsValidEmail:(NSString *)checkString

{
    
    BOOL stricterFilter = YES;
    
    NSString *stricterFilterString = @"^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,4})$";
    
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:checkString];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        //Do something
        TGforgotpasswordViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"TGLoginViewController"];
        [self.navigationController pushViewController:view animated:YES];
    }
}
@end
