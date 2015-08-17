//
//  TGselectEventViewController.m
//  Tailgate-All
//
//  Created by Soumarsi Kundu on 13/08/15.
//  Copyright (c) 2015 esolz. All rights reserved.
//

#import "TGselectEventViewController.h"
#import "NSString+TGGlobalString.h"
#import "UIColor+TGGlobalColor.h"
#import "UIFont+TGGlobalFont.h"
#import "TGMapViewController.h"
@interface TGselectEventViewController ()

@end

@implementation TGselectEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eventArray = [[NSArray alloc]init];
    
    _globalClass = [[TGGlobalClass alloc]init];
    
    if (_globalClass.connectedToNetwork == YES)
    {
        [_globalClass parameterstring:@"action.php?mode=eventList" withblock:^(id result, NSError *error) {
           
            
            self.eventArray = result[@"orderdata"];
            self.selectEventPicker.transform = CGAffineTransformMakeScale(1.3, 2);
            self.selectEventPicker.delegate = self;
            self.selectEventPicker.dataSource = self;
                        
            [self.selectEventPicker selectRow:0 inComponent:0 animated:NO];
            self.eventName = [[self.eventArray objectAtIndex:[_selectEventPicker selectedRowInComponent:0]] objectForKey:@"event_name"];
            self.eventID = [[self.eventArray objectAtIndex:[_selectEventPicker selectedRowInComponent:0]]objectForKey:@"event_id"];
            self.eventDate = [[self.eventArray objectAtIndex:[_selectEventPicker selectedRowInComponent:0]] objectForKey:@"event_date"];
            
        }];
    }
    
    // Do any additional setup after loading the view.
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *retval = (id)view;
    if (!retval) {
        retval= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] ;
    }
    
    retval.textAlignment= NSTextAlignmentCenter;
    retval.textColor = [UIColor BlackColor];
    retval.font = [UIFont PickerLabel];
    retval.text = [NSString stringWithFormat:@"%@ - %@",[[self.eventArray objectAtIndex:row] objectForKey:@"event_name"],[[self.eventArray objectAtIndex:row] objectForKey:@"event_date"]];
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
    return self.eventArray.count;
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.eventArray[row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.eventName = [[self.eventArray objectAtIndex:[pickerView selectedRowInComponent:component]] objectForKey:@"event_name"];
    self.eventID = [[self.eventArray objectAtIndex:[pickerView selectedRowInComponent:component]]objectForKey:@"event_id"];
    self.eventDate = [[self.eventArray objectAtIndex:[pickerView selectedRowInComponent:component]] objectForKey:@"event_date"];
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

- (IBAction)eventSubmit:(UIButton *)sender {
    
    TGMapViewController *map = [[TGMapViewController alloc]init];
    [map setVenueName:self.VenueName];
    [map setLocationId:self.locationId];
    [map setLocationLattitude:self.LocationLattitude];
    [map setLocationLongitude:self.LocationLongitude];
    [map setType:self.Type];
    [map setEVENTID:self.eventID];
    [map setEventName:self.eventName];
    [map setEventDate:self.eventDate];
    [self.navigationController pushViewController:map animated:YES];
}

- (IBAction)Back:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
