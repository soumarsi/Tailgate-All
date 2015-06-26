//
//  TGforgotpasswordViewController.m
//  Tailgate-All
//
//  Created by Soumarsi Kundu on 25/06/15.
//  Copyright (c) 2015 esolz. All rights reserved.
//

#import "TGforgotpasswordViewController.h"

@interface TGforgotpasswordViewController ()

@end

@implementation TGforgotpasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}
@end
