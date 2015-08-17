//
//  TGselectVenueViewController.m
//  Tailgate-All
//
//  Created by Soumarsi Kundu on 25/06/15.
//  Copyright (c) 2015 esolz. All rights reserved.
//

#import "TGselectVenueViewController.h"
#import "TGMapViewController.h"
#import "TGselectEventViewController.h"
#ifdef DEBUG

#define DebugLog(...) NSLog(__VA_ARGS__)

#else

#define DebugLog(...) while(0)

#endif
@interface TGselectVenueViewController ()

@end
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@implementation TGselectVenueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.GlobalClass = [[TGGlobalClass alloc]init];
    
    
    self.venueArray = [[NSMutableArray alloc]init];
    self.locationData = [[NSMutableArray alloc]init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    if(IS_OS_8_OR_LATER) {
        
        NSUInteger code = [CLLocationManager authorizationStatus];
        
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [self.locationManager  requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager  requestWhenInUseAuthorization];
            } else {
            }
        }
    }
    
    self.locationManager.delegate=self;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    self.locationManager.distanceFilter=kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    [self.GlobalClass GlobalDict:[NSString stringWithFormat:@"action.php?mode=locationInfo"] Withblock:^(id result, NSError *error) {
        
        if ([[result objectForKey:@"message"] isEqualToString:[NSString success]])
        {
            DebugLog(@"--------//---- :%@", [result objectForKey:@"locationdata"]);
            
            self.locationData = [result objectForKey:@"locationdata"];
            for (self.data = 0; self.data < self.locationData.count; self.data ++)
            {
                self.locationdict = [[NSMutableDictionary alloc]init];
                
                [self.locationdict setObject:[[self.locationData objectAtIndex:self.data]objectForKey:@"name"] forKey:@"name"];
                [self.locationdict setObject:[[self.locationData objectAtIndex:self.data] objectForKey:@"locid"] forKey:@"locid"];
                [self.locationdict setObject:[[self.locationData objectAtIndex:self.data]objectForKey:@"latitude"] forKey:@"latitude"];
                [self.locationdict setObject:[[self.locationData objectAtIndex:self.data]objectForKey:@"longitude"] forKey:@"longitude"];
                [self.locationdict setObject:[[self.locationData objectAtIndex:self.data]objectForKey:@"type"] forKey:@"type"];
                [self.venueArray addObject:self.locationdict];
            }
             DebugLog(@"venue------------>%@",self.venueArray);
            
            self.venuePicker.transform = CGAffineTransformMakeScale(2, 2);
            self.venuePicker.delegate = self;
            self.venuePicker.dataSource = self;
            
            [self.venuePicker selectRow:0 inComponent:0 animated:NO];
            self.venueString = [[self.venueArray objectAtIndex:[self.venuePicker selectedRowInComponent:0]] objectForKey:@"name"];
            self.locId = [[self.venueArray objectAtIndex:[self.venuePicker selectedRowInComponent:0]] objectForKey:@"locid"];
            self.latitude = [[[self.venueArray objectAtIndex:[self.venuePicker selectedRowInComponent:0]] objectForKey:@"latitude"] floatValue];
            self.longitude = [[[self.venueArray objectAtIndex:[self.venuePicker selectedRowInComponent:0]] objectForKey:@"longitude"] floatValue];
            self.type = [[self.venueArray objectAtIndex:[self.venuePicker selectedRowInComponent:0]] objectForKey:@"type"];
        }
        
    }];
    
    // Do any additional setup after loading the view.
}
//#pragma uipickerviewdelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{    
    UILabel *retval = (id)view;
    if (!retval) {
        retval= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] ;
    }
    
    retval.textAlignment= NSTextAlignmentCenter;
    retval.textColor = [UIColor BlackColor];
    retval.font = [UIFont PickerLabel];
    retval.text = [[self.venueArray objectAtIndex:row] objectForKey:@"name"];
    return retval;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0f;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.venueArray.count;
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.venueArray[row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.venueString = [[self.venueArray objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"name"];
    self.locId = [[self.venueArray objectAtIndex:[pickerView selectedRowInComponent:0]]objectForKey:@"locid"];
    self.latitude = [[[self.venueArray objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"latitude"] floatValue];
    self.longitude = [[[self.venueArray objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"longitude"] floatValue];
    self.type = [[self.venueArray objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"type"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    CLLocation *currentLocation = newLocation;
    
    
    [self.locationManager stopUpdatingLocation];
    if (currentLocation != nil) {
      }
     
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)venueSelectButton:(id)sender {
    
    if ([self.type isEqualToString:@"Oxford"])
    {
        TGselectEventViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TGselectEventViewController"];
        [vc setVenueName:self.venueString];
        [vc setLocationId:self.locId];
        [vc setLocationLattitude:self.latitude];
        [vc setLocationLongitude:self.longitude];
        [vc setType:self.type];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else
    {
    TGMapViewController *map = [[TGMapViewController alloc]init];
    [map setVenueName:self.venueString];
    [map setLocationId:self.locId];
    [map setLocationLattitude:self.latitude];
    [map setLocationLongitude:self.longitude];
    [map setType:self.type];
    [self.navigationController pushViewController:map animated:YES];
    }
}

- (IBAction)settingsButton:(UIButton *)sender {
    self.settingsPopUp = [[UIActionSheet alloc] initWithTitle:nil
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Logout"
                                       otherButtonTitles:nil];
    [self.settingsPopUp showInView:self.view];
}

#pragma UIActionsheetdelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"The %ld button was tapped.",(long)buttonIndex);
    
    if (buttonIndex == 0)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"Logout"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"Remember"];
        
        [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        
        TGselectVenueViewController *Logout = [self.storyboard instantiateViewControllerWithIdentifier:@"TGLoginViewController"];
        [self.navigationController pushViewController:Logout animated:YES];
    }
}

@end
